# LazyVim プラグイン管理・更新・復元ガイド

## 1. 目的・適用範囲

本書は、LazyVim環境で使用する **lazy.nvim** のプラグイン管理コマンド、`lazy-lock.json` の役割、更新・検証・復元の手順を定める。

- 対象：`lvim` で起動する独立したLazyVim環境（`NVIM_APPNAME=nvim-lazyvim`）
- 設定：`~/.config/nvim-lazyvim/`（dotfilesから管理）
- プラグイン実体：`~/.local/share/nvim-lazyvim/lazy/`
- ロックファイル：`~/.config/nvim-lazyvim/lazy-lock.json`
- Git管理リポジトリ：`~/dotfiles`
- 既存のPacker版Neovim（`nvim`）は対象外とし、そのプラグインは更新しない。

**基本方針：プラグイン更新前にロックファイルのGit状態を確定し、更新後の動作確認が済んでからロックファイルをコミットする。**

## 2. 管理対象と役割

| 対象 | 役割 | Gitで管理するか |
| --- | --- | --- |
| `lua/plugins/*.lua` など | プラグインの導入・オプション・依存関係を定義 | 管理する |
| `lazyvim.json` | LazyVim Extrasの選択など | 管理する |
| `lazy-lock.json` | プラグインごとのGitリビジョン（コミットID等）を記録 | **管理する** |
| `~/.local/share/nvim-lazyvim/lazy/` | インストール済みプラグインの実体 | 通常は管理しない |

`lazy-lock.json` は**過去の履歴を保存するバックアップファイルではない**。現在記録されているプラグインのリビジョン一覧であり、更新すると内容も変わる。過去の状態はGit履歴で保存する。

プラグイン設定ファイル、`lazyvim.json`、およびロックファイルは関連する場合がある。設定やExtrasの変更を伴う更新では、必要なファイルをまとめてコミットする。

## 3. lazy.nvimの主要コマンド

以下はLazyVim上のNeovimコマンドラインで実行する（先頭の `:` を含めて入力）。`[plugins]` は対象プラグインを絞るための任意引数。

| コマンド | 動作 | 主な用途・注意点 |
| --- | --- | --- |
| `:Lazy` | プラグイン管理UIを開く | 状態や実行結果の確認 |
| `:Lazy check` | 更新の有無を確認し、更新ログを表示する | **更新候補の確認**。インストール済みリビジョンの更新は行わない |
| `:Lazy update` | プラグインを更新し、ロックファイルも更新する | 日常のバージョン更新 |
| `:Lazy update {plugin}` | 指定プラグインを更新する | 影響範囲を絞った更新 |
| `:Lazy restore` | **現在のロックファイル**に記録されたリビジョンへ戻す | 更新前に戻すには先にロックファイルをGitで戻す |
| `:Lazy restore {plugin}` | 指定プラグインをロックファイル記録の状態へ復元する | 単一プラグインの復元 |
| `:Lazy install` | 不足しているプラグインをインストールする | 新規追加や環境構築 |
| `:Lazy clean` | 現在の設定で不要なプラグインを削除する | 設定から削除したプラグインの整理。実行対象を確認する |
| `:Lazy sync` | `install`・`clean`・`update` をまとめて実行する | **更新も行う**ため、単なる復元目的で使わない |
| `:Lazy log` | 最近のプラグイン更新履歴を確認する | 更新内容の調査 |
| `:Lazy build {plugin}` | プラグインのビルド処理を実行する | ビルドが必要なプラグインの再構築 |
| `:Lazy health` | lazy.nvimのヘルスチェックを実行する | トラブルシューティング |
| `:Lazy profile` | 読み込み処理のプロファイルを確認する | 起動パフォーマンスの調査 |

`:Lazy check` はリモートから更新情報を取得する処理を含む。`check` の実行は、`update` と異なりプラグインのチェックアウト先を更新する操作ではない。

`:Lazy sync` は `restore` と同義ではない。ロックファイルに合わせて環境を戻す目的では `:Lazy restore` を使用する。

## 4. 更新と復元の関係

```text
Gitに保存した旧 lazy-lock.json（バージョンA）
    │
    ├─ :Lazy update
    │     ├─ プラグイン実体 → バージョンB
    │     └─ lazy-lock.json → バージョンB
    │
    ├─ そのまま :Lazy restore
    │     └─ バージョンBへ復元（Aには戻らない）
    │
    └─ Gitで lazy-lock.json をAに戻す
          └─ :Lazy restore → プラグイン実体もAへ戻す
```

**重要：`git restore` はロックファイルの内容だけを戻す操作。`:Lazy restore` は、そのロックファイルを参照してインストール済みプラグインのリビジョンを戻す操作。** 更新前へのロールバックには両方が必要。

## 5. 標準ワークフロー：更新前の確認

### 5.1 ロックファイルに未コミット変更がないことを確認

ターミナル（fish）で実行する。

```fish
git -C ~/dotfiles status --short -- .config/nvim-lazyvim/lazy-lock.json
git -C ~/dotfiles diff -- .config/nvim-lazyvim/lazy-lock.json
```

出力がなければ、ロックファイルの作業ツリーに未コミット変更はない。すでに変更がある場合は、その変更を検証・コミットするか、意図を確認してから破棄する。**理由がわからない差分をそのまま破棄しない。**

設定ファイルやExtrasにも変更がある場合は、別途 `git -C ~/dotfiles status --short` で確認する。

### 5.2 更新候補を確認

LazyVimを `lvim` で起動し、次を実行する。

```vim
:Lazy check
```

必要に応じて対象プラグインの変更履歴を確認する。

```vim
:Lazy log
```

## 6. 標準ワークフロー：更新・検証・コミット

### 6.1 プラグインを更新

```vim
:Lazy update
```

一部のみ更新する場合：

```vim
:Lazy update gitsigns.nvim
```

更新完了後、LazyVimを再起動する。

### 6.2 動作を検証

利用する機能を中心に確認する。例：

- 起動、バッファ操作、Telescope／Snacksなどの画面操作
- LSP接続、補完、定義参照、Diagnostics
- 保存時のフォーマット・ESLint修正
- Treesitterのハイライトやテキスト操作
- Git関連表示、lualine、Noice、各種キーマップ

問題がある場合は **第7章** の復元手順を実施する。

### 6.3 差分を確認

```fish
git -C ~/dotfiles diff --check
git -C ~/dotfiles diff -- .config/nvim-lazyvim/lazy-lock.json
```

更新対象が意図どおりであることを確認する。

### 6.4 Gitコミット

```fish
git -C ~/dotfiles add .config/nvim-lazyvim/lazy-lock.json
git -C ~/dotfiles diff --cached --check
git -C ~/dotfiles diff --cached
git -C ~/dotfiles commit -m "chore(lazyvim): プラグインのバージョンを更新"
```

その他の設定変更を同時に行っていた場合は、コミットするファイルとメッセージを変更内容に合わせて調整する。

## 7. 問題発生時のロールバック

**前提：更新前の `lazy-lock.json` がGitコミットに保存されており、その後にロックファイルのコミットを行っていない場合。**

### 7.1 ロックファイルをGitの状態に戻す

LazyVimを終了してから、ターミナルで実行する。

```fish
git -C ~/dotfiles restore -- .config/nvim-lazyvim/lazy-lock.json
```

このコマンドは未コミットのロックファイル変更を破棄する。ほかの未コミット変更を残したい場合は、先に退避・確認する。

### 7.2 プラグイン実体を戻す

再度 `lvim` で起動し、次を実行する。

```vim
:Lazy restore
```

完了後にLazyVimを再起動し、問題が解消したことを確認する。

### 7.3 更新済みロックファイルをすでにコミットした場合

戻したい過去のコミットを確認する。

```fish
git -C ~/dotfiles log --oneline -- .config/nvim-lazyvim/lazy-lock.json
```

目的のコミットが決まったら、その時点のロックファイルを作業ツリーへ取り出す。

```fish
git -C ~/dotfiles restore --source=<復元したいコミットID> -- .config/nvim-lazyvim/lazy-lock.json
```

次に `lvim` で `:Lazy restore` を実行する。復元後の状態を採用するなら、そのロックファイルも新しいコミットとして記録する。`git reset --hard` は無関係な変更まで破棄するため、通常の復元手順では使用しない。

### 7.4 追加の注意点

- プラグインの設定やExtrasも変更した場合、ロックファイルだけでは旧構成を完全に再現できない。それらのファイルも適切なGitリビジョンへ戻す。
- 対象プラグインの更新以前からロックファイルに未コミット変更があった場合、`git restore` で意図する状態へ戻せるとは限らない。
- プラグイン更新以外の外部ツール（Node.js、Mason管理のLSPサーバー、Tree-sitter CLIなど）のバージョンは、`lazy-lock.json` の復元対象ではない。
- プラグインのビルド成果物やキャッシュまで完全に戻ることは保証されない。必要に応じて再ビルド・再起動・個別調査を行う。

## 8. 新しいPC・別環境への再現

1. dotfilesを取得し、LazyVim用の設定を所定の場所に配置する。
2. LazyVim環境を `lvim` で起動する。
3. 不足しているプラグインがあれば `:Lazy install` で導入する。
4. `:Lazy restore` を実行して、Git管理された `lazy-lock.json` のリビジョンに合わせる。
5. LazyVimを再起動し、必要な外部ツール・LSP・各種操作を確認する。

**注意：最初から既存環境と同じリビジョンを再現することが目的なら、`:Lazy sync` を安易に使わない。** `sync` は更新を含むため、ロックファイルを書き換える可能性がある。

## 9. 日常運用の判断表

| 目的 | 実行すること |
| --- | --- |
| 更新の有無だけ知りたい | `:Lazy check` |
| 通常の更新を実施したい | Git状態確認 → `:Lazy update` → 動作確認 → Gitコミット |
| 特定プラグインだけ更新したい | `:Lazy update {plugin}` → 動作確認 → Gitコミット |
| 更新直後に問題が発生した | Gitでロックファイルを更新前に戻す → `:Lazy restore` |
| 以前にコミットした状態へ戻したい | `git log` で対象を特定 → `git restore --source=...` → `:Lazy restore` |
| 別環境で記録済みのバージョンを再現したい | 不足分をインストール → `:Lazy restore` |
| 不要プラグインを掃除したい | 設定を確認 → `:Lazy clean` |
| プラグインの追加・削除・更新を一括実行したい | 影響を確認した上で `:Lazy sync` |

## 10. 運用上の原則

- **更新前の状態をGitに残す。** ロックファイルの未コミット変更がある状態で、無条件に次の更新を重ねない。
- **`update` と `restore` を混同しない。** `restore` の復元先は、その時点のロックファイルで決まる。
- **正常に動作した更新のみコミットする。** 問題のある更新状態を確定させない。
- **設定変更とプラグイン更新を分けられる場合は、別コミットにする。** 原因の追跡と復元を容易にする。
- **既存Packer環境を巻き込まない。** コマンドの実行対象は `lvim` のLazyVim環境とする。

## 11. 参考資料

- [lazy.nvim 公式：Commands](https://lazy.folke.io/usage)
- [lazy.nvim 公式：Lockfile](https://lazy.folke.io/usage/lockfile)
- [lazy.nvim GitHub](https://github.com/folke/lazy.nvim)
