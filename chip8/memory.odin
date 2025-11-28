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
	return m.data[u16(a)], true
}

mem_get_word :: proc(m: ^Memory, a: Address) -> (u16, bool) {
	assert(m != nil)
	if !address_is_valid(a) do return 0, false
	high := u16(m.data[u16(a)])
	low := u16(m.data[u16(a) + 1])
	return (high << 8) | low, true
}

mem_set_byte :: proc(m: ^Memory, a: Address, v: u8) -> bool {
	assert(m != nil)
	if !address_is_valid(a) do return false
	m.data[u16(a)] = v
	return true
}

mem_set_word :: proc(m: ^Memory, a: Address, v: u16) -> bool {
	assert(m != nil)
	if !address_is_valid(a) do return false
	m.data[u16(a)] = u8(v)
	m.data[u16(a) + 1] = u8(v >> 8)
	return true
}
