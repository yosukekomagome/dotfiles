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

        -- 検索ハイライト
        hl.Search = {
          fg = "#00ff00",
          bg = "#003b00",
        }

        -- 現在カーソルがある検索一致箇所
        hl.CurSearch = {
          fg = "#003b00",
          bg = "#00ff00",
          bold = true,
        }

        -- blink.cmpのハイライト
        hl.BlinkCmpMenuBorder = { fg = c.blue }
        hl.BlinkCmpMenuSelection = { bg = c.bg_highlight }
        hl.BlinkCmpDocBorder = { fg = c.blue }
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
