package chip8

REGISTER_COUNT :: 16

Register :: enum u8 {
	V0 = 0x0,
	V1 = 0x1,
	V2 = 0x2,
	V3 = 0x3,
	V4 = 0x4,
	V5 = 0x5,
	V6 = 0x6,
	V7 = 0x7,
	V8 = 0x8,
	V9 = 0x9,
	VA = 0xA,
	VB = 0xB,
	VC = 0xC,
	VD = 0xD,
	VE = 0xE,
	VF = 0xF, // Carry flag register
}

register_to_u8 :: proc(register: Register) -> u8 {
	return u8(register)
}

register_is_valid :: proc(register: Register) -> Error {
	return register_to_u8(register) < REGISTER_COUNT ? .None : .InvalidRegister
}

Registers :: struct {
	delay_timer:    u8,
	sound_timer:    u8,
	index_register: Address,
	registers:      [REGISTER_COUNT]u8,
}

registers_init :: proc(r: ^Registers) -> Error {
	assert(r != nil)
	r^ = Registers{}
	return .None
}

registers_get :: proc(r: ^Registers, register: Register) -> (result: u8, error: Error) {
	assert(r != nil)
	register_is_valid(register) or_return
	return r.registers[register], .None
}

registers_set :: proc(r: ^Registers, register: Register, value: u8) -> Error {
	assert(r != nil)
	register_is_valid(register) or_return
	r.registers[register] = value
	return .None
}

registers_get_index_register :: proc(r: ^Registers) -> (Address, Error) {
	assert(r != nil)
	return r.index_register, .None
}

registers_set_index :: proc(r: ^Registers, value: Address) -> Error {
	assert(r != nil)
	address_is_valid(value) or_return
	r.index_register = value
	return .None
}

registers_get_delay_timer :: proc(r: ^Registers) -> (u8, Error) {
	assert(r != nil)
	return r.delay_timer, .None
}

registers_set_delay_timer :: proc(r: ^Registers, value: u8) -> Error {
	assert(r != nil)
	r.delay_timer = value
	return .None
}

registers_get_sound_timer :: proc(r: ^Registers) -> (u8, Error) {
	assert(r != nil)
	return r.sound_timer, .None
}

registers_set_sound_timer :: proc(r: ^Registers, value: u8) -> Error {
	assert(r != nil)
	r.sound_timer = value
	return .None
}
