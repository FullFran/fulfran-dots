{ config, lib, ... }:

{
  imports = [
    ./packages.nix
  ];

  programs.bash.initExtra = lib.mkIf config.programs.fulfran.dev.enableGitHelpers (
    builtins.readFile ./git-helpers.sh
  );

  programs.zsh.initExtra = lib.mkIf config.programs.fulfran.dev.enableGitHelpers (
    builtins.readFile ./git-helpers.sh
  );
}
