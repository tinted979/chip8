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

create :: proc() -> ^Chip8 {
	c := new(Chip8)
	reset(c)
	return c
}

destroy :: proc(c: ^Chip8) {
	free(c)
}

cycle :: proc(c: ^Chip8) {
	assert(c != nil)
	if !c.rom_loaded do return
	raw_opcode, ok := memory_get_word(&c.memory, program_counter_to_address(c.pc))
	if !ok do return
	opcode := Opcode(raw_opcode)
	program_counter_advance(&c.pc)
	INSTRUCTIONS[opcode_category(opcode)](c, opcode)
}

update_timers :: proc(c: ^Chip8) {
	assert(c != nil)
	dt := registers_get_dt(&c.registers)
	st := registers_get_st(&c.registers)
	if dt > 0 do registers_set_dt(&c.registers, dt - 1)
	if st > 0 do registers_set_st(&c.registers, st - 1)
}

reset :: proc(c: ^Chip8) {
	assert(c != nil)
	c^ = Chip8{}
	program_counter_set(&c.pc, program_counter_from_address(PROGRAM_START_ADDRESS))
	stack_init(&c.stack)
	registers_init(&c.registers)
	memory_init(&c.memory)
	keypad_init(&c.keypad)
	if !load_fontset(c) do return
}

load_rom :: proc(c: ^Chip8, path: string) -> bool {
	assert(c != nil)
	reset(c)
	data, ok := os.read_entire_file(path)
	if !ok do return false
	defer delete(data)
	for b, i in data {
		address := PROGRAM_START_ADDRESS + Address(i)
		if !memory_set_byte(&c.memory, address, b) do return false
	}
	c.rom_loaded = true
	return true
}

load_fontset :: proc(c: ^Chip8) -> bool {
	assert(c != nil)
	for b, i in FONTSET {
		address := FONT_START_ADDRESS + Address(i)
		if !memory_set_byte(&c.memory, address, b) do return false
	}
	return true
}
