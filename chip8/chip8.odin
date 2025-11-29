package chip8

import "core:os"

Chip8 :: struct {
	pc:         ProgramCounter,
	keypad:     Keypad,
	stack:      Stack,
	memory:     Memory,
	registers:  Registers,
	display:    [DISPLAY_WIDTH * DISPLAY_HEIGHT]u32,
	rom_loaded: bool,
}

cycle :: proc(c: ^Chip8) -> Error {
	assert(c != nil)

	if !c.rom_loaded do return .RomNotLoaded

	raw_opcode := memory_get_word(&c.memory, program_counter_to_address(c.pc)) or_return
	opcode := Opcode(raw_opcode)

	program_counter_advance(&c.pc)
	INSTRUCTIONS[opcode_category(opcode)](c, opcode) or_return

	return .None
}

update_timers :: proc(c: ^Chip8) -> Error {
	assert(c != nil)
	dt := registers_get_dt(&c.registers) or_return
	st := registers_get_st(&c.registers) or_return
	if dt > 0 do registers_set_dt(&c.registers, dt - 1) or_return
	if st > 0 do registers_set_st(&c.registers, st - 1) or_return
	return .None
}

reset :: proc(c: ^Chip8) -> Error {
	assert(c != nil)
	c^ = Chip8{}
	program_counter_set(&c.pc, program_counter_from_address(PROGRAM_START_ADDRESS))
	stack_init(&c.stack) or_return
	registers_init(&c.registers) or_return
	memory_init(&c.memory) or_return
	keypad_init(&c.keypad) or_return
	load_fontset(c) or_return
	return .None
}

load_rom :: proc(c: ^Chip8, path: string) -> Error {
	assert(c != nil)
	reset(c)

	data, ok := os.read_entire_file(path)
	if !ok do return .RomLoadFailed
	defer delete(data)

	if len(data) > int(MEMORY_SIZE - PROGRAM_START_ADDRESS) do return .RomTooLarge

	for b, i in data {
		address := PROGRAM_START_ADDRESS + Address(i)
		memory_set_byte(&c.memory, address, b) or_return
	}

	c.rom_loaded = true
	return .None
}

load_fontset :: proc(c: ^Chip8) -> Error {
	assert(c != nil)
	for b, i in FONTSET {
		address := FONT_START_ADDRESS + Address(i)
		memory_set_byte(&c.memory, address, b) or_return
	}
	return .None
}
