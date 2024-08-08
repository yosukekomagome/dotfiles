local on_attach = function(client, bufnr)
	-- format on save
	--[[
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("Format", { clear = true }),
      buffer = bufnr,
      callback = function() vim.lsp.buf.formatting_seq_sync() end
    })
  end
  ]]
	-- build-in LSP function
	-- local keymap = vim.keymap
	-- local opts = { noremap = true, silent = true }
	-- keymap.set('n', 'K',  '<cmd>lua vim.lsp.buf.hover()<CR>')
	-- keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
	-- keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
	-- keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
	-- keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
	-- keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
end

-- LSP server management
-- 補完プラグインであるcmp_nvim_lspをLSPと連携させています（後述）

local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- (2022/11/1追記):cmp-nvim-lspに破壊的変更が加えられ、
-- local capabilities = require('cmp_nvim_lsp').update_capabilities(
--  vim.lsp.protocol.make_client_capabilities()
-- )
-- ⇑上記のupdate_capabilities(...)の関数は非推奨となり、代わりにdefault_capabilities()関数が採用されました。日本語情報が少ないため、念の為併記してメモしておきます。

-- この一連の記述で、mason.nvimでインストールしたLanguage Serverが自動的に個別にセットアップされ、利用可能になります
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers({
	function(server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup({
			on_attach = on_attach, --keyバインドなどの設定を登録
			capabilities = capabilities, --cmpを連携
		})
	end,
})

-- LSP関連の表示などを設定
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	update_in_insert = false,
	virtual_text = {
		format = function(diagnostic)
			return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
		end,
	},
})

-- Reference highlight
vim.cmd([[
set updatetime=500
highlight LspReferenceText  ctermfg=1 ctermbg=8 guibg=#190d85
highlight LspReferenceRead  ctermfg=1 ctermbg=8 guibg=#190d85
highlight LspReferenceWrite ctermfg=1 ctermbg=8 guibg=#190d85
augroup lsp_document_highlight
  autocmd!
  autocmd CursorHold,CursorHoldI * lua vim.lsp.buf.document_highlight()
  autocmd CursorMoved,CursorMovedI * lua vim.lsp.buf.clear_references()
augroup END
]])

-- settingn exsample
-- highlight LspReferenceText  cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
-- highlight LspReferenceRead  cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
-- highlight LspReferenceWrite cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
