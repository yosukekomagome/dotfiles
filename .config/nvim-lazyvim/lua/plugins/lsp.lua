return {
  -- 定義、実装、参照ジャンプをlspsagaで実行する場合の設定
  {
    "neovim/nvim-lspconfig",

    -- プレビュー画面のハイライトが蓄積していく問題回避のコード
    init = function()
      local group = vim.api.nvim_create_augroup("LspsagaFinderCurrentHighlight", {
        clear = true,
      })

      local finder_ns = vim.api.nvim_create_namespace("SagaFinder")

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "sagafinder",

        callback = function(args)
          vim.api.nvim_create_autocmd("CursorMoved", {
            group = group,
            buffer = args.buf,

            callback = function()
              for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                if bufnr ~= args.buf and vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr) then
                  vim.api.nvim_buf_clear_namespace(bufnr, finder_ns, 0, -1)
                end
              end
            end,
          })
        end,
      })
    end,

    opts = {
      inlay_hints = {
        enabled = false, -- LSPが解析した型情報や引数名をコード上に補助表示する機能OFF
      },
      servers = {
        ["*"] = {
          keys = {
            -- 定義、実装、参照ジャンプをlspsagaで実行する場合の設定
            {
              "gd",
              "<cmd>Lspsaga finder def+imp+ref<cr>",
              desc = "Lspsaga Definition and Implementation and References",
              has = "definition", -- 定義
            },
            {
              "gi",
              "<cmd>Lspsaga finder imp<cr>",
              desc = "Lspsaga Implementation",
              has = "implementation", -- 実装
            },
            {
              "gr",
              "<cmd>Lspsaga finder ref<cr>",
              desc = "Lspsaga References",
              has = "references", -- 参照
            },

            -- LazyVim標準のリネームキーを無効化
            {
              "<leader>cr",
              false,
            },

            -- LazyVim標準のリネームを新しいキーに割り当て
            {
              "<leader>rn",
              vim.lsp.buf.rename,
              desc = "Rename",
              has = "rename",
            },
          },
        },
      },
    },
  },
}
