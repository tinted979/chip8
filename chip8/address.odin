package chip8

Address :: distinct u16

address_is_valid :: proc(address: Address) -> bool {
	return address >= 0 && address < MEMORY_SIZE
}
