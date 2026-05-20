{ config, pkgs, lib, ... }:

let
  cfg = config.programs.fulfran.tmux;
in
lib.mkIf cfg.enableConfig {
  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      resurrect
      continuum
      vim-tmux-navigator
    ];
    extraConfig = builtins.readFile ./configs/tmux.conf;
  };
}
