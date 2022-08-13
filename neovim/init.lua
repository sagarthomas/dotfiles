require('settings')
require('plugins')
--require('colorschemes.ayu')
require('colorschemes.catppuccin')
require('mappings')

-- Require all plugin config 
require('plugins.config.lualine')
--require('plugins.config.bufferline')
require('plugins.config.blankline')
require('plugins.config.nvimtree')
require('plugins.config.telescope')
require('plugins.config.treesitter')
require('plugins.config.context')

-- Require LSP specific plugin config
require('plugins.config.lsp.lspconfig')
require('plugins.config.lsp.lspcmp')
