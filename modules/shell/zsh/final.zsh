# Post-init hooks (ble.sh is bash-only — handled by home-manager autosuggestion plugin)
# zoxide and direnv are injected by home-manager's enableZshIntegration

# Auto-attach to tmux in interactive logins only; never exec (lets the shell survive tmux errors).
if [[ -o interactive ]] \
  && [[ -z "$TMUX" ]] \
  && [[ -z "$VIM" ]] \
  && [[ "$TERM_PROGRAM" != "vscode" ]] \
  && [[ -z "$INSIDE_EMACS" ]] \
  && [[ -z "$FULFRAN_NO_TMUX" ]] \
  && command -v tmux >/dev/null 2>&1 \
  && [[ -t 0 ]]; then
  tmux new-session -As main && exit
fi
