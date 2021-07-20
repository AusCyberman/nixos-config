{ nixpkgs, home-manager, config, overlays, inputs, agenix, ... }:
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
    agenix.nixosModules.age
    {
      environment.systemPackages =  [ agenix.defaultPackage.x86_64-linux];
    }
  ];

}

