package chip8

Memory :: struct {
	data: [MEMORY_SIZE]u8,
}

memory_init :: proc(m: ^Memory) {
	assert(m != nil)
	m^ = Memory{}
}

memory_get_byte :: proc(m: ^Memory, address: Address) -> (u8, bool) {
	assert(m != nil)
	if !address_is_valid(address) do return 0, false
	return m.data[address], true
}

memory_get_word :: proc(m: ^Memory, address: Address) -> (u16, bool) {
	assert(m != nil)
	if !address_is_valid(address) || !address_is_valid(address + 1) do return 0, false
	high, low := u16(m.data[address]) << 8, u16(m.data[address + 1])
	return high | low, true
}

memory_set_byte :: proc(m: ^Memory, address: Address, value: u8) -> bool {
	assert(m != nil)
	if !address_is_valid(address) do return false
	m.data[address] = value
	return true
}

memory_set_word :: proc(m: ^Memory, address: Address, value: u16) -> bool {
	assert(m != nil)
	if !address_is_valid(address) || !address_is_valid(address + 1) do return false
	high, low := u8(value >> 8), u8(value)
	m.data[address] = high
	m.data[address + 1] = low
	return true
}
