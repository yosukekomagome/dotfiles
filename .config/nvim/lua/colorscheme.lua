require('solarized-osaka').setup({
	-- your configuration comes here
	-- or leave it empty to use the default settings
	transparent = true, -- Enable this to disable setting the background color
	terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
	styles = {
		-- Style to be applied to different syntax groups
		-- Value is any valid attr-list value for `:help nvim_set_hl`
		comments = { italic = true },
		keywords = { italic = true },
		functions = {},
		variables = {},
		-- Background styles. Can be "dark", "transparent" or "normal"
		-- sidebars = "dark", -- style for sidebars, see below
		-- floats = "dark", -- style for floating windows
		sidebars = 'transparent', -- style for sidebars, see below
		floats = 'transparent', -- style for floating windows
	},
	sidebars = { 'qf', 'help' }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
	day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
	hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
	dim_inactive = false, -- dims inactive windows
	lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

	--- You can override specific color groups to use other groups or a hex color
	--- function will be called with a ColorScheme table
	on_colors = function(colors) end,

	--- You can override specific highlights to use other groups or a hex color
	--- function will be called with a Highlights and ColorScheme table
	on_highlights = function(highlights, colors)
		highlights.TelescopeBorder = {
			fg = colors.fg_dark,
		}
		highlights.TelescopePromptBorder = {
			fg = colors.fg_dark,
		}
		highlights.TelescopePromptTitle = {
			fg = colors.fg_dark,
		}
		highlights.TelescopePromptPrefix = {
			fg = colors.fg_dark,
		}
		highlights.TelescopePromptNormal = {
			fg = colors.fg_dark,
		}
		highlights.TelescopePreviewTitle = {
			fg = colors.fg_dark,
		}
		highlights.TelescopeResultsTitle = {
			fg = colors.fg_dark,
		}
		highlights.LineNr = {
			fg = '#29a298',
		}
		highlights.CursorLineNr = {
			fg = '#05f1f5',
		}
	end,
})
--　カラースキーム設定
-- vim.cmd([[colorscheme solarized-osaka]])
-- vim.cmd("highlight LineNr guifg=#29a298")
-- vim.cmd("highlight CursorLineNr guifg=#849900 gui=bold")

-- 半透明に設定する
require('tokyonight').setup({
	transparent = true,
	-- styles = {
	-- 	sidebars = 'transparent',
	-- 	floats = 'transparent',
	-- },
	styles = {
		-- Style to be applied to different syntax groups
		-- Value is any valid attr-list value for `:help nvim_set_hl`
		comments = { italic = true },
		keywords = { italic = false },
		functions = {},
		variables = {},
		-- Background styles. Can be "dark", "transparent" or "normal"
		sidebars = 'transparent', -- style for sidebars, see below
		floats = 'transparent', -- style for floating windows
	},
	on_highlights = function(hl, c)
		hl.TelescopeBorder = {
			fg = c.fg_dark,
		}
		hl.TelescopePromptBorder = {
			fg = c.fg_dark,
		}
		hl.TelescopePromptTitle = {
			fg = c.fg_dark,
		}
		hl.TelescopePromptPrefix = {
			fg = c.fg_dark,
		}
		hl.TelescopePromptNormal = {
			fg = c.fg_dark,
		}
		hl.TelescopePreviewTitle = {
			fg = c.fg_dark,
		}
		hl.TelescopeResultsTitle = {
			fg = c.fg_dark,
		}
	end,
})

vim.cmd([[colorscheme tokyonight-moon]])
vim.cmd('highlight TelescopeSelection cterm=bold gui=bold guifg=#a6e3a1 guibg=#181825')
