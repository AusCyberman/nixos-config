{ config, pkgs, system, lib, ... }:
rec {
  targets.genericLinux.enable = true;
  home.packages = with pkgs; [
#    rnix-lsp
postman
(polybar.override {
  pulseSupport = true;
  iwSupport  = true;
  githubSupport = true;
})
#google-chrome

  ];
}
