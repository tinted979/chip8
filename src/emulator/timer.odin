package emulator

Timer :: distinct u8

init_timer :: proc(t: ^Timer) {
	t^ = 0
}

update_timer :: proc(t: ^Timer) {
	if t^ > 0 do t^ -= 1
}

get_time :: proc(t: ^Timer) -> u8 {
	return u8(t^)
}

set_time :: proc(t: ^Timer, value: u8) {
	t^ = Timer(value)
}
