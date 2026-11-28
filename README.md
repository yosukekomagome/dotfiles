# macOS 開発環境 構築・管理ガイド

## 1. 概要

Apple Silicon 搭載 Mac における開発環境の構成と、新しい Mac へのセットアップ手順をまとめる。

設定ファイルは `~/dotfiles` で Git 管理し、Homebrew・mise・各種プラグインマネージャを利用して環境を構築する。

構築後の定期アップデート・障害対応については、[開発環境メンテナンス手順書](docs/maintenance.md) を参照する。

**基本方針**

- **設定ファイルの一元管理**：各ツールの設定を dotfiles で Git 管理する。
- **自動セットアップ**：`setup.sh` からアプリ・開発ツール・プラグインを導入する。
- **バージョン管理**：Neovim と Node.js は mise で完全固定バージョンとして管理する。
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
| Yazi プラグイン・Flavor | Ya                    | `package.toml`        |
| 言語ランタイム     | Node.js                    | mise                  |
| CLI ツール         | fzf、ripgrep、lazygit など | Homebrew              |
| LSP・Formatter     | LSP サーバー・Formatter   | Mason                 |
| 構文解析 CLI       | Tree-sitter CLI            | Homebrew              |
| 構文解析パーサー   | Tree-sitter                | Neovim 側の設定       |

その他の Homebrew パッケージは `Brewfile` で管理する。

### 2.2 Neovim・Node.js のバージョン

グローバル設定は `~/.config/mise/config.toml` に定義する。現在のバージョンは [config.toml](.config/mise/config.toml) を参照する。

- Neovim・Node.js は完全固定バージョンで管理する。
- npm は Node.js 付属版を利用する。
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
├── README.md
├── setup.sh
├── docs/
│   └── maintenance.md
└── .config/
    ├── fish/
    │   ├── config.fish
    │   ├── fish_plugins
    │   └── functions/
    │       └── ide.fish
    │
    ├── mise/
    │   └── config.toml
    │
    ├── nvim/
    │   ├── init.lua
    │   ├── lazy-lock.json
    │   ├── lazyvim.json
    │   ├── docs/
    │   │   └── lazyvim-plugin-management.md
    │   └── lua/
    │       ├── config/
    │       └── plugins/
    │
    ├── wezterm/
    │   └── wezterm.lua
    │
    └── yazi/
        ├── init.lua
        ├── yazi.toml
        ├── keymap.toml
        ├── theme.toml
        ├── package.toml
        └── yazi-setup.md
```

上記は Git 管理対象の主要ファイルのみを示す。

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
| 5    | Fisher 本体・fish プラグインの復元              |
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

Fisher が利用できない場合は、公式配布元から関数を取得して fish セッション内で読み込む。その後、`fisher update` を実行し、`fish_plugins` に登録された Fisher 本体とプラグインを導入する。

初回導入処理は [setup.sh](setup.sh) に含まれるため、通常は手動で Fisher をインストールする必要はない。

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

`setup.sh` は、新しい Mac への初回セットアップを対象としている。

- 既存環境の移行やバックアップは行わない。
- 既存の設定ファイルは上書きしない。
- セットアップ失敗時の自動ロールバックは行わない。
- `setup.sh` を繰り返し実行する運用は想定していない。
- Tide の外観設定は自動復元しない。

Homebrew の初回導入時には、管理者パスワードの入力や Command Line Tools のインストールが必要になる場合がある。

各管理ツールのバージョン管理方式や配布状況により、別の Mac で同一バージョンの環境を完全に再現できるとは限らない。詳細は[開発環境メンテナンス手順書](docs/maintenance.md#5-障害対応復旧方針)を参照する。

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

プラグインの復元には `:Lazy restore` を使用する。詳細は[LazyVim プラグイン管理手順](.config/nvim/docs/lazyvim-plugin-management.md)を参照する。

### 5.2 Neovim：Mason・Tree-sitter

LSP サーバーや Formatter は Mason、構文解析パーサーは Tree-sitter 側で管理する。

導入対象は LazyVim の標準設定、Extras、および独自設定で管理する。

`setup.sh` には Mason パッケージや Tree-sitter パーサーを個別に列挙しない。

初回起動時や対応するファイルを開いた際に自動インストールが行われる想定だが、すべての導入が初回起動だけで完了するとは限らない。

新しい Mac では `:Mason` や Tree-sitter の状態を確認する。

なお、`lazy-lock.json` は Mason の外部ツールや Tree-sitter パーサーのバージョンを固定するものではない。

### 5.3 fish：Fisher

fish のプラグインと Fisher 本体は Fisher で管理する。

管理対象の一覧は [fish_plugins](.config/fish/fish_plugins) に記録する。Fisher 本体も `jorgebucaran/fisher` として登録し、自己管理する。Tide の `@v6` 指定は維持する。

Fisher 本体およびプラグインの実体は Git 管理対象外とする。`fish_plugins` はコミットハッシュを記録するロックファイルではない。

初回導入は `setup.sh` で行う。Tide の外観設定は、必要に応じて初回セットアップ後に手動で実行する。

```fish
tide configure
```

### 5.4 Yazi：パッケージマネージャ

Yazi のプラグインと Flavor は `package.toml` で管理する。

`plugins/` および `flavors/` の実体は Git 管理せず、次のコマンドで復元する。

```zsh
ya pkg install
```

プラグインを更新する場合は、`package.toml` の変更を Git に反映する。詳細は[Yazi セットアップ手順](.config/yazi/yazi-setup.md)を参照する。

---

## 6. セットアップ後の動作確認

### 6.1 Homebrew

```zsh
brew --version
brew bundle check --no-upgrade --file="$HOME/dotfiles/Brewfile"
```

### 6.2 シンボリックリンク

```zsh
ls -ld ~/.config ~/.zprofile ~/.zshrc
```

3つとも `~/dotfiles` 内を参照していることを確認する。

### 6.3 mise・Neovim・Node.js

プロジェクト固有の設定の影響を避けるため、dotfiles ディレクトリで確認する。

```zsh
cd ~/dotfiles
mise ls
nvim --version
node --version
npm --version
mise which nvim
mise which node
```

Neovim・Node.js が `~/.config/mise/config.toml` に記録されたバージョンであり、npm が Node.js 付属版であることを確認する。

通常のシェルからコマンドが見つからない場合は、mise の PATH・有効化設定を確認する。

### 6.4 fish・Yazi

fish では次のコマンドで Fisher 本体とプラグイン一覧を確認する。

```fish
fisher --version
fisher list
type -p fisher
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

## 7. 日常の管理・メンテナンス

設定ファイルは `~/dotfiles` 内で編集し、Git にコミットする。

Homebrew パッケージの追加・削除に伴う構成変更は `Brewfile` に反映する。

定期アップデート、更新後の動作確認、臨時メンテナンス、障害対応・復旧方針については、[開発環境メンテナンス手順書](docs/maintenance.md) を参照する。`setup.sh` は定期アップデートには使用しない。

---

## 8. 補足

### 旧 Neovim 環境について

以前使用していた Packer ベースの Neovim と、`NVIM_APPNAME=nvim-lazyvim` を使用する並行運用は終了した。

現在は標準の `nvim` コマンドで LazyVim を起動する。

そのため、旧 `lvim` エイリアスや `nvim-lazyvim` ディレクトリはセットアップ対象に含めない。

### 新しい Mac での動作検証について

現行 Mac では、`setup.sh` の zsh 構文チェック、`Brewfile` の依存関係チェック、および Fisher の導入部分の fish 構文チェックを実施済み。

Fisher の初回導入処理は、一時的な XDG ディレクトリを使用した環境で実動作を検証済み。

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
