vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.o.relativenumber = true
vim.o.number = true

vim.o.clipboard = "unnamedplus"
vim.o.hlsearch = true
vim.o.autoindent = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4

-- configure undofile
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/undo"

vim.o.foldlevel = 99
vim.o.foldcolumn = "1"
vim.o.foldlevelstart = 99
vim.o.foldenable = true
