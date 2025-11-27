package chip8

Opcode :: distinct u16

op_nnn :: proc(op: Opcode) -> u16 {
	return u16(u16(op) & 0x0FFF)
}

op_kk :: proc(op: Opcode) -> u8 {
	return u8(u16(op) & 0x00FF)
}

op_x :: proc(op: Opcode) -> u8 {
	return u8((u16(op) & 0x0F00) >> 8)
}

op_y :: proc(op: Opcode) -> u8 {
	return u8((u16(op) & 0x00F0) >> 4)
}

op_n :: proc(op: Opcode) -> u8 {
	return u8(u16(op) & 0x000F)
}

op_major_byte :: proc(op: Opcode) -> u8 {
	return u8((u16(op) & 0xFF00) >> 8)
}

op_minor_byte :: proc(op: Opcode) -> u8 {
	return u8(u16(op) & 0x00FF)
}

op_major :: proc(op: Opcode) -> u8 {
	return u8((u16(op) & 0xF000) >> 12)
}

op_minor :: proc(op: Opcode) -> u8 {
	return u8(u16(op) & 0x000F)
}
