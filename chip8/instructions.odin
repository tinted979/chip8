package chip8

import "core:math/rand"

Instruction :: proc(c: ^Chip8, op: Opcode) -> Error

OP_NULL :: proc(c: ^Chip8, op: Opcode) -> Error {
	return .None
}

INSTRUCTIONS := [0xF + 1]Instruction {
	0x0 = router_0x0,
	0x1 = JP,
	0x2 = CALL,
	0x3 = SE_VX_KK,
	0x4 = SNE_VX_KK,
	0x5 = SE_VX_VY,
	0x6 = LD_VX_KK,
	0x7 = ADD_VX_KK,
	0x8 = router_0x8,
	0x9 = SNE_VX_VY,
	0xA = LD_I_NNN,
	0xB = JP_V0_NNN,
	0xC = RND_VX_KK,
	0xD = DRW_VX_VY_N,
	0xE = router_0xE,
	0xF = router_0xF,
}

MATH_INSTRUCTIONS := [0xE + 1]Instruction {
	0x0 = LD_VX_VY,
	0x1 = OR_VX_VY,
	0x2 = AND_VX_VY,
	0x3 = XOR_VX_VY,
	0x4 = ADD_VX_VY,
	0x5 = SUB_VX_VY,
	0x6 = SHR_VX,
	0x7 = SUBN_VX_VY,
	0x8 = OP_NULL,
	0x9 = OP_NULL,
	0xA = OP_NULL,
	0xB = OP_NULL,
	0xC = OP_NULL,
	0xD = OP_NULL,
	0xE = SHL_VX,
}

router_0x0 :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	switch op.low_byte {
	case 0xE0:
		CLS(c, op) or_return
	case 0xEE:
		RET(c, op) or_return
	case:
		OP_NULL(c, op) or_return
	}
	return .None
}

router_0x8 :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	MATH_INSTRUCTIONS[op.n](c, op) or_return
	return .None
}

router_0xE :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	switch op.low_byte {
	case 0x9E:
		SKP_VX(c, op) or_return
	case 0xA1:
		SKNP_VX(c, op) or_return
	case:
		OP_NULL(c, op) or_return
	}
	return .None
}

router_0xF :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	switch op.low_byte {
	case 0x07:
		LD_VX_DT(c, op) or_return
	case 0x0A:
		LD_VX_K(c, op) or_return
	case 0x15:
		LD_DT_VX(c, op) or_return
	case 0x18:
		LD_ST_VX(c, op) or_return
	case 0x1E:
		ADD_I_VX(c, op) or_return
	case 0x29:
		LD_F_VX(c, op) or_return
	case 0x33:
		LD_B_VX(c, op) or_return
	case 0x55:
		LD_I_VX(c, op) or_return
	case 0x65:
		LD_VX_I(c, op) or_return
	case:
		OP_NULL(c, op) or_return
	}
	return .None
}

// Clear the display (0x00E0 - CLS)
CLS :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	display_clear(&c.display)
	return .None
}

// Return from a subroutine (0x00EE - RET)
RET :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	pc := stack_pop(&c.stack) or_return
	pc_set(&c.program_counter, pc)
	return .None
}

// Jump to address NNN (0x1NNN - JP NNN)
JP :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	pc := pc_from_address(op.nnn)
	pc_set(&c.program_counter, pc)
	return .None
}

// Call subroutine at address NNN (0x2NNN - CALL NNN)
CALL :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	stack_push(&c.stack, c.program_counter) or_return
	pc := pc_from_address(op.nnn)
	pc_set(&c.program_counter, pc)
	return .None
}

// Skip next instruction if Vx equals KK (0x3XKK - SE Vx, KK)
SE_VX_KK :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	vx := registers_get(&c.registers, op.x)
	if vx == op.kk do pc_advance(&c.program_counter)
	return .None
}

// Skip next instruction if Vx does not equal KK (0x4XKK - SNE Vx, KK)
SNE_VX_KK :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	vx := registers_get(&c.registers, op.x)
	if vx != op.kk do pc_advance(&c.program_counter)
	return .None
}

// Skip next instruction if Vx equals Vy (0x5XY0 - SE Vx, Vy)
SE_VX_VY :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	vx := registers_get(&c.registers, op.x)
	vy := registers_get(&c.registers, op.y)
	if vx == vy do pc_advance(&c.program_counter)
	return .None
}

// Load value KK into Vx (0x6XKK - LD Vx, KK)
LD_VX_KK :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	registers_set(&c.registers, op.x, op.kk)
	return .None
}

// Add value KK to Vx (0x7XKK - ADD Vx, KK)
ADD_VX_KK :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	vx := registers_get(&c.registers, op.x)
	registers_set(&c.registers, op.x, vx + op.kk)
	return .None
}

// Load value Vy into Vx (0x8XY0 - LD Vx, Vy)
LD_VX_VY :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	vy := registers_get(&c.registers, op.y)
	registers_set(&c.registers, op.x, vy)
	return .None
}

// Bitwise OR Vx with Vy (0x8XY1 - OR Vx, Vy)
OR_VX_VY :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	vx := registers_get(&c.registers, op.x)
	vy := registers_get(&c.registers, op.y)
	registers_set(&c.registers, op.x, vx | vy)
	return .None
}

// Bitwise AND Vx with Vy (0x8XY2 - AND Vx, Vy)
AND_VX_VY :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	vx := registers_get(&c.registers, op.x)
	vy := registers_get(&c.registers, op.y)
	registers_set(&c.registers, op.x, vx & vy)
	return .None
}

// Bitwise XOR Vx with Vy (0x8XY3 - XOR Vx, Vy)
XOR_VX_VY :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	vx := registers_get(&c.registers, op.x)
	vy := registers_get(&c.registers, op.y)
	registers_set(&c.registers, op.x, vx ~ vy)
	return .None
}

// Add Vx and Vy (0x8XY4 - ADD Vx, Vy)
ADD_VX_VY :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	vx := registers_get(&c.registers, op.x)
	vy := registers_get(&c.registers, op.y)
	result := u16(vx) + u16(vy)
	registers_set(&c.registers, .VF, result > 0xFF ? 1 : 0)
	registers_set(&c.registers, op.x, u8(result & 0xFF))
	return .None
}

// Subtract Vy from Vx (0x8XY5 - SUB Vx, Vy)
SUB_VX_VY :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	vx := registers_get(&c.registers, op.x)
	vy := registers_get(&c.registers, op.y)
	registers_set(&c.registers, .VF, vx > vy ? 1 : 0)
	registers_set(&c.registers, op.x, vx - vy)
	return .None
}

// Shift Vx right by 1 (0x8XY6 - SHR Vx)
SHR_VX :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	vx := registers_get(&c.registers, op.x)
	registers_set(&c.registers, .VF, vx & 1)
	registers_set(&c.registers, op.x, vx >> 1)
	return .None
}

// Subtract Vy from Vx (0x8XY7 - SUBN Vx, Vy)
SUBN_VX_VY :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	vx := registers_get(&c.registers, op.x)
	vy := registers_get(&c.registers, op.y)
	registers_set(&c.registers, .VF, vy > vx ? 1 : 0)
	registers_set(&c.registers, op.x, vy - vx)
	return .None
}

// Shift Vx left by 1 (0x8XYE - SHL Vx)
SHL_VX :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	vx := registers_get(&c.registers, op.x)
	registers_set(&c.registers, .VF, (vx & 0x80) >> 7)
	registers_set(&c.registers, op.x, vx << 1)
	return .None
}

// Skip next instruction if Vx does not equal Vy (0x9XY0 - SNE Vx, Vy)
SNE_VX_VY :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	vx := registers_get(&c.registers, op.x)
	vy := registers_get(&c.registers, op.y)
	if vx != vy do pc_advance(&c.program_counter)
	return .None
}

// Load NNN into index register (0xANNN - LD I, NNN)
LD_I_NNN :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	registers_set_index(&c.registers, op.nnn) or_return
	return .None
}

// Jump to NNN + V0 (0xBNNN - JP V0, NNN)
JP_V0_NNN :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	v0 := registers_get(&c.registers, .V0)
	pc := pc_from_address(op.nnn + Address(v0))
	expect(pc < MEMORY_SIZE, .InvalidAddress) or_return
	pc_set(&c.program_counter, pc)
	return .None
}

// Set Vx to the result of a random number and KK (0xCKK - RND Vx, KK)
RND_VX_KK :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	rnd := u8(rand.int_max(256)) // 255 + 1 because n is exclusive.
	registers_set(&c.registers, op.x, rnd & op.kk)
	return .None
}

// Draw N bytes starting at memory location I at (Vx, Vy) (0xDXYN - DRW Vx, Vy, N)
DRW_VX_VY_N :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	index := registers_get_index(&c.registers)
	vx := registers_get(&c.registers, op.x)
	vy := registers_get(&c.registers, op.y)
	start_x := vx % DISPLAY_WIDTH
	start_y := vy % DISPLAY_HEIGHT
	collision := false
	expect(index + Address(op.n) <= MEMORY_SIZE, .InvalidAddress) or_return
	for row in 0 ..< op.n {
		sprite_byte := memory_get_byte(&c.memory, index + Address(row)) or_continue
		for col in 0 ..< 8 {
			if sprite_byte & (0x80 >> u8(col)) != 0 {
				x := (start_x + u8(col)) % DISPLAY_WIDTH
				y := (start_y + u8(row)) % DISPLAY_HEIGHT
				pixel_collision := display_toggle_pixel(&c.display, x, y) or_continue
				if pixel_collision do collision = true
			}
		}
	}
	registers_set(&c.registers, .VF, collision ? 1 : 0)
	return .None
}

// Skip next instruction if key with value Vx is pressed (0xEX9E - SKP Vx)
SKP_VX :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	vx := registers_get(&c.registers, op.x)
	pressed := keypad_get_pressed(&c.keypad, vx) or_return
	if pressed do pc_advance(&c.program_counter)
	return .None
}

// Skip next instruction if key with value Vx is not pressed (0xEXA1 - SKNP Vx)
SKNP_VX :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	vx := registers_get(&c.registers, op.x)
	pressed := keypad_get_pressed(&c.keypad, vx) or_return
	if !pressed do pc_advance(&c.program_counter)
	return .None
}

// Load value of delay timer into Vx (0xFX07 - LD Vx, DT)
LD_VX_DT :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	dt := timer_get(&c.registers.delay_timer)
	registers_set(&c.registers, op.x, timer_to_u8(dt))
	return .None
}

// Wait for a key press and store the value of the key in Vx (0xFX0A - LD Vx, K)
LD_VX_K :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	for key, i in &c.keypad.keys {
		if key {
			registers_set(&c.registers, op.x, u8(i))
			return .None
		}
	}
	// If no key is pressed, repeat the instruction.
	pc_return(&c.program_counter)
	return .None
}

// Load value of Vx into delay timer (0xFX15 - LD DT, Vx)
LD_DT_VX :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	vx := registers_get(&c.registers, op.x)
	timer_set(&c.registers.delay_timer, timer_from_u8(vx))
	return .None
}

// Load value of Vx into sound timer (0xFX18 - LD ST, Vx)
LD_ST_VX :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	vx := registers_get(&c.registers, op.x)
	timer_set(&c.registers.sound_timer, timer_from_u8(vx))
	return .None
}

// Add value of Vx to index register (0xFX1E - ADD I, Vx)
ADD_I_VX :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	vx := registers_get(&c.registers, op.x)
	index := registers_get_index(&c.registers)
	registers_set_index(&c.registers, index + Address(vx)) or_return
	return .None
}

// Load address of sprite for digit Vx into index register (0xFX29 - LD F, Vx)
LD_F_VX :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	vx := registers_get(&c.registers, op.x)
	index := FONT_START_ADDRESS + Address(FONT_SIZE * u16(vx))
	registers_set_index(&c.registers, index)
	return .None
}

// Store binary-coded decimal representation of Vx in memory (0xFX33 - LD B, Vx)
LD_B_VX :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	vx := registers_get(&c.registers, op.x)
	index := registers_get_index(&c.registers)
	expect(index + 2 <= MEMORY_SIZE, .InvalidAddress) or_return
	memory_set_byte(&c.memory, index + 2, vx % 10) or_return
	vx /= 10
	memory_set_byte(&c.memory, index + 1, vx % 10) or_return
	vx /= 10
	memory_set_byte(&c.memory, index, vx % 10) or_return
	return .None
}

// Store V0 to Vx in memory starting at location I (0xFX55 - LD [I], Vx)
LD_I_VX :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	index := registers_get_index(&c.registers)
	expect(index + Address(op.x) <= MEMORY_SIZE, .InvalidAddress) or_return
	for register in Register.V0 ..= op.x {
		value := registers_get(&c.registers, register)
		memory_set_byte(&c.memory, index + Address(register_to_u8(register)), value) or_return
	}
	return .None
}

// Load memory starting at location I into V0 to Vx (0xFX65 - LD Vx, [I])
LD_VX_I :: proc(c: ^Chip8, op: Opcode) -> Error {
	assert(c != nil)
	index := registers_get_index(&c.registers)
	expect(index + Address(op.x) <= MEMORY_SIZE, .InvalidAddress) or_return
	for register in Register.V0 ..= op.x {
		value := memory_get_byte(&c.memory, index + Address(register_to_u8(register))) or_continue
		registers_set(&c.registers, register, value)
	}
	return .None
}
