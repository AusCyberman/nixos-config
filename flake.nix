{

  inputs = {
    #Non flakes
    picom = {
      url = "github:yshui/picom";
      flake = false;
    };
    xmonad = {
      url = "github:auscyberman/xmonad";
      flake = false;
    };
    xmonad-contrib = {
            url = "github:auscyberman/xmonad-contrib";
#      url = "/home/auscyber/xmonad-contrib";
      flake = false;
    };
    dotfiles = {
      #      url = "github:auscyberman/dotfiles?dir=xmonad";
      url = "/home/auscyber/dotfiles";
      flake = false;
    };
    agda-stdlib = {
      url = "github:agda/agda-stdlib/";
      flake = false;
    };

    eww.url = "github:auscyberman/eww";

    #    ghc = {
    #      url = "github:ghc/ghc";
    #      flake = false;
    #    };

    #flakes
    rust-overlay.url = "github:oxalica/rust-overlay";
    idris2-pkgs.url = "github:claymager/idris2-pkgs";
    idris2.url = "github:idris-lang/Idris2";
    rnix.url = "github:nix-community/rnix-lsp";
    neovim.url = "github:neovim/neovim?dir=contrib";
    #    neovim.url = "/home/auscyber/packages/neovim?dir=contrib";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";

    #nixpkgs
    master.url = "github:nixos/nixpkgs/master";
    stable.url = "github:nixos/nixpkgs/nixos-21.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs.follows = "unstable";

  };
  outputs = inputs@{ self, flake-utils, nixpkgs, home-manager, neovim, picom, rnix, idris2, idris2-pkgs, rust-overlay, dotfiles, eww, ... }:
    with nixpkgs.lib;
    let
      config = {
        allowBroken = true;
        allowUnfree = true;
      };
      filterNixFiles = k: v: v == "regular" && hasSuffix ".nix" k;

      importNixFiles = path:
        (lists.forEach (mapAttrsToList (name: _: path + ("/" + name))
          (filterAttrs filterNixFiles (builtins.readDir path)))) import;
      overlays = [
        rust-overlay.overlay
        (final: prev:
        let system = final.stdenv.hostPlatform.system;
        in
          {

            eww = eww.packages.${system}.eww;
            rnix-lsp = rnix.packages."${system}".rnix-lsp;
            picom = (prev.picom.overrideAttrs (attrs: { src = picom; }));
            idris2 = idris2.packages."${system}".idris2;
            neovim-nightly = neovim.packages."${system}".neovim;

            haskellPackages = prev.haskellPackages.override {
              overrides = self: super: rec {
                #ghc = prev.haskell.compiler.ghc901;                #          X11 = self.X11_1_10;
                xmonad = self.callCabal2nix "xmonad" inputs.xmonad { };
                xmonad-contrib =
                  self.callCabal2nix "xmonad-contrib" inputs.xmonad-contrib { };
                my-xmonad = self.callCabal2nix "my-xmonad" (inputs.dotfiles + "/xmonad") { };

                agda-stdlib =
                  self.callCabal2nix "agda-stdlib-utils" inputs.agda-stdlib { };
              };
            };

          })
      ];

      #    ++ (importNixFiles ./overlays);

    in
    (flake-utils.lib.eachDefaultSystem (system: {
      apps.${system}.nvim = neovim.apps.${system}.nvim;
    })) //
    {
      nixosConfigurations.auspc = import ./systems/auspc {
        inherit nixpkgs config home-manager overlays inputs;
      };

    };

}


