-- For executing single line of lua code
vim.keymap.set("n", "<space><space>x", "<cmd>source <CR>")

local set = vim.opt_local

set.shiftwidth = 2
set.number = true
set.relativenumber = true
