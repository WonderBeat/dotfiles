{
  description = "My Darwin Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    #darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = { self, nixpkgs, darwin, ... }@inputs:
    let
      mkHost = host: darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [ ./darwin-configuration.nix ./hosts/${host}.nix ];
      };
    in {
      darwinConfigurations."gato" = mkHost "gato";
      darwinConfigurations."hmnd" = mkHost "hmnd";
    };
}
