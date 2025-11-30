package emulator

import "../shared"

Emulator :: struct {
	program_counter: u16,
	index_register:  u16,
	display:         Display,
	memory:          Memory,
	stack:           Stack,
	registers:       Registers,
	delay_timer:     Timer,
	sound_timer:     Timer,
	keypad:          Keypad,
}

create :: proc() -> (emulator: ^Emulator, error: shared.Error) {
	emulator = new(Emulator)
	emulator.program_counter = shared.MEMORY_ROM_START_ADDRESS
	init_display(&emulator.display)
	init_memory(&emulator.memory)
	init_stack(&emulator.stack)
	init_registers(&emulator.registers)
	init_timer(&emulator.delay_timer)
	init_timer(&emulator.sound_timer)
	init_keypad(&emulator.keypad)

	for b, i in shared.FONTSET {
		write_byte(&emulator.memory, shared.MEMORY_FONT_START_ADDRESS + u16(i), b) or_return
	}

	return emulator, .None
}

destroy :: proc(emulator: ^Emulator) -> shared.Error {
	free(emulator)
	return .None
}

load_rom :: proc(emulator: ^Emulator, data: []byte) -> (error: shared.Error) {
	for i in 0 ..< len(data) {
		write_byte(&emulator.memory, shared.MEMORY_ROM_START_ADDRESS + u16(i), data[i]) or_return
	}
	return .None
}

cycle :: proc(emulator: ^Emulator) -> shared.Error {
	raw_instruction := fetch_instruction(emulator) or_return
	instruction := decode_instruction(raw_instruction) or_return
	execute_instruction(emulator, instruction) or_return
	return .None
}

update_timers :: proc(emulator: ^Emulator) {
	update_timer(&emulator.delay_timer)
	update_timer(&emulator.sound_timer)
}

get_display_buffer :: proc(emulator: ^Emulator) -> []bool {
	return emulator.display.data[:]
}

set_key_state :: proc(emulator: ^Emulator, key: shared.Key, pressed: bool) -> shared.Error {
	set_pressed(&emulator.keypad, key, pressed)
	return .None
}

@(private)
fetch_instruction :: proc(emulator: ^Emulator) -> (instruction: u16, error: shared.Error) {
	instruction = read_word(&emulator.memory, emulator.program_counter) or_return
	emulator.program_counter += 2
	return instruction, .None
}

@(private)
execute_instruction :: proc(emulator: ^Emulator, instruction: Instruction) -> shared.Error {
	switch i in instruction {
	case Null:
	// Flow Control
	case Jump:
		op_jump(emulator, i) or_return
	case JumpWithOffset:
		op_jump_with_offset(emulator, i) or_return
	case CallSubroutine:
		op_call_subroutine(emulator, i) or_return
	case ReturnFromSubroutine:
		op_return_from_subroutine(emulator, i) or_return

	// Conditional Skips
	case SkipIfEqualValue:
		op_skip_if_equal_value(emulator, i) or_return
	case SkipIfNotEqualValue:
		op_skip_if_not_equal_value(emulator, i) or_return
	case SkipIfEqualRegister:
		op_skip_if_equal_register(emulator, i) or_return
	case SkipIfNotEqualRegister:
		op_skip_if_not_equal_register(emulator, i) or_return
	case SkipIfKeyPressed:
		op_skip_if_key_pressed(emulator, i) or_return
	case SkipIfKeyNotPressed:
		op_skip_if_key_not_pressed(emulator, i) or_return

	// Register Operations
	case SetRegisterValue:
		op_set_register_value(emulator, i) or_return
	case SetRegisterRegister:
		op_set_register_register(emulator, i) or_return
	case AddValue:
		op_add_value(emulator, i) or_return
	case AddRegister:
		op_add_register(emulator, i) or_return
	case SubtractRegister:
		op_subtract_register(emulator, i) or_return
	case SubtractRegisterReversed:
		op_subtract_register_reversed(emulator, i) or_return

	// Bitwise Operations
	case OrRegister:
		op_or_register(emulator, i) or_return
	case AndRegister:
		op_and_register(emulator, i) or_return
	case XorRegister:
		op_xor_register(emulator, i) or_return
	case ShiftRight:
		op_shift_right(emulator, i) or_return
	case ShiftLeft:
		op_shift_left(emulator, i) or_return

	// Memory & Index
	case SetIndex:
		op_set_index(emulator, i) or_return
	case AddToIndex:
		op_add_to_index(emulator, i) or_return
	case SetIndexToFontChar:
		op_set_index_to_font_char(emulator, i) or_return
	case StoreBCD:
		op_store_bcd(emulator, i) or_return
	case StoreRegisters:
		op_store_registers(emulator, i) or_return
	case LoadRegisters:
		op_load_registers(emulator, i) or_return

	// Graphics & Display
	case ClearDisplay:
		op_clear_display(emulator, i) or_return
	case DrawSprite:
		op_draw_sprite(emulator, i) or_return

	// System & Timers
	case SetDelayTimer:
		op_set_delay_timer(emulator, i) or_return
	case SetSoundTimer:
		op_set_sound_timer(emulator, i) or_return
	case ReadDelayTimer:
		op_read_delay_timer(emulator, i) or_return
	case WaitForKey:
		op_wait_for_key(emulator, i) or_return
	case Random:
		op_random(emulator, i) or_return
	}

	return .None
}
