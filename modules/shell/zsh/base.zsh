setopt AUTO_CD
setopt EXTENDED_GLOB
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP
setopt PROMPT_SUBST
setopt HIST_VERIFY
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_ALL_DUPS

autoload -Uz compinit
compinit -d "${ZDOTDIR:-$HOME/.config/zsh}/.zcompdump"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

autoload -Uz colors && colors

# Ctrl+Backspace — delete word backwards
bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word   # Ctrl+Delete — delete word forwards
