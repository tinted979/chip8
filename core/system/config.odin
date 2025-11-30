package system

Config :: struct {
	window_title:  string,
	window_width:  uint,
	window_height: uint,
	display_scale: uint,
	target_fps:    uint,
}

default_config :: proc() -> Config {
	return Config {
		window_title = "Chip8",
		window_width = 64,
		window_height = 32,
		display_scale = 10,
		target_fps = 60,
	}
}

clear_config :: proc(config: ^Config) {
	config.window_title = ""
	config.window_width = 0
	config.window_height = 0
	config.display_scale = 0
	config.target_fps = 0
}
