-- keymap
local keymap = vim.keymap
local opts = { noremap = true, silent = true }
keymap.set('n', '<leader>di', ':DiffviewOpen<cr>', opts)
