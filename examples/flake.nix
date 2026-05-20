{
  description = "Example private flake consuming fulfran-dots";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    fulfran-dots.url = "github:FullFran/fulfran-dots";
  };

  outputs = { nixpkgs, home-manager, fulfran-dots, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      homeConfigurations."user@example-host" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          fulfran-dots.homeManagerModules.full
          ./hosts/example-linux.nix
        ];
      };
    };
}
