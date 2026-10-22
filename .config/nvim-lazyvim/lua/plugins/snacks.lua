return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        enabled = false,
      },
      picker = {
        win = {
          list = {
            keys = { -- ウィンドウ分割のキーバーインドを設定
              ["ss"] = "edit_split",
              ["sv"] = "edit_vsplit",
            },
          },
        },
        sources = {
          -- telescopeライクな設定をsnacksで再現する設定
          explorer = {
            hidden = true, -- ドットファイル表示
            focus = "list", -- 初期フォーカスinput or list
            auto_close = true, -- 別のウィンドウへフォーカスが映った時にPickerを閉じる
            jump = {
              close = true, -- 選択したファイルを開いたらウィンドウを閉じる
            },
            layout = {
              preset = "default", -- UIレイアウト"telescope"も設定可能
              preview = true,
            },

            actions = {
              -- cwdに戻る+ファイル一覧を更新 -> cwdに戻る動作
              explorer_goto_cwd = function(picker)
                local cwd = vim.api.nvim_win_call(picker.main, function()
                  return vim.fn.getcwd()
                end)
                picker:set_cwd(cwd)
                picker:find()
              end,

              -- プロジェクトルートに戻る+ファイル一覧を更新 -> gitrootに戻る動作
              explorer_goto_root = function(picker)
                local root = LazyVim.root({
                  buf = picker.input.filter.current_buf,
                  normalize = true,
                })
                picker:set_cwd(root)
                picker:find()
              end,
            },
            win = {
              list = {
                -- explorerの一覧画面での独自キーバインド
                keys = {
                  ["o"] = "confirm", -- OS指定アプリで開く->vimで開くに変更
                  ["w"] = "explorer_goto_cwd", -- explorerのカーソルをcwdに戻す
                  ["g"] = "explorer_goto_root", -- explorerのカーソルgitrootに戻す
                  ["e"] = "explorer_up", -- 親ディレクトリに戻る（標準はBackspaceキー）
                  ["N"] = "explorer_add", -- 新規ファイル、ディレクトリ作成
                },
              },
            },
          },
          files = {
            hidden = true,
          },
          grep = {
            hidden = true,
          },
        },
      },
      indent = {
        chunk = {
          enabled = true,
          char = {
            corner_top = "╭",
            corner_bottom = "╰",
            horizontal = "─",
            vertical = "│",
            arrow = ">",
          },
        },
      },
    },
  },
}
