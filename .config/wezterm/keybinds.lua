local wezterm = require("wezterm")
local action = wezterm.action

----------------------------------------------------
-- key bind
----------------------------------------------------

-- leader key の設定tmuxライクにする
local leader = { key = "t", mods = "CTRL", timeout_milliseconds = 2000 }

local keys = {
	-- OSネイティブライクのキー(SUPER = Cmd)
	{ key = "q", mods = "SUPER", action = action.QuitApplication }, -- アプリ終了
	{ key = "w", mods = "SUPER", action = action.CloseCurrentTab({ confirm = false }) }, -- 現在のTabを閉じる
	{ key = "c", mods = "SUPER", action = action.CopyTo("Clipboard") }, -- システムのクリップボードへコピー(Cmd + c)
	{ key = "v", mods = "SUPER", action = action.PasteFrom("Clipboard") }, -- システムのクリップボードからペースト(Cmd + v)
	{ key = "+", mods = "SUPER", action = action.IncreaseFontSize }, -- フォントサイズ拡大
	{ key = "-", mods = "SUPER", action = action.DecreaseFontSize }, -- フォントサイズ縮小
	{ key = "0", mods = "SUPER", action = action.ResetFontSize }, -- フォントサイズリセット

	-- leaderキーを使うキー
	{ key = "c", mods = "LEADER", action = action.SpawnTab("CurrentPaneDomain") }, -- 新しいTabを開く
	{ key = "n", mods = "LEADER", action = action.ActivateTabRelative(1) }, -- 次のタブへ（相対的移動）
	{ key = "p", mods = "LEADER", action = action.ActivateTabRelative(-1) }, -- 前のタブへ（相対的移動）
	{ key = "v", mods = "LEADER", action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }) }, -- Paneを右に分割
	{ key = "s", mods = "LEADER", action = action.SplitVertical({ domain = "CurrentPaneDomain" }) }, -- Paneを下に分割
	{ key = "x", mods = "LEADER", action = action.CloseCurrentPane({ confirm = false }) }, -- Paneを閉じる
	{ key = "h", mods = "LEADER", action = action.ActivatePaneDirection("Left") }, -- Pane移動
	{ key = "l", mods = "LEADER", action = action.ActivatePaneDirection("Right") }, -- Pane移動
	{ key = "j", mods = "LEADER", action = action.ActivatePaneDirection("Down") }, -- Pane移動
	{ key = "k", mods = "LEADER", action = action.ActivatePaneDirection("Up") }, -- Pane移動
	{ key = "z", mods = "LEADER", action = action.TogglePaneZoomState }, -- 選択中のPaneのみ表示
	{ key = "r", mods = "LEADER", action = action.ReloadConfiguration }, -- 設定ファイルの再読み込み
	{ key = "Space", mods = "LEADER", action = action.QuickSelect }, -- 画面内のパスやURLをキーボードで一発コピー
	{ key = "d", mods = "LEADER", action = action.DetachDomain("CurrentPaneDomain") }, -- デタッチ（裏でプロセスを動かしたまま画面を切り離す）

	-- モード移行
	{ key = "w", mods = "LEADER", action = action.ActivateKeyTable({ name = "resize_pane", one_shot = false }) }, -- resize_paneモード入る
	{ key = "[", mods = "LEADER", action = action.ActivateCopyMode }, -- copy_modeへ入る
	{ key = "/", mods = "LEADER", action = action.Search({ CaseInSensitiveString = "" }) }, -- serch_modeに入る
}

----------------------------------------------------
-- key table
----------------------------------------------------

-- weztermの標準の特殊モード（copy_mode,serch_mode）をそのまま読み込む
local key_tables = wezterm.gui.default_key_tables()

-- Paneサイズ調整 leader + w
key_tables.resize_pane = {
	{ key = "h", action = action.AdjustPaneSize({ "Left", 1 }) },
	{ key = "l", action = action.AdjustPaneSize({ "Right", 1 }) },
	{ key = "j", action = action.AdjustPaneSize({ "Down", 1 }) },
	{ key = "k", action = action.AdjustPaneSize({ "Up", 1 }) },
	{ key = "Escape", action = "PopKeyTable" }, -- モード終了
	{ key = "Enter", action = "PopKeyTable" }, -- モード終了
}

-- serch_mode終了、検索パターンクリア
table.insert(key_tables.search_mode, {
	key = "Escape",
	mods = "NONE",
	action = action.Multiple({ action.CopyMode("ClearPattern"), action.CopyMode("Close") }),
})

-- ヤンクしたらcopy_mode終了、検索パターンクリア
table.insert(key_tables.copy_mode, {
	key = "y",
	mods = "NONE",
	action = action.Multiple({
		action.CopyTo("ClipboardAndPrimarySelection"),
		action.CopyMode("ClearPattern"),
		action.ScrollToBottom,
		action.CopyMode("Close"),
	}),
})

-- ヤンクせずcopy_mode終了、検索パターンクリア
table.insert(key_tables.copy_mode, {
	key = "Escape",
	mods = "NONE",
	action = action.Multiple({
		action.CopyMode("ClearPattern"),
		action.ScrollToBottom,
		action.CopyMode("Close"),
	}),
})

return {
	keys = keys,
	key_tables = key_tables,
	leader = leader,
}
