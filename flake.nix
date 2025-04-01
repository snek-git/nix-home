{
  description = "Home Manager configuration of snek";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, zen-browser, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
    in
    {
      homeConfigurations = {
        "snek" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit zen-browser; };
          modules = [ 
            ./home.nix
            {
              home = {
                username = "snek";
                homeDirectory = "/home/snek";
                packages = [
                ];
              };
              nixpkgs.config.allowUnfree = true;
            }
          ];
        };
      };
    };
}
