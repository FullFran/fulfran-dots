{ config, lib, ... }:

let
  cfg = config.programs.fulfran.shell;
  readFile = builtins.readFile;
  dir = ./.;
in
lib.mkIf cfg.enableZsh {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    history = {
      path = "${config.home.homeDirectory}/.config/zsh/.zsh_history";
      size = 50000;
      save = 50000;
      ignoreDups = true;
      share = true;
    };
    # initContent replaces the deprecated initExtra. mkOrder 1000 reproduces the
    # position initExtra used to occupy, so the generated .zshrc is unchanged.
    initContent = lib.mkOrder 1000 ''
      ${readFile (dir + "/init.zsh")}
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
