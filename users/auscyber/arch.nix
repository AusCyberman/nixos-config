{ config, pkgs, system, lib, ... }:
rec {
  home.packages = with pkgs; [
    rnix-lsp
    emacsGcc
  ];


}
