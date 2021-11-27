{
  description = "auscyber home-manager flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    #    home-manager.url = "github:nix-community/home-manager";
    home-manager.url = "/home/auscyber/packages/home-manager?ref=neovim-use-plugin"; # github:auscyberman/home-manager?ref=neovim-use-plugin";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    neovim.url = "github:neovim/neovim?dir=contrib";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs";
  };

  outputs = inputs@{ home-manager, nixpkgs, emacs-overlay, nix-doom-emacs, neovim, ... }:
    let
      #      fmerge = cfg: f: merge cfg (f cfg);
      overlays = [
        emacs-overlay.overlay
        (final: prev:
          let system = final.stdenv.hostPlatform.system;
          in
          {


            #eww = eww.packages.${system}.eww;
            #rnix-lsp = rnix.packages."${system}".rnix-lsp;
            #picom = (prev.picom.overrideAttrs (attrs: { src = picom; }));
            #            idris2 = idris2.packages."${system}".idris2;
            #            wezterm = (masterp {inherit system;}).wezterm;
            neovim-nightly = neovim.packages."${system}".neovim.overrideAttrs (attrs: {
              nativeBuildInputs = attrs.nativeBuildInputs ++ (with prev; [ prev.patchelf ]);
              postFixup = ''
                patchelf --add-needed ${neovim.packages."${system}".neovim.stdenv.cc.cc.lib}/lib/libstdc++.so.6 $out/bin/nvim
              '';
            });

            #minecraft-server = (import master { inherit system config; }).minecraft-server;
          })
      ];
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
              imports = [ ./arch.nix ./agda.nix ./emacs.nix ./neovim.nix ];
            };
          };
        };
    };
}
