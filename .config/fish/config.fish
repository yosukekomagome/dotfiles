# ==========================================
# 1. インタラクティブ（手動操作）時のみ読み込む設定
# ==========================================
if status is-interactive
  # Commands to run in interactive sessions can go here
  alias vim='nvim'
  alias debugchrom='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222'
  alias ll='eza -l -F --icons --sort=type --time-style iso'
  alias lla='eza -a -l -F --icons --sort=type --time-style iso'


  # 最新のNeovimの起動する、nvim-lazyvimフォルダを参照する設定
  alias lvim="env NVIM_APPNAME=nvim-lazyvim mise exec neovim@latest -- nvim"
  abbr -a glog git log --graph --oneline --all
  abbr -a reload source ~/dotfiles/.config/fish/config.fish
end

# ==========================================
# Vimモードとカスタムキーバインドの設定
# ==========================================
# 一度有効化してから解除するとグローバル環境変数に書き込みされて解除できないので注意
# vimモードの解除には環境変数自体も再度描き戻す必要あり
# function fish_user_key_bindings
#     # 1. まずVimモードを読み込む
#     fish_vi_key_bindings
#
#     # 2. その後に、インサートモード用の独自設定を「上書き」する（※順番が重要です）
#     bind -M insert jj "set fish_bind_mode default; commandline -f backward-char force-repaint"
#     bind -M insert \cf forward-char       # Ctrl + f でサジェスト確定
#     bind -M insert \ef forward-word       # Alt + f で1単語ずつ確定
# end


# ディレクトリ移動の短縮化プラグインの初期設定
zoxide init fish | source


# ==========================================
# タイポやスペース始まりのコマンドを履歴から消す（Sponge代替）
# ==========================================
function _clean_history_on_postexec --on-event fish_postexec
    set -l last_status $status
    set -l cmd $argv[1]

    # コマンドの先頭がスペースの場合、または実行に失敗（エラー）した場合
    if string match -q -r '^\s' "$cmd"; or test $last_status -ne 0
        # 履歴から該当のコマンドを正確に削除する
        history delete --exact --case-sensitive "$cmd"
    end
end

# ==========================================
# Yazi (ファイラー) 連携設定
# ==========================================
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
