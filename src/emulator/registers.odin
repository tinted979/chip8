package emulator

import "../shared"

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
	data: [shared.REGISTERS_SIZE]u8,
}

init_registers :: proc(r: ^Registers) {
	r.data = {}
}

get_register :: proc(r: ^Registers, register: Register) -> u8 {
	return r.data[register]
}

set_register :: proc(r: ^Registers, register: Register, value: u8) {
	r.data[register] = value
}

set_flag_register :: proc(r: ^Registers, value: u8) {
	r.data[Register.VF] = value
}

register_to_u8 :: proc(r: Register) -> u8 {
	return u8(r)
}

register_from_u8 :: proc(value: u8) -> (Register, shared.Error) {
	if value >= shared.REGISTERS_SIZE {
		return {}, .InvalidRegisterValue
	}
	return Register(value), .None
}
