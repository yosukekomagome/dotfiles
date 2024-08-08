-- takuya matsuyama
-- https://zenn.dev/takuya/articles/4472285edbc132
-- よりコピー
local status, packer = pcall(require, 'packer')
if not status then
	print('Packer is not installed')
	return
end

vim.cmd([[packadd packer.nvim]])

packer.startup(function(use)
	use('wbthomason/packer.nvim')
	-- Your plugins go here

	use({ 'nvim-lualine/lualine.nvim' }) -- Statusline
	use({ 'craftzdog/solarized-osaka.nvim' }) -- Colorscheme
	use('folke/tokyonight.nvim')

	-- utils
	use({
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end,
	}) -- コメントアウト
	use({ 'norcalli/nvim-colorizer.lua' })
	use({ 'kylechui/nvim-surround' })
	use({ 'lewis6991/gitsigns.nvim' })
	use({
		'nvim-neo-tree/neo-tree.nvim',
		branch = 'v3.x',
		requires = {
			'nvim-lua/plenary.nvim',
			'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
			'MunifTanjim/nui.nvim',
			'3rd/image.nvim',
		},
	})

	-- LSP
	use({ 'neovim/nvim-lspconfig' })
	use({ 'williamboman/mason.nvim' })
	use({ 'williamboman/mason-lspconfig.nvim' })
	use({ 'hrsh7th/nvim-cmp' }) -- 補完エンジン本体
	use({ 'hrsh7th/cmp-nvim-lsp' }) -- LSPを補完ソースに
	use({ 'hrsh7th/cmp-buffer' }) -- bufferを補完ソースに
	use({ 'hrsh7th/cmp-cmdline' }) -- cmdを補完ソースに
	use({ 'hrsh7th/cmp-path' }) -- pathを補完ソースに
	use({ 'onsails/lspkind-nvim' }) -- 補完欄にアイコンを表示
	use({ 'nvimdev/lspsaga.nvim' })

	-- formatter & linter
	use({ 'stevearc/conform.nvim' })
	use({ 'mfussenegger/nvim-lint' })

	-- SNIPET
	use({ 'hrsh7th/vim-vsnip' }) --スニペットエンジン
	use({ 'hrsh7th/cmp-vsnip' }) -- vim-vsnipの補完ソース
	use({ 'L3MON4D3/LuaSnip' }) -- luaスニペットエンジン

	-- Cursor scroll & UI
	use({ 'karb94/neoscroll.nvim' })
	use({ 'echasnovski/mini.indentscope' })
	use({ 'kdheepak/tabline.nvim' })
	use({
		'folke/noice.nvim',
		requires = {
			'MunifTanjim/nui.nvim',
			'rcarriga/nvim-notify',
		},
	})
	use({ 'b0o/incline.nvim', require = { 'nvim-tree/nvim-web-devicons' } })

	-- Treesitter
	use({
		'nvim-treesitter/nvim-treesitter',
		run = function()
			local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
			ts_update()
		end,
	})
	use({ 'windwp/nvim-ts-autotag' })
	use({ 'windwp/nvim-autopairs' })

	-- Telescope
	use({ 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { { 'nvim-lua/plenary.nvim' } } })
	use({ 'nvim-telescope/telescope-file-browser.nvim' })
	use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })
	use({ 'nvim-tree/nvim-web-devicons' })
end)
