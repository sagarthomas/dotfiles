
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
                separator =  { left = '', right = ''}
                -- color = { fg = '#ffaa88', bg = 'grey', gui='italic,bold' }
            }
        },
        --lualine_b = {'buffers'},
        lualine_b = {},
        lualine_c = {
            {
                'filename',
                path = 1,
            },
        },
        lualine_x = { 'filetype', 'location', 'progress'},
        lualine_y = {'diagnostics', 'branch'},
        lualine_z = {}
       -- lualine_z = {
       --     {
       --         'branch',
       --         separator =  { left = '', right = ''}

       --     }
       -- },
    },
    extensions = {'nvim-tree'}
}
