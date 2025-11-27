package chip8

import "core:fmt"
import "core:os"

Chip8 :: struct {
	keypad:     Keypad,
	stack:      Stack,
	memory:     Memory,
	registers:  Registers,
	pc:         ProgramCounter,
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
	if !c.rom_loaded do return

	opcode := Opcode(mem_get_word(&c.memory, pc_get(&c.pc)))

	pc_advance(&c.pc)
	INSTRUCTIONS[op_major(opcode)](c, opcode)

	dt := reg_get_dt(&c.registers)
	st := reg_get_st(&c.registers)
	if dt > 0 do reg_set_dt(&c.registers, dt - 1)
	if st > 0 do reg_set_st(&c.registers, st - 1)
}

reset :: proc(c: ^Chip8) {
	c^ = Chip8{}
	pc_set(&c.pc, PROGRAM_START)
	mem_init(&c.memory)
	stack_init(&c.stack)
	kp_init(&c.keypad)
	reg_init(&c.registers)

	for b, i in FONTSET {
		mem_set_byte(&c.memory, u16(FONTSET_START + i), b)
	}
}

load_rom :: proc(c: ^Chip8, path: string) -> bool {
	reset(c)

	data, success := os.read_entire_file(path)
	if !success {
		fmt.println("Failed to load ROM: ", path)
		return false
	}
	defer delete(data)

	for b, i in data {
		mem_set_byte(&c.memory, u16(PROGRAM_START + i), b)
	}

	c.rom_loaded = true
	return true
}
