autoload -Uz vcs_info
setopt PROMPT_SUBST

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats       " %F{221}(%b%u%c%F{221})%f"
zstyle ':vcs_info:git:*' actionformats " %F{221}(%b|%a%u%c%F{221})%f"

precmd_functions+=(__vcs_info_update)
__vcs_info_update() { vcs_info }

PROMPT=$'%F{240}┌──(%f%F{141}%~%f%F{240})%f${vcs_info_msg_0_}\n%F{240}└─%f%(?.%F{87}.%F{203})❯%f '
