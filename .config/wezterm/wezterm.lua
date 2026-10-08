local wezterm = require("wezterm")
local config = wezterm.config_builder()
require("status_format")

config.automatically_reload_config = true
config.font_size = 15.0
config.use_ime = true
config.window_background_opacity = 0.60
config.macos_window_background_blur = 15
config.color_scheme = "Solarized Dark - Patched"
config.font = wezterm.font("Hack Nerd Font")

----------------------------------------------------
-- ペインの見た目（非アクティブ状態のスタイル）
----------------------------------------------------
config.inactive_pane_hsb = {
	saturation = 1.0, -- 彩度（1.0が元の色。数値を下げると白黒に近づく）
	brightness = 0.4, -- 明度（1.0が元の明るさ。数値を下げると暗くなる）
}

----------------------------------------------------
-- タブバーのカスタマイズ
----------------------------------------------------

-- タイトルバーを非表示
config.window_decorations = "RESIZE"

-- タブバーの表示
config.show_tabs_in_tab_bar = true

-- タブが一つの時は非表示
config.hide_tab_bar_if_only_one_tab = false

-- タブバーの透過
config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}

-- タブバーを背景色に合わせる
config.window_background_gradient = { colors = { "#000000" } }

-- タブの追加ボタンを非表示
config.show_new_tab_button_in_tab_bar = false

-- タブの閉じるボタンを非表示（nightlyのみ使用可能）
config.show_close_tab_button_in_tabs = false

-- タブ同士の境界線を非表示
config.colors = { tab_bar = { inactive_tab_edge = "none" } }

-- タブバーを画面下部に配置する
config.tab_bar_at_bottom = false

----------------------------------------------------
-- タブの形をカスタマイズ
----------------------------------------------------

-- タブの左側の装飾
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle

-- タブの右側の装飾
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = "#5c6d74"
	local foreground = "#FFFFFF"
	local edge_background = "none"

	if tab.is_active then
		background = "#ae8b2d"
		foreground = "#FFFFFF"
	end

	local edge_foreground = background
	local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)

----------------------------------------------------
-- カーソルのスタイルの指定
----------------------------------------------------

-- cursorを点滅させる
config.default_cursor_style = "BlinkingBlock"

-- cursorの点滅スピード
config.cursor_blink_rate = 500

-- cursorのフェードアニメーションを無効化（パキッと点滅）
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

----------------------------------------------------
-- keybinds
----------------------------------------------------
local keybinds = require("keybinds")

config.disable_default_key_bindings = true
config.keys = keybinds.keys
config.key_tables = keybinds.key_tables
config.leader = keybinds.leader

----------------------------------------------------
-- バックグランド保持（Multiplexer）の設定
----------------------------------------------------
-- 'unix_local'という名前のローカルドメイン（バックグランドプロセス）を定義
config.unix_domains = { { name = "unix_local" } }

-- WerTerm起動時に、自動的にこのバックグランドプロセスに接続（アタッチ）する
config.default_gui_startup_args = { "connect", "unix_local" }

return config
