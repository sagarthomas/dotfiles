return require'packer'.startup(function()
    use 'wbthomason/packer.nvim'

    -- Appearance
    use 'Luxed/ayu-vim'
    use 'kyazdani42/nvim-web-devicons'  
    use 'nvim-lualine/lualine.nvim'

    -- Editor
    use 'kyazdani42/nvim-tree.lua'
    use 'akinsho/bufferline.nvim' -- For showing buffers on top
    use 'lukas-reineke/indent-blankline.nvim' -- For indent lines
    use 'sbdchd/neoformat'
    use {
        'nvim-treesitter/nvim-treesitter', -- For better syntax highlighting
        run = ':TSUpdate'
    }


    -- Git
    use 'mhinz/vim-signify' -- For showing git +/- on the editor
    use 'tpope/vim-fugitive' -- For git controls

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            {'nvim-lua/plenary.nvim'},
            {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
        }
    }

    -- Language 
    use 'maxmellon/vim-jsx-pretty'
    use 'vim-python/python-syntax'
    use 'prettier/vim-prettier'
    use {
        'fatih/vim-go',
        run = ':GoUpdateBinaries'
    }


    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/nvim-cmp'
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use 'onsails/lspkind.nvim'
end)




