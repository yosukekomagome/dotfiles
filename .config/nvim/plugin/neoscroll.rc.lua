-- 1. まず 'neoscroll' モジュール本体を読み込み、変数に保存します
local neoscroll = require('neoscroll')

-- 2. その変数を使って setup() を呼び出します
neoscroll.setup({
	easing_function = 'sine',
	mappings = {}, -- neoscrollによるデフォルトのキーマップを無効化
})

-- 3. Vim標準のキーマップ設定（vim.keymap.set）を使います
local opts = { noremap = true, silent = true }
local modes = { 'n', 'v', 's' } -- ノーマル、ビジュアル、セレクトモードで有効

-- 4. 'neoscroll.scroll' には文字列ではなく、数値を渡します

-- <C-u>
vim.keymap.set(modes, '<C-u>', function()
	neoscroll.scroll(-vim.wo.scroll, true, 125)
end, opts)

-- <C-d>
vim.keymap.set(modes, '<C-d>', function()
	neoscroll.scroll(vim.wo.scroll, true, 125)
end, opts)

-- <C-b>
vim.keymap.set(modes, '<C-b>', function()
	neoscroll.scroll(-vim.api.nvim_win_get_height(0), true, 125)
end, opts)

-- <C-f>
vim.keymap.set(modes, '<C-f>', function()
	neoscroll.scroll(vim.api.nvim_win_get_height(0), true, 125)
end, opts)
