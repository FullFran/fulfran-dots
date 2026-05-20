{ config, lib, ... }:

lib.mkIf config.programs.fulfran.btop.enableConfig {
  xdg.configFile."btop/btop.conf".source = ./configs/btop/btop.conf;
  xdg.configFile."btop/themes/hackerman-tokyo-night.theme".source =
    ./configs/btop/themes/hackerman-tokyo-night.theme;
}
