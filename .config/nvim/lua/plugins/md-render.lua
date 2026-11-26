return {
  {
    "delphinus/md-render.nvim",
    cmd = "MdRender",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "delphinus/budoux.lua",
    },
    init = function()
      vim.g.md_render_max_width = 160
    end,
    keys = {
      {
        "<leader>mp",
        "<cmd>MdRender toggle<cr>",
        desc = "Toggle Markdown Render",
      },
      {
        "<leader>ms",
        "<cmd>vert MdRender split<cr>",
        desc = "Markdown Preview (Vertical Split)",
      },
    },
  },
}
