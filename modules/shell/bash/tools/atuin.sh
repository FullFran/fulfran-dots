# Atuin shell history
if command -v atuin >/dev/null 2>&1; then
    [[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
    eval "$(atuin init bash)"
fi
