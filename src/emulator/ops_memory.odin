package emulator

import "../shared"

// [ANNN] Set the index register to the value of NNN (addr).
op_set_index :: proc(e: ^Emulator, i: SetIndex) -> shared.Error {
	e.index_register = i.addr
	return .None
}

// [FX1E] Add the value of VX to the index register.
op_add_to_index :: proc(e: ^Emulator, i: AddToIndex) -> shared.Error {
	e.index_register += u16(get_register(&e.registers, register_from_u8(i.vx) or_return))
	return .None
}

// [FX29] Set the index register to the location of the sprite for the character in VX.
op_set_index_to_font_char :: proc(e: ^Emulator, i: SetIndexToFontChar) -> shared.Error {
	e.index_register = u16(get_register(&e.registers, register_from_u8(i.vx) or_return)) * 5
	return .None
}

// [FX33] Store the binary-coded decimal (BCD) representation of VX at the address in the index register.
op_store_bcd :: proc(e: ^Emulator, i: StoreBCD) -> shared.Error {
	value := get_register(&e.registers, register_from_u8(i.vx) or_return)
	write_byte(&e.memory, e.index_register, value / 100) or_return
	write_byte(&e.memory, e.index_register + 1, (value / 10) % 10) or_return
	write_byte(&e.memory, e.index_register + 2, value % 10) or_return
	return .None
}

// [FX55] Store the values of the registers from V0 to VX (including VX) in memory starting at the address in the index register.
op_store_registers :: proc(e: ^Emulator, i: StoreRegisters) -> shared.Error {
	for register in 0 ..= i.vx {
		write_byte(
			&e.memory,
			e.index_register + u16(register),
			get_register(&e.registers, register_from_u8(u8(register)) or_return),
		) or_return
	}
	return .None
}

// [FX65] Load the values of the registers from V0 to VX (including VX) into memory starting at the address in the index register.
op_load_registers :: proc(e: ^Emulator, i: LoadRegisters) -> shared.Error {
	for register in 0 ..= i.vx {
		set_register(
			&e.registers,
			register_from_u8(u8(register)) or_return,
			read_byte(&e.memory, e.index_register + u16(register)) or_return,
		)
	}
	return .None
}
