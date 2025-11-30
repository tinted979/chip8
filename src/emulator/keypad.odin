package emulator

import "../shared"

Keypad :: struct {
	data: [shared.KEYPAD_SIZE]bool,
}

init_keypad :: proc(k: ^Keypad) {
	k.data = {}
}

is_pressed :: proc(k: ^Keypad, key: shared.Key) -> bool {
	return k.data[key]
}

set_pressed :: proc(k: ^Keypad, key: shared.Key, pressed: bool) {
	k.data[key] = pressed
}

key_to_u8 :: proc(key: shared.Key) -> u8 {
	return u8(key)
}

key_from_u8 :: proc(value: u8) -> (shared.Key, shared.Error) {
	if value >= shared.KEYPAD_SIZE {
		return {}, .InvalidKeyCode
	}
	return shared.Key(value), .None
}
