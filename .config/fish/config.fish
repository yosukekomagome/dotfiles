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
# function fish_user_key_bindings
#     # 1. まずVimモードを読み込む
#     fish_vi_key_bindings
#
#     # 2. その後に、インサートモード用の独自設定を「上書き」する（※順番が重要です）
#     bind -M insert jj "set fish_bind_mode default; commandline -f backward-char force-repaint"
#     bind -M insert \cf forward-char       # Ctrl + f でサジェスト確定
#     bind -M insert \ef forward-word       # Alt + f で1単語ずつ確定
# end

