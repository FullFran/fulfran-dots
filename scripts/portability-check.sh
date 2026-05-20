#!/bin/sh
# portability-check.sh — enforce fulfran-dots portability invariants
# Run from .local/fulfran-dots/ (the repo root).
# Exits non-zero on first failing gate and prints the offending matches.
set -e

REPO="${REPO:-$(dirname "$(dirname "$(realpath "$0")")")}"
PASS=0
FAIL=1
rc=0

pass() { printf '\033[32m[PASS]\033[0m %s\n' "$1"; }
fail() { printf '\033[31m[FAIL]\033[0m %s\n' "$1"; }

# ── P1: no personal usernames ────────────────────────────────────────────────
printf 'P1  no personal usernames ... '
if rg -n "franblakia|franciscomanuelolmedocorts" \
       "$REPO" \
       --glob '!LICENSE' \
       --glob '!README.md' \
       --glob '!scripts/**' \
       2>/dev/null; then
  fail "P1 — personal usernames found (see matches above)"
  rc=1
else
  pass "P1 — no personal usernames"
fi

# ── P2: no agentic AI hooks ──────────────────────────────────────────────────
printf 'P2  no agentic AI hooks ... '
if rg -n "tmux-agent-sidebar|ai-selector|@agent_done|/tmp/tmux-done|tmux-agent-notify|gentle-ai|franos" \
       "$REPO/modules" \
       "$REPO/tui" \
       2>/dev/null; then
  fail "P2 — agentic AI hooks found (see matches above)"
  rc=1
else
  pass "P2 — no agentic AI hooks"
fi

# ── P3: no hardcoded absolute /home/<user> paths ─────────────────────────────
# Excludes: *.md, LICENSE, examples/, templates/, scripts/ (intentional placeholders and self-scan)
printf 'P3  no absolute home paths ... '
if rg -n "/home/[a-zA-Z0-9_-]+" \
       "$REPO" \
       --glob '!*.md' \
       --glob '!LICENSE' \
       --glob '!examples/**' \
       --glob '!templates/**' \
       --glob '!scripts/**' \
       2>/dev/null; then
  fail "P3 — absolute /home/<user> paths found (see matches above)"
  rc=1
else
  pass "P3 — no absolute home paths"
fi

# ── P4: nix flake check ──────────────────────────────────────────────────────
printf 'P4  nix flake check ... '
if nix flake check --no-write-lock-file 2>&1 | grep -q "^error"; then
  fail "P4 — nix flake check failed"
  rc=1
else
  pass "P4 — nix flake check passed"
fi

# ── Summary ──────────────────────────────────────────────────────────────────
if [ "$rc" -eq 0 ]; then
  printf '\n\033[32mAll portability gates passed.\033[0m\n'
else
  printf '\n\033[31mOne or more portability gates FAILED.\033[0m\n'
fi

exit "$rc"
