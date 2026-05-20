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
      poppler-utils
      direnv
      delta
      gh
      git
    ]
    # unar is Linux-only in nixpkgs
    ++ lib.optionals pkgs.stdenv.isLinux [ unar ]
    ++ lib.optional config.programs.fulfran.dev.enableJdk pkgs.jdk21;
}
