local lib = require 'lib'
_G = table.merge(_G,lib)
local bo = vim.bo
local wo = vim.wo
local o = vim.o
o.mouse = 'a'
bo.expandtab = true
bo.tabstop=4
bo.shiftwidth=4
o.expandtab = true
o.tabstop=4
o.shiftwidth=4
o.hidden = true
o.updatetime=300
o.signcolumn = 'yes'

wo.rnu = true
wo.nu = true
o.termguicolors = true
--vim.o.guifont= "Hasklug Nerd Font:h15"
--vim.api.nvim_command [[ let g:neovide_fullscreen=v:true ]]
vim.api.nvim_command [[

colorscheme pink_ocean
so ~/.config/nvim/animate.vim
filetype plugin indent on
filetype on
]]