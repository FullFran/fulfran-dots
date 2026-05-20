{ pkgs, lib, ... }:
{
  home.username = "user";
  home.homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/user"
    else "/home/user";

  home.stateVersion = "25.05";

  # By default the imported preset (e.g. fulfran-dots.homeManagerModules.full) enables
  # every config file. To AVOID overwriting your existing dotfiles, disable any you want
  # to keep. Uncomment the toggles you need.
  #
  # programs.fulfran.tmux.enableConfig = false;       # keep your tmux.conf
  # programs.fulfran.ghostty.enableConfig = false;    # keep your ghostty config
  # programs.fulfran.nvim.enableConfig = false;       # keep your nvim
  # programs.fulfran.shell.enableBash = false;        # keep your .bashrc
  # programs.fulfran.shell.enableZsh = false;         # keep your .zshrc
  # programs.fulfran.lazygit.enableConfig = false;    # keep your lazygit
  # programs.fulfran.dev.enableJdk = true;            # opt-in to jdk21
}
