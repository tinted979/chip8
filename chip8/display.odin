package chip8

Display :: struct {
	data: [DISPLAY_WIDTH * DISPLAY_HEIGHT]u32,
}

display_init :: proc(display: ^Display) {
	assert(display != nil)
	display^ = Display{}
}

display_clear :: proc(display: ^Display) {
	assert(display != nil)
	display.data = [?]u32 {
		0 ..< len(display.data) = 0,
	}
}

display_get_data :: proc(display: ^Display) -> []u32 {
	assert(display != nil)
	return display.data[:]
}

display_get_pixel :: proc(display: ^Display, x, y: u8) -> (result: u32, error: Error) {
	assert(display != nil)
	display_expect_coords(x, y) or_return
	idx := pixel_index(x, y)
	return display.data[idx], .None
}

display_set_pixel :: proc(display: ^Display, x, y: u8, value: u32) -> Error {
	assert(display != nil)
	display_expect_coords(x, y) or_return
	idx := pixel_index(x, y)
	display.data[idx] = value
	return .None
}

display_toggle_pixel :: proc(display: ^Display, x, y: u8) -> (collision: bool, error: Error) {
	assert(display != nil)
	expect(x < DISPLAY_WIDTH && y < DISPLAY_HEIGHT, .InvalidPixel) or_return
	idx := pixel_index(x, y)
	was_set := display.data[idx] == 0xFFFFFFFF
	display.data[idx] ~= 0xFFFFFFFF
	return was_set && display.data[idx] == 0, .None
}

@(private)
display_expect_coords :: proc(x, y: u8) -> Error {
	return expect(x < DISPLAY_WIDTH && y < DISPLAY_HEIGHT, .InvalidPixel)
}

@(private)
pixel_index :: proc(x, y: u8) -> u16 {
	return u16(y) * DISPLAY_WIDTH + u16(x)
}
