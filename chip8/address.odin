package chip8

Address :: distinct u16

address_is_valid :: proc(a: Address) -> bool {
	return a >= 0 && a < MEMORY_SIZE
}
