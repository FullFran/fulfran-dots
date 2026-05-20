# Ghostty shell integration (manual mode)
# Enables: cursor shape, sudo password prompt, title updates, click-to-move
# Only loads when running inside Ghostty.

if [ -n "${GHOSTTY_RESOURCES_DIR:-}" ] && [ -f "$GHOSTTY_RESOURCES_DIR/shell-integration/bash/ghostty.bash" ]; then
    builtin source "$GHOSTTY_RESOURCES_DIR/shell-integration/bash/ghostty.bash"
fi
