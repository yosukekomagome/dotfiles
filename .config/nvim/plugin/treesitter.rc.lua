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
	ensure_installed = 'all', -- :TSInstall allと同じ
})
