local status, autopairs = pcall(require, 'nvim-autopairs')
if not status then
	return
end

autopairs.setup({
	disacheck_ts = true,
	ble_filetype = { 'TelescopePrompt', 'vim' },
})
