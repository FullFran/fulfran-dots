# zoxide — smarter cd
# Note: when using home-manager's programs.zoxide, this file is not needed.
# Kept as a portable fallback for non-HM environments.
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash --hook pwd)"
fi
