package chip8

import "vendor:sdl2"

KEY_COUNT :: 16

KeyMapping :: struct {
	sdl_key:   sdl2.Keycode,
	chip8_key: u8,
}

KEY_MAPPINGS := [KEY_COUNT]KeyMapping {
	{.NUM1, 0x1},
	{.NUM2, 0x2},
	{.NUM3, 0x3},
	{.NUM4, 0xC},
	{.Q, 0x4},
	{.W, 0x5},
	{.E, 0x6},
	{.R, 0xD},
	{.A, 0x7},
	{.S, 0x8},
	{.D, 0x9},
	{.F, 0xE},
	{.Z, 0xA},
	{.X, 0x0},
	{.C, 0xB},
	{.V, 0xF},
}

Keypad :: struct {
	keys: [KEY_COUNT]bool,
}

kp_init :: proc(k: ^Keypad) {
	k.keys = [?]bool {
		0 ..< len(k.keys) = false,
	}
}

kp_get_pressed :: proc(k: ^Keypad, key: u8) -> bool {
	return k.keys[key]
}

kp_set_pressed :: proc(k: ^Keypad, key: u8, pressed: bool) {
	k.keys[key] = pressed
}

kp_get_mapping :: proc(key: sdl2.Keycode) -> (u8, bool) {
	for mapping in KEY_MAPPINGS {
		if mapping.sdl_key == key {
			return mapping.chip8_key, true
		}
	}
	return 0, false
}
