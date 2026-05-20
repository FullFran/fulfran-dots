{ config, pkgs, lib, ... }:

{
  imports = [
    ./options.nix
    ./packages.nix
    ./shell.nix
  ];

  home.stateVersion = lib.mkDefault "25.05";
  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false;
}
