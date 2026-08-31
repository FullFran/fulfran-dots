#!/usr/bin/env bash
# Kept as the entry point the README documents for contributors. The gates
# themselves live in tests/, where each one can be run on its own.
#
# The logic that used to be here failed open: it ran `if rg <pattern>; then
# fail`, so on a machine without ripgrep rg exited non-zero, the else branch
# ran, and every gate printed PASS with a real violation in the tree.
exec "$(dirname "$(realpath "$0")")/../tests/run-all.sh" "$@"
