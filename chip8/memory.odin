package chip8

MEMORY_SIZE :: 4096

Memory :: struct {
	data: [MEMORY_SIZE]u8,
}

mem_init :: proc(m: ^Memory) {
	m^ = Memory{}
}

mem_get_byte :: proc(m: ^Memory, address: u16) -> u8 {
	return m.data[address]
}

mem_set_byte :: proc(m: ^Memory, address: u16, value: u8) {
	m.data[address] = value
}

mem_get_word :: proc(m: ^Memory, address: u16) -> u16 {
	high := u16(m.data[address])
	low := u16(m.data[address + 1])
	return (high << 8) | low
}

mem_set_word :: proc(m: ^Memory, address: u16, value: u16) {
	m.data[address] = u8(value)
	m.data[address + 1] = u8(value >> 8)
}
