local status, ts = pcall(require, 'nvim-treesitter.configs')
if not status then
	return
end

ts.setup({
	highlight = {
		enable = true, -- syntax highlightを有効にする
		disable = {}, -- 一部の言語では無効にする
	},
	indent = {
		enable = true, -- これを設定することでtree-sitterによるインデントを有効にできます
		disable = {}, --　一部の言語では向こうにする
	},
	ensure_installed = {
		-- ここにあなたが使う言語を追加・削除してください
		'lua',
		'vim',
		'javascript',
		'typescript',
		'tsx',
		'json',
		'yaml',
		'html',
		'css',
		'markdown',
		'bash',
		'python',
	},
})
