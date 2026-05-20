{ config, lib, ... }:

{
  xdg.configFile."lazygit/config.yml" = lib.mkIf config.programs.fulfran.lazygit.enableConfig {
    source = ./configs/lazygit.yml;
  };
}
