{
  description = "My private dotfiles (built on fulfran-dots)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      # master tracks the latest fixes (incl. structuredAttrs compatibility
      # with Determinate Nix 3.x). Pin to a release branch only if you need
      # extra stability and have verified it works on your platform.
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fulfran-dots.url = "github:FullFran/fulfran-dots";
  };

  outputs = { nixpkgs, home-manager, fulfran-dots, ... }:
    let
      # Helper: build a homeConfiguration for any system. Each host below
      # declares its own system string (e.g. "aarch64-darwin",
      # "x86_64-linux") so the same flake works across machines.
      mkHome = system: modules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          inherit modules;
        };
    in {
      homeConfigurations = {
        "user@example-host" = mkHome "x86_64-linux" [
          fulfran-dots.presets.full
          ./hosts/example.nix
        ];
        # FULFRAN_TUI_INSERT_HERE
      };
    };
}
