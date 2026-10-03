local wezterm = require("wezterm")
local action = wezterm.action

----------------------------------------------------
-- WezTermのステータス領域の表示設定
----------------------------------------------------
wezterm.on("update-status", function(window, pane)
	local text = ""
	local bg_color = "transparent" -- status領域の背景は完全に透過
	local fg_color = "#1a1b26"

	-- 1. リーダーキーが押されているか
	if window:leader_is_active() then
		text = "  LEADER  "
		fg_color = "#fa05ac"
	end

	-- 2. キーテーブル（モード）に入っているか
	local name = window:active_key_table()
	if name then
		text = "  " .. name .. "  "
		fg_color = "#1a1b26" -- 背景がある時は文字を暗くして読みやすくする
		bg_color = "#7aa2f7" -- 爽やかなブルー
	end

	-- 何も表示することがない場合は空にして終了
	if text == "" then
		window:set_left_status("")
		window:set_right_status("")
		return
	end

	-- 表示するデザインの部品リスト（テーブル）を作る
	local status_format = {}

	-- bg_color が設定されている時だけ、背景色の設定を追加する
	if bg_color then
		table.insert(status_format, { Background = { Color = bg_color } })
	end

	-- 文字色、太字、テキスト本体を追加する
	table.insert(status_format, { Foreground = { Color = fg_color } })
	-- table.insert(status_format, { Attribute = { Intensity = "Bold" } })
	table.insert(status_format, { Text = text })

	-- 組み立てたデザインを左側にセット
	window:set_left_status(wezterm.format(status_format))

	-- 右側は空にする（時計などを入れる場合はここを変更します）
	window:set_right_status("")
end)

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
		action.ScrollToBottom(),
		action.CopyMode("Close"),
	}),
})

-- ヤンクせずcopy_mode終了、検索パターンクリア
table.insert(key_tables.copy_mode, {
	key = "Escape",
	mods = "NONE",
	action = action.Multiple({
		action.CopyMode("ClearPattern"),
		action.ScrollToBottom(),
		action.CopyMode("Close"),
	}),
})

return {
	keys = keys,
	key_tables = key_tables,
	leader = leader,
}
