package chip8

Memory :: struct {
	data: [MEMORY_SIZE]u8,
}

memory_init :: proc(m: ^Memory) -> Error {
	assert(m != nil)
	m^ = Memory{}
	return .None
}

memory_get_byte :: proc(m: ^Memory, address: Address) -> (u8, Error) {
	assert(m != nil)
	if !address_is_valid(address) do return 0, .InvalidAddress
	return m.data[address], .None
}

memory_set_byte :: proc(m: ^Memory, address: Address, value: u8) -> Error {
	assert(m != nil)
	if !address_is_valid(address) do return .InvalidAddress
	m.data[address] = value
	return .None
}

memory_get_word :: proc(m: ^Memory, address: Address) -> (u16, Error) {
	assert(m != nil)
	if !address_is_valid(address) || !address_is_valid(address + 1) do return 0, .InvalidAddress
	high, low := u16(m.data[address]) << 8, u16(m.data[address + 1])
	return high | low, .None
}

memory_set_word :: proc(m: ^Memory, address: Address, value: u16) -> Error {
	assert(m != nil)
	if !address_is_valid(address) || !address_is_valid(address + 1) do return .InvalidAddress
	high, low := u8(value >> 8), u8(value)
	m.data[address] = high
	m.data[address + 1] = low
	return .None
}
