#!/usr/bin/env bash
# Runs every gate. Used by CI and by anyone opening a PR.
#
# Each test is a separate process so one failing suite cannot abort the rest:
# knowing all four results is worth more than stopping at the first.
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

failed=0
for t in tests/portability.test.sh tests/secrets.test.sh tests/flake.test.sh; do
  [ -x "$t" ] || { printf 'not executable: %s\n' "$t" >&2; failed=1; continue; }
  "$t" || failed=1
done

printf '\n'
if [ "$failed" -eq 0 ]; then
  printf '\033[32m✅ every gate passed\033[0m\n'
else
  printf '\033[31m❌ at least one gate failed\033[0m\n'
fi
exit "$failed"
