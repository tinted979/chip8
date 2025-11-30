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
	expect(stack.pointer < STACK_SIZE, .StackOverflow) or_return
	stack.data[stack.pointer] = value
	stack.pointer += 1
	return error_none()
}

stack_pop :: proc(stack: ^Stack) -> (result: PC, error: Error) {
	assert(stack != nil)
	expect(stack.pointer > 0, .StackUnderflow) or_return
	stack.pointer -= 1
	return stack.data[stack.pointer], error_none()
}
