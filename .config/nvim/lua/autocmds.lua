
-- yankした範囲をハイライト
vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#4700A5" })
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = 'YankHighlight', timeout = 500 })
  end,
})

--  最後のカーソル位置の保存
vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
    pattern = { '*' },
    callback = function()
        vim.api.nvim_exec('silent! normal! g`"zv', false)
    end,
})


