package chip8

Stack :: struct {
	pointer: u8,
	data:    [STACK_SIZE]PC,
}

stack_init :: proc(stack: ^Stack) {
	assert(stack != nil)
	stack^ = Stack{}
}

stack_push :: proc(stack: ^Stack, value: PC) -> Error {
	assert(stack != nil)
	if is_full(stack) do return .StackOverflow
	stack.data[stack.pointer] = value
	stack.pointer += 1
	return .None
}

stack_pop :: proc(stack: ^Stack) -> (PC, Error) {
	assert(stack != nil)
	if is_empty(stack) do return 0, .StackUnderflow
	stack.pointer -= 1
	return stack.data[stack.pointer], .None
}

@(private)
is_empty :: proc(stack: ^Stack) -> bool {
	assert(stack != nil)
	return stack.pointer <= 0
}

@(private)
is_full :: proc(stack: ^Stack) -> bool {
	assert(stack != nil)
	return stack.pointer >= STACK_SIZE
}
