# yazi wrapper: cd to directory on exit
function y() {
  local tmp cwd
  tmp=$(mktemp)
  yazi "$@" --cwd-file="$tmp"
  cwd=$(cat "$tmp" 2>/dev/null)
  [[ -d "$cwd" && "$cwd" != "$PWD" ]] && cd "$cwd"
  rm -f "$tmp"
}
