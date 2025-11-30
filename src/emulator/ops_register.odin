package emulator

import "../shared"

// [6XKK] Set VX to the value of KK.
op_set_register_value :: proc(e: ^Emulator, i: SetRegisterValue) -> shared.Error {
	set_register(&e.registers, register_from_u8(i.vx) or_return, i.value)
	return .None
}

// [8XY0] Set VX to the value of VY.
op_set_register_register :: proc(e: ^Emulator, i: SetRegisterRegister) -> shared.Error {
	set_register(
		&e.registers,
		register_from_u8(i.vx) or_return,
		get_register(&e.registers, register_from_u8(i.vy) or_return),
	)
	return .None
}

// [7XKK] Add the value of KK to VX.
op_add_value :: proc(e: ^Emulator, i: AddValue) -> shared.Error {
	set_register(
		&e.registers,
		register_from_u8(i.vx) or_return,
		get_register(&e.registers, register_from_u8(i.vx) or_return) + i.value,
	)
	return .None
}

// [8XY4] Add the value of VY to VX.
op_add_register :: proc(e: ^Emulator, i: AddRegister) -> shared.Error {
	set_register(
		&e.registers,
		register_from_u8(i.vx) or_return,
		get_register(&e.registers, register_from_u8(i.vx) or_return) +
		get_register(&e.registers, register_from_u8(i.vy) or_return),
	)
	return .None
}

// [8XY5] Subtract the value of VY from VX.
op_subtract_register :: proc(e: ^Emulator, i: SubtractRegister) -> shared.Error {
	set_register(
		&e.registers,
		register_from_u8(i.vx) or_return,
		get_register(&e.registers, register_from_u8(i.vx) or_return) -
		get_register(&e.registers, register_from_u8(i.vy) or_return),
	)
	return .None
}

// [8XY7] Subtract the value of VX from VY.
op_subtract_register_reversed :: proc(e: ^Emulator, i: SubtractRegisterReversed) -> shared.Error {
	set_register(
		&e.registers,
		register_from_u8(i.vx) or_return,
		get_register(&e.registers, register_from_u8(i.vy) or_return) -
		get_register(&e.registers, register_from_u8(i.vx) or_return),
	)
	return .None
}
