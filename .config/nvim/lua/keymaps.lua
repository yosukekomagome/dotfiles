local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- leader key <space>へ変更
vim.g.mapleader = ' '

-- exit insert mode
keymap.set('i', 'jj', '<ESC>', opts)
keymap.set('i', 'っｊ', '<ESC>', opts)
keymap.set('i', 'ｊｊ', '<ESC>', opts)

-- Do not yank with x,s
keymap.set('n', 'x', '"_x', opts)
keymap.set('n', 's', '"_s', opts)

-- Delete a word backwards
-- keymap.set("n", "dw", 'vb"_d')

-- Select all
keymap.set('n', '<C-a>', 'gg<S-v>G')

-- Split window
keymap.set('n', 'ss', ':split<Return>', opts)
keymap.set('n', 'sv', ':vsplit<Return>', opts)
keymap.set('n', 'sx', ':close<cr>', opts)

-- tab
keymap.set('n', 'tx', ':tabclose<cr>', opts)

-- Move window
keymap.set('n', 'sh', '<C-w>h')
keymap.set('n', 'sk', '<C-w>k')
keymap.set('n', 'sj', '<C-w>j')
keymap.set('n', 'sl', '<C-w>l')

-- no highlight
keymap.set('n', '<ESC><ESC>', ':nohl<CR>', opts)