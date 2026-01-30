local luasnip = require('luasnip')
local lspkind = require('lspkind')

--補完関係の設定
local cmp = require('cmp')
cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	sources = {
		{ name = 'nvim_lsp' }, --ソース類を設定
		{ name = 'luasnip' },
		{ name = 'buffer' },
		{ name = 'path' },
	},
	mapping = cmp.mapping.preset.insert({
		['<C-k>'] = cmp.mapping.select_prev_item(), --Ctrl+pで補完欄を一つ上に移動
		['<C-j>'] = cmp.mapping.select_next_item(), --Ctrl+nで補完欄を一つ下に移動
		['<C-l>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<tab>'] = cmp.mapping.confirm({ select = true }), --Ctrl+yで補完を選択確定
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),

		['<C-n>'] = cmp.mapping(function(fallback)
			if luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { 'i', 's' }),
	}),
	experimental = {
		ghost_text = false,
	},

	-- 補完候補表示時のフローティングウィンドウのボーダースタイル
	window = {
		completion = cmp.config.window.bordered({
			border = 'single',
		}),
		documentation = cmp.config.window.bordered({
			border = 'single',
		}),
	},

	-- Lspkind(アイコン)を設定
	formatting = {
		format = lspkind.cmp_format({
			mode = 'symbol', -- show only symbol annotations
			maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
			ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
			-- The function below will be called before any actual modifications from lspkind
			-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
		}),
	},
})

-- 検索、コマンドライン表示時に補完する設定
cmp.setup.cmdline('?', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }, --ソース類を設定
	},
})
cmp.setup.cmdline('/', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }, --ソース類を設定
	},
})
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'path' }, --ソース類を設定
		-- { name = "cmdline"}
	},
})

-- 補完候補表示時のフローティングウィンドウのボーダースタイル
vim.cmd([[highlight FloatBorder guifg=#05F1f5]])
