local js_formatters = { 'prettierd', 'eslint_d', stop_after_first = false }
require('conform').setup({
	formatters_by_ft = {
		json = js_formatters,
		javascript = js_formatters,
		javascriptreact = js_formatters,
		typescript = js_formatters,
		typescriptreact = js_formatters,
		lua = { 'stylua' },
	},
	format_on_save = {
		timeout_ms = 2000,
		lsp_fallback = false,
		quiet = false,
	},
})
