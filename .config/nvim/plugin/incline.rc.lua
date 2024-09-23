local helpers = require('incline.helpers')
local devicons = require('nvim-web-devicons')
require('incline').setup({
	window = {
		padding = 0,
		margin = { horizontal = 0 },
	},
	hide = {
		cursorline = true,
		-- focused_win = true,
		-- only_win = true
	},
	render = function(props)
		local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
		if filename == '' then
			filename = '[No Name]'
		end
		local ft_icon, ft_color = devicons.get_icon_color(filename)
		local modified = vim.bo[props.buf].modified
		return {
			ft_icon and { ' ', ft_icon, ' ', guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or '',
			-- ft_icon and { ' ', ft_icon, ' ', guibg = '#4700A5', guifg = helpers.contrast_color(ft_color) } or '',
			' ',
			{ filename, gui = modified and 'bold,italic' or '' }, -- ファイルが編集されたらファイル名がイタリックになる
			' ',
			-- guigb = '#4700A5',
		}
	end,
})
-- 以下をコマンドラインで実行するとファイルネームのgbカラーを変更できる
vim.cmd([[highlight InclineNormal guibg = #4700A5 ]])
-- vim.cmd[[highlight InclineNormalNC guibg = #4700A5 ]]
