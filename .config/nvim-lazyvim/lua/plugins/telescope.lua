return {
  {
    "nvim-telescope/telescope.nvim",
    lazy = false, -- ★追加: LazyVimの遅延読み込みを無効化し、起動時に確実にロードする
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },

    opts = function(_, opts)
      local actions = require("telescope.actions")
      local fb_actions = require("telescope._extensions.file_browser.actions")

      opts.extensions = opts.extensions or {}
      opts.extensions.file_browser = {
        respect_gitignore = false,
        hijack_netrw = true,
        initial_mode = "normal",
        hidden = true,
        grouped = true,
        theme = "dropdown",
        layout_config = {
          prompt_position = "top",
          height = 0.5,
          width = 0.5,
        },
        previewer = false,
        mappings = {
          ["n"] = {
            ["q"] = actions.close,
            ["sv"] = actions.select_vertical,
            ["ss"] = actions.select_horizontal,
            ["o"] = actions.select_default,
            ["l"] = actions.select_default,
            ["N"] = fb_actions.create,
            ["h"] = fb_actions.goto_parent_dir,

            -- toggle_all
            ["s"] = false,
            ["<C-a>"] = fb_actions.toggle_all,

            -- corsor up/down
            ["<C-u>"] = function(prompt_bufnr)
              for _ = 1, 10 do
                actions.move_selection_previous(prompt_bufnr)
              end
            end,
            ["<C-d>"] = function(prompt_bufnr)
              for _ = 1, 10 do
                actions.move_selection_next(prompt_bufnr)
              end
            end,
          },
        },
      }
    end,

    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("file_browser")
    end,
  },
}
