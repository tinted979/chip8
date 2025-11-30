package chip8

PC :: distinct u16

pc_set :: proc(program_counter: ^PC, value: PC) {
	assert(program_counter != nil)
	program_counter^ = value
}

pc_skip :: proc(program_counter: ^PC, value: PC) {
	assert(program_counter != nil)
	program_counter^ += value
}

pc_advance :: proc(program_counter: ^PC) {
	assert(program_counter != nil)
	program_counter^ += 2
}

pc_return :: proc(program_counter: ^PC) {
	assert(program_counter != nil)
	program_counter^ -= 2
}

pc_to_address :: proc(program_counter: PC) -> Address {
	return Address(program_counter)
}

pc_from_address :: proc(address: Address) -> PC {
	return PC(address)
}
