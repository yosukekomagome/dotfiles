#!/bin/zsh
set -e

# ==========================================
# 1. Homebrewのインストール
# ==========================================

# Apple Siliconのみ対応
if [[ "$(uname -m)" != "arm64" ]]; then
  echo "Error: Apple Silicon搭載Macのみ対応しています"
  exit 1
fi

# Homebrewが未インストールの場合のみ実行
if [[ ! -x /opt/homebrew/bin/brew ]]; then
  installer=$(/usr/bin/curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh) || exit 1
  /bin/bash -c "$installer"
fi



# HomebrewのPATHを有効化
eval "$(/opt/homebrew/bin/brew shellenv)"

# ==========================================
# 2. Brewfileによるパッケージのインストール
# ==========================================

brew bundle install --file="$HOME/dotfiles/Brewfile" --no-upgrade

# ==========================================
# 3. dotfilesのシンボリックリンク作成
# ==========================================

# 既存の設定ファイルがある場合は中断
for name in .config .zprofile .zshrc; do
  if [[ -e "$HOME/$name" || -L "$HOME/$name" ]]; then
    echo "Error: $HOME/$name がすでに存在します"
    exit 1
  fi
done

# シンボリックリンク作成
for name in .config .zprofile .zshrc; do
  ln -s "$HOME/dotfiles/$name" "$HOME/$name"
done

# ==========================================
# 4. miseによる開発ツールのインストール
# ==========================================

# ~/dotfiles/.config/mise/config.tomlを参照してインストール
cd "$HOME"
mise install
mise ls

# ==========================================
# 5. fishプラグインの復元
# ==========================================

/opt/homebrew/bin/fish -c 'fisher update'

# ==========================================
# 6. Yaziプラグインの復元
# ==========================================

ya pkg install

# ==========================================
# 7. LazyVimプラグインの復元
# ==========================================

mise exec -- nvim --headless "+Lazy! restore" +qa
