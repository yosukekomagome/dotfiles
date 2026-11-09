return {
  {
    "nvimdev/lspsaga.nvim",
    cmd = "Lspsaga",
    opts = {
      finder = {
        default = "def+imp+ref",
        layout = "float",
        max_height = 0.8,
        left_width = 0.5,
        right_width = 0.5,
        keys = {
          vsplit = "sv",
          split = "ss",
        },
      },
      symbol_in_winbar = {
        enable = false, -- パンクズリスト表示
      },
      ui = {
        devicon = true,
        title = false, -- プレビューウィンドウにファイル名表示しない
        scroll_down = "<C-d>",
        scroll_up = "<C-u>",
      },
      lightbulb = {
        enable = false,
      },
    },
  },
}
