package chip8

Memory :: struct {
	data: [MEMORY_SIZE]u8,
}

memory_init :: proc(m: ^Memory) -> Error {
	assert(m != nil)
	m^ = Memory{}
	return .None
}

memory_get_byte :: proc(m: ^Memory, address: Address) -> (result: u8, error: Error) {
	assert(m != nil)
	address_is_valid(address) or_return
	return m.data[address], .None
}

memory_set_byte :: proc(m: ^Memory, address: Address, value: u8) -> Error {
	assert(m != nil)
	address_is_valid(address) or_return
	m.data[address] = value
	return .None
}

memory_get_word :: proc(m: ^Memory, address: Address) -> (result: u16, error: Error) {
	assert(m != nil)
	address_is_valid(address) or_return
	address_is_valid(address + 1) or_return
	high, low := u16(m.data[address]) << 8, u16(m.data[address + 1])
	return high | low, .None
}

memory_set_word :: proc(m: ^Memory, address: Address, value: u16) -> Error {
	assert(m != nil)
	address_is_valid(address) or_return
	address_is_valid(address + 1) or_return
	high, low := u8(value >> 8), u8(value)
	m.data[address] = high
	m.data[address + 1] = low
	return .None
}
