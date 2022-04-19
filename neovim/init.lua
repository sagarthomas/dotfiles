require('settings')
require('plugins')
require('colorschemes.ayu')
require('mappings')

-- Require all plugin config 
require('plugins.config.lualine')
require('plugins.config.bufferline')
require('plugins.config.blankline')
require('plugins.config.nvimtree')
require('plugins.config.telescope')

-- Require LSP specific plugin config
require('plugins.config.lsp.lspconfig')
require('plugins.config.lsp.lspcmp')
