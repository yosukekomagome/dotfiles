-- which-keyが監視しているとコメントトグルgccコマンドが動かないバグがある
-- wiich-keyをOFFにすることで正しく動作するので以下の設定でOFFにする
return {
  {
    "folke/which-key.nvim",
    cond = false,
  },
}
