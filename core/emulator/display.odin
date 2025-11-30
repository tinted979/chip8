package emulator

import "../shared"

Display :: struct {
	buffer: [shared.DISPLAY_SIZE]bool,
}

init_display :: proc(display: ^Display) {
	clear_display(display)
}

toggle_pixel :: proc(display: ^Display, x, y: u8) {
	idx := y * shared.DISPLAY_WIDTH + x
	display.buffer[idx] = !display.buffer[idx]
}

clear_display :: proc(display: ^Display) {
	for i in 0 ..< shared.DISPLAY_SIZE {
		display.buffer[i] = false
	}
}
