package chip8

Address :: distinct u16

address_is_valid :: proc(address: Address) -> Error {
	return address < MEMORY_SIZE ? .None : .InvalidAddress
}
