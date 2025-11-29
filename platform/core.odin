package platform

import "core:strings"
import "vendor:sdl2"

Key :: enum u8 {
	KEY_0 = 0x0,
	KEY_1 = 0x1,
	KEY_2 = 0x2,
	KEY_3 = 0x3,
	KEY_4 = 0x4,
	KEY_5 = 0x5,
	KEY_6 = 0x6,
	KEY_7 = 0x7,
	KEY_8 = 0x8,
	KEY_9 = 0x9,
	KEY_A = 0xA,
	KEY_B = 0xB,
	KEY_C = 0xC,
	KEY_D = 0xD,
	KEY_E = 0xE,
	KEY_F = 0xF,
}

key_to_u8 :: proc(key: Key) -> u8 {
	return u8(key)
}

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

Platform :: struct {
	window:   ^sdl2.Window,
	renderer: ^sdl2.Renderer,
	texture:  ^sdl2.Texture,
	width:    i32,
	height:   i32,
	scale:    i32,
}

PlatformError :: enum {
	SUCCESS,
	INIT_FAILED,
	WINDOW_CREATION_FAILED,
	RENDERER_CREATION_FAILED,
	TEXTURE_CREATION_FAILED,
}

// Initialize the platform.
init :: proc(title: string, width, height, scale: i32) -> (Platform, PlatformError) {
	// Initialize SDL2.
	if sdl2.Init(sdl2.INIT_VIDEO) != 0 do return Platform{}, .INIT_FAILED

	// Create window.
	window := sdl2.CreateWindow(
		strings.clone_to_cstring(title, context.temp_allocator),
		sdl2.WINDOWPOS_UNDEFINED,
		sdl2.WINDOWPOS_UNDEFINED,
		width * scale,
		height * scale,
		sdl2.WINDOW_SHOWN,
	)
	if window == nil do return Platform{}, .WINDOW_CREATION_FAILED

	// Create renderer.
	renderer := sdl2.CreateRenderer(window, -1, sdl2.RENDERER_ACCELERATED)
	if renderer == nil do return Platform{}, .RENDERER_CREATION_FAILED

	// Create texture.
	texture := sdl2.CreateTexture(
		renderer,
		sdl2.PixelFormatEnum.RGBA8888,
		sdl2.TextureAccess.STREAMING,
		width,
		height,
	)
	if texture == nil do return Platform{}, .TEXTURE_CREATION_FAILED

	// Return the platform.
	return Platform {
			window = window,
			renderer = renderer,
			texture = texture,
			width = width,
			height = height,
			scale = scale,
		},
		.SUCCESS
}

// Destroy the platform.
destroy :: proc(p: ^Platform) {
	assert(p != nil)
	sdl2.DestroyWindow(p.window)
	sdl2.DestroyRenderer(p.renderer)
	sdl2.DestroyTexture(p.texture)
	sdl2.Quit()
}

// Poll events.
poll_event :: proc(p: ^Platform, event: ^Event) -> bool {
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
		key, ok := sdl_key_to_key(sdl_event.key.keysym.sym)
		if !ok do return false
		event.type = .KEY_DOWN
		event.key = key
		return true
	case sdl2.EventType.KEYUP:
		key, ok := sdl_key_to_key(sdl_event.key.keysym.sym)
		if !ok do return false
		event.type = .KEY_UP
		event.key = key
		return true
	case:
		event.type = .NONE
		return false
	}
}

// Update display buffer and present frame.
update :: proc(p: ^Platform, display: []u32) -> PlatformError {
	assert(p != nil)
	assert(len(display) == int(p.width * p.height))
	sdl2.UpdateTexture(
		p.texture,
		nil,
		rawptr(raw_data(display)),
		i32(size_of(display[0]) * p.width),
	)
	sdl2.RenderClear(p.renderer)
	sdl2.RenderCopy(p.renderer, p.texture, nil, nil)
	sdl2.RenderPresent(p.renderer)
	return .SUCCESS
}

sdl_key_to_key :: proc(key: sdl2.Keycode) -> (Key, bool) {
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
