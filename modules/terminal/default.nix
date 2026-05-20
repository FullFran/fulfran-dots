{ pkgs, ... }:

{
  home.packages = with pkgs; [
    tmux
    tmuxPlugins.resurrect
    tmuxPlugins.continuum
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
  ];

  fonts.fontconfig.enable = true;
}
