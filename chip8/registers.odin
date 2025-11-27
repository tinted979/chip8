package chip8

Registers :: struct {
	registers:      [16]u8,
	index_register: u16,
	delay_timer:    u8,
	sound_timer:    u8,
}

reg_init :: proc(r: ^Registers) {
	r^ = Registers{}
}

reg_get :: proc(r: ^Registers, index: u8) -> u8 {
	return r.registers[index]
}

reg_set :: proc(r: ^Registers, index: u8, value: u8) {
	r.registers[index] = value
}

reg_get_index :: proc(r: ^Registers) -> u16 {
	return r.index_register
}

reg_set_index :: proc(r: ^Registers, value: u16) {
	r.index_register = value
}

reg_get_dt :: proc(r: ^Registers) -> u8 {
	return r.delay_timer
}

reg_set_dt :: proc(r: ^Registers, value: u8) {
	r.delay_timer = value
}

reg_get_st :: proc(r: ^Registers) -> u8 {
	return r.sound_timer
}

reg_set_st :: proc(r: ^Registers, value: u8) {
	r.sound_timer = value
}
