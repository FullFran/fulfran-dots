#!/usr/bin/env bash
# Enforces the portability invariants a public, team-facing dotfiles repo needs:
# nothing personal, nothing private, nothing machine-specific.
#
# Supersedes the gate logic that lived in scripts/portability-check.sh, which
# used `if rg <pattern>; then fail`. On a machine without ripgrep, rg exited
# non-zero, the if took the else branch, and every gate printed PASS with a
# real leak sitting in front of it. Here a missing tool IS a failure, and the
# searching is done by git grep, which ships with the git this repo already
# requires.
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1
. tests/lib.sh

printf '\nportability\n'

require git || finish

# Paths that are allowed to mention these terms. The scanners themselves must
# be excluded or they match their own source; README and LICENSE name the
# owner legitimately; examples/ and templates/ carry deliberate placeholders.
EXCLUDE=(':!tests/**' ':!scripts/**' ':!README.md' ':!LICENSE' ':!examples/**' ':!templates/**')

# ── P1: no personal usernames ────────────────────────────────────────────────
PERSONAL='franblakia|franciscomanuelolmedocorts'
if hits=$(git grep -nIE "$PERSONAL" -- . "${EXCLUDE[@]}" 2>/dev/null); then
  fail "P1 personal usernames in the tree"; printf '%s\n' "$hits" | head -5
else
  pass "P1 no personal usernames"
fi

# ── P2: no private agent tooling ─────────────────────────────────────────────
PRIVATE='tmux-agent-sidebar|ai-selector|@agent_done|/tmp/tmux-done|tmux-agent-notify|gentle-ai|franos'
if hits=$(git grep -nIE "$PRIVATE" -- modules tui 2>/dev/null); then
  fail "P2 private agent tooling referenced"; printf '%s\n' "$hits" | head -5
else
  pass "P2 no private agent tooling"
fi

# ── P3: no hardcoded absolute home paths ─────────────────────────────────────
if hits=$(git grep -nIE '/home/[a-zA-Z0-9_-]+|/Users/[a-zA-Z0-9_-]+' -- . "${EXCLUDE[@]}" ':!*.md' 2>/dev/null); then
  # /home/user and /Users/user are the documented placeholders, not a leak.
  real=$(printf '%s\n' "$hits" | grep -vE '/(home|Users)/user\b') || true
  if [ -n "$real" ]; then
    fail "P3 absolute home paths"; printf '%s\n' "$real" | head -5
  else
    pass "P3 no absolute home paths (only documented placeholders)"
  fi
else
  pass "P3 no absolute home paths"
fi

# ── P4: history is clean too ─────────────────────────────────────────────────
# The scope that actually matters. Deleting a file that named a private tool
# leaves it in every earlier commit, so P1-P3 passing on the tree proves only
# that someone tidied up — the content is still one `git log -p` away.
# Scoped with a pathspec rather than filtered by text: the scanners themselves
# spell these terms as patterns, and `git log -p | grep '^+'` has already lost
# the filename by the time a text filter could tell a pattern from a leak.
if hits=$(git log -p --all --no-color -- . ':!tests/**' ':!scripts/**' ':!README.md' 2>/dev/null \
            | grep -E '^\+' | grep -nIE "$PERSONAL|$PRIVATE"); then
  info "P4 history mentions personal/private terms in $(printf '%s\n' "$hits" | wc -l) added line(s)"
  info "     history is not rewritten automatically; review before making anything else public"
  printf '%s\n' "$hits" | head -3 | cut -c1-110
else
  pass "P4 history clean of personal/private terms"
fi

# ── P5: prove the scanners actually scan ─────────────────────────────────────
# Without this the four gates above are unfalsifiable. Plant a violation in a
# tracked-looking path inside a scratch clone and require P1 to catch it.
scratch="$(mktemp -d)"
trap 'rm -rf "$scratch"' EXIT
git clone -q --depth 1 . "$scratch/repo" 2>/dev/null
if [ -d "$scratch/repo" ]; then
  printf '# owner: franblakia\n' >> "$scratch/repo/modules/core/options.nix"
  ( cd "$scratch/repo" && git add -A >/dev/null 2>&1
    git grep -nIE "$PERSONAL" -- . ':!tests/**' ':!scripts/**' ':!README.md' >/dev/null 2>&1 )
  if [ $? -eq 0 ]; then
    pass "P5 scanner verified against a planted violation"
  else
    fail "P5 scanner is broken: a planted username was NOT caught, so P1-P3 prove nothing"
  fi
else
  fail "P5 could not create scratch clone to verify the scanner"
fi

finish
