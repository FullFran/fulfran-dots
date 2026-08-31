#!/usr/bin/env bash
# Guards against publishing credentials from a public dotfiles repo.
#
# Uses gitleaks rather than a hand-rolled pattern list. Hand-rolled scans fail
# in a specific, quiet way: one that looked for `token` as a standalone word
# missed a key named ENGRAM_CLOUD_TOKEN and reported the file clean. The rule
# you did not think of is exactly the one that leaks.
#
# gitleaks is not installed; it runs through `nix run`, which this repo already
# depends on. No new tooling to manage.
#
# Two scopes, and the SECOND is the one that matters: deleting a leaked file
# leaves it intact in every earlier commit, so a clean tree proves nothing.
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1
. tests/lib.sh

GITLEAKS=(nix run --quiet nixpkgs#gitleaks --)

printf '\nsecrets\n'

require nix "https://install.determinate.systems/nix" || finish

# ── 1. the working tree is clean ─────────────────────────────────────────────
# Judged by exit status. gitleaks prints "no leaks found" on success, so a
# naive match on /leaks/ would read a clean run as a failure.
if "${GITLEAKS[@]}" dir . --no-banner --redact >/dev/null 2>&1; then
  pass "working tree has no detectable credentials"
else
  fail "gitleaks found credentials in the working tree — run: nix run nixpkgs#gitleaks -- dir . --redact"
fi

# ── 2. every commit is clean ─────────────────────────────────────────────────
if "${GITLEAKS[@]}" git . --no-banner --redact >/dev/null 2>&1; then
  pass "full history has no detectable credentials"
else
  fail "gitleaks found credentials in history — a leak survives deletion; rotate the key first, then rewrite"
fi

# ── 3. prove the detector actually detects ───────────────────────────────────
# A guard that has never been shown to catch anything is decoration. Plant a
# credential in a throwaway copy and require a hit. If this stops failing, the
# scanner silently stopped working and checks 1 and 2 became meaningless.
planted="$(mktemp -d)"
trap 'rm -rf "$planted"' EXIT
# A GitHub PAT shape: the most plausible real leak for a dotfiles repo, and one
# gitleaks flags reliably. AWS's documented example key and a short PEM block
# were both tried first and neither was flagged — the canonical AWS example is
# allowlisted precisely because it is fake, which is the sort of thing only a
# self-test surfaces.
#
# The body is random rather than literal: the history check above reads every
# commit, including the one that adds this file, so a hardcoded token here
# would make the repo fail its own scan forever.
printf 'github_pat = "ghp_%s"\n' \
  "$(head -c 64 /dev/urandom | base64 | tr -dc 'A-Za-z0-9' | head -c 36)" \
  > "$planted/planted.env"
if "${GITLEAKS[@]}" dir "$planted" --no-banner --redact >/dev/null 2>&1; then
  fail "detector is broken: a planted credential was NOT flagged, so checks 1-2 prove nothing"
else
  pass "detector verified against a planted credential"
fi

finish
