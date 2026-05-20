{
  description = "My private dotfiles (built on fulfran-dots)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fulfran-dots.url = "github:FullFran/fulfran-dots";
  };

  outputs = { nixpkgs, home-manager, fulfran-dots, ... }:
    let
      pkgsFor = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      homeConfigurations = {
        # FULFRAN_TUI_INSERT_HERE
      };
    };
}
