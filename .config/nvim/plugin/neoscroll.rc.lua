require('neoscroll').setup({
  -- Disable <C-e>, <C-y> because I faced a performance issue in a small
  -- window.
  mappings = { 'gg','G','<C-u>', '<C-d>', '<C-b>', '<C-f>' },
  easing_function = "sine",
})
local t = {}

t["gg"] = { "scroll", { "-2*vim.api.nvim_buf_line_count(0)", "true", "1", [['sine']] } }
t["G"] = { "scroll", { "2*vim.api.nvim_buf_line_count(0)", "true", "200", [['sine']] } }
t['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '125' } }
t['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '125' } }
t['<C-b>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '250' } }
t['<C-f>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '250' } }
require('neoscroll.config').set_mappings(t)

