# bash/init.sh
#
# Load order:
#   1. base.sh        — history options, window resize
#   2. env/path.sh    — portable PATH entries
#   2. env/editor.sh  — EDITOR/VISUAL
#   3. tools/         — atuin, fzf, ghostty
#   4. aliases/       — core, eza, bat, nav
#   5. prompt.sh      — Tokyo Night kali-style prompt
#   6. final.sh       — :q alias

# Only run in interactive shells
case $- in
    *i*) ;;
      *) return;;
esac

__fd="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# 1. base
[ -f "$__fd/base.sh" ] && . "$__fd/base.sh"

# bash-completion from system
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# 2. env
[ -f "$__fd/env/path.sh" ]   && . "$__fd/env/path.sh"
[ -f "$__fd/env/editor.sh" ] && . "$__fd/env/editor.sh"

# 3. tools
for __tool in atuin fzf ghostty; do
    __tp="$__fd/tools/${__tool}.sh"
    [ -f "$__tp" ] && . "$__tp"
done
unset __tool __tp

# 4. aliases
for __alias in core eza bat nav; do
    __ap="$__fd/aliases/${__alias}.sh"
    [ -f "$__ap" ] && . "$__ap"
done
unset __alias __ap

# 5. prompt
[ -f "$__fd/prompt.sh" ] && . "$__fd/prompt.sh"

# 6. final
[ -f "$__fd/final.sh" ] && . "$__fd/final.sh"

unset __fd
