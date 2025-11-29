package chip8

REGISTER_COUNT :: 16

Registers :: struct {
	dt:        u8,
	st:        u8,
	index:     Address,
	registers: [REGISTER_COUNT]u8,
}

registers_init :: proc(r: ^Registers) -> Error {
	assert(r != nil)
	r^ = Registers{}
	return .None
}

registers_get :: proc(r: ^Registers, index: u8) -> (u8, Error) {
	assert(r != nil)
	if index >= REGISTER_COUNT do return 0, .InvalidRegister
	return r.registers[index], .None
}

registers_set :: proc(r: ^Registers, index: u8, value: u8) -> Error {
	assert(r != nil)
	if index >= REGISTER_COUNT do return .InvalidRegister
	r.registers[index] = value
	return .None
}

registers_get_index :: proc(r: ^Registers) -> (Address, Error) {
	assert(r != nil)
	return r.index, .None
}

registers_set_index :: proc(r: ^Registers, value: Address) -> Error {
	assert(r != nil)
	r.index = value
	return .None
}

registers_get_dt :: proc(r: ^Registers) -> (u8, Error) {
	assert(r != nil)
	return r.dt, .None
}

registers_set_dt :: proc(r: ^Registers, value: u8) -> Error {
	assert(r != nil)
	r.dt = value
	return .None
}

registers_get_st :: proc(r: ^Registers) -> (u8, Error) {
	assert(r != nil)
	return r.st, .None
}

registers_set_st :: proc(r: ^Registers, value: u8) -> Error {
	assert(r != nil)
	r.st = value
	return .None
}
