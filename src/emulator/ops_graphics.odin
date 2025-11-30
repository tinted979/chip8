package emulator

import "../shared"

// [00E0] Clear the display.
op_clear_display :: proc(e: ^Emulator, i: ClearDisplay) -> shared.Error {
	clear_display(&e.display)
	return .None
}

// [DXYN] Draw a sprite at position (VX, VY) with height N.
op_draw_sprite :: proc(e: ^Emulator, i: DrawSprite) -> shared.Error {
	x_coord := get_register(&e.registers, register_from_u8(i.vx) or_return)
	y_coord := get_register(&e.registers, register_from_u8(i.vy) or_return)

	// Reset collision flag (VF) to 0
	set_register(&e.registers, .VF, 0)

	for row in 0 ..< i.height {
		// Fetch the sprite byte from memory at I + row
		sprite_byte := read_byte(&e.memory, e.index_register + u16(row)) or_return

		// Iterate over each of the 8 bits in the byte
		for col in 0 ..< 8 {
			// Check if the current bit in the sprite is 1 (active pixel)
			if (sprite_byte & (0x80 >> u8(col))) != 0 {
				// Calculate screen coordinates
				x := (u16(x_coord) + u16(col))
				y := (u16(y_coord) + u16(row))

				// Clip sprites that go off screen (classic Chip-8 behavior)
				// Some interpreters wrap, but standard is usually clipping or partial wrap.
				// If you want wrapping, use % shared.DISPLAY_WIDTH here.
				// For now, strict check against bounds to prevent panic:
				if x >= shared.DISPLAY_WIDTH || y >= shared.DISPLAY_HEIGHT {
					continue
				}

				// Calculate linear index
				idx := y * shared.DISPLAY_WIDTH + x

				// Check if pixel is already set (Collision)
				if e.display.data[idx] {
					set_register(&e.registers, .VF, 1)
				}

				// XOR the pixel
				e.display.data[idx] = !e.display.data[idx]
			}
		}
	}

	return .None
}
