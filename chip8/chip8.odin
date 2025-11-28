package chip8

import "core:fmt"
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

	opcode, ok := mem_get_word(&c.memory, pc_to_address(c.pc))
	if !ok do return

	pc_advance(&c.pc)
	INSTRUCTIONS[opcode_category(Opcode(opcode))](c, Opcode(opcode))

	dt := reg_get_dt(&c.registers)
	st := reg_get_st(&c.registers)
	if dt > 0 do reg_set_dt(&c.registers, dt - 1)
	if st > 0 do reg_set_st(&c.registers, st - 1)
}

reset :: proc(c: ^Chip8) {
	assert(c != nil)
	c^ = Chip8{}
	pc_set(&c.pc, address_to_pc(PROGRAM_START_ADDRESS))

	stack_init(&c.stack)
	reg_init(&c.registers)
	mem_init(&c.memory)
	kp_init(&c.keypad)

	for b, i in FONTSET {
		address := FONT_START_ADDRESS + Address(i)
		if !mem_set_byte(&c.memory, address, b) do continue
	}
}

load_rom :: proc(c: ^Chip8, path: string) -> bool {
	assert(c != nil)
	reset(c)

	data, success := os.read_entire_file(path)
	if !success do return false
	defer delete(data)

	for b, i in data {
		address := PROGRAM_START_ADDRESS + Address(i)
		if !mem_set_byte(&c.memory, address, b) do continue
	}

	c.rom_loaded = true
	return true
}
