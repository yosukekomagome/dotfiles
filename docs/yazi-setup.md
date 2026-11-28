# Yazi インストール＆設定 備忘録（fishシェル向け）

Rust製の高速ターミナルファイラー「Yazi」の構成、主要なプレビュー機能に必要なパッケージ、fishシェルとの連携、プラグイン設定および操作方法をまとめる。

新しいMacへの環境構築は[macOS 開発環境 構築・管理ガイド](../README.md)、定期アップデート・障害対応は[開発環境メンテナンス手順書](maintenance.md)を参照する。

## 1. 環境

- **OS**: macOS（Apple Silicon）
- **Terminal**: WezTerm Nightly
- **Shell**: fish
- **Filer**: Yazi（Homebrewで管理）

現在のバージョンは `yazi --version` および `ya --version` で確認する。

## 2. Yazi本体と依存パッケージのインストール

Yazi本体と関連パッケージは [Brewfile](../Brewfile) で管理する。通常の新規環境構築では `setup.sh` によって導入されるため、個別のインストールは不要。

Yaziの基本機能に加え、主要なプレビュー機能や高速な検索機能を利用するため、以下のパッケージを使用する。一部のパッケージは利用する機能に応じて任意で導入するものだが、現在の環境ではすべてBrewfileに登録している。

### インストールするパッケージの役割

**メインアプリケーション**

- **`yazi`**: ファイラー本体とCLIツール `ya`。

**プレビュー拡張ツール**

- **`imagemagick`**: 主にHEIC、JPEG XL、フォントなどのプレビューを補助する。一般的な画像プレビューすべてに必須ではない。
- **`ffmpeg`**: 主に動画のサムネイル生成に使用する。
- **`poppler`**: PDFページを画像に変換してプレビューする。
- **`jq`**: JSONファイルを整形してプレビューする。
- **`sevenzip`**: 圧縮ファイルを展開せずに、その内容を参照するために使用する。

**検索・移動アシストツール**

- **`fd`**: 高速なファイル検索（`find` 代替）。
- **`ripgrep`**: 高速なファイル内容検索（`grep` 代替）。
- **`fzf`**: ファイル・ディレクトリへの高速移動（ファジーファインド）に使用する。
- **`zoxide`**: 過去の訪問履歴に基づくディレクトリジャンプ機能を提供する。

## 3. fishシェルとの連携

### 3.1 ディレクトリ同期のラッパー関数設定

Yaziを `y` で起動し、`Q` で終了した際に、fishシェルのカレントディレクトリをYaziの終了時のディレクトリに同期させる。`q` では同期せずに終了する。

ラッパー関数は [config.fish](../.config/fish/config.fish) に定義済みである。dotfilesを展開した環境では追記する必要はない。

```fish
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"

    if read -z cwd <"$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
        builtin cd -- "$cwd"
    end

    command rm -f -- "$tmp"
end
```

`q` と `Q` の動作は [keymap.toml](../.config/yazi/keymap.toml) の独自設定による。標準の終了キーとは同期の有無が逆になっている。

## 4. Yaziの詳細設定

### 4.1 CSV/Excel等のファイル展開ルール

CSVやExcelファイルをmacOSのデフォルトアプリケーションで開くように設定する。

ファイルの拡張子やMIMEタイプに応じて、使用するアプリケーションを指定できる。

- **`url`**: Globパターンによるファイルの判定。
- **`mime`**: MIMEタイプによるファイルの判定。
- **`use`**: 使用するオープナーの指定。

現在の [yazi.toml](../.config/yazi/yazi.toml) では以下のルールを設定している。

```toml
[open]
prepend_rules = [
    { url = "**/*.csv", use = [ "open", "edit" ] },
    { url = "**/*.xlsx", use = [ "open", "reveal" ] }
]
```

**操作方法**

- **`Enter`**: `smart-enter` により、フォルダなら移動し、ファイルなら開く。
- **`o`**: 設定されたオープナーでファイルを開く。
- **`O`（Shift + o）**: 開き方を選択するメニューを表示する。

`o` / `O` は、複数のファイルを選択している場合、選択中のファイルを対象とする。

なお、`Enter` は5章で説明する `smart-enter` プラグインを実行するため、標準の `open` コマンドと動作が完全に同じとは限らない。

### 4.2 隠しファイルの表示

`yazi.toml` で隠しファイルを初期状態から表示するように設定している。

```toml
[mgr]
show_hidden = true
```

## 5. プラグイン・Flavorの管理と設定

### 5.1 管理方法

プラグインとFlavorは [package.toml](../.config/yazi/package.toml) で管理し、リビジョンとハッシュをGitに記録する。`plugins/`、`flavors/` の実体はGit管理しない。

通常の新規環境構築では `setup.sh` が `ya pkg install` を実行する。Yaziのパッケージだけを導入・復元する場合も、配置済みの `package.toml` を利用する。

| コマンド | 用途 |
| --- | --- |
| `ya pkg add パッケージID` | 新しいプラグイン・Flavorの追加 |
| `ya pkg install` | `package.toml` に記録されたパッケージの導入・復元 |
| `ya pkg upgrade` | パッケージの更新 |
| `ya pkg list` | 管理対象の確認 |

定期更新、動作確認、Gitへの反映はメンテナンス手順書の3.7に従う。Yazi本体とプラグイン・Flavorの互換性は別途考慮する。

### 5.2 smart-enter（直感的な操作）

`Enter` と `l` を「フォルダなら中に入り、ファイルなら開く」という動作に統一する。

パッケージIDは `yazi-rs/plugins:smart-enter`。現在は登録済みのため、通常は `ya pkg add` を実行しない。

[keymap.toml](../.config/yazi/keymap.toml) の設定：

```toml
[[mgr.prepend_keymap]]
on   = "<Enter>"
run  = "plugin smart-enter"
desc = "Enter the directory, or open the file"

[[mgr.prepend_keymap]]
on   = "l"
run  = "plugin smart-enter"
desc = "Enter the directory, or open the file"
```

キーマップの設定には `[[mgr.prepend_keymap]]` を使用する。旧形式の `[[manager.prepend_keymap]]` は使用しない。設定変更後はYaziを再起動する。

### 5.3 full-border（罫線表示）

パッケージIDは `yazi-rs/plugins:full-border`。角丸の罫線を表示するため、[init.lua](../.config/yazi/init.lua) で以下の設定を行っている。

```lua
require("full-border"):setup({
    set = "rounded",
})
```

旧設定の `type` オプションではなく `set` を使用する。

### 5.4 tokyo-night（Flavor）

パッケージIDは `BennyOe/tokyo-night`。[theme.toml](../.config/yazi/theme.toml) でダークテーマとして指定する。

```toml
[flavor]
dark = "tokyo-night"
```

## 6. 基本的な使い方と検索TIPS

設定完了後、以下のコマンドでYaziを起動する。

```fish
y
```

`y` は3.1で定義したfishのラッパー関数であり、`Q` で終了した際にカレントディレクトリを同期する。

### 6.1 主要なキーバインド（Vimライク）

| キー | 動作 | 区分 |
| --- | --- | --- |
| `j` / `k` | カーソルの上下移動 | 標準 |
| `h` | 親ディレクトリに戻る | 標準 |
| `l` / `Enter` | フォルダなら中に入り、ファイルなら開く（smart-enter） | 独自 |
| `o` | 設定されたオープナーでファイルを開く | 標準 |
| `O` | 開き方を選択する | 標準 |
| `Space` | ファイルの選択・選択解除 | 標準 |
| `q` | ディレクトリを同期せずに終了 | 独自 |
| `Q` | 終了時にディレクトリを同期（`y` で起動した場合） | 独自 |
| `J` / `K` | プレビューを下／上へスクロール | 標準 |
| `w` | Gitリポジトリのルートディレクトリへ移動 | 独自 |
| `e` | ホームディレクトリへ移動 | 独自 |
| `i` | ファイル一覧の絞り込み（`filter --smart`） | 独自 |

独自キーマップの実装は [keymap.toml](../.config/yazi/keymap.toml) を参照する。`w` はGitリポジトリ内で使用する。標準の `w`（タスク管理）は上書きされている。

### 6.2 インクリメンタルサーチ・移動アシスト

| キー | 使用ツール | 何を探す？ | 主な用途 |
| --- | --- | --- | --- |
| `f`（Filter） | 標準機能 | 現在のディレクトリ内のファイル・ディレクトリ | 入力文字列でリアルタイムに絞り込む |
| `i`（独自設定） | 標準機能 | 現在のディレクトリ内のファイル・ディレクトリ | `filter --smart` による絞り込み |
| `/`（Find） | 標準機能 | 現在のディレクトリ内のファイル・ディレクトリ | 前方検索。`n` / `N` で次・前の一致項目へ移動 |
| `s`（Search name） | fd | ファイル・フォルダの名前 | 名前が分かっているファイルを探す |
| `S`（Search contents） | ripgrep | ファイルの中身 | 特定の文字列を含むファイルを探す |
| `z` | fzf | ファイル・フォルダ | 候補を絞って移動またはファイルを表示する |
| `Z` | zoxide + fzf | 過去に訪れたフォルダ | よく使う作業フォルダへジャンプする |

### 6.3 マルチタブ

| キー | 動作 |
| --- | --- |
| `t` → `t` | 現在のディレクトリで新規タブを作成 |
| `1` ～ `9` | 指定番号のタブへ移動 |
| `[` | 前のタブへ移動 |
| `]` | 次のタブへ移動 |
| `{` | 現在のタブと前のタブを入れ替える |
| `}` | 現在のタブと次のタブを入れ替える |
| `Ctrl + c` | 現在のタブを閉じる |

標準キーマップはYazi本体の更新で変更される場合がある。現在の割り当てはYazi内のヘルプ（`~`）や公式ドキュメントで確認する。

## 7. 参考資料

- [Yazi公式：Installation](https://yazi-rs.github.io/docs/installation/)
- [Yazi公式：Quick Start](https://yazi-rs.github.io/docs/quick-start/)
- [Yazi公式：CLI](https://yazi-rs.github.io/docs/cli/)
- [Yazi公式：keymap.toml](https://yazi-rs.github.io/docs/configuration/keymap/)
