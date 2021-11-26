{
  description = "auscyber home-manager flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs";
  };

  outputs = inputs@{ home-manager, nixpkgs, emacs-overlay, nix-doom-emacs, ... }:
    let
      #      fmerge = cfg: f: merge cfg (f cfg);
      overlays = [ emacs-overlay.overlay ];
      external_modules = [ ./. nix-doom-emacs.hmModule ];
    in
    {
      homeConfigurations = builtins.mapAttrs
        (name: cfg: home-manager.lib.homeManagerConfiguration (
          cfg //
          {
            configuration = { config, ... }: {
              imports = [ cfg.configuration ] ++ external_modules;
              home.sessionVariables.NIXFLAKE = "${config.xdg.configHome}/nixpkgs#${name}";
              nixpkgs.overlays = overlays;
            };
          }
        ))
        {
          wsl = {
            system = "x86_64-linux";
            homeDirectory = "/home/auscyber";
            username = "auscyber";
          };

          nixos =
            {
              system = "x86_64-linux";
              homeDirectory = "/home/auscber";
              username = "auscyber";
              configuration = {
                imports = [ ./nixos.nix ./agda.nix ./emacs.nix ];
              };
            };
          arch = {
            system = "x86_64-linux";
            homeDirectory = "/home/auscyber";
            username = "auscyber";
            configuration = {
              imports = [ ./arch.nix ./agda.nix ./emacs.nix ];
            };
          };
        };
    };
}
