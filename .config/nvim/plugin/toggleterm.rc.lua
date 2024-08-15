require('toggleterm').setup({
	direction = 'float',
})

vim.keymap.set('n', '<leader>tm', ':ToggleTerm<CR>', { noremap = true, silent = true })

-- lazygit setting
local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({
	cmd = 'lazygit',
	hidden = true,
	direction = 'float',
})

function Lazygit_toggle()
	lazygit:toggle()
end

vim.keymap.set('n', '<leader>lg', '<cmd>lua Lazygit_toggle()<CR>', { noremap = true, silent = true })
