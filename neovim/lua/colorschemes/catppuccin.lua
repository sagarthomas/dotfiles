local catppuccin = require("catppuccin")

catppuccin.setup({
    flavour = "frappe",
    integrations = {
        telescope = {
            enabled = true,
            style = "nvchad"
        },
    }
})

vim.cmd.colorscheme "catppuccin"
-- vim.cmd [[colorscheme catppuccin]]
