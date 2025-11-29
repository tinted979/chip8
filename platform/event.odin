package platform

import "vendor:sdl2"

EventType :: enum {
	NONE,
	QUIT,
	KEY_DOWN,
	KEY_UP,
}

Event :: struct {
	type: EventType,
	key:  Key,
}

event_poll :: proc(p: ^Platform, event: ^Event) -> bool {
	assert(p != nil)
	assert(event != nil)

	sdl_event: sdl2.Event
	if !sdl2.PollEvent(&sdl_event) {
		event.type = .NONE
		return false
	}

	#partial switch sdl_event.type {
	case sdl2.EventType.QUIT:
		event.type = .QUIT
		return true
	case sdl2.EventType.KEYDOWN:
		key, ok := sdl_key_to_platform_key(sdl_event.key.keysym.sym)
		if !ok do return false
		event.type = .KEY_DOWN
		event.key = key
		return true
	case sdl2.EventType.KEYUP:
		key, ok := sdl_key_to_platform_key(sdl_event.key.keysym.sym)
		if !ok do return false
		event.type = .KEY_UP
		event.key = key
		return true
	case:
		event.type = .NONE
		return false
	}
}

sdl_key_to_platform_key :: proc(key: sdl2.Keycode) -> (Key, bool) {
	#partial switch key {
	case .NUM1:
		return .KEY_1, true
	case .NUM2:
		return .KEY_2, true
	case .NUM3:
		return .KEY_3, true
	case .NUM4:
		return .KEY_C, true
	case .Q:
		return .KEY_4, true
	case .W:
		return .KEY_5, true
	case .E:
		return .KEY_6, true
	case .R:
		return .KEY_D, true
	case .A:
		return .KEY_7, true
	case .S:
		return .KEY_8, true
	case .D:
		return .KEY_9, true
	case .F:
		return .KEY_E, true
	case .Z:
		return .KEY_A, true
	case .X:
		return .KEY_0, true
	case .C:
		return .KEY_B, true
	case .V:
		return .KEY_F, true
	case:
		return {}, false
	}
}
