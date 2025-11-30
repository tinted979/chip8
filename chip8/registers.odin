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
	VF = 0xF,
}

Registers :: struct {
	delay_timer:    Timer,
	sound_timer:    Timer,
	index_register: Address,
	registers:      [REGISTER_COUNT]u8,
}

registers_init :: proc(registers: ^Registers) {
	assert(registers != nil)
	registers^ = Registers{}
	timer_init(&registers.delay_timer)
	timer_init(&registers.sound_timer)
}

registers_get :: proc(registers: ^Registers, register: Register) -> u8 {
	assert(registers != nil)
	return registers.registers[register]
}

registers_set :: proc(registers: ^Registers, register: Register, value: u8) {
	assert(registers != nil)
	registers.registers[register] = value
}

registers_get_index :: proc(registers: ^Registers) -> Address {
	assert(registers != nil)
	return registers.index_register
}

registers_set_index :: proc(registers: ^Registers, value: Address) -> Error {
	assert(registers != nil)
	address_is_valid(value) or_return
	registers.index_register = value
	return .None
}

register_to_u8 :: proc(register: Register) -> u8 {
	return u8(register)
}

register_from_u8 :: proc(value: u8) -> (Register, Error) {
	if value >= REGISTER_COUNT do return {}, .InvalidRegister
	return Register(value), .None
}
