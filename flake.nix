{
  inputs = {
    #Non flakes
    picom = {
      url = "github:ibhagwan/picom";
      flake = false;
    };

    #flakes
    agenix.url = "github:ryantm/agenix";
    eww.url = "github:elkowar/eww";
    rust-overlay.url = "github:oxalica/rust-overlay";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs";
    idris2-pkgs.url = "github:claymager/idris2-pkgs";
    local-nixpkgs.url = "github:auscyberman/nixpkgs";
    home-manager = {
      url = "github:auscyberman/home-manager/neovim-use-plugin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #idris2-pkgs.url = "github:claymager/idris2-pkgs";
    idris2.url = "github:idris-lang/Idris2";
    rnix.url = "github:nix-community/rnix-lsp";
    neovim = {
      #      inputs.nixpkgs.follows = "local-nixpkgs";
      url = "github:neovim/neovim?dir=contrib";
    };

    nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
    emacs.url = "github:/nix-community/emacs-overlay";
    flake-utils.url = "github:numtide/flake-utils";
    #nixpkgs
    master.url = "github:nixos/nixpkgs/master";
    stable.url = "github:nixos/nixpkgs/nixos-21.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs.follows = "unstable";

  };
  outputs =
    inputs@{ self
    , master
    , flake-utils
    , nixpkgs
    , home-manager
    , neovim
    , picom
    , rnix
    , idris2
    , rust-overlay
    , eww
    , nixos-mailserver
    , agenix
    , nix-doom-emacs
    , idris2-pkgs
    , ...
    }:
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
          inputs.emacs.overlays.default
          rust-overlay.overlays.default
          (final: prev:
            let system = final.stdenv.hostPlatform.system;
            in
            {

              eww = eww.packages.${system}.eww;
              rnix-lsp = rnix.packages."${system}".rnix-lsp;
              picom = (prev.picom.overrideAttrs (attrs: { src = picom; }));
              #            idris2 = idris2.packages."${system}".idris2;
              #            wezterm = (masterp {inherit system;}).wezterm;
              discord = (import master { inherit system config; }).discord;
              wezterm = prev.wezterm.overrideAttrs (attrs: {
                src = inputs.wezterm;
                cargoDeps = attrs.cargoDeps.overrideAttrs (cattrs: {
                  src = inputs.wezterm;
                  outputHash =
                    "sha256-iNv9JEu1aQBxhwlugrl2GdoSvF9cYgM6TXBqamrPjFo=";
                });
              });
              neovim-nightly = neovim.packages."${system}".neovim.overrideAttrs (drv: {
                #                link-lstdcpp = true;
                propagatedBuildInputs = [ prev.gcc12Stdenv.cc.cc.lib ];
              });

              idris2 = final.idris2Pkgs.idris2;
              idris2Pkgs = idris2-pkgs.packages."${system}";
              minecraft-server =
                (import master { inherit system config; }).minecraft-server;
            })
        ];

        base-home = name: system: {
          inherit system name;
          home = "/home/${name}";
        };
        #    ++ (importNixFiles ./overlays);


      in
      (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        apps.nvim = flake-utils.lib.mkApp {
          name = "nvim";
          drv = pkgs.neovim-nightly;
        };
      })) // {
        nixosConfigurations = {
          auspc = import ./systems/auspc {
            inherit nixpkgs config overlays inputs agenix;
          };
          secondpc = import ./systems/secondpc {
            inherit nixpkgs config overlays inputs nixos-mailserver;
          };

        };
        homeConfigurations = builtins.mapAttrs
          (name: cfg:
            let pkgs = import nixpkgs {
              config.allowUnfree = true;
              system = cfg.system;
              inherit overlays;
            };
            in
            home-manager.lib.homeManagerConfiguration (cfg // {
              inherit pkgs;
              configuration = { config, lib, pkgs, ... }: {
                imports = [ cfg.configuration ./hm/. nix-doom-emacs.hmModule ];
                home.sessionVariables = {
                  FLAKENAME = "${name}";
                  NIXFLAKE = "$HOME/dotfiles/nixos-config";
                };
                nixpkgs.overlays = overlays;
              };
            }))
          {
            #            wsl = {
            #              system = "x86_64-linux";
            #              homeDirectory = "/home/auscyber";
            #              username = "auscyber";
            #            };
            manjaro = base-home "auscyber" "x86_64-linux";
            nixos = {
              system = "x86_64-linux";
              homeDirectory = "/home/auscyber";
              username = "auscyber";
              configuration = {
                imports = [ ./hm/nixos.nix ./hm/agda.nix ./hm/emacs.nix ];
              };
            };
            arch = {
              system = "x86_64-linux";
              homeDirectory = "/home/auscyber";
              username = "auscyber";
              configuration = {
                imports = [
                  ./hm/arch.nix
                  ./hm/modules/agda.nix
                  #                  ./hm/modules/emacs.nix
                  ./hm/modules/neovim.nix
                  ./hm/modules/kakoune.nix
                  ./hm/modules/idris2.nix
                ];
              };
            };
          };
      };
}

