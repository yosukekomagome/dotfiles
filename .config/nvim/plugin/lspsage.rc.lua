require('lspsaga').setup({
	symbol_in_winbar = {
		enable = false, -- パンクズリスト表示
	},
	ui = {
		border = 'single', -- フローティングウィンドウのボーダーのスタイル
		devicon = true,
		title = false,
		scroll_down = '<C-d>', -- デフォルトは<C-f>
		scroll_up = '<C-u>', -- デフォルトは<C-b>
		-- code_action = '💡' -- lightbulb有効時に表示するアイコン
	},
	lightbulb = {
		enable = false, -- code action のアイコンを表示する
	},
	finder = {
		default = 'imp+ref',
		max_height = 0.5,
		keys = {
			vsplit = 'sv',
			split = 'ss',
			tabnew = 'st',
		},
	},
	outline = {
		win_position = 'left',
		win_width = 50,
		auto_preview = false, -- layout = normal時だけ効くがプレビューがうまく表示されない
		auto_close = true, -- うまく動いていない様子
		close_after_jump = true,
		layout = 'float',
		max_height = 0.5,
		left_width = 0.3,
	},
	rename = {
		keys = {
			quit = '<ESC>',
		},
	},
})

-- keymap
local opts = { noremap = true, silent = true }
vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>', opts)
vim.keymap.set('n', 'gd', '<cmd>Lspsaga finder<CR>', opts)
vim.keymap.set('n', '<C-j>', '<cmd>Lspsaga diagnostic_jump_next<CR>', opts)
vim.keymap.set('n', '<C-k>', '<cmd>Lspsaga diagnostic_jump_prev<CR>', opts)
vim.keymap.set('n', '<leader>rn', '<cmd>Lspsaga rename<CR>', opts)

-- colors
-- vim.cmd([[highlight SagaBorder guifg = #05f1f5]])

-- not use functions
-- vim.keymap.set('n', 'gp', '<cmd>Lspsaga preview_definition<CR>')
-- vim.keymap.set('n', 'lo', '<cmd>Lspsaga outline<CR>')
-- vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>")
-- vim.keymap.set("n", "ga", "<cmd>Lspsaga code_action<CR>")
-- vim.keymap.set("n", "gn", "<cmd>Lspsaga rename<CR>")
-- vim.keymap.set("n", "ge", "<cmd>Lspsaga show_line_diagnostics<CR>")
-- vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
-- vim.keymap.set("n", "<A-d>", "<cmd>Lspsaga open_floaterm<CR>")
-- vim.keymap.set("n", "<A-d>", "<cmd>Lspsaga open_floaterm lazygit<CR>")
-- vim.keymap.set("t", "<A-d>", [[<C-\><C-n><cmd>Lspsaga close_floaterm<CR>]])
