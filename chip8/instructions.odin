package chip8

import "core:math/rand"

Instruction :: proc(c: ^Chip8, op: Opcode)

OP_NULL :: proc(c: ^Chip8, op: Opcode) {}

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
	0xE = SHL_VX,
}

router_0x0 :: proc(c: ^Chip8, op: Opcode) {
	switch op_minor_byte(op) {
	case 0xE0:
		CLS(c, op)
	case 0xEE:
		RET(c, op)
	case:
		OP_NULL(c, op)
	}
}

router_0x8 :: proc(c: ^Chip8, op: Opcode) {
	MATH_INSTRUCTIONS[op_minor(op)](c, op)
}

router_0xF :: proc(c: ^Chip8, op: Opcode) {
	switch op_minor_byte(op) {
	case 0x07:
		LD_VX_DT(c, op)
	case 0x0A:
		LD_VX_K(c, op)
	case 0x15:
		LD_DT_VX(c, op)
	case 0x18:
		LD_ST_VX(c, op)
	case 0x1E:
		ADD_I_VX(c, op)
	case 0x29:
		LD_F_VX(c, op)
	case 0x33:
		LD_B_VX(c, op)
	case 0x55:
		LD_I_VX(c, op)
	case 0x65:
		LD_VX_I(c, op)
	case:
		OP_NULL(c, op)
	}
}

router_0xE :: proc(c: ^Chip8, op: Opcode) {
	switch op_minor_byte(op) {
	case 0x9E:
		SKP_VX(c, op)
	case 0xA1:
		SKNP_VX(c, op)
	case:
		OP_NULL(c, op)
	}
}

// Clear the display (0x00E0 - CLS)
CLS :: proc(c: ^Chip8, op: Opcode) {
	c.display = [?]u32 {
		0 ..< len(c.display) = 0,
	}
}

// Return from a subroutine (0x00EE - RET)
RET :: proc(c: ^Chip8, op: Opcode) {
	if value, ok := stack_pop(&c.stack); ok {
		pc_set(&c.pc, value)
	}
}

// Jump to address NNN (0x1NNN - JP NNN)
JP :: proc(c: ^Chip8, op: Opcode) {
	pc_set(&c.pc, op_nnn(op))
}

// Call subroutine at address NNN (0x2NNN - CALL NNN)
CALL :: proc(c: ^Chip8, op: Opcode) {
	// Save the return address.
	if !stack_push(&c.stack, pc_get(&c.pc)) {
		return
	}
	// Jump to the address NNN.
	pc_set(&c.pc, op_nnn(op))
}

// Skip next instruction if Vx equals KK (0x3XKK - SE Vx, KK)
SE_VX_KK :: proc(c: ^Chip8, op: Opcode) {
	vx := reg_get(&c.registers, op_x(op))
	if vx == op_kk(op) do pc_advance(&c.pc)
}

// Skip next instruction if Vx does not equal KK (0x4XKK - SNE Vx, KK)
SNE_VX_KK :: proc(c: ^Chip8, op: Opcode) {
	vx := reg_get(&c.registers, op_x(op))
	if vx != op_kk(op) do pc_advance(&c.pc)
}

// Skip next instruction if Vx equals Vy (0x5XY0 - SE Vx, Vy)
SE_VX_VY :: proc(c: ^Chip8, op: Opcode) {
	vx := reg_get(&c.registers, op_x(op))
	vy := reg_get(&c.registers, op_y(op))
	if vx == vy do pc_advance(&c.pc)
}

// Load value KK into Vx (0x6XKK - LD Vx, KK)
LD_VX_KK :: proc(c: ^Chip8, op: Opcode) {
	reg_set(&c.registers, op_x(op), op_kk(op))
}

// Add value KK to Vx (0x7XKK - ADD Vx, KK)
ADD_VX_KK :: proc(c: ^Chip8, op: Opcode) {
	vx := reg_get(&c.registers, op_x(op))
	reg_set(&c.registers, op_x(op), vx + op_kk(op))
}

// Load value Vy into Vx (0x8XY0 - LD Vx, Vy)
LD_VX_VY :: proc(c: ^Chip8, op: Opcode) {
	vy := reg_get(&c.registers, op_y(op))
	reg_set(&c.registers, op_x(op), vy)
}

// Bitwise OR Vx with Vy (0x8XY1 - OR Vx, Vy)
OR_VX_VY :: proc(c: ^Chip8, op: Opcode) {
	vx := reg_get(&c.registers, op_x(op))
	vy := reg_get(&c.registers, op_y(op))
	reg_set(&c.registers, op_x(op), vx | vy)
}

// Bitwise AND Vx with Vy (0x8XY2 - AND Vx, Vy)
AND_VX_VY :: proc(c: ^Chip8, op: Opcode) {
	vx := reg_get(&c.registers, op_x(op))
	vy := reg_get(&c.registers, op_y(op))
	reg_set(&c.registers, op_x(op), vx & vy)
}

// Bitwise XOR Vx with Vy (0x8XY3 - XOR Vx, Vy)
XOR_VX_VY :: proc(c: ^Chip8, op: Opcode) {
	vx := reg_get(&c.registers, op_x(op))
	vy := reg_get(&c.registers, op_y(op))
	reg_set(&c.registers, op_x(op), vx ~ vy)
}

// Add Vx and Vy (0x8XY4 - ADD Vx, Vy)
ADD_VX_VY :: proc(c: ^Chip8, op: Opcode) {
	vx := reg_get(&c.registers, op_x(op))
	vy := reg_get(&c.registers, op_y(op))
	result := u16(vx) + u16(vy)
	reg_set(&c.registers, 0xF, result > 0xFF ? 1 : 0)
	reg_set(&c.registers, op_x(op), u8(result & 0xFF))
}

// Subtract Vy from Vx (0x8XY5 - SUB Vx, Vy)
SUB_VX_VY :: proc(c: ^Chip8, op: Opcode) {
	vx := reg_get(&c.registers, op_x(op))
	vy := reg_get(&c.registers, op_y(op))
	reg_set(&c.registers, 0xF, vx > vy ? 1 : 0)
	reg_set(&c.registers, op_x(op), vx - vy)
}

// Shift Vx right by 1 (0x8XY6 - SHR Vx)
SHR_VX :: proc(c: ^Chip8, op: Opcode) {
	vx := reg_get(&c.registers, op_x(op))
	reg_set(&c.registers, 0xF, vx & 1)
	reg_set(&c.registers, op_x(op), vx >> 1)
}

// Subtract Vy from Vx (0x8XY7 - SUBN Vx, Vy)
SUBN_VX_VY :: proc(c: ^Chip8, op: Opcode) {
	vx := reg_get(&c.registers, op_x(op))
	vy := reg_get(&c.registers, op_y(op))
	reg_set(&c.registers, 0xF, vy > vx ? 1 : 0)
	reg_set(&c.registers, op_x(op), vy - vx)
}

// Shift Vx left by 1 (0x8XYE - SHL Vx)
SHL_VX :: proc(c: ^Chip8, op: Opcode) {
	vx := reg_get(&c.registers, op_x(op))
	reg_set(&c.registers, 0xF, (vx & 0x80) >> 7)
	reg_set(&c.registers, op_x(op), vx << 1)
}

// Skip next instruction if Vx does not equal Vy (0x9XY0 - SNE Vx, Vy)
SNE_VX_VY :: proc(c: ^Chip8, op: Opcode) {
	vx := reg_get(&c.registers, op_x(op))
	vy := reg_get(&c.registers, op_y(op))
	if vx != vy do pc_advance(&c.pc)
}

// Load NNN into index register (0xANNN - LD I, NNN)
LD_I_NNN :: proc(c: ^Chip8, op: Opcode) {
	reg_set_index(&c.registers, op_nnn(op))
}

// Jump to NNN + V0 (0xBNNN - JP V0, NNN)
JP_V0_NNN :: proc(c: ^Chip8, op: Opcode) {
	v0 := reg_get(&c.registers, 0)
	pc_set(&c.pc, op_nnn(op) + u16(v0))
}

// Set Vx to the result of a random number and KK (0xCKK - RND Vx, KK)
RND_VX_KK :: proc(c: ^Chip8, op: Opcode) {
	rnd := u8(rand.int_max(256)) // 255 + 1 because n is exclusive.
	reg_set(&c.registers, op_x(op), rnd & op_kk(op))
}

// Draw N bytes starting at memory location I at (Vx, Vy) (0xDXYN - DRW Vx, Vy, N)
DRW_VX_VY_N :: proc(c: ^Chip8, op: Opcode) {
	index := reg_get_index(&c.registers)
	start_x := reg_get(&c.registers, op_x(op)) % DISPLAY_WIDTH
	start_y := reg_get(&c.registers, op_y(op)) % DISPLAY_HEIGHT

	collision := false

	for row in 0 ..< op_n(op) {
		sprite_byte := mem_get_byte(&c.memory, index + u16(row))
		for col in 0 ..< 8 {
			if sprite_byte & (0x80 >> u8(col)) != 0 {
				x := start_x + u8(col) % DISPLAY_WIDTH
				y := start_y + u8(row) % DISPLAY_HEIGHT
				idx := u16(y) * DISPLAY_WIDTH + u16(x)

				if c.display[idx] == 0xFFFFFFFF {
					collision = true
				}

				c.display[idx] ~= 0xFFFFFFFF
			}
		}
	}

	reg_set(&c.registers, 0xF, collision ? 1 : 0)
}

// Skip next instruction if key with value Vx is pressed (0xEX9E - SKP Vx)
SKP_VX :: proc(c: ^Chip8, op: Opcode) {
	vx := reg_get(&c.registers, op_x(op))
	if kp_get_pressed(&c.keypad, vx) do pc_advance(&c.pc)
}

// Skip next instruction if key with value Vx is not pressed (0xEXA1 - SKNP Vx)
SKNP_VX :: proc(c: ^Chip8, op: Opcode) {
	vx := reg_get(&c.registers, op_x(op))
	if !kp_get_pressed(&c.keypad, vx) do pc_advance(&c.pc)
}

// Load value of delay timer into Vx (0xFX07 - LD Vx, DT)
LD_VX_DT :: proc(c: ^Chip8, op: Opcode) {
	dt := reg_get_dt(&c.registers)
	reg_set(&c.registers, op_x(op), dt)
}

// Wait for a key press and store the value of the key in Vx (0xFX0A - LD Vx, K)
LD_VX_K :: proc(c: ^Chip8, op: Opcode) {
	for key, i in &c.keypad.keys {
		if key {
			reg_set(&c.registers, op_x(op), u8(i))
			return
		}
	}
	// If no key is pressed, repeat the instruction.
	pc_return(&c.pc)
}

// Load value of Vx into delay timer (0xFX15 - LD DT, Vx)
LD_DT_VX :: proc(c: ^Chip8, op: Opcode) {
	vx := reg_get(&c.registers, op_x(op))
	reg_set_dt(&c.registers, vx)
}

// Load value of Vx into sound timer (0xFX18 - LD ST, Vx)
LD_ST_VX :: proc(c: ^Chip8, op: Opcode) {
	vx := reg_get(&c.registers, op_x(op))
	reg_set_st(&c.registers, vx)
}

// Add value of Vx to index register (0xFX1E - ADD I, Vx)
ADD_I_VX :: proc(c: ^Chip8, op: Opcode) {
	vx := reg_get(&c.registers, op_x(op))
	index := reg_get_index(&c.registers)
	reg_set_index(&c.registers, index + u16(vx))
}

// Load address of sprite for digit Vx into index register (0xFX29 - LD F, Vx)
LD_F_VX :: proc(c: ^Chip8, op: Opcode) {
	vx := reg_get(&c.registers, op_x(op))
	index := u16(FONTSET_START + (FONT_SIZE * u16(vx)))
	reg_set_index(&c.registers, index)
}

// Store binary-coded decimal representation of Vx in memory (0xFX33 - LD B, Vx)
LD_B_VX :: proc(c: ^Chip8, op: Opcode) {
	vx := reg_get(&c.registers, op_x(op))
	index := reg_get_index(&c.registers)
	mem_set_byte(&c.memory, index + 2, vx % 10)
	vx /= 10
	mem_set_byte(&c.memory, index + 1, vx % 10)
	vx /= 10
	mem_set_byte(&c.memory, index, vx % 10)
}

// Store V0 to Vx in memory starting at location I (0xFX55 - LD [I], Vx)
LD_I_VX :: proc(c: ^Chip8, op: Opcode) {
	index := reg_get_index(&c.registers)
	for i in 0 ..= op_x(op) {
		mem_set_byte(&c.memory, index + u16(i), reg_get(&c.registers, i))
	}
}

// Load memory starting at location I into V0 to Vx (0xFX65 - LD Vx, [I])
LD_VX_I :: proc(c: ^Chip8, op: Opcode) {
	index := reg_get_index(&c.registers)
	for i in 0 ..= op_x(op) {
		reg_set(&c.registers, i, mem_get_byte(&c.memory, index + u16(i)))
	}
}
