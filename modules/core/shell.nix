{ config, ... }:

{
  home.sessionVariables = {
    ZDOTDIR = "${config.home.homeDirectory}/.config/zsh";
    PNPM_HOME = "${config.home.homeDirectory}/.local/share/pnpm";
  };

  home.sessionPath = [ "${config.home.homeDirectory}/.local/share/pnpm" ];

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
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
