# Custom prompt — Kali Inspired Minimal (Tokyo Night)
# Uses __git_ps1 from git-sh-prompt (much faster than invoking git 4 times).

# Colors (Tokyo Night Palette)
RESET='\[\e[0m\]'
BLUE='\[\e[38;5;75m\]'
CYAN='\[\e[38;5;87m\]'
PURPLE='\[\e[38;5;141m\]'
GREEN='\[\e[38;5;114m\]'
RED='\[\e[38;5;203m\]'
YELLOW='\[\e[38;5;221m\]'
DIM='\[\e[2m\]'

# Load git-sh-prompt (provides __git_ps1)
for __gp in \
    /opt/homebrew/etc/bash_completion.d/git-prompt.sh \
    /usr/local/etc/bash_completion.d/git-prompt.sh \
    /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh \
    /usr/lib/git-core/git-sh-prompt \
    /usr/share/git/completion/git-prompt.sh \
    /usr/share/git-core/contrib/completion/git-prompt.sh \
    /etc/bash_completion.d/git-prompt
do
    if [ -f "$__gp" ]; then
        . "$__gp"
        break
    fi
done
unset __gp

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_HIDE_IF_PWD_IGNORED=1
export GIT_PS1_SHOWCOLORHINTS=
GIT_PS1_FMT="${DIM}(${RESET}${YELLOW}%s${RESET}${DIM})${RESET}"

__git_segment() {
    if declare -F __git_ps1 >/dev/null 2>&1; then
        local out
        out="$(__git_ps1 " $GIT_PS1_FMT")"
        printf '%s' "$out"
    fi
}

__set_prompt() {
    local EXIT="$?"
    local ARROW_COLOR="$CYAN"
    if [ $EXIT -ne 0 ]; then
        ARROW_COLOR="$RED"
    fi

    PS1="\n${DIM}┌──(${RESET}${PURPLE}\w${RESET}${DIM})${RESET}$(__git_segment)\n${DIM}└─${RESET}${ARROW_COLOR}❯${RESET} "
}

case ";${PROMPT_COMMAND};" in
    *";__set_prompt;"*) ;;
    *) PROMPT_COMMAND="__set_prompt${PROMPT_COMMAND:+;$PROMPT_COMMAND}" ;;
esac
