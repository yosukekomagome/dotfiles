# -----------------------------------------------
# インタラクティブ（手動操作）時のみ読み込む設定
# -----------------------------------------------
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

# -----------------------------------------------
# vimモードとカスタムキーバインドの設定
# -----------------------------------------------

function fish_user_key_bindings
    # 基本のVimモードを有効化
    fish_vi_key_bindings

    # jj でインサートモードを抜ける設定を追加
    bind -M insert jj "set fish_bind_mode default; commandline -f backward-char force-repaint"
end
