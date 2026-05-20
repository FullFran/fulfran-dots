# Post-init hooks (ble.sh is bash-only — handled by home-manager autosuggestion plugin)
# zoxide and direnv are injected by home-manager's enableZshIntegration

# Auto-attach to tmux on every interactive shell open (unless already inside tmux
# or running inside VS Code's terminal which has its own session management).
if [[ -z "$TMUX" ]] && [[ "$TERM_PROGRAM" != "vscode" ]] && command -v tmux &>/dev/null; then
  exec tmux new-session -As main
fi
