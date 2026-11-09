return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "folke/tokyonight.nvim",
    },
    opts = function(_, opts)
      opts.sections.lualine_b = {
        -- Git branch icon
        { "branch", icon = "" },
      }

      opts.sections.lualine_c = {
        ---@diagnostic disable-next-line: assign-type-mismatch
        LazyVim.lualine.root_dir({ cwd = true }),
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { "filename", path = 0, separator = "", symbols = { modified = "" } },
      }

      opts.sections.lualine_x = {
        "searchcount",

        -- Diagnostics
        {
          "diagnostics",
          symbols = {
            error = " ",
            warn = " ",
            info = " ",
            hint = " ",
          },
        },

        -- Lazy Updates
        {
          require("lazy.status").updates,
          cond = require("lazy.status").has_updates,
          color = function()
            return { fg = Snacks.util.color("Special") }
          end,
        },

        -- DAP Status
        {
          function()
            return "  " .. require("dap").status()
          end,
          cond = function()
            return package.loaded["dap"] and require("dap").status() ~= ""
          end,
          color = function()
            return { fg = Snacks.util.color("Debug") }
          end,
        },

        -- LSP status
        {
          "lsp_status",
          fmt = function(status)
            local result = status:gsub("%s*✓", "")
            return result
          end,
        },

        "encoding",
      }

      opts.sections.lualine_y = {
        { "progress", padding = { left = 1, right = 1 } },
      }

      opts.sections.lualine_z = {
        { "location", padding = { left = 1, right = 1 } },
      }

      -- lualine color theme
      opts.options.theme = "tokyonight"
    end,
  },
}
