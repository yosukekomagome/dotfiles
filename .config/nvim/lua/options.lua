-- lang
-- vim.cmd('language en_US.utf8') -- 表示言語を英語にする（Linux）
vim.cmd('language en_US.UTF-8') -- 表示言語を英語にする（Mac）

-- ファイル
vim.opt.fileencoding = 'utf-8' -- エンコーディングをUTF-8に設定
vim.opt.swapfile = false -- スワップファイルを作成しない
vim.opt.helplang = 'ja' -- ヘルプファイルの言語は日本語
vim.opt.hidden = true -- バッファを切り替えるときにファイルを保存しなくてもOKに

-- 補完候補表示時の挙動
vim.opt.completeopt = 'menu,menuone,noselect'

-- カラースキーム
vim.opt.termguicolors = true -- 24 ビットカラーを使用
vim.opt.background = 'dark' -- ダークカラーを使用する

-- カーソル移動
vim.opt.whichwrap = 'b,s,h,l,[,],<,>,~'
vim.opt.backspace = { 'start', 'eol', 'indent' }

-- クリップボード共有
vim.opt.clipboard:append({ 'unnamedplus' }) -- レジスタとクリップボードを共有

-- メニューとコマンド
vim.opt.wildmenu = true -- コマンドラインで補完
vim.opt.cmdheight = 1 -- コマンドラインの表示行数
vim.opt.showcmd = true -- コマンドラインに入力されたコマンドを表示
vim.opt.laststatus = 3 -- 最下部に表示しているウィンドウのステータス情報を表示

-- 検索・置換え
vim.opt.hlsearch = true -- ハイライト検索を有効
vim.opt.incsearch = true -- インクリメンタルサーチを有効
vim.opt.matchtime = 1 -- 入力された文字列がマッチするまでにかかる時間
vim.opt.ignorecase = true -- 検索時に大文字と小文字を区別しない
vim.opt.wildignore:append({ '*/node_modules/*' })

-- インデント
vim.opt.shiftwidth = 2 -- 自動インデントでずれる幅
vim.opt.tabstop = 2 -- タブ幅を2に設定する
vim.opt.expandtab = true -- タブ文字をスペースに置き換える
vim.opt.softtabstop = -1 -- タブキーで入力するスペース数 (-1: tabstop に合わせる)
vim.opt.autoindent = true -- 自動インデントを有効にする
vim.opt.smartindent = true -- インデントをスマートに調整する
vim.opt.breakindent = true -- 行を折り返しするときにインデントを考慮する

-- インタフェース
vim.o.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20' -- カーソルの形状
vim.opt.number = true -- 行番号を表示
vim.opt.relativenumber = true -- 相対行番号を表示
vim.opt.wrap = false -- テキストの自動折り返しを無効に
vim.opt.showtabline = 2 -- タブラインを表示（1:常に表示、2:タブが開かれたときに表示）
vim.opt.visualbell = true -- ビープ音を表示する代わりに画面をフラッシュ
vim.opt.showmatch = true -- 対応する括弧をハイライト表示
vim.opt.title = true -- ファイル名を表示
vim.opt.scrolloff = 10 -- 画面端でのスクロールに余裕を持つ
vim.opt.winblend = 0 -- ウィンドウの不透明度
vim.opt.pumblend = 0 -- ポップアップメニューの不透明度
vim.opt.signcolumn = 'yes' -- サインカラムを表示
vim.opt.cursorline = true -- カーソル行をハイライト
-- vim.opt.cursorcolumn = true -- カーソルがある列を強調
vim.opt.wildoptions = 'pum' -- コマンドラインモードの補完をポップアップで表示
-- vim.cmd("highlight LineNr guifg=#0be629") -- 行番号の色を変更（色は適宜変更してください）

-- ウィンドウ操作
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])
