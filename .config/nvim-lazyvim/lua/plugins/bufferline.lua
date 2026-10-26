return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        separator_style = "thin",
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
        always_show_bufferline = true,
      },

      -- Bufferline color settings
      highlights = {
        separator = {
          fg = "#002b36",
        },
        separator_visible = {
          fg = "#002b36",
        },
        separator_selected = {
          fg = "#002b36",
        },
      },
    },
  },
}
