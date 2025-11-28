package chip8

ProgramCounter :: distinct u16

pc_set :: proc(pc: ^ProgramCounter, value: ProgramCounter) {
	assert(pc != nil)
	pc^ = value
}

pc_skip :: proc(pc: ^ProgramCounter, value: ProgramCounter) {
	assert(pc != nil)
	pc^ += value
}

pc_advance :: proc(pc: ^ProgramCounter) {
	assert(pc != nil)
	pc^ += ProgramCounter(2)
}

pc_return :: proc(pc: ^ProgramCounter) {
	assert(pc != nil)
	pc^ -= ProgramCounter(2)
}

pc_to_address :: proc(pc: ProgramCounter) -> Address {
	return Address(pc)
}

address_to_pc :: proc(a: Address) -> ProgramCounter {
	return ProgramCounter(a)
}
