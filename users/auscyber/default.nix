{ config, pkgs, system, lib, modulesPath, ... }:
{
  programs = {
    command-not-found.enable = true;
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
    #zsh.enable = true;
    home-manager.enable = true;
  };
  services.lorri = {
    enable = true;
  };
  home.packages = with pkgs; [ rnix-lsp nixfmt ];

}
