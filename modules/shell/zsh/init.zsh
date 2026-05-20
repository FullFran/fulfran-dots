# ZSH entrypoint

__zfd="${${(%):-%x}:h}"

[[ -f "$__zfd/base.zsh" ]]   && source "$__zfd/base.zsh"
[[ -f "$__zfd/env.zsh" ]]    && source "$__zfd/env.zsh"

for tool in atuin ghostty git mermaid yazi; do
  f="$__zfd/tools/${tool}.zsh"
  [[ -f "$f" ]] && source "$f"
done
unset f tool

# Source shared POSIX-compatible bash aliases
for a in core eza bat nav; do
  f="${__zfd}/../bash/aliases/${a}.sh"
  [[ -f "$f" ]] && source "$f"
done
unset f a

[[ -f "$__zfd/aliases/zsh-only.zsh" ]] && source "$__zfd/aliases/zsh-only.zsh"

[[ -f "$__zfd/prompt.zsh" ]] && source "$__zfd/prompt.zsh"
[[ -f "$__zfd/final.zsh" ]]  && source "$__zfd/final.zsh"

alias :q='exit'

unset __zfd
