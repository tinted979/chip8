package chip8

Memory :: struct {
	data: [MEMORY_SIZE]u8,
}

memory_init :: proc(memory: ^Memory) {
	assert(memory != nil)
	memory^ = Memory{}
}

memory_get_byte :: proc(memory: ^Memory, address: Address) -> (result: u8, error: Error) {
	assert(memory != nil)
	address_is_valid(address) or_return
	return memory.data[address], .None
}

memory_set_byte :: proc(memory: ^Memory, address: Address, value: u8) -> Error {
	assert(memory != nil)
	address_is_valid(address) or_return
	memory.data[address] = value
	return .None
}

memory_get_word :: proc(memory: ^Memory, address: Address) -> (result: u16, error: Error) {
	assert(memory != nil)
	address_is_valid(address) or_return
	address_is_valid(address + 1) or_return
	high, low := u16(memory.data[address]) << 8, u16(memory.data[address + 1])
	return high | low, .None
}

memory_set_word :: proc(memory: ^Memory, address: Address, value: u16) -> Error {
	assert(memory != nil)
	address_is_valid(address) or_return
	address_is_valid(address + 1) or_return
	high, low := u8(value >> 8), u8(value)
	memory.data[address] = high
	memory.data[address + 1] = low
	return .None
}
