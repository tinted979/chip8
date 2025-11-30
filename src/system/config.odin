package system

import "../shared"

Config :: struct {
	window_title:  string,
	window_width:  uint,
	window_height: uint,
	display_scale: uint,
	target_fps:    uint,
}

default_config :: proc() -> Config {
	return Config {
		window_title = shared.DEFAULT_WINDOW_TITLE,
		window_width = shared.DISPLAY_WIDTH,
		window_height = shared.DISPLAY_HEIGHT,
		display_scale = shared.DEFAULT_DISPLAY_SCALE,
		target_fps = shared.DEFAULT_TARGET_FPS,
	}
}

clear_config :: proc(config: ^Config) {
	config.window_title = ""
	config.window_width = 0
	config.window_height = 0
	config.display_scale = 0
	config.target_fps = 0
}
