require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "python", "typescript", "javascript","go", "lua", "rust", "java"},

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,


  highlight = {
    -- `false` will disable the whole extension
    disable = {"markdown"},
    enable = true,
    additional_vim_regex_highlighting = true,
  },
}
