package emulator

import "../shared"

Display :: struct {
	data: [shared.DISPLAY_SIZE]bool,
}

init_display :: proc(display: ^Display) {
	display.data = {}
}

toggle_pixel :: proc(display: ^Display, x, y: u8) {
	idx := y * shared.DISPLAY_WIDTH + x
	display.data[idx] = !display.data[idx]
}

clear_display :: proc(display: ^Display) {
	for i in 0 ..< shared.DISPLAY_SIZE {
		display.data[i] = false
	}
}
