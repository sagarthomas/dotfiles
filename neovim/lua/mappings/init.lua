local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.g.mapleader = ' '

map('n', '<leader>n', ':NvimTreeToggle<CR>', opts)

-- Pane movement
map('n', '<leader>j', '<C-w>j<CR>', opts)
map('n', '<leader>h', '<C-w>h<CR>', opts)
map('n', '<leader>k', '<C-w>k<CR>', opts)
map('n', '<leader>l', '<C-w>l<CR>', opts)

-- Telescope
map('n', '<leader>ff', ':Telescope find_files<CR>', opts)
map('n', '<leader>fb', ':Telescope buffers<CR>', opts)

-- Vim Fugitive
map('n', '<leader>gj', '<cmd>diffget //3<CR>', opts)
map('n', '<leader>gf', '<cmd>diffget //2<CR>', opts)
map('n', '<leader>gs', '<cmd>G<CR>', opts)

