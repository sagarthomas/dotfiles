return require'packer'.startup(function()
    use 'wbthomason/packer.nvim'

    -- Appearance
    use 'Luxed/ayu-vim'
    use 'kyazdani42/nvim-web-devicons'  
    use 'nvim-lualine/lualine.nvim'

    -- Editor
    use 'kyazdani42/nvim-tree.lua'
    use 'akinsho/bufferline.nvim'
    use 'lukas-reineke/indent-blankline.nvim'


    -- Git
    use 'mhinz/vim-signify'
    use 'tpope/vim-fugitive'

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            {'nvim-lua/plenary.nvim'},
            {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
        }
    }

    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/nvim-cmp'
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
end)




