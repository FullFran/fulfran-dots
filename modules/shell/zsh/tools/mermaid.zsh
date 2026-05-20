# mmaid: renders mermaid blocks from a markdown file or stdin
# Usage: mmaid file.md | cat file.md | mmaid | mmaid diagram.mmd
mmaid() {
  if ! command -v mmaid >/dev/null 2>&1; then
    echo "mmaid not installed (expected on PATH)" && return 1
  fi

  if [[ $# -eq 0 ]]; then
    local input
    input=$(cat)
    if echo "$input" | grep -q '```mermaid'; then
      echo "$input" | awk '/^```mermaid$/{found=1; next} found && /^```$/{found=0; print "---"; next} found{print}' | \
        while IFS= read -r line; do
          if [[ "$line" == "---" ]]; then
            echo ""
          else
            printf '%s\n' "$line"
          fi
        done | mmaid -f -
    else
      echo "$input" | mmaid -f -
    fi
  else
    command mmaid -f "$1"
  fi
}
