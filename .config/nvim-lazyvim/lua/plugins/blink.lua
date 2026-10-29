return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = {
          border = "rounded",
          max_height = 20,
        },
        documentation = {
          window = {
            border = "rounded",
          },
        },
      },

      -- コード補完時(サジェスト)のキーバインド
      keymap = {
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<Tab>"] = { "accept", "snippet_forward", "fallback" },
      },
    },
  },
}
