#!/usr/bin/env bash
# Shared helpers for the fulfran-dots test suite.
#
# The one rule everything here exists to enforce: a check that cannot run must
# FAIL, never pass. scripts/portability-check.sh used `if rg ...; then fail`,
# so on a machine without ripgrep rg exited non-zero, the if took the else
# branch, and a gate with a real leak sitting in front of it printed PASS.
# A guard that goes quiet exactly when its tooling is missing — CI, a fresh
# clone — is worse than no guard, because it is trusted.
set -uo pipefail

RED=$'\033[31m'; GREEN=$'\033[32m'; YELLOW=$'\033[33m'; RESET=$'\033[0m'

TEST_FAILURES=0

pass() { printf '  %s[PASS]%s %s\n' "$GREEN" "$RESET" "$1"; }
fail() { printf '  %s[FAIL]%s %s\n' "$RED" "$RESET" "$1"; TEST_FAILURES=$((TEST_FAILURES + 1)); }
info() { printf '  %s·%s %s\n' "$YELLOW" "$RESET" "$1"; }

# require <tool> [install hint] -- absence is a failure, not a skip.
require() {
  command -v "$1" >/dev/null 2>&1 && return 0
  fail "missing tool: $1${2:+ ($2)}"
  return 1
}

# grep_tracked <pattern> [extra git-grep args...] -- search the WORKING TREE.
# Uses git grep so .gitignore and untracked scratch files never enter the scan,
# and so the exit status is git's, not a missing binary's.
grep_tracked() { git grep -nIE "$@" -- . 2>/dev/null; }

# grep_history <pattern> -- search EVERY commit, which is the scope that counts.
# Deleting a leaked file leaves it in every earlier commit, so a clean tree
# proves nothing on its own: the file is still one `git log -p` away.
grep_history() {
  git log -p --all --no-color 2>/dev/null | grep -E '^\+' | grep -nIE "$1"
}

finish() {
  printf '\n'
  if [ "$TEST_FAILURES" -eq 0 ]; then
    printf '%sAll checks passed.%s\n' "$GREEN" "$RESET"
    exit 0
  fi
  printf '%s%s check(s) FAILED.%s\n' "$RED" "$TEST_FAILURES" "$RESET"
  exit 1
}
