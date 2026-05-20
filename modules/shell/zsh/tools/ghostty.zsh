# Ghostty shell integration for zsh.
# shell-integration = detect in ghostty/config handles auto-injection when
# GHOSTTY_RESOURCES_DIR is set. This file provides a manual fallback.
if [[ -n "$GHOSTTY_RESOURCES_DIR" ]]; then
  local hook="$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
  [[ -f "$hook" ]] && source "$hook"
fi
