package chip8

Opcode :: distinct u16

opcode_category :: proc(op: Opcode) -> u8 {
	return u8((u16(op) & 0xF000) >> 12)
}

opcode_nnn :: proc(op: Opcode) -> Address {
	return Address(u16(op) & 0x0FFF)
}

opcode_kk :: proc(op: Opcode) -> u8 {
	return u8(u16(op) & 0x00FF)
}

opcode_x :: proc(op: Opcode) -> u8 {
	return u8((u16(op) & 0x0F00) >> 8)
}

opcode_y :: proc(op: Opcode) -> u8 {
	return u8((u16(op) & 0x00F0) >> 4)
}

opcode_n :: proc(op: Opcode) -> u8 {
	return u8(u16(op) & 0x000F)
}

opcode_high_byte :: proc(op: Opcode) -> u8 {
	return u8((u16(op) & 0xFF00) >> 8)
}

opcode_low_byte :: proc(op: Opcode) -> u8 {
	return u8(u16(op) & 0x00FF)
}
