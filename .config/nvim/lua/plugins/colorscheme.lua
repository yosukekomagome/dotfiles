return {
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      on_highlights = function(hl, c)
        -- telescope border color
        hl.TelescopeBorder = { fg = c.blue }
        hl.TelescopePromptBorder = { fg = c.blue }
        hl.TelescopePromptTitle = { fg = c.blue }
        hl.TelescopePromptPrefix = { fg = c.blue }
        hl.TelescopePromptNormal = { fg = c.blue }
        hl.TelescopePreviewTitle = { fg = c.blue }
        hl.TelescopeResultsTitle = { fg = c.blue }

        -- lspsaga border color
        hl.SagaBorder = { fg = c.blue }

        -- Bufferline transparency
        hl.TabLineFill = {
          bg = "NONE",
          nocombine = true,
        }

        -- LSP reference highlight
        hl.LspReferenceText = { bg = "#000080" }
        hl.LspReferenceRead = { bg = "#000080" }
        hl.LspReferenceWrite = { bg = "#000080" }

        -- LSP hover border color
        hl.NoiceHoverBorder = {
          fg = c.blue,
          bg = "NONE",
        }

        -- Search Mode Inactive highlight
        hl.Search = {
          fg = "#00ff00",
          bg = "#003b00",
        }

        -- Search Mode active highlight
        hl.CurSearch = {
          fg = "#003b00",
          bg = "#00ff00",
          bold = true,
        }

        -- blink.cmp highlight
        hl.BlinkCmpMenuBorder = { fg = c.blue }
        hl.BlinkCmpMenuSelection = { bg = c.bg_highlight }
        hl.BlinkCmpDocBorder = { fg = c.blue }

        -- Incline highlight
        hl.InclineNormal = { fg = c.base01, bg = "#000080" }
        hl.InclineNormalNC = { fg = c.base01, bg = "NONE" }
      end,
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "solarized-osaka",
    },
  },
}
