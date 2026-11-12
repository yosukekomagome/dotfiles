# macOS 開発環境 構築・管理ガイド

## 1. 概要

Apple Silicon 搭載 Mac における開発環境の構成と、新しい Mac へのセットアップ手順をまとめる。

設定ファイルは `~/dotfiles` で Git 管理し、Homebrew・mise・各種プラグインマネージャを利用して環境を構築する。

**基本方針**

- **設定ファイルの一元管理**：各ツールの設定を dotfiles で Git 管理する。
- **自動セットアップ**：`setup.sh` からアプリ・開発ツール・プラグインを導入する。
- **バージョン管理**：Neovim と Node.js は mise で管理する。
- **プラグイン管理**：プラグイン本体は Git 管理せず、各パッケージマネージャで復元する。
- **シンプルな構成**：GNU Stow などは使用せず、シンボリックリンクで設定を共有する。

旧 Neovim（Packer）との並行運用は終了しており、現在は LazyVim を標準の Neovim 環境として使用する。

---

## 2. 開発環境の構成

### 2.1 主要ツール

| 分類               | ツール                     | 管理方法              |
| ------------------ | -------------------------- | --------------------- |
| ターミナル         | WezTerm Nightly            | Homebrew              |
| シェル             | zsh / fish                 | macOS 標準 / Homebrew |
| シェルプロンプト   | Tide                       | Fisher                |
| エディタ           | Neovim + LazyVim           | mise / lazy.nvim      |
| ファイルマネージャ | Yazi                       | Homebrew              |
| 言語ランタイム     | Node.js                    | mise                  |
| CLI ツール         | fzf、ripgrep、lazygit など | Homebrew              |
| LSP・Formatter     | Mason                      | Neovim 側の設定       |
| 構文解析パーサー   | Tree-sitter                | Neovim 側の設定       |

その他のパッケージは `Brewfile` で管理する。

### 2.2 Neovim・Node.js のバージョン

グローバル設定は `~/.config/mise/config.toml` に定義する。

```toml
[tools]
neovim = "0.12.6"
node = "latest"
```

- Neovim は `0.12.6` を使用する。
- Node.js はグローバルで最新版を使用する。
- プロジェクト固有のバージョンは、各プロジェクトの `mise.toml` で管理する。

例えば、`kintone-v1` プロジェクトでは Node.js `20.15.1` を使用する。

プロジェクトの設定ファイルは dotfiles とは別に、各プロジェクトの Git リポジトリで管理する。

### 2.3 シェルの起動構成

通常のターミナル起動時は、zsh から fish に切り替える。

```text
WezTerm
  └── zsh
       ├── ~/.zprofile
       │    └── HomebrewのPATH・環境変数を設定
       │
       └── ~/.zshrc
            └── exec fish
                 └── ~/.config/fish/config.fish
```

各設定ファイルの役割は以下のとおり。

| ファイル                   | 役割                               |
| -------------------------- | ---------------------------------- |
| `.zprofile`                | Homebrew の PATH・環境変数設定     |
| `.zshrc`                   | zsh の初期設定と fish への切り替え |
| `.config/fish/config.fish` | fish の各種設定                    |

`.zprofile` では `brew shellenv` を使用し、Homebrew の PATH を設定する。また、`HOMEBREW_NO_AUTO_UPDATE=1` を指定する。

`.zshrc` では対話モードの場合に `exec fish` を実行する。

---

## 3. dotfiles のディレクトリ構成

```text
~/dotfiles/
├── .gitignore
├── .zprofile
├── .zshrc
├── Brewfile
├── setup.sh
└── .config/
    ├── fish/
    │   ├── config.fish
    │   ├── fish_plugins
    │   └── functions/
    │       └── fisher.fish
    │
    ├── mise/
    │   └── config.toml
    │
    ├── nvim/
    │   ├── init.lua
    │   ├── lazy-lock.json
    │   ├── lazyvim.json
    │   └── lua/
    │       ├── config/
    │       └── plugins/
    │
    ├── wezterm/
    │   └── wezterm.lua
    │
    └── yazi/
        ├── yazi.toml
        ├── keymap.toml
        ├── theme.toml
        └── package.toml
```

上記は主要ファイルのみを示す。

### シンボリックリンク

ホームディレクトリには、以下の3つのシンボリックリンクを作成する。

```text
~/.config   -> ~/dotfiles/.config
~/.zprofile -> ~/dotfiles/.zprofile
~/.zshrc    -> ~/dotfiles/.zshrc
```

これにより、各ツールの設定は dotfiles 内のファイルを直接参照する。

シンボリックリンクは `setup.sh` で作成するため、通常は手動操作を必要としない。

---

## 4. 新しい Mac へのセットアップ

### 4.1 前提条件

- Apple Silicon 搭載 Mac
- インターネット接続が利用できること
- Git が利用できること
- `~/dotfiles` にリポジトリをクローンすること
- Homebrew は未インストールを想定
- `~/.config`、`~/.zprofile`、`~/.zshrc` は未作成を想定

Git が利用できない場合は、必要に応じて Xcode Command Line Tools を導入する。

### 4.2 dotfiles のクローン

GitHub から dotfiles をクローンする。

```zsh
git clone <リポジトリURL> ~/dotfiles
```

`<リポジトリURL>` は、自身の dotfiles リポジトリの URL に置き換える。

### 4.3 セットアップスクリプトの実行

```zsh
zsh ~/dotfiles/setup.sh
```

`setup.sh` は次の処理を順番に実行する。

| 順序 | 処理                                            |
| ---- | ----------------------------------------------- |
| 1    | Homebrew のインストール                         |
| 2    | Brewfile によるアプリ・CLI ツールのインストール |
| 3    | dotfiles のシンボリックリンク作成               |
| 4    | mise による Neovim・Node.js のインストール      |
| 5    | Fisher による fish プラグインの復元             |
| 6    | Yazi プラグイン・Flavor の復元                  |
| 7    | LazyVim プラグインの復元                        |

**Homebrew**

未インストールの場合のみ、公式インストーラーを実行する。インストール後は、同じスクリプト内で `brew shellenv` を実行して PATH を有効化する。

**Brewfile**

```zsh
brew bundle install --file="$HOME/dotfiles/Brewfile" --no-upgrade
```

Brewfile に定義されたアプリ・CLI ツールを導入する。

**シンボリックリンク**

既存の `~/.config`、`~/.zprofile`、`~/.zshrc` が存在する場合は、上書きせずに中断する。

**mise**

```zsh
cd "$HOME"
mise install
```

Git 管理済みの `~/.config/mise/config.toml` に従って Neovim と Node.js をインストールする。

**Fisher**

```zsh
/opt/homebrew/bin/fish -c 'fisher update'
```

`fish_plugins` に定義されたプラグインを復元する。

**Yazi**

```zsh
ya pkg install
```

`package.toml` に記録されたプラグインと Flavor を復元する。

**LazyVim**

```zsh
mise exec -- nvim --headless "+Lazy! restore" +qa
```

`lazy-lock.json` に基づいて Neovim のプラグインを復元する。

### 4.4 セットアップ時の注意事項

初版の `setup.sh` は、新しい Mac への初回セットアップを対象としている。

- 既存環境の移行やバックアップは行わない。
- 既存の設定ファイルは上書きしない。
- セットアップ失敗時の自動ロールバックは行わない。
- `setup.sh` を繰り返し実行する運用は想定していない。
- Tide の外観設定は自動復元しない。

Homebrew の初回導入時には、管理者パスワードの入力や Command Line Tools のインストールが必要になる場合がある。

---

## 5. プラグイン管理と復元

### 5.1 Neovim：lazy.nvim

Neovim のプラグインは lazy.nvim で管理する。

| 対象                           | 管理方法         |
| ------------------------------ | ---------------- |
| プラグイン設定                 | `lua/plugins/`   |
| LazyVim Extras                 | `lazyvim.json`   |
| プラグインのリビジョン         | `lazy-lock.json` |
| インストール済みプラグイン本体 | Git 管理対象外   |

`lazy-lock.json` を Git 管理することで、別の Mac でも記録されたプラグインのリビジョンを復元できる。

プラグインの復元には `:Lazy restore` を使用する。

### 5.2 Neovim：Mason・Tree-sitter

LSP サーバーや Formatter は Mason、構文解析パーサーは Tree-sitter 側で管理する。

現在利用している主な Mason パッケージは以下の7つ。

```text
eslint-lsp
lua-language-server
marksman
prettier
shfmt
stylua
vtsls
```

これらの導入対象は LazyVim の標準設定、Extras、および独自設定で管理する。

`setup.sh` には Mason パッケージや Tree-sitter パーサーを個別に列挙しない。

初回起動時や対応するファイルを開いた際に自動インストールが行われる想定だが、すべての導入が初回起動だけで完了するとは限らない。

新しい Mac では `:Mason` や Tree-sitter の状態を確認する。

なお、`lazy-lock.json` は Mason の外部ツールや Tree-sitter パーサーのバージョンを固定するものではない。

### 5.3 fish：Fisher

fish のプラグインは Fisher で管理する。

プラグイン一覧は `~/.config/fish/fish_plugins` に記録する。

現在利用しているプラグインは以下の3つ。

```text
IlanCosman/tide@v6
patrickf1/fzf.fish
jorgebucaran/autopair.fish
```

プラグイン本体は Git 管理対象外とし、Fisher で復元する。

Tide の外観設定は、必要に応じて初回セットアップ後に手動で実行する。

```fish
tide configure
```

### 5.4 Yazi：パッケージマネージャ

Yazi のプラグインと Flavor は `package.toml` で管理する。

`plugins/` および `flavors/` の実体は Git 管理せず、次のコマンドで復元する。

```zsh
ya pkg install
```

プラグインを更新する場合は、`package.toml` の変更を Git に反映する。

---

## 6. セットアップ後の動作確認

### 6.1 Homebrew

```zsh
brew --version
brew bundle check --file="$HOME/dotfiles/Brewfile"
```

### 6.2 シンボリックリンク

```zsh
ls -ld ~/.config ~/.zprofile ~/.zshrc
```

3つとも `~/dotfiles` 内を参照していることを確認する。

### 6.3 mise・Neovim・Node.js

```zsh
mise ls
nvim --version
node --version
```

Neovim は `0.12.6`、Node.js は mise のグローバル設定で選択されたバージョンであることを確認する。

通常のシェルからコマンドが見つからない場合は、mise の PATH・有効化設定を確認する。

### 6.4 fish・Yazi

fish では次のコマンドで Fisher のプラグイン一覧を確認する。

```fish
fisher list
```

Yazi のパッケージ一覧は次のコマンドで確認する。

```zsh
ya pkg list
```

### 6.5 LazyVim

```zsh
nvim
```

起動後、必要に応じて以下を確認する。

- `:Lazy`：プラグインの状態
- `:Mason`：LSP・Formatter のインストール状態
- `:checkhealth`：Neovim 環境の診断

TypeScript・JavaScript・Lua・Markdown などのファイルを開き、LSP や Tree-sitter の動作を確認する。

---

## 7. 日常の管理方針

### 設定ファイルの変更

設定ファイルは `~/dotfiles` 内で編集し、Git にコミットする。

### Homebrew パッケージの追加・削除

`Brewfile` を更新して管理する。

### Neovim・Node.js のバージョン変更

`~/.config/mise/config.toml`、または各プロジェクトの `mise.toml` を変更する。

### Neovim プラグインの更新

lazy.nvim で更新し、動作確認後に `lazy-lock.json` を Git にコミットする。

### fish・Yazi プラグインの更新

Fisher の `fish_plugins`、Yazi の `package.toml` を管理元とし、必要に応じて Git に変更を反映する。

---

## 8. 補足

### 旧 Neovim 環境について

以前使用していた Packer ベースの Neovim と、`NVIM_APPNAME=nvim-lazyvim` を使用する並行運用は終了した。

現在は標準の `nvim` コマンドで LazyVim を起動する。

そのため、旧 `lvim` エイリアスや `nvim-lazyvim` ディレクトリはセットアップ対象に含めない。

### 新しい Mac での動作検証について

現行 Mac では、`setup.sh` の zsh 構文チェックと、`Brewfile` の依存関係チェックを実施済み。

ただし、新しい Mac に対する `setup.sh` の一括実行は未検証である。初回構築後は、各ツールのインストール状態と動作を確認する。

---

## 9. 最短セットアップ手順

新しい Apple Silicon Mac では、基本的に次の2ステップで環境を構築する。

**1. dotfiles をクローン**

```zsh
git clone <リポジトリURL> ~/dotfiles
```

**2. setup.sh を実行**

```zsh
zsh ~/dotfiles/setup.sh
```

セットアップ後、新しいターミナルを起動し、必要なツールとプラグインの動作を確認する。

Tide の外観設定など、個人環境に依存する項目は必要に応じて手動で調整する。
