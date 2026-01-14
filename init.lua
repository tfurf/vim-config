vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local vimrc = vim.fn.stdpath("config") .. "/.vimrc"

vim.cmd.source(vimrc)
vim.lsp.enable('harper-ls')

-- empty setup using defaults
require("nvim-tree").setup()

