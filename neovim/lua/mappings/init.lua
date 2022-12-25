--local map = vim.api.nvim_set_keymap
--local opts = { noremap = true, silent = true }

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set('n', '<leader>n', ':NvimTreeToggle<CR>')

-- Pane movement
vim.keymap.set('n', '<leader>j', '<C-w>j<CR>')
vim.keymap.set('n', '<leader>h', '<C-w>h<CR>')
vim.keymap.set('n', '<leader>k', '<C-w>k<CR>')
vim.keymap.set('n', '<leader>l', '<C-w>l<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Vim Fugitive
vim.keymap.set('n', '<leader>gj', '<cmd>diffget //3<CR>')
vim.keymap.set('n', '<leader>gf', '<cmd>diffget //2<CR>')
vim.keymap.set('n', '<leader>gs', '<cmd>G<CR>')

