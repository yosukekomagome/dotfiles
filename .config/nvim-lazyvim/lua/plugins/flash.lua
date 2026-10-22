return {
  {
    "folke/flash.nvim",
    keys = {
      -- 標準の "s" によるジャンプ起動を無効化
      { "s", mode = { "n", "x", "o" }, false },
      -- 代替として "S" (Shift+s) などに割り当てる場合（任意）
      -- { "S", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    },
  },
}
