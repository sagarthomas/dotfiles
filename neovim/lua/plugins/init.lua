local Plug = vim.fn['plug#']
vim.call('plug#begin','~/.vim/plugged')

-- Appearance
Plug 'Luxed/ayu-vim'
Plug 'kyazdani42/nvim-web-devicons'  
Plug 'nvim-lualine/lualine.nvim'

-- Plug 'beauwilliams/statusline.lua'
-- Plug 'feline-nvim/feline.nvim'

-- Editor
Plug 'kyazdani42/nvim-tree.lua'
Plug 'akinsho/bufferline.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'

-- Telescope

-- LSP
Plug 'neovim/nvim-lspconfig'

vim.call('plug#end')

-- Require all config 
require('plugins.config.lualine')
require('plugins.config.bufferline')
require('plugins.config.blankline')
require('plugins.config.nvimtree')



