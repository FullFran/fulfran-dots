{ ... }:
{
  home.username = "user";
  home.homeDirectory = "/home/user";

  # Override fulfran-dots toggles here. All defaults are true unless noted.
  # Disable tmux config:    programs.fulfran.tmux.enableConfig = false;
  # Disable ghostty config: programs.fulfran.ghostty.enableConfig = false;
  # Disable neovim config:  programs.fulfran.nvim.enableConfig = false;
  # Disable bash config:    programs.fulfran.shell.enableBash = false;
  # Disable zsh config:     programs.fulfran.shell.enableZsh = false;
  # Enable JDK:             programs.fulfran.dev.enableJdk = true;
}
