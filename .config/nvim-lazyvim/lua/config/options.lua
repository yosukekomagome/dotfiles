-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- ESLintの自動フォーマットを無効化、コード整形はPrettierなどのFormatterに任せる
vim.g.lazyvim_eslint_auto_format = false

-- メッセージは英語、ヘルプは日本語
vim.cmd("language messages C")
vim.opt.helplang = "ja"

-- 行頭・行末でカーソルを前後の行へ回り込ませる設定
vim.opt.whichwrap:append("h,l,<,>,[,]")

-- j,kでスクロール次に確保する上下の余白
vim.opt.scrolloff = 10
