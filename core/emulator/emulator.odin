package emulator

import "core:fmt"

import "../shared"

Emulator :: struct {
	display: Display,
}

create :: proc() -> (emulator: ^Emulator, error: Error) {
	emulator = new(Emulator)
	init_display(&emulator.display)
	return emulator, .None
}

destroy :: proc(emulator: ^Emulator) -> Error {
	free(emulator)
	return .None
}

load_rom :: proc(data: []byte) -> (error: Error) {
	return .None
}

get_display_buffer :: proc(emulator: ^Emulator) -> []bool {
	return emulator.display.buffer[:]
}
