require'nvim-tree'.setup {

    renderer = {
        indent_markers = {
            enable = true,
            icons = {
                corner = "└ ",
                edge = "│ ",
                none = "  ",
            }
        }
    },
    git = {
        ignore = false
    }
}
