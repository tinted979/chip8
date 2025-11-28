package chip8

Stack :: struct {
	pointer: u8,
	data:    [STACK_SIZE]ProgramCounter,
}

stack_init :: proc(s: ^Stack) {
	assert(s != nil)
	s^ = Stack{}
}

stack_push :: proc(s: ^Stack, v: ProgramCounter) -> bool {
	assert(s != nil)
	if stack_is_full(s) do return false
	s.data[s.pointer] = v
	s.pointer += 1
	return true
}

stack_pop :: proc(s: ^Stack) -> (ProgramCounter, bool) {
	assert(s != nil)
	if stack_is_empty(s) do return ProgramCounter(0), false
	s.pointer -= 1
	return s.data[s.pointer], true
}

stack_is_empty :: proc(s: ^Stack) -> bool {
	assert(s != nil)
	return s.pointer <= 0
}

stack_is_full :: proc(s: ^Stack) -> bool {
	assert(s != nil)
	return s.pointer >= STACK_SIZE
}
