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
