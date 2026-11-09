return {
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    opts = {
      window = {
        margin = {
          vertical = 1,
          horizontal = 0,
        },
      },

      hide = {
        cursorline = "smart",
      },

      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")

        -- 変更マークを付ける前にアイコンを取得
        local icon, color = require("nvim-web-devicons").get_icon_color(filename)

        if vim.bo[props.buf].modified then
          filename = "[+] " .. filename
        end

        return {
          icon and { icon, guifg = color } or "",
          { " " },
          { filename },
        }
      end,
    },
  },
}
