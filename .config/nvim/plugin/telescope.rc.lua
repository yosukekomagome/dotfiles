local status, telescope = pcall(require, 'telescope')
if not status then
	return
end
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')

local function telescope_buffer_dir()
	return vim.fn.expand('%:p:h')
end
local fb_actions = require('telescope').extensions.file_browser.actions

telescope.setup({
	defaults = {
		file_ignore_patterns = {
			'^.git/',
			'^.cache/',
			'^Library/',
			'Parallels',
			'^Movies',
			'^Music',
			-- "node_modules",
			'vendor',
		},
		vimgrep_arguments = {
			'rg',
			'--color=never',
			'--no-heading',
			'--with-filename',
			'--line-number',
			'--column',
			'--smart-case',
			'-uu',
		},
		mappings = {
			n = {
				['q'] = actions.close,
				['sv'] = actions.select_vertical,
				['ss'] = actions.select_horizontal,
				['st'] = actions.select_tab,
				['o'] = actions.select_default,
				['l'] = actions.select_default,
			},
		},
	},
	extensions = {
		-- ソート性能を大幅に向上させるfzfを使う
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = 'smart_case',
		},
		file_browser = {
			path = '%:p:h',
			cwd = telescope_buffer_dir(),
			respect_gitignore = false,
			theme = 'dropdown',
			hijack_netrw = true,
			initial_mode = 'normal',
			hidden = true,
			layout_config = { height = 40 },
			grouped = true,
			previewer = false,
			mappings = {
				-- your custom insert mode mappings
				['i'] = {},
				-- your custom normal mode mappings
				['n'] = {
					['N'] = fb_actions.create,
					['h'] = fb_actions.goto_parent_dir,
					['<C-u>'] = function(prompt_bufnr)
						for i = 1, 10 do
							actions.move_selection_previous(prompt_bufnr)
						end
					end,
					['<C-d>'] = function(prompt_bufnr)
						for i = 1, 10 do
							actions.move_selection_next(prompt_bufnr)
						end
					end,
					['<PageUp>'] = actions.preview_scrolling_up,
					['<PageDown>'] = actions.preview_scrolling_down,
				},
			},
		},
	},
})
require('telescope').load_extension('fzf')
require('telescope').load_extension('file_browser')

-- keymaps
-- local { noremap = true, silent = true, desc = '' } = { noremap = true, silent = true, desc = '' }
vim.keymap.set('n', ';f', function()
	builtin.find_files({ no_ignore = false, hidden = true })
end, { noremap = true, silent = true, desc = 'telescope find_files' })
vim.keymap.set('n', ';g', function()
	builtin.live_grep()
end, { noremap = true, silent = true, desc = 'telescope live_grep' })
vim.keymap.set('n', ';e', function()
	builtin.diagnostics()
end, { noremap = true, silent = true, desc = 'telescope diagnostics' })
vim.keymap.set('n', ';b', function()
	builtin.buffers()
end, { noremap = true, silent = true, desc = 'telescope buffers' })
vim.keymap.set('n', ';h', function()
	builtin.help_tags()
end, { noremap = true, silent = true, desc = 'telescope help_tags' })
vim.keymap.set('n', ';k', function()
	builtin.keymaps()
end, { noremap = true, silent = true, desc = 'telescope keymaps' })
-- 直前に実行したtelescopeFileBrowserの機能を再度起動する（間違えるので使わない）
-- vim.keymap.set('n', ';;', function()
-- 	builtin.resume()
-- end, opts)
vim.keymap.set('n', 'sf', function()
	telescope.load_extension('file_browser').file_browser()
end, { noremap = true, silent = true, desc = 'telescope file_browser' })
