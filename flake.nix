{
  description = "fulfran-dots — public reusable dotfiles base";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in {
      homeManagerModules = {
        core     = import ./modules/core;
        shell    = import ./modules/shell;
        terminal = import ./modules/terminal;
        editor   = import ./modules/editor;
        dev      = import ./modules/dev;
        minimal       = import ./presets/minimal.nix;
        full          = import ./presets/full.nix;
        "dev-only"    = import ./presets/dev-only.nix;
        "terminal-only" = import ./presets/terminal-only.nix;
      };

      presets = {
        minimal       = import ./presets/minimal.nix;
        full          = import ./presets/full.nix;
        "dev-only"    = import ./presets/dev-only.nix;
        "terminal-only" = import ./presets/terminal-only.nix;
      };

      templates.default = {
        path = ./templates/default;
        description = "Skeleton private flake consuming fulfran-dots";
      };

      apps.x86_64-linux = import ./apps/tui.nix { inherit pkgs; };
    };
}
