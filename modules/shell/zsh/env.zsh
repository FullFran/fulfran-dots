# Portable PATH — no private tools, no Homebrew, no cargo
export PATH="$HOME/.local/bin:$HOME/go/bin:$PATH"
export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"

# Ensure $SHELL points to the nix-managed zsh so tmux and subprocesses inherit it.
if [[ -x "$HOME/.nix-profile/bin/zsh" ]]; then
  export SHELL="$HOME/.nix-profile/bin/zsh"
fi
