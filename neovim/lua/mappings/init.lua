local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.g.mapleader = ' '

map('n', '<leader>n', ':NvimTreeToggle<CR>', opts)

-- Pane movement
map('n', '<leader>j', '<C-w>j<CR>', opts)
map('n', '<leader>h', '<C-w>h<CR>', opts)
map('n', '<leader>k', '<C-w>k<CR>', opts)
map('n', '<leader>l', '<C-w>l<CR>', opts)

