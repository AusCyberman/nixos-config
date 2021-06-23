{

  inputs = {
    #Non flakes
      picom = { url = "github:yshui/picom"; flake = false; };
      xmonad = { url = "path:/home/auscyber/xmonad"; flake = false; };
      xmonad-contrib = { url = "path:/home/auscyber/xmonad-contrib"; flake = false; };
      agda-stdlib = { url = "path:/home/auscyber/agda-stdlib-1.5"; flake = false; };

    

      #flakes
      neovim.url = "github:neovim/neovim?dir=contrib";
      flake-utils.url = "github:numtide/flake-utils"; 
      home-manager.url = "github:nix-community/home-manager";

      #nixpkgs
      master.url = "github:nixos/nixpkgs/master";
      stable.url = "github:nixos/nixpkgs/nixos-21.05";
      unstable.url = "github:nixos/nixpkgs/nixos-unstable";

       nixpkgs.follows = "master";

  };
  outputs = inputs@{self, nixpkgs, home-manager, neovim, picom, ... }: 
  with nixpkgs.lib;
   let 
        config =  {
          allowBroken = true;
          allowUnfree = true;

        };
        filterNixFiles = k: v: v == "regular" && hasSuffix ".nix" k;

        importNixFiles = path: (lists.forEach (mapAttrsToList (name: _: path + ("/" + name))
                      (filterAttrs filterNixFiles (builtins.readDir path)))) import;
      overlays = [ (final: prev: let system = final.stdenv.hostPlatform.system; in { 
         
        picom = (prev.picom.overrideAttrs (attrs: {
          src = picom;
         }));

        neovim-nightly = neovim.packages.${system}.neovim;
        haskellPackages = prev.haskellPackages.override {
            overrides = self: super: rec {

#    X11 = self.callCabal2nix "X11" (pkgs.fetchFromGitHub {
#      owner = "xmonad";
#      repo = "X11";
#      rev = "master";
#      sha256= "0fyaap5w2lywi6rdmfypy9kqplrdp9jc9m3qbp48a9q6fr87mxdh";
#    }) {};

#          X11 = self.X11_1_10;
          xmonad = self.callCabal2nix "xmonad" inputs.xmonad {};
          xmonad-contrib = self.callCabal2nix "xmonad-contrib" inputs.xmonad-contrib {};
    #my-xmonad = self.callPackage "/home/auscyber/dotfiles/xmonad/my-xmonad.nix" {} ;
      

      

        agda-stdlib = self.callCabal2nix "agda-stdlib-utils" inputs.agda-stdlib {};
    };
  };

    }) ] ++ (importNixFiles ./overlays);

  in

  {
    nixosConfigurations.auspc = import ./systems/auspc { inherit nixpkgs config home-manager overlays inputs; };


  };

}
