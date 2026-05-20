{ config, pkgs, lib, ... }:

let
  cfg = config.programs.fulfran.ghostty;
in
lib.mkIf cfg.enableConfig {
  xdg.configFile."ghostty/config".source = ./configs/ghostty.config;
  home.packages = [ pkgs.ghostty ];
}
