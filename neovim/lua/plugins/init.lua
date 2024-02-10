return {
    "nvim-lualine/lualine.nvim", -- Status bar
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {}
    },                         -- Adds indentation guide lines
    "lewis6991/gitsigns.nvim", -- Adds git line status
    "tpope/vim-fugitive",
    -- Colorscheme
    {
        "catppuccin/nvim",
        name = "catppuccin"
    },
    -- File tree
    {
        "kyazdani42/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons", -- File icons
        }
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            { "williamboman/mason.nvim", config = true },
            "williamboman/mason-lspconfig.nvim",

            -- Additional lua configuration, makes nvim stuff amazing!
            "folke/neodev.nvim",
        }
    },
    {
        "j-hui/fidget.nvim",
        tag = "legacy",
        event = "LspAttach"
    },
    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            "L3MON4D3/LuaSnip",
            --"saadparwaiz1/cmp_luasnip",

            -- Adds LSP completion capabilities
            "hrsh7th/cmp-nvim-lsp",

            -- Adds a number of user-friendly snippets
            --"rafamadriz/friendly-snippets",
            -- Adds icons for autocomplete menu
            "onsails/lspkind.nvim"
        }
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {} -- this is equalent to setup({}) function
    },
    -- Fuzzy Finder
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            -- Only load if `make` is available. Make sure you have the system
            -- requirements installed.
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                -- NOTE: If you are having trouble with this installation,
                --       refer to the README for telescope-fzf-native for more instructions.
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
        }
    },
    -- Highlight, edit, and navigate code
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
    },
}
