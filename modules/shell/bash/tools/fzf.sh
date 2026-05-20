# FZF — portable initialization
# When managed by home-manager's programs.fzf, this file is not needed.
# Kept as a portable fallback.
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --bash)"
fi
