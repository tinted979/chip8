package chip8

Keypad :: struct {
	keys: [KEY_COUNT]bool,
}

keypad_init :: proc(k: ^Keypad) -> Error {
	assert(k != nil)
	keypad_set_all_pressed(k, false)
	return .None
}

keypad_get_pressed :: proc(k: ^Keypad, key: u8) -> (bool, Error) {
	assert(k != nil)
	if !keypad_is_key_valid(key) do return false, .InvalidKey
	return k.keys[key], .None
}

keypad_set_pressed :: proc(k: ^Keypad, key: u8, pressed: bool) -> Error {
	assert(k != nil)
	if !keypad_is_key_valid(key) do return .InvalidKey
	k.keys[key] = pressed
	return .None
}

keypad_set_all_pressed :: proc(k: ^Keypad, pressed: bool) -> Error {
	assert(k != nil)
	for &key in k.keys {
		key = pressed
	}
	return .None
}

keypad_is_key_valid :: proc(key: u8) -> bool {
	return key >= 0 && key < KEY_COUNT
}
