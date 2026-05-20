{ config, lib, ... }:

{
  home.sessionVariables = lib.mkIf config.programs.fulfran.core.enable {
    ZDOTDIR = "${config.home.homeDirectory}/.config/zsh";
    PNPM_HOME = "${config.home.homeDirectory}/.local/share/pnpm";
  };

  home.sessionPath = lib.mkIf config.programs.fulfran.core.enable [
    "${config.home.homeDirectory}/.local/share/pnpm"
  ];

  programs.zoxide = lib.mkIf config.programs.fulfran.core.enable {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.direnv = lib.mkIf config.programs.fulfran.core.enable {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
