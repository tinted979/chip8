package chip8

Opcode :: struct {
	category:  u8,
	nnn:       Address,
	kk:        u8,
	x:         Register,
	y:         Register,
	n:         u8,
	high_byte: u8,
	low_byte:  u8,
}

opcode_parse :: proc(raw_opcode: u16) -> Opcode {
	return Opcode {
		category = opcode_category(raw_opcode),
		nnn = opcode_nnn(raw_opcode),
		kk = opcode_kk(raw_opcode),
		x = opcode_x(raw_opcode),
		y = opcode_y(raw_opcode),
		n = opcode_n(raw_opcode),
		high_byte = opcode_high_byte(raw_opcode),
		low_byte = opcode_low_byte(raw_opcode),
	}
}

@(private)
opcode_category :: proc(op: u16) -> u8 {
	return u8((op & 0xF000) >> 12)
}

@(private)
opcode_nnn :: proc(op: u16) -> Address {
	return Address(op & 0x0FFF)
}

@(private)
opcode_kk :: proc(op: u16) -> u8 {
	return u8(op & 0x00FF)
}

@(private)
opcode_x :: proc(op: u16) -> Register {
	return Register(u8((op & 0x0F00) >> 8))
}

@(private)
opcode_y :: proc(op: u16) -> Register {
	return Register(u8((op & 0x00F0) >> 4))
}

@(private)
opcode_n :: proc(op: u16) -> u8 {
	return u8(op & 0x000F)
}

@(private)
opcode_high_byte :: proc(op: u16) -> u8 {
	return u8((op & 0xFF00) >> 8)
}

@(private)
opcode_low_byte :: proc(op: u16) -> u8 {
	return u8(op & 0x00FF)
}
