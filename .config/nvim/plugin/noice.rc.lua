require('noice').setup({
	cmdline = {
		format = {
			-- search iconの文字化け対策
			search_down = { kind = 'search', pattern = '^/', icon = ' ', lang = 'regex' },
			search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex' },
		},
	},
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			['vim.lsp.util.convert_input_to_markdown_lines'] = true,
			['vim.lsp.util.stylize_markdown'] = true,
			-- 以下のコードがneovim編集中に急にサジェストされなくなる現象の原因の様子なのでコメント化2026/02/12実行
			-- ["cmp.entry.get_documentation"] = true,
		},
		signature = {
			enabled = false,
		},
	},
	-- you can enable a preset for easier configuration
	presets = {
		bottom_search = false, -- use a classic bottom cmdline for search
		command_palette = false, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false, -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = true, -- add a border to hover docs and signature help
	},
})
