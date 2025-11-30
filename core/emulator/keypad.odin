package emulator

import "../shared"

Key :: enum u8 {
	Key0 = 0x0,
	Key1 = 0x1,
	Key2 = 0x2,
	Key3 = 0x3,
	Key4 = 0x4,
	Key5 = 0x5,
	Key6 = 0x6,
	Key7 = 0x7,
	Key8 = 0x8,
	Key9 = 0x9,
	KeyA = 0xA,
	KeyB = 0xB,
	KeyC = 0xC,
	KeyD = 0xD,
	KeyE = 0xE,
	KeyF = 0xF,
}

Keypad :: struct {
	data: [shared.KEYPAD_SIZE]bool,
}

init_keypad :: proc(k: ^Keypad) {
	k.data = {}
}

is_pressed :: proc(k: ^Keypad, key: Key) -> bool {
	return k.data[key]
}

set_pressed :: proc(k: ^Keypad, key: Key, pressed: bool) {
	k.data[key] = pressed
}

key_to_u8 :: proc(key: Key) -> u8 {
	return u8(key)
}

key_from_u8 :: proc(value: u8) -> (Key, Error) {
	if value >= shared.KEYPAD_SIZE {
		return {}, .InvalidKeyCode
	}
	return Key(value), .None
}
