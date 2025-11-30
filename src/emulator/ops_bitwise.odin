package emulator

import "../shared"

// [8XY1] Bitwise OR VX with VY.
op_or_register :: proc(e: ^Emulator, i: OrRegister) -> shared.Error {
	set_register(
		&e.registers,
		register_from_u8(i.vx) or_return,
		get_register(&e.registers, register_from_u8(i.vx) or_return) |
		get_register(&e.registers, register_from_u8(i.vy) or_return),
	)
	return .None
}

// [8XY2] Bitwise AND VX with VY.
op_and_register :: proc(e: ^Emulator, i: AndRegister) -> shared.Error {
	set_register(
		&e.registers,
		register_from_u8(i.vx) or_return,
		get_register(&e.registers, register_from_u8(i.vx) or_return) &
		get_register(&e.registers, register_from_u8(i.vy) or_return),
	)
	return .None
}

// [8XY3] Bitwise XOR VX with VY.
op_xor_register :: proc(e: ^Emulator, i: XorRegister) -> shared.Error {
	set_register(
		&e.registers,
		register_from_u8(i.vx) or_return,
		get_register(&e.registers, register_from_u8(i.vx) or_return) ~
		get_register(&e.registers, register_from_u8(i.vy) or_return),
	)
	return .None
}

// [8XY6] Shift VX right by one.
op_shift_right :: proc(e: ^Emulator, i: ShiftRight) -> shared.Error {
	set_register(
		&e.registers,
		register_from_u8(i.vx) or_return,
		get_register(&e.registers, register_from_u8(i.vx) or_return) >> 1,
	)
	return .None
}

// [8XYE] Shift VX left by one.
op_shift_left :: proc(e: ^Emulator, i: ShiftLeft) -> shared.Error {
	set_register(
		&e.registers,
		register_from_u8(i.vx) or_return,
		get_register(&e.registers, register_from_u8(i.vx) or_return) << 1,
	)
	return .None
}
