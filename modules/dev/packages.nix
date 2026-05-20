{ pkgs, lib, config, ... }:

{
  home.packages = with pkgs;
    [
      nodejs_22
      pnpm
      bun
      go
      lazygit
      yazi
      ffmpegthumbnailer
      unar
      poppler_utils
      direnv
      delta
      gh
      git
    ]
    ++ lib.optional config.programs.fulfran.dev.enableJdk pkgs.jdk21;
}
