#Neovim & WezTerm モダン開発環境 構築備忘録


## 概要・アーキテクチャ

既存のNeovim環境（Packer / システムのNeovim v0.10.x）を一切破壊せずに、最新のNeovim（v0.12.x以上）＋ LazyVim の次世代環境を並行稼働させるための構築手順。

**【ポイント】**

1. **ディレクトリ構造**: 既に `~/.config` が `~/dotfiles/.config` へシンボリックリンクされている状態を活かし、Stowなどの外部ツールは使わず直接ディレクトリ内に配置する。
2. **Neovimバージョンの分離**: `mise` を使い、新環境専用の最新Neovimをシステム（グローバル）に影響を与えない形で裏側にインストールする。
3. **設定の分離**: Neovimの `NVIM_APPNAME` 機能を使い、新環境は `nvim-lazyvim` ディレクトリを読み込ませる。

これにより、以下の共存を実現する。

- `nvim` コマンド ＝ 旧環境（iTerm2で利用）
- `lvim` コマンド ＝ 新環境（WezTermで利用）

## 構築手順

### Step 1: 必須ツールのインストール

Homebrewを使って、新しいターミナルエミュレータ（WezTerm）とバージョン管理ツール（mise）をインストールする。

Bash

```bash
brew install wezterm mise
```

### Step 2: WezTermの設定ファイル作成

dotfilesの `.config` リンクを利用し、WezTermの設定ファイルを配置する。

Bash

```
# WezTerm用の設定ディレクトリを作成
mkdir -p ~/dotfiles/.config/wezterm

# 設定ファイルの作成（以降、このファイルを編集してカスタマイズする）
touch ~/dotfiles/.config/wezterm/wezterm.lua
```

### Step 3: 新環境専用の最新Neovimのインストール

システム標準のNeovim（旧環境用）を上書きしないよう、`mise` でグローバル化を避けてインストールする。

Bash

```
# 最新のNeovimをインストール（システム全体には反映されない）
mise install neovim@latest
```

*(※ `mise WARN neovim installed but not activated` と警告が出るのが正解（意図した挙動）である。)*

### Step 4: LazyVimのダウンロード（新環境の構築）

新環境用の設定ディレクトリとして `nvim-lazyvim` という名前を使用し、そこにLazyVimのスターターテンプレートを配置する。

Bash

```
# dotfilesの.config内に直接ダウンロード
git clone https://github.com/LazyVim/starter ~/dotfiles/.config/nvim-lazyvim

# 自身のGitで管理するため、スターターの.git履歴を削除
rm -rf ~/dotfiles/.config/nvim-lazyvim/.git
```

### Step 5: 新環境起動用エイリアスの設定（fish shell用）

`lvim` コマンドで「最新Neovim + LazyVim設定」が起動するように、fishの設定ファイルにエイリアスを登録する。

Bash

```
# config.fish をエディタで開く
nvim ~/.config/fish/config.fish
```

以下の1行を末尾に追記して保存する。

コード スニペット

```
alias lvim="env NVIM_APPNAME=nvim-lazyvim mise exec neovim@latest -- nvim"
```

設定を再読み込みして反映させる。

Bash

```
source ~/.config/fish/config.fish
```

### Step 6: 動作確認

新旧の環境が完全に分離して起動するか確認する。

Bash

```
# バージョンの確認
nvim -v  # システムの古いバージョン（v0.10.x など）が出力される
lvim -v  # miseで入れた最新バージョン（v0.12.x など）が出力される

# 新環境の初回起動（プラグインのインストールが自動で始まる）
lvim
```

## （参考）別PCへの環境構築（同期）手順

会社PCなど、全く同じ環境を別のMacに構築する場合は以下の手順を行う。

1. GitHubから `~/dotfiles` をクローンする。
2. `ln -s ~/dotfiles/.config ~/.config` でシンボリックリンクを張る。
3. `brew install wezterm mise` を実行する。
4. `mise install neovim@latest` を実行する。
5. `config.fish` にエイリアス（Step 5）を追記する。
6. WezTermを立ち上げ、`lvim` を実行する。

（以上）
