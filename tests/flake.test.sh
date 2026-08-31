#!/usr/bin/env bash
# The flake must evaluate. This is what stops a broken module from reaching
# someone who runs the bootstrap on a fresh machine.
#
# Judged by exit status. The previous gate piped the output to `grep -q "^error"`
# and ignored nix's exit code entirely, so any failure whose message did not
# start with "error" at column zero — and any failure at all when nix itself was
# absent, since grep then simply found nothing — reported PASS.
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1
. tests/lib.sh

printf '\nflake\n'

require nix "https://install.determinate.systems/nix" || finish

if out=$(nix flake check --no-build --no-write-lock-file 2>&1); then
  pass "nix flake check"
else
  fail "nix flake check failed"
  printf '%s\n' "$out" | tail -12
fi

finish
