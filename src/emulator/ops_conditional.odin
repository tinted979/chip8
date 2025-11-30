package emulator

import "../shared"

// [3XKK] Skip next instruction if VX equals KK.
op_skip_if_equal_value :: proc(e: ^Emulator, i: SkipIfEqualValue) -> shared.Error {
	if get_register(&e.registers, register_from_u8(i.vx) or_return) == i.value {
		e.program_counter += 2
	}
	return .None
}

// [4XKK] Skip next instruction if VX does not equal KK.
op_skip_if_not_equal_value :: proc(e: ^Emulator, i: SkipIfNotEqualValue) -> shared.Error {
	if get_register(&e.registers, register_from_u8(i.vx) or_return) != i.value {
		e.program_counter += 2
	}
	return .None
}

// [5XY0] Skip next instruction if VX equals VY.
op_skip_if_equal_register :: proc(e: ^Emulator, i: SkipIfEqualRegister) -> shared.Error {
	if get_register(&e.registers, register_from_u8(i.vx) or_return) ==
	   get_register(&e.registers, register_from_u8(i.vy) or_return) {
		e.program_counter += 2
	}
	return .None
}

// [9XY0] Skip next instruction if VX does not equal VY.
op_skip_if_not_equal_register :: proc(e: ^Emulator, i: SkipIfNotEqualRegister) -> shared.Error {
	if get_register(&e.registers, register_from_u8(i.vx) or_return) !=
	   get_register(&e.registers, register_from_u8(i.vy) or_return) {
		e.program_counter += 2
	}
	return .None
}

// [EX9E] Skip next instruction if key with the value of VX is pressed.
op_skip_if_key_pressed :: proc(e: ^Emulator, i: SkipIfKeyPressed) -> shared.Error {
	if is_pressed(&e.keypad, shared.key_from_u8(i.vx) or_return) {
		e.program_counter += 2
	}
	return .None
}

// [EXA1] Skip next instruction if key with the value of VX is not pressed.
op_skip_if_key_not_pressed :: proc(e: ^Emulator, i: SkipIfKeyNotPressed) -> shared.Error {
	if !is_pressed(&e.keypad, shared.key_from_u8(i.vx) or_return) {
		e.program_counter += 2
	}
	return .None
}
