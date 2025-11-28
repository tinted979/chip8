package chip8

Memory :: struct {
	data: [MEMORY_SIZE]u8,
}

mem_init :: proc(m: ^Memory) {
	assert(m != nil)
	m^ = Memory{}
}

mem_get_byte :: proc(m: ^Memory, a: Address) -> (u8, bool) {
	assert(m != nil)
	if !address_is_valid(a) do return 0, false
	return m.data[a], true
}

mem_get_word :: proc(m: ^Memory, a: Address) -> (u16, bool) {
	assert(m != nil)
	if !address_is_valid(a) || !address_is_valid(a + 1) do return 0, false
	high := u16(m.data[a]) << 8
	low := u16(m.data[a + 1])
	return high | low, true
}

mem_set_byte :: proc(m: ^Memory, a: Address, v: u8) -> bool {
	assert(m != nil)
	if !address_is_valid(a) do return false
	m.data[a] = v
	return true
}

mem_set_word :: proc(m: ^Memory, a: Address, v: u16) -> bool {
	assert(m != nil)
	if !address_is_valid(a) || !address_is_valid(a + 1) do return false
	m.data[a] = u8(v >> 8)
	m.data[a + 1] = u8(v)
	return true
}
