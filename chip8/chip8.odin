package chip8

import "core:os"

Chip8 :: struct {
	program_counter: PC,
	keypad:          Keypad,
	stack:           Stack,
	memory:          Memory,
	registers:       Registers,
	display:         Display,
	rom_loaded:      bool,
}

cycle :: proc(c: ^Chip8) -> Error {
	assert(c != nil)
	expect(c.rom_loaded, .RomNotLoaded) or_return

	raw_opcode := memory_get_word(&c.memory, pc_to_address(c.program_counter)) or_return
	opcode := opcode_parse(raw_opcode)

	pc_advance(&c.program_counter)
	INSTRUCTIONS[opcode.category](c, opcode) or_return

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
	display_init(&c.display)
}

load_rom :: proc(c: ^Chip8, path: string) -> Error {
	assert(c != nil)
	reset(c)

	data, ok := os.read_entire_file(path)
	expect(ok, .RomLoadFailed) or_return
	defer delete(data)

	expect(len(data) <= int(MEMORY_SIZE - PROGRAM_START_ADDRESS), .RomTooLarge) or_return
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
