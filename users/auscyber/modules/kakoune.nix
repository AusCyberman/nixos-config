{ config, pkgs, ... }:
{
  programs.kakoune = {
    enable = true;
    plugins = with pkgs.kakounePlugins; [ kak-lsp parinfer-rust powerline-kak ];
  };

}
