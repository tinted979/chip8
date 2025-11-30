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
	return emulator, .None
}

destroy :: proc(emulator: ^Emulator) -> shared.Error {
	free(emulator)
	return .None
}

load_rom :: proc(data: []byte) -> (error: shared.Error) {
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
	return .None
}
