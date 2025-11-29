package chip8

ProgramCounter :: distinct u16

program_counter_set :: proc(pc: ^ProgramCounter, value: ProgramCounter) {
	assert(pc != nil)
	pc^ = value
}

program_counter_skip :: proc(pc: ^ProgramCounter, value: ProgramCounter) {
	assert(pc != nil)
	pc^ += value
}

program_counter_advance :: proc(pc: ^ProgramCounter) {
	assert(pc != nil)
	pc^ += 2
}

program_counter_return :: proc(pc: ^ProgramCounter) {
	assert(pc != nil)
	pc^ -= 2
}

program_counter_to_address :: proc(pc: ProgramCounter) -> Address {
	return Address(pc)
}

program_counter_from_address :: proc(address: Address) -> ProgramCounter {
	return ProgramCounter(address)
}
