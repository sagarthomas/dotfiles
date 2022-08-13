local set = vim.opt

-- vim.cmd[[set.noerrorbells = true]]
-- vim.cmd[[set.belloff=all]]
set.tabstop = 4
set.softtabstop= 4
set.shiftwidth = 4
set.expandtab = true
set.smartindent = true
set.relativenumber = true
set.nu = true
set.ignorecase = true
set.smartcase = true
-- set.nowrap = true
set.hlsearch = true
set.incsearch = true

set.smarttab = true

-- set.noswapfile = true
-- set.nobackup = true
--set.undodir=~/.vim/undodir
--set.undofile=true

set.showmatch = true
set.cursorline = true
set.hidden = true
set.scrolloff = 12

set.termguicolors = true
vim.cmd[[set colorcolumn=80]]
vim.cmd[[highlight ColorColumn ctermbg=0 guibg=lightgrey]]
vim.cmd[[set clipboard=unnamedplus]]
set.laststatus = 2
set.conceallevel = 3

vim.cmd[[autocmd BufNewFile,BufRead Jenkinsfile set filetype=groovy]]
