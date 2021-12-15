{
  description = "auscyber home-manager flake";

  inputs = {
    caches.url = "github:jonascarpay/declarative-cachix";
    rust-overlay.url = "github:oxalica/rust-overlay";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    local-nixpkgs.url = "/opt/nixpkgs";
    #    home-manager.url = "github:nix-community/home-manager";
    home-manager.url = "/home/auscyber/packages/home-manager?ref=neovim-use-plugin"; # github:auscyberman/home-manager?ref=neovim-use-plugin";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    neovim.url = "github:neovim/neovim?dir=contrib";
    neovim.inputs.nixpkgs.follows = "local-nixpkgs";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs";
    idris2-pkgs.url = "github:claymager/idris2-pkgs";
    idris.url = "github:idris-lang/idris2";
    idris.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ home-manager, nixpkgs, emacs-overlay, nix-doom-emacs, neovim, rust-overlay, local-nixpkgs, idris2-pkgs, caches, idris, ... }:
    let
      #      fmerge = cfg: f: merge cfg (f cfg);
      local-pkgs = import local-nixpkgs;
      overlays = [
        #        rust-overlay
        emacs-overlay.overlay
        (final: prev:
          let system = final.stdenv.hostPlatform.system;
          in
          rec {
            #eww = eww.packages.${system}.eww;
            #rnix-lsp = rnix.packages."${system}".rnix-lsp;
            #picom = (prev.picom.overrideAttrs (attrs: { src = picom; }));
            #            idris2 = idris2.packages."${system}".idris2;
            #            idris2 = idris.packages."${system}".idris2;
            #            wezterm = (masterp {inherit system;}).wezterm;
            idris2 = idris2Pkgs.idris2;
            #            neovim-nightly = neovim.packages."${system}".neovim.override { gcc = prev.gcc_latest; };
            neovim-nightly =
              neovim.packages."${system}".neovim.override {
                link-lstdcpp = true;
                stdenv = prev.gcc11Stdenv;
              }
            ;

            idris2Pkgs = idris2-pkgs.packages."${system}";
            #minecraft-server = (import master { inherit system config; }).minecraft-server;
          })
      ];
      external_modules = [ ./. nix-doom-emacs.hmModule ];
    in
    {
      homeConfigurations = builtins.mapAttrs
        (name: cfg: home-manager.lib.homeManagerConfiguration
          (
            cfg //
            {
              configuration = { config, lib, pkgs, ... }: {
                imports = [ cfg.configuration ] ++ external_modules;
                home.sessionVariables = {
                  FLAKENAME = "${name}";
                  NIXFLAKE = "${config.xdg.configHome}/nixpkgs";
                };
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
              imports = [ ./arch.nix ./modules/agda.nix ./modules/emacs.nix ./modules/neovim.nix ./modules/kakoune.nix ./modules/idris2.nix ];
            };
          };
        };
    };
}
