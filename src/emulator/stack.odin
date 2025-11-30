package emulator

import "../shared"

Stack :: struct {
	pointer: u8,
	data:    [shared.STACK_SIZE]u16,
}

init_stack :: proc(stack: ^Stack) {
	stack^ = {}
}

push_stack :: proc(stack: ^Stack, value: u16) -> shared.Error {
	if stack.pointer >= shared.STACK_SIZE {
		return .StackOverflow
	}
	stack.data[stack.pointer] = value
	stack.pointer += 1
	return .None
}

pop_stack :: proc(stack: ^Stack) -> (value: u16, error: shared.Error) {
	if stack.pointer == 0 {
		return 0, .StackUnderflow
	}
	stack.pointer -= 1
	return stack.data[stack.pointer], .None
}
