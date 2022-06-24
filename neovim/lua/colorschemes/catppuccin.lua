local catppuccin = require("catppuccin")

-- configure it
catppuccin.setup()

vim.g.catppuccin_flavour = "frappe" -- latte, frappe, macchiato, mocha
vim.cmd[[colorscheme catppuccin]]
