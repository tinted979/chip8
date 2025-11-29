package chip8

Timer :: distinct u8

timer_init :: proc(timer: ^Timer) {
	assert(timer != nil)
	timer^ = 0
}

timer_get :: proc(timer: ^Timer) -> Timer {
	assert(timer != nil)
	return timer^
}

timer_set :: proc(timer: ^Timer, value: Timer) {
	assert(timer != nil)
	timer^ = value
}

timer_decrement :: proc(timer: ^Timer) {
	assert(timer != nil)
	if timer^ > 0 do timer^ -= 1
}

timer_to_u8 :: proc(timer: Timer) -> u8 {
	return u8(timer)
}

timer_from_u8 :: proc(value: u8) -> Timer {
	return Timer(value)
}
