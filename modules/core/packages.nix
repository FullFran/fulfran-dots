{ config, pkgs, lib, ... }:

{
  home.packages = lib.mkIf config.programs.fulfran.core.enable (with pkgs; [
    git
    gh
    jq
    fd
    ripgrep
    bat
    eza
    fzf
    zoxide
    atuin
    direnv
    wget
    curl
    fastfetch
    tree
    btop
  ]);
}
