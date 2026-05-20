{ config, lib, ... }:

let
  cfg = config.programs.fulfran.shell;
  readFile = builtins.readFile;
  dir = ./.;
in
lib.mkIf cfg.enableBash {
  programs.bash = {
    enable = true;
    initExtra = ''
      ${readFile (dir + "/init.sh")}
    '';
  };

  home.shellAliases = {
    vi   = "nvim";
    vim  = "nvim";
    ":q" = "exit";
    ".."    = "cd ..";
    "..."   = "cd ../..";
    "...." = "cd ../../..";
  };
}
