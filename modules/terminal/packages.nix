{ pkgs, lib, ... }:

{
  # Base terminal packages — always installed when terminal module is imported.
  # tmux is managed via programs.tmux in tmux.nix when enableConfig = true.
  # Fonts and ghostty are declared here unconditionally (ghostty config is toggled separately).
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
  ];

  # fontconfig is Linux-only; on macOS fonts in ~/.nix-profile/share/fonts are
  # picked up automatically by the OS font system.
  fonts.fontconfig.enable = lib.mkIf pkgs.stdenv.isLinux true;
}
