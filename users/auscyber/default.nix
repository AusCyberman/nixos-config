conf@{ config, pkgs, system, lib, ... }:
let impConf = fil: import fil conf;

in
rec {
  imports = [ ./picom.nix ];
  programs = {
    kakoune = {
      enable = true;
      plugins = with pkgs.kakounePlugins; [ kak-lsp parinfer-rust powerline-kak ];
    };
    vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ vim-airline vim-addon-nix ];
      settings = { ignorecase = true; };
      extraConfig = ''
        set mouse=a
      '';
    };
    command-not-found.enable = true;
    home-manager.enable = true;
  };
#  xdg.configFile."nvim/parser/c.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-c}/parser";
#  xdg.configFile."nvim/parser/lua.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-lua}/parser";
#  xdg.configFile."nvim/parser/rust.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-rust}/parser";
#  xdg.configFile."nvim/parser/python.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-python}/parser";


  services = {
    dunst.enable = false;
    gpg-agent = {
      enable = true;
      pinentryFlavor = "qt";
      enableSshSupport = true;
      extraConfig = ''
        allow-loopback-pinentry
      '';
    };
  };
  programs.gpg.enable = true;

  home.packages = with pkgs;
    [
      direnv
      #  st
      #  ((pkgs.gradleGen.override {
      #    java = jdk8;
      #  }).gradle_latest)
      neovim-nightly
      firefox
      tmux
      rust-analyzer
      wineWowPackages.stable
      emacs
      kotlin
      pcmanfm
      fzf
      vscode
      openjdk8
      xorg.xmodmap
      xorg.xmessage
      multimc
      skypeforlinux
      rofi
      arandr
      ccls
      steam
      jetbrains.idea-ultimate
      libnotify
      stack
      xclip
      ripgrep
      discord
      polybarFull
      git
      playerctl
      htop
      eclipses.eclipse-java
      starship
      fish
      feh
      maim
      teams
      gcc
      dunst
      procps-ng
      nodejs-14_x
      nixfmt
      lua
      (spotify.overrideAttrs (attrs: { nativeInputs = [ gnutls ]; }))
      unzip
      scala
      rnix-lsp
      #  starship ardour
      slack
      #  luaPackages.lua-lsp
      idris2
      stdenv.cc.cc.lib
      grub2_efi
      (python3.withPackages (p: with p; [ pynvim ]))
      metals
      _1password
      gnome.gnome-keyring
      gnome.nautilus
      eww
    ] ++ (with pkgs.lua51Packages; [ luarocks ]) ++ (with pkgs.haskellPackages; [
      stylish-haskell
      agda-stdlib
      Agda
      taffybar
      my-xmonad
      haskell-language-server
      pinentry
      thunderbird
    ]) ++ ([
      (pkgs.haskellPackages.ghcWithPackages (pk:
        with pk; [
          microlens-th
          microlens
          dbus
          xmonad-contrib
          cabal-install
          X11
          xmonad
        ]))
    ]) ++ (with nodePackages; [
      yarn
      typescript-language-server
      typescript
      purescript-language-server
    ]);
  #    ++ (with ocamlPackages; [utop dune ocaml opam merlin]);
  home.username = "auscyber";
  home.homeDirectory = "/home/auscyber";
  home.sessionVariables.EDITOR = "nvim";
  home.stateVersion = "21.11";
}