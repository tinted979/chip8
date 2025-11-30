package chip8

import "core:os"

Chip8 :: struct {
	program_counter: PC,
	keypad:          Keypad,
	stack:           Stack,
	memory:          Memory,
	registers:       Registers,
	display:         [DISPLAY_WIDTH * DISPLAY_HEIGHT]u32,
	rom_loaded:      bool,
}

cycle :: proc(c: ^Chip8) -> Error {
	assert(c != nil)

	if !c.rom_loaded do return .RomNotLoaded

	raw_opcode := memory_get_word(&c.memory, pc_to_address(c.program_counter)) or_return
	opcode := Opcode(raw_opcode)

	pc_advance(&c.program_counter)
	INSTRUCTIONS[opcode_category(opcode)](c, opcode) or_return

	return .None
}

update_timers :: proc(c: ^Chip8) {
	assert(c != nil)
	timer_decrement(&c.registers.delay_timer)
	timer_decrement(&c.registers.sound_timer)
}

reset :: proc(c: ^Chip8) {
	assert(c != nil)
	c^ = Chip8{}
	pc_set(&c.program_counter, pc_from_address(PROGRAM_START_ADDRESS))
	stack_init(&c.stack)
	registers_init(&c.registers)
	memory_init(&c.memory)
	keypad_init(&c.keypad)
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
