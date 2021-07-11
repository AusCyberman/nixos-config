{ nixpkgs, home-manager, config, overlays, inputs, ... }:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    ./hardware-configuration.nix
    ./../../modules/system/grub.nix
    ./boot.nix
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.auscyber = import ../../users/auscyber;
      };
      nixpkgs = { inherit config overlays; };

    }
    home-manager.nixosModules.home-manager
  ];

}

