-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Insertモード終了時に英語入力へ切り替える
local ime_group = vim.api.nvim_create_augroup("user_ime", { clear = true })

vim.api.nvim_create_autocmd("InsertLeave", {
  group = ime_group,
  desc = "Switch IME to English",
  callback = function()
    vim.fn.jobstart({ "macism", "com.apple.keylayout.ABC" }, {
      detach = true,
    })
  end,
})

-- ウィンドウフォーカスがNeovimに戻ったらIMEをOFFにする
vim.api.nvim_create_autocmd("FocusGained", {
  pattern = "*",
  callback = function()
    -- 現在のモードがインサートモード('i')以外（ノーマルモード等）かチェック
    if vim.api.nvim_get_mode().mode ~= "i" then
      vim.fn.jobstart({ "macism", "com.apple.keylayout.ABC" }, {
        detach = true,
      })
    end
  end,
})

-- テーマ読み込み時にSnacksの枠線をTelescopeBorderにリンクする
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Snacks Picker (検索など) の枠線
    vim.api.nvim_set_hl(0, "SnacksPickerBorder", { link = "TelescopeBorder" })
    -- Snacks Notifier (通知ポップアップ) の枠線
    vim.api.nvim_set_hl(0, "SnacksNotifierBorder", { link = "TelescopeBorder" })
    -- Snacks の汎用ウィンドウ (Scratchなど) の枠線
    vim.api.nvim_set_hl(0, "SnacksWinBorder", { link = "TelescopeBorder" })
  end,
})

-- 保存時にESLintの自動修正を実行する
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("user_eslint_fix_on_save", { clear = true }),
  callback = function(args)
    -- 自動フォーマットが無効なら実行しない
    if not LazyVim.format.enabled(args.buf) then
      return
    end

    -- ESLintが接続されているバッファだけを対象にする
    if #vim.lsp.get_clients({ bufnr = args.buf, name = "eslint" }) == 0 then
      return
    end

    -- ESLintによる自動修正
    vim.api.nvim_buf_call(args.buf, function()
      if vim.fn.exists(":LspEslintFixAll") == 2 then
        vim.cmd("LspEslintFixAll")
      end
    end)
  end,
})
