# Git Worktree Helpers
# Usage:
#   gwt add <branch>  - Create a worktree in ../<repo>-wt/<branch>
#   gwt ls            - List all worktrees
#   gwt rm <branch>   - Remove a worktree

gwt() {
  local cmd=$1
  shift

  case "$cmd" in
    add)
      local branch=$1
      if [ -z "$branch" ]; then
        echo "Usage: gwt add <branch-name>"
        return 1
      fi

      local repo_name=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
      if [ -z "$repo_name" ]; then
        echo "Error: Not in a git repository"
        return 1
      fi

      local target_dir="../${repo_name}-wt/${branch}"
      mkdir -p "../${repo_name}-wt"

      if git rev-parse --verify "$branch" >/dev/null 2>&1; then
        echo "Branch '$branch' exists. Creating worktree..."
        git worktree add "$target_dir" "$branch"
      else
        echo "Branch '$branch' does not exist. Creating NEW branch and worktree..."
        git worktree add -b "$branch" "$target_dir"
      fi

      if [ $? -eq 0 ]; then
        echo "Entering worktree..."
        cd "$target_dir"
      else
        echo "Error: Failed to create worktree."
        return 1
      fi
      ;;

    ls)
      git worktree list
      ;;

    rm)
      local branch=$1
      if [ -z "$branch" ]; then
        echo "Usage: gwt rm <branch-name>"
        return 1
      fi

      local repo_name=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
      local target_dir="../${repo_name}-wt/${branch}"

      if [ -d "$target_dir" ]; then
        echo "Removing worktree in '$target_dir'..."
        git worktree remove "$target_dir"
        rmdir "../${repo_name}-wt" 2>/dev/null || true
      else
        echo "Error: Worktree directory '$target_dir' not found"
        return 1
      fi
      ;;

    *)
      echo "Git Worktree Helpers"
      echo "Commands:"
      echo "  add <branch>  - Create/checkout branch in a separate worktree and enter it"
      echo "  ls            - List worktrees"
      echo "  rm <branch>   - Remove worktree"
      ;;
  esac
}

# Alias for lazygit
alias lg='lazygit'
