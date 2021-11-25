{ config, pkgs, ... }: {
  home.packages = with pkgs; [ (agda.withPackages (p: [ p.standard-library p.cubical p.agda-categories ])) ];
}

