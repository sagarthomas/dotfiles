local catppuccin = require("catppuccin")

vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
local cp = require("catppuccin.palettes").get_palette()

catppuccin.setup({
    custom_highlights = {
        TelescopeBorder = { fg = cp.blue },
        TelescopeSelectionCaret = { fg = cp.flamingo, bg = cp.surface0 },
        TelescopeSelection = { fg = cp.text, bg = cp.surface0, style = { "bold" } },
        TelescopeMatching = { fg = cp.blue },
        --TelescopePromptPrefix = { bg = cp.crust },
        TelescopePromptNormal = { bg = cp.surface0 },
        TelescopeResultsNormal = { bg = cp.crust },
        TelescopePreviewNormal = { bg = cp.crust },
        TelescopePromptBorder = { bg = cp.surface0, fg = cp.surface0},
        TelescopeResultsBorder = { bg = cp.crust, fg = cp.crust },
        TelescopePreviewBorder = { bg = cp.crust, fg = cp.crust },
        TelescopePromptTitle = { fg = "#0c0d13", bg = cp.red },
        --TelescopeResultsTitle = { fg = "#0c0d13", bg = cp.teal },
        TelescopeResultsTitle = { fg = cp.crust },
        TelescopePreviewTitle = { fg = "#0c0d13", bg = cp.teal}
    }
})

vim.cmd[[colorscheme catppuccin]]
