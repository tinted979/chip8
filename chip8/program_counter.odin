package chip8

ProgramCounter :: distinct u16

pc_get :: proc(pc: ^ProgramCounter) -> u16 {
	return u16(pc^)
}

pc_set :: proc(pc: ^ProgramCounter, value: u16) {
	pc^ = ProgramCounter(value)
}

pc_jump :: proc(pc: ^ProgramCounter, value: u16) {
	pc^ = ProgramCounter(value)
}

pc_skip :: proc(pc: ^ProgramCounter, value: u16) {
	pc^ += ProgramCounter(value)
}

pc_advance :: proc(pc: ^ProgramCounter) {
	pc^ += ProgramCounter(2)
}

pc_return :: proc(pc: ^ProgramCounter) {
	pc^ -= ProgramCounter(2)
}
