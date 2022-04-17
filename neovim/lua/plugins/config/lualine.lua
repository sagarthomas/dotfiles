
require('lualine').setup {
    options = {
        --disabled_filetypes = {'NvimTree'},
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},

    },
    sections = {
        lualine_a = {
            {
                'mode',
                -- color = { fg = '#ffaa88', bg = 'grey', gui='italic,bold' }
            }
        },
        lualine_b = {},
        lualine_c = {
            {
                'filename',
                path = 1,
            }
        },
        lualine_x = {'encoding', 'filetype', 'location', 'progress'},
        lualine_y = {},
        -- lualine_z = {'location'}
        lualine_z = {'branch', 'diff', 'diagnostics'},
    },
    extensions = {'nvim-tree'}
}
