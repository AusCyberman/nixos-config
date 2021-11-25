{
  description = "A Home Manager flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: {
    homeConfigurations = {
      auscyber = inputs.home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        homeDirectory = "/home/auscyber";
        username = "auscyber";
        configuration.imports = [ ./home.nix ];
      };
    };
  };
}

