package chip8

Stack :: struct {
	pointer: u8,
	data:    [STACK_SIZE]ProgramCounter,
}

stack_init :: proc(s: ^Stack) {
	assert(s != nil)
	s^ = Stack{}
}

stack_push :: proc(s: ^Stack, value: ProgramCounter) -> Error {
	assert(s != nil)
	if is_full(s) do return .StackOverflow
	s.data[s.pointer] = value
	s.pointer += 1
	return .None
}

stack_pop :: proc(s: ^Stack) -> (ProgramCounter, Error) {
	assert(s != nil)
	if is_empty(s) do return 0, .StackUnderflow
	s.pointer -= 1
	return s.data[s.pointer], .None
}

@(private)
is_empty :: proc(s: ^Stack) -> bool {
	assert(s != nil)
	return s.pointer <= 0
}

@(private)
is_full :: proc(s: ^Stack) -> bool {
	assert(s != nil)
	return s.pointer >= STACK_SIZE
}
