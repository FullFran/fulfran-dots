{ pkgs, lib, config, ... }:

{
  home.packages = with pkgs; [
    neovim
    delta
  ];
}
