{ pkgs, ... }:

{
  # Base terminal packages — always installed when terminal module is imported.
  # tmux is managed via programs.tmux in tmux.nix when enableConfig = true.
  # Fonts and ghostty are declared here unconditionally (ghostty config is toggled separately).
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
  ];

  fonts.fontconfig.enable = true;
}
