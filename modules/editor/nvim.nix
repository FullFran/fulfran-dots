{ config, lib, ... }:

{
  xdg.configFile."nvim" = lib.mkIf config.programs.fulfran.nvim.enableConfig {
    source = ./nvim;
    recursive = true;
  };
}
