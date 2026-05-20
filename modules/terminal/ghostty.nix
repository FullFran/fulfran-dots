{ config, pkgs, lib, ... }:

let
  cfg = config.programs.fulfran.ghostty;
in
lib.mkIf cfg.enableConfig {
  xdg.configFile."ghostty/config".source = ./configs/ghostty.config;
  # Ghostty is Linux-only in nixpkgs; on macOS install via ghostty.org or Homebrew.
  home.packages = lib.optionals pkgs.stdenv.isLinux [ pkgs.ghostty ];
}
