return {
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        command_palette = {
          views = {
            cmdline_popup = {
              position = {
                row = "50%",
                col = "50%",
              },
            },
            cmdline_popupmenu = {
              position = {
                row = "65%",
                col = "50%",
              },
            },
          },
        },
        bottom_search = false,
      },

      -- ctrl+KのLSPホバーのスタイルとカラー指定
      views = {
        hover = {
          border = {
            style = "rounded",
          },
          win_options = {
            winhighlight = {
              FloatBorder = "NoiceHoverBorder",
            },
          },
        },
      },
      lsp = {
        signature = {
          opts = {
            position = { row = 2, col = 0 },
          },
        },
      },
    },
  },
}
