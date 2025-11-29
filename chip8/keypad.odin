package chip8

Keypad :: struct {
	keys: [KEY_COUNT]bool,
}

keypad_init :: proc(k: ^Keypad) {
	assert(k != nil)
	keypad_set_all_pressed(k, false)
}

keypad_get_pressed :: proc(k: ^Keypad, key: u8) -> bool {
	assert(k != nil)
	if !keypad_is_key_valid(key) do return false
	return k.keys[key]
}

keypad_set_pressed :: proc(k: ^Keypad, key: u8, pressed: bool) {
	assert(k != nil)
	if !keypad_is_key_valid(key) do return
	k.keys[key] = pressed
}

keypad_set_all_pressed :: proc(k: ^Keypad, pressed: bool) {
	assert(k != nil)
	for &key in k.keys {
		key = pressed
	}
}

keypad_is_key_valid :: proc(key: u8) -> bool {
	return key >= 0 && key < KEY_COUNT
}
