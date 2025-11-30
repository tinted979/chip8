package system

import "../shared"

Event :: union {
	EventQuit,
	EventKey,
}

EventQuit :: struct {}

EventKey :: struct {
	key:     shared.Key,
	pressed: bool,
}
