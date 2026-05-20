{ lib, ... }:
{
  options.programs.fulfran = {
    core.enable = lib.mkEnableOption "install fulfran-dots core CLI packages" // {
      default = true;
    };

    shell.enableBash = lib.mkEnableOption "ship the public bash modular config" // {
      default = true;
    };
    shell.enableZsh = lib.mkEnableOption "ship the public zsh modular config" // {
      default = true;
    };

    tmux.enableConfig = lib.mkEnableOption "ship the public tmux config" // {
      default = true;
    };
    ghostty.enableConfig = lib.mkEnableOption "ship the public ghostty config" // {
      default = true;
    };

    nvim.enableConfig = lib.mkEnableOption "ship the LazyVim config tree" // {
      default = true;
    };
    lazygit.enableConfig = lib.mkEnableOption "ship the lazygit config" // {
      default = true;
    };
    btop.enableConfig = lib.mkEnableOption "ship the btop config" // {
      default = true;
    };

    dev.enableGitHelpers = lib.mkEnableOption "install gwt() bash/zsh helpers" // {
      default = true;
    };
    dev.enableJdk = lib.mkEnableOption "install jdk21" // {
      default = false;
    };
  };
}
