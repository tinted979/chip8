package chip8

Keypad :: struct {
	keys: [KEY_COUNT]bool,
}

keypad_init :: proc(k: ^Keypad) {
	assert(k != nil)
	keypad_set_all_pressed(k, false)
}

keypad_get_pressed :: proc(k: ^Keypad, key: u8) -> (result: bool, error: Error) {
	assert(k != nil)
	keypad_is_key_valid(key) or_return
	return k.keys[key], .None
}

keypad_set_pressed :: proc(k: ^Keypad, key: u8, pressed: bool) -> Error {
	assert(k != nil)
	keypad_is_key_valid(key) or_return
	k.keys[key] = pressed
	return .None
}

keypad_set_all_pressed :: proc(k: ^Keypad, pressed: bool) {
	assert(k != nil)
	for &key in k.keys {
		key = pressed
	}
}

keypad_is_key_valid :: proc(key: u8) -> Error {
	return key < KEY_COUNT ? .None : .InvalidKey
}
