package chip8

REGISTER_COUNT :: 16

Registers :: struct {
	dt:        u8,
	st:        u8,
	index:     Address,
	registers: [REGISTER_COUNT]u8,
}

registers_init :: proc(r: ^Registers) {
	assert(r != nil)
	r^ = Registers{}
}

registers_get :: proc(r: ^Registers, index: u8) -> u8 {
	assert(r != nil)
	if index >= REGISTER_COUNT do return 0
	return r.registers[index]
}

registers_set :: proc(r: ^Registers, index: u8, value: u8) {
	assert(r != nil)
	if index >= REGISTER_COUNT do return
	r.registers[index] = value
}

registers_get_index :: proc(r: ^Registers) -> Address {
	assert(r != nil)
	return r.index
}

registers_set_index :: proc(r: ^Registers, value: Address) {
	assert(r != nil)
	r.index = value
}

registers_get_dt :: proc(r: ^Registers) -> u8 {
	assert(r != nil)
	return r.dt
}

registers_set_dt :: proc(r: ^Registers, value: u8) {
	assert(r != nil)
	r.dt = value
}

registers_get_st :: proc(r: ^Registers) -> u8 {
	assert(r != nil)
	return r.st
}

registers_set_st :: proc(r: ^Registers, value: u8) {
	assert(r != nil)
	r.st = value
}
