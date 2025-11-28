package chip8

Registers :: struct {
	registers:   [16]u8,
	index:       Address,
	delay_timer: u8,
	sound_timer: u8,
}

reg_init :: proc(r: ^Registers) {
	assert(r != nil)
	r^ = Registers{}
}

reg_get :: proc(r: ^Registers, index: u8) -> u8 {
	assert(r != nil)
	return r.registers[index]
}

reg_set :: proc(r: ^Registers, index: u8, value: u8) {
	assert(r != nil)
	r.registers[index] = value
}

reg_get_index :: proc(r: ^Registers) -> Address {
	assert(r != nil)
	return r.index
}

reg_set_index :: proc(r: ^Registers, value: Address) {
	assert(r != nil)
	r.index = value
}

reg_get_dt :: proc(r: ^Registers) -> u8 {
	assert(r != nil)
	return r.delay_timer
}

reg_set_dt :: proc(r: ^Registers, value: u8) {
	assert(r != nil)
	r.delay_timer = value
}

reg_get_st :: proc(r: ^Registers) -> u8 {
	assert(r != nil)
	return r.sound_timer
}

reg_set_st :: proc(r: ^Registers, value: u8) {
	assert(r != nil)
	r.sound_timer = value
}
