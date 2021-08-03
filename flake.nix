{

  inputs = {
    #Non flakes
    picom = {
      url = "github:ibhagwan/picom";
      flake = false;
    };
    #    ghc = {
    #      url = "github:ghc/ghc";
    #      flake = false;
    #    };

    #flakes
    wezterm = {
      url = "/home/auscyber/code/wezterm";
      flake = false;
#      submodules = true;
    };
    xmonad-config.url = "/home/auscyber/dotfiles/xmonad-config";
    agenix.url = "github:ryantm/agenix";
    eww.url = "github:elkowar/eww";
    rust-overlay.url = "github:oxalica/rust-overlay";
    #idris2-pkgs.url = "github:claymager/idris2-pkgs";
    idris2.url = "github:idris-lang/Idris2";
    rnix.url = "github:nix-community/rnix-lsp";
    neovim.url = "github:neovim/neovim?dir=contrib";
    #    neovim.url = "/home/auscyber/packages/neovim?dir=contrib";
    home-manager.url = "github:nix-community/home-manager";
    nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
    emacs.url = "github:/nix-community/emacs-overlay";
    flake-utils.url = "github:numtide/flake-utils";
    #nixpkgs
    master.url = "github:nixos/nixpkgs/master";
    stable.url = "github:nixos/nixpkgs/nixos-21.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs.follows = "unstable";

  };
  outputs = inputs@{ self, master, flake-utils, nixpkgs, home-manager, neovim, picom, rnix, idris2, rust-overlay, eww, nixos-mailserver, agenix, xmonad-config, ... }:
    with nixpkgs.lib;
    let
      config = {
        allowBroken = true;
        allowUnfree = true;
      };
      filterNixFiles = k: v: v == "regular" && hasSuffix ".nix" k;
      masterp = import master;
      importNixFiles = path:
        (lists.forEach (mapAttrsToList (name: _: path + ("/" + name))
          (filterAttrs filterNixFiles (builtins.readDir path)))) import;
      overlays = [
        xmonad-config.overlay
        inputs.emacs.overlay
        rust-overlay.overlay
        (final: prev:
          let system = final.stdenv.hostPlatform.system;
          in
          {


            eww = eww.packages.${system}.eww;
            rnix-lsp = rnix.packages."${system}".rnix-lsp;
            picom = (prev.picom.overrideAttrs (attrs: { src = picom; }));
            #            idris2 = idris2.packages."${system}".idris2;
            #            wezterm = (masterp {inherit system;}).wezterm;
            wezterm = prev.wezterm.overrideAttrs (attrs: {
              src = inputs.wezterm;
              cargoDeps = attrs.cargoDeps.overrideAttrs (cattrs: {
                src = inputs.wezterm;
                outputHash = "sha256-iNv9JEu1aQBxhwlugrl2GdoSvF9cYgM6TXBqamrPjFo=";
              });
            });
            neovim-nightly = neovim.packages."${system}".neovim.overrideAttrs (attrs:
              {
                nativeBuildInputs = with final.pkgs; [ unzip cmake pkgconfig gettext tree-sitter gcc ];
              });

            minecraft-server = (import master { inherit system config; }).minecraft-server;
          })
      ];

      #    ++ (importNixFiles ./overlays);

    in
    (flake-utils.lib.eachDefaultSystem (system: {
      apps.${system}.nvim = neovim.apps.${system}.nvim;
    })) //
    {
      nixosConfigurations = {
        auspc = import ./systems/auspc {
          inherit nixpkgs config home-manager overlays inputs agenix;
        };
        secondpc = import ./systems/secondpc {
          inherit nixpkgs config home-manager overlays inputs nixos-mailserver;
        };

      };
    };

}




