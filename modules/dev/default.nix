{ pkgs, ... }:

{
  home.packages = with pkgs; [
    git
    lazygit
    gh
    neovim
    nodejs_22
    pnpm
    bun
    go
    jdk21
  ];
}
