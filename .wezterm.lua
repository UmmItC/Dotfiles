local wezterm = require 'wezterm'
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Actual config

config.enable_tab_bar = false

config.window_background_opacity = 0.75

config.color_scheme = 'Builtin Dark'
config.colors = {
	foreground = '#E3E3EA',
	background = '#000B1C',

	cursor_bg 		= '#FFFFFF',
	cursor_fg 		= '#000000',
	cursor_border 	= '#7FD4FF',

	selection_fg = '#000000',
	selection_bg = '#99CCFF',
}

config.default_cursor_style 	= 'BlinkingBar'
config.cursor_blink_ease_in 	= 'Constant'
config.cursor_blink_ease_out 	= 'Constant'

-- Config End
return config
