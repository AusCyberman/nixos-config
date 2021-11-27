{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    vimDiffAlias = true;
    package = pkgs.neovim-nightly;
    plugins = with pkgs.vimPlugins; [ vim-nix ];
    extraConfig = ''
      let g:sqlite_clib_path = "${pkgs.sqlite.out}/lib/libsqlite3.so"
    '';
  };
}
