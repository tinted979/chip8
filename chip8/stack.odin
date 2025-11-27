package chip8

Stack :: struct {
	pointer: u8,
	data:    [STACK_SIZE]u16,
}

stack_init :: proc(s: ^Stack) {
	s^ = Stack{}
}

stack_push :: proc(s: ^Stack, value: u16) -> bool {
	if stack_is_full(s) do return false
	s.data[s.pointer] = value
	s.pointer += 1
	return true
}

stack_pop :: proc(s: ^Stack) -> (u16, bool) {
	if stack_is_empty(s) do return 0, false
	s.pointer -= 1
	return s.data[s.pointer], true
}

stack_is_empty :: proc(s: ^Stack) -> bool {
	return s.pointer <= 0
}

stack_is_full :: proc(s: ^Stack) -> bool {
	return s.pointer >= STACK_SIZE
}
