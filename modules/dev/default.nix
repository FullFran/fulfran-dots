{ config, lib, ... }:

{
  imports = [
    ./packages.nix
  ];

  programs.bash.initExtra = lib.mkIf config.programs.fulfran.dev.enableGitHelpers (
    builtins.readFile ./git-helpers.sh
  );

  # zsh uses initContent; initExtra is deprecated. mkOrder 1000 reproduces the
  # position initExtra used to occupy, so the generated .zshrc is unchanged.
  programs.zsh.initContent = lib.mkIf config.programs.fulfran.dev.enableGitHelpers (
    lib.mkOrder 1000 (builtins.readFile ./git-helpers.sh)
  );
}
