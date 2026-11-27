# 開発環境メンテナンス手順書

> 初版（レビュー済み）：環境全体の実動作検証前。検証結果に応じて修正する。

## 定期アップデート早見表

週1回を目安に、上から順に実施する。確認・コミットの詳細は第3章を参照する。

| 順序 | 対象 | 主な操作 |
| --- | --- | --- |
| 0 | 事前確認 | `cd ~/dotfiles`、`git status -sb` |
| 1 | Homebrew | `brew update`、`brew upgrade --cask --greedy-latest`、`brew upgrade --formula` |
| 2 | mise | `mise upgrade --global --bump` |
| 3 | LazyVim・Tree-sitter | `:Lazy check`、`:Lazy update`、再起動 |
| 4 | Mason | `:MasonUpdate`、`:Mason` → `C` → `U`、再起動 |
| 5 | Fisher | `fisher update` |
| 6 | Yazi | `ya pkg upgrade` |
| 7 | 最終確認 | `git status -sb`、`git push` |

早見表は更新順序を確認するためのものであり、動作確認を省略して連続実行するためのものではない。

## 1. 概要

### 1.1 目的

macOS上の共通開発環境を継続的に更新し、正常動作を維持する。各管理ツールの標準機能を利用し、更新作業と設定管理を簡潔に保つ。

### 1.2 対象範囲

| 管理ツール | 更新対象 |
| --- | --- |
| Homebrew | Formula・Cask、mise、fish、Tree-sitter CLI、WezTerm、Yazi・Yaなど |
| mise | グローバルのNeovim・Node.js（付属npmを含む） |
| lazy.nvim | LazyVim・関連プラグイン、Tree-sitterパーサーのビルド処理 |
| Mason | Registry、LSPサーバー、Formatterなど |
| Fisher | Fisher本体、fishプラグイン |
| Ya | Yaziプラグイン・テーマ |

macOS本体、業務システム固有のNode.jsバージョン、プロジェクトのnpm依存パッケージは対象外とする。npmグローバルパッケージの独立した更新工程は設けない。

## 2. 運用方針

### 2.1 更新頻度・実施条件

- 週1回を目安に手動で実施する。曜日・日時は固定しない。
- 業務状況を優先し、動作確認の時間が確保できるときに実施する。
- セキュリティ修正、不具合修正、必要な新機能などは臨時更新で対応する。
- 独自の自動更新・通知・一括実行スクリプトは導入しない。各ツールの既存の標準機能は維持する。

### 2.2 バージョン管理方針

| 対象 | 方針 |
| --- | --- |
| Homebrew | Formula・Caskが提供するバージョンを利用 |
| mise | Neovim・Node.jsを完全固定し、更新時に `--bump` を指定 |
| npm | Node.js付属版を利用 |
| LazyVim | 原則として対象ブランチの最新コミット。LazyVim内部の互換性制約は維持し、個別制約は明確な理由がある場合のみ設定 |
| Mason | Registryが提供するバージョンを利用 |
| Fisher | 自己管理。tideの `@v6` 指定を維持 |
| Yazi | `package.toml` にリビジョン・ハッシュを記録し、原則として更新可能な状態を維持 |

### 2.3 Git管理方針

| 管理ファイル | 更新時の扱い |
| --- | --- |
| `Brewfile` | 通常の更新では変更しない |
| `.config/mise/config.toml` | バージョン変更時にコミット |
| `.config/nvim/lazy-lock.json` | プラグイン更新時にコミット |
| `.config/fish/fish_plugins` | 管理対象の変更時にコミット |
| `.config/yazi/package.toml` | パッケージ更新時にコミット |

外部ツールやプラグインの実体は各管理ツールに任せる。Fisher本体もGit管理外とする。設定ファイルは引き続きGit管理する。

動作確認後、管理対象ごとに差分をコミットする。miseとLazyVimはMason更新後の総合動作確認を終えてから個別にコミットする。pushは最終工程でまとめて行う。

### 2.4 バックアップ・クリーンアップ方針

定期更新時の追加バックアップは原則行わない。Homebrewの自動クリーンアップは標準動作のままとし、`HOMEBREW_NO_INSTALL_CLEANUP` は設定しない。

不要なパッケージや旧バージョンの明示的な削除は通常の更新と分離する。復旧が必要になった場合は状況に応じて個別対応する。Git管理情報だけでは外部ツールの完全な復元は保証されない。

## 3. 定期アップデート手順

### 3.1 事前確認

macOS標準のターミナルを起動し、作業中のファイルを保存してWezTermを終了する。Caskの更新後にWezTermへ切り替え、以降の作業はWezTermで実施する。

プロジェクト固有のmise設定の影響を避けるため、以降のシェル操作は原則としてdotfilesディレクトリで実施する。

```fish
cd ~/dotfiles
git status -sb
```

- [ ] 作業ツリーがクリーンである。
- [ ] 編集中のファイルを保存し、Neovim・Yaziを終了した。
- [ ] 業務上重要な作業の途中ではない。
- [ ] 更新後の動作確認を行う時間が確保できる。

未コミットの変更がある場合は先に内容を整理する。以降のコマンドは1行ずつ実行し、結果を確認する（コードブロックをまとめて貼り付けない）。エラーが発生した場合は残りの操作を続行せず、原則として次の工程に進む前に原因を調査する。

### 3.2 Homebrew

#### 更新対象の確認

```fish
brew update
brew outdated --cask --greedy-latest
brew outdated --formula
```

#### Caskのアップデート

macOS標準のターミナルで実行する。WezTerm Nightlyのような `latest` 指定のCaskも更新対象に含める。Caskによっては自動更新型など、通常の更新対象外になるものがある。

```fish
brew upgrade --cask --greedy-latest
```

更新処理の完了後、WezTermを起動し、WezTerm内で確認する。

```fish
wezterm --version
```

設定の読み込みやターミナル操作に問題がないことを確認する。正常であればmacOS標準のターミナルを終了し、以降はWezTermで作業する。

#### Formulaのアップデート

WezTerm内で実行する。

```fish
cd ~/dotfiles
brew upgrade --formula
```

#### 更新結果・動作確認

```fish
brew outdated --cask --greedy-latest
brew outdated --formula
brew bundle check --no-upgrade --file="$HOME/dotfiles/Brewfile"
brew doctor
```

```fish
brew --version
mise --version
fish --version
tree-sitter --version
yazi --version
wezterm --version
```

- [ ] 更新処理にエラーがない。
- [ ] Brewfileの必要なパッケージが導入されている。
- [ ] `brew doctor` の警告を確認した（実害のない警告は許容する）。
- [ ] WezTermなど主要ツールが正常に起動する。

Formulaの更新後、新しいWezTermタブでfishセッションを開き、`cd ~/dotfiles` で作業を継続する。通常はBrewfileの変更・コミットは不要。

### 3.3 mise・Neovim・Node.js

#### 更新対象の確認

```fish
mise outdated --global --bump
```

#### アップデート

```fish
mise upgrade --global --bump
```

グローバル設定の固定バージョンを更新する。プロジェクト固有の設定・ロックファイルは更新対象外とする。`--inactive` は指定しない。なお、現在の公式仕様では `--global` はシステム設定も対象に含むため、そのような設定を追加した場合は更新対象を確認する。

#### 更新結果・動作確認

```fish
mise ls
nvim --version
node --version
npm --version
mise which nvim
mise which node
git diff -- .config/mise/config.toml
```

- [ ] Neovim・Node.jsのバージョンが意図どおり更新された。
- [ ] config.tomlの完全固定指定が維持されている。
- [ ] Neovimが起動する。

npmの独立した更新は行わない。旧バージョンの保持はmiseの標準動作に任せ、業務プロジェクトで必要なバージョンが利用できることを確認する。詳細な互換性確認とGitコミットは3.5で実施する。

### 3.4 LazyVim・Tree-sitter

#### 更新対象の確認

Neovim内で実行する。

```vim
:Lazy check
```

更新候補を確認する。重要な変更や互換性への影響が疑われる場合は、変更履歴や公式リリース情報も確認する。

#### アップデート

```vim
:Lazy update
```

更新およびビルド処理の完了を確認し、Neovimを再起動する。

nvim-treesitterの更新時はLazyVimのビルド処理によるパーサー更新を利用する。通常は `:TSUpdate` を別途実行しない。必要な場合は4.3を参照する。

#### 更新結果・動作確認

- [ ] プラグインの更新・ビルド処理にエラーがない。
- [ ] Neovimの再起動後に正常に操作できる。
- [ ] Tree-sitterのハイライトが正常に表示される。

```fish
git -C ~/dotfiles diff -- .config/nvim/lazy-lock.json
```

詳細な動作確認とGitコミットは3.5で実施する。詳細なプラグイン管理については[LazyVimプラグイン管理手順](../.config/nvim/docs/lazyvim-plugin-management.md)を参照する。

### 3.5 Mason

#### Registryの更新

Neovim内で実行する。

```vim
:MasonUpdate
```

Registryの更新完了を確認する。Masonプラグインの更新とは別に、Registryを明示的に更新する。

#### 外部ツールのアップデート

```vim
:Mason
```

管理画面で次のキーを順に操作する。

| キー | 操作 |
| --- | --- |
| `C` | 更新候補を確認し、確認処理の完了を待つ |
| `U` | インストール済みパッケージを一括更新 |

すべての更新が完了し、インストールエラーがないことを確認してNeovimを再起動する。

#### Neovim関連の総合動作確認

- [ ] Neovimの起動・終了、テーマ・背景透過、キーマップ。
- [ ] Snacksの検索・Explorer、Git関連機能。
- [ ] blink.cmpの補完、LSPの定義ジャンプ。
- [ ] JavaScript・TypeScriptのvtsls、ESLint診断・保存時自動修正、Prettier整形。
- [ ] Lua、Markdown、JSON、YAML、TOMLのLSPおよび対象言語のフォーマット。
- [ ] Tree-sitterのハイライト、md-render.nvimのMarkdown表示。
- [ ] 必要に応じて既存業務プロジェクト内でも動作を確認する（依存パッケージは更新しない）。

#### Gitコミット

総合動作確認の完了後、ターミナルで差分を確認する。

```fish
cd ~/dotfiles
git status -sb
git diff --check
git diff -- .config/mise/config.toml .config/nvim/lazy-lock.json
```

miseの設定に差分がある場合のみ実行する。

```fish
git add .config/mise/config.toml
git diff --cached --check
git diff --cached --stat
git commit -m "chore(mise): NeovimとNode.jsのバージョンを更新"
```

LazyVimのロックファイルに差分がある場合のみ実行する。

```fish
git add .config/nvim/lazy-lock.json
git diff --cached --check
git diff --cached --stat
git commit -m "chore(nvim): LazyVimおよび関連プラグインを更新"
```

互換性対応などで設定を変更した場合は、差分を確認して適切な単位でコミットする。Mason外部ツールのみの更新では通常コミット不要。

### 3.6 Fisher

#### アップデート

```fish
fisher update
```

Fisher本体と `fish_plugins` に登録されているプラグインを一括更新する。tideの `@v6` 指定は維持する。

#### 更新結果・動作確認

```fish
fisher --version
fisher list
```

新しいfishセッションを開いて確認する。

- [ ] 起動時エラーがなく、tideのプロンプトが正常に表示される。
- [ ] `Ctrl + R` による履歴検索、`Ctrl + Alt + F` によるファイル検索が動作する。
- [ ] 括弧・引用符の自動補完とペアの削除が動作する。
- [ ] miseのPATH設定が正常に機能する。

```fish
git -C ~/dotfiles diff -- .config/fish/
```

Fisher本体はGit管理外のため、通常の更新ではコミット不要。`fish_plugins` は実際のコミットを記録するロックファイルではない。管理ファイルや自作設定に変更がある場合のみコミットする。

### 3.7 Yazi

#### アップデート

Yaziを終了した状態で実行する。

```fish
ya pkg upgrade
```

#### 更新結果・動作確認

```fish
yazi --version
ya --version
yazi
```

- [ ] smart-enterによるファイル・ディレクトリ操作。
- [ ] full-borderの罫線表示とtokyo-nightテーマ。
- [ ] 画像・PDFのプレビュー、カスタムキーマップ。

#### Gitコミット

```fish
cd ~/dotfiles
git diff -- .config/yazi/package.toml
```

差分があり、正常動作を確認できた場合のみ実行する。

```fish
git add .config/yazi/package.toml
git diff --cached --check
git diff --cached --stat
git commit -m "chore(yazi): プラグインおよびテーマを更新"
```

### 3.8 最終確認・Git push

```fish
cd ~/dotfiles
git status -sb
git diff --check
git diff --stat
git diff --cached --check
git diff --cached --stat
```

- [ ] 各工程の更新・動作確認が完了している。
- [ ] 意図しない変更がなく、必要なコミットが完了している。
- [ ] 未解決のエラーがない。

```fish
git push
git status -sb
```

pushが正常終了し、作業ツリーがクリーンで、追跡ブランチに対する未送信コミットがないことを確認する。

## 4. 臨時メンテナンス

### 4.1 個別アップデート

必要なツールだけを更新する場合の例。依存関係を確認し、更新後は対象機能と関連機能を検証する。WezTermを個別更新する場合も、WezTermを終了して別のターミナルから実行する。

| 対象 | コマンド・操作例 |
| --- | --- |
| Homebrew Formula | `brew upgrade --formula fish` |
| WezTerm Nightly | `brew upgrade --cask --greedy-latest wezterm@nightly` |
| Neovim | `mise upgrade --global --bump neovim` |
| Node.js | `mise upgrade --global --bump node` |
| Neovimプラグイン | `:Lazy update md-render.nvim` |
| Masonパッケージ | `:Mason` で対象を選択して `c`、`u` |
| Fisher本体 | `fisher update jorgebucaran/fisher` |

### 4.2 不要なパッケージ・ファイルの整理

通常の週次更新には含めない。必要になった場合だけ実施する。

| 操作 | 削除対象の確認 | 実行コマンド |
| --- | --- | --- |
| Homebrewの整理 | `brew cleanup --dry-run` | `brew cleanup` |
| 不要な依存関係 | `brew autoremove --dry-run` | `brew autoremove` |
| Brewfileにないパッケージ | `brew bundle cleanup --file="$HOME/dotfiles/Brewfile"` | `brew bundle cleanup --force --file="$HOME/dotfiles/Brewfile"` |
| miseの未使用バージョン | `mise prune --dry-run` | `mise prune` |
| miseの個別バージョン | `mise ls` | `mise uninstall ツール@バージョン` |
| 不要なNeovimプラグイン | `:Lazy` のClean対象を確認 | `:Lazy clean` |

削除対象を必ず確認する。特にmiseの旧Node.jsは業務プロジェクトで使用している可能性があるため、グローバル設定にないことだけで不要と判断しない。

### 4.3 ヘルスチェック・診断

| コマンド | 用途 |
| --- | --- |
| `brew doctor` | Homebrewの環境診断（通常更新でも実施） |
| `mise doctor` | miseの環境診断 |
| `:checkhealth` | Neovim全体の診断 |
| `:checkhealth vim.treesitter` | Tree-sitterの診断 |
| `:TSUpdate` | パーサーの手動更新・自動更新失敗時の対応 |
| `:checkhealth mason` | Masonの診断 |
| `:checkhealth vim.lsp` / `:LspInfo` | LSPの状態確認 |
| `:MasonLog` | Masonのログ確認 |

## 5. 障害対応・復旧手順

更新中にエラーや動作不良が発生した場合は、原則として次の工程への進行を中断する。エラーメッセージやGit差分を確認し、原因を特定した上で、設定修正・再インストール・旧バージョンへの変更などから適切な対応を選択する。

正常動作を確認できるまで、問題のある変更を通常の更新コミットとして確定しない。旧バージョンの取得可能性や依存関係の互換性は保証されない。

LazyVimの既存の復元手順については[プラグイン管理手順](../.config/nvim/docs/lazyvim-plugin-management.md)を参照する。

各管理ツールの詳細な復旧手順は、定期アップデートの実動作検証後に追記する。

## 6. 関連ドキュメント

### 6.1 既存ドキュメント

- [LazyVimプラグイン管理手順](../.config/nvim/docs/lazyvim-plugin-management.md)
- [Yaziセットアップ手順](../.config/yazi/yazi-setup.md)

#### 補足：新規環境でのFisherのブートストラップ

Fisher本体はGit管理外のため、dotfilesを新規展開した環境では初回のみ導入が必要となる。fishで以下を実行する。公式取得先のコードを読み込む操作であるため、必要に応じて事前に内容を確認する。

```fish
curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
and fisher update
```

`fish_plugins` が配置済みで、Fisher自身（`jorgebucaran/fisher`）も登録されていることが前提。既存の一覧を復元するため、Fisherだけを個別にインストールするのではなく `fisher update` を利用する。新規環境での復元処理は未検証のため、実行後に `fisher list` と `fish_plugins` の内容、各プラグインの動作を確認する。

### 6.2 公式ドキュメント

- [Homebrew Manual](https://docs.brew.sh/Manpage)
- [Homebrew Bundle](https://docs.brew.sh/Brew-Bundle-and-Brewfile)
- [mise upgrade](https://mise.jdx.dev/cli/upgrade.html)
- [mise outdated](https://mise.jdx.dev/cli/outdated.html)
- [LazyVim](https://www.lazyvim.org/)
- [lazy.nvim](https://lazy.folke.io/)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [Mason](https://github.com/mason-org/mason.nvim)
- [Fisher](https://github.com/jorgebucaran/fisher)
- [Yazi CLI](https://yazi-rs.github.io/docs/cli/)
