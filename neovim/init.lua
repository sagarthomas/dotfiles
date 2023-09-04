-- Modified version of https://github.com/nvim-lua/kickstart.nvim

-- Configures leader mappings first before plugins are loaded
require('mappings')
-- Basic Configuration
require('settings')

-- Configure lazy nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")



-- Theme
require('colorschemes.catppuccin')
--require('colorschemes.ayu')

-- Plugin config
require('plugins.config.telescope')
require('plugins.config.treesitter')
require('plugins.config.lualine')
require('plugins.config.blankline')
require('plugins.config.gitsigns')
require('plugins.config.lspconfig')
require('plugins.config.nvimtree')


local function open_nvim_tree(data)

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- change to the directory
  vim.cmd.cd(data.file)

  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })



