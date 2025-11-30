package system

Event :: union {
	EventQuit,
	EventKey,
}

EventQuit :: struct {}

EventKey :: struct {
	key:     u8, // 0x0 - 0xF
	pressed: bool, // true = down, false = up
}
