local wezterm = require("wezterm")

----------------------------------------------------
-- 特殊モード用のUI設定テーブル
----------------------------------------------------
local mode_config = {
	copy_mode = { fg_color = "#d8ca8b", bg_color = "#3e382b" },
	resize_pane = { fg_color = "#8ea4c8", bg_color = "#2a313f" },
	search_mode = { fg_color = "#8fbc9f", bg_color = "#2b3a32" },
}
----------------------------------------------------
-- WezTermのステータス領域の表示設定
----------------------------------------------------
wezterm.on("update-status", function(window, pane)
	local text = "NORMAL"
	local bg_color = "transparent"
	local fg_color = "#585e75"

	-- 1. リーダーキーが押されているか
	if window:leader_is_active() then
		text = "LEADER  "
		fg_color = "#fa05ac"
	end

	-- 2. キーテーブル（モード）に入っているか
	local mode_name = window:active_key_table()
	if mode_name then
		text = mode_name
		fg_color = mode_config[mode_name].fg_color
		bg_color = mode_config[mode_name].bg_color
	end

	-- 表示するデザインの部品リスト（テーブル）を作る
	local status_format = {}

	-- 文字色、太字、テキスト本体を追加する
	table.insert(status_format, { Foreground = { Color = fg_color } })
	table.insert(status_format, { Background = { Color = bg_color } })
	table.insert(status_format, { Attribute = { Intensity = "Bold" } })
	table.insert(status_format, { Text = "  " .. text:upper() .. "  " })

	-- 組み立てたデザインを左側にセット
	window:set_left_status(wezterm.format(status_format))

	-- 右側は空にする（時計などを入れる場合はここを変更します）
	window:set_right_status("")
end)
