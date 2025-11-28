package chip8

REGISTER_COUNT :: 16

Registers :: struct {
	dt:        u8,
	st:        u8,
	index:     Address,
	registers: [REGISTER_COUNT]u8,
}

reg_init :: proc(r: ^Registers) {
	assert(r != nil)
	r^ = Registers{}
}

reg_get :: proc(r: ^Registers, index: u8) -> u8 {
	assert(r != nil)
	if index >= REGISTER_COUNT do return 0
	return r.registers[index]
}

reg_set :: proc(r: ^Registers, index: u8, value: u8) {
	assert(r != nil)
	if index >= REGISTER_COUNT do return
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
	return r.dt
}

reg_set_dt :: proc(r: ^Registers, value: u8) {
	assert(r != nil)
	r.dt = value
}

reg_get_st :: proc(r: ^Registers) -> u8 {
	assert(r != nil)
	return r.st
}

reg_set_st :: proc(r: ^Registers, value: u8) {
	assert(r != nil)
	r.st = value
}
