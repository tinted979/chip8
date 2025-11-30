package system

import "core:fmt"
import "core:strings"
import "vendor:sdl2"

import "../shared"

System :: struct {
	config:          Config,
	window:          ^sdl2.Window,
	renderer:        ^sdl2.Renderer,
	texture:         ^sdl2.Texture,
	graphics_buffer: [shared.DISPLAY_SIZE]u32,
}

create :: proc() -> (system: ^System, error: Error) {
	system = new(System)
	system.config = default_config()
	if !init_window(system) do return system, .FailedToInitializeWindow
	if !init_renderer(system) do return system, .FailedToInitializeRenderer
	if !init_texture(system) do return system, .FailedToInitializeTexture
	return system, .None
}

destroy :: proc(system: ^System) -> Error {
	clear_config(&system.config)
	sdl2.DestroyWindow(system.window)
	sdl2.DestroyRenderer(system.renderer)
	sdl2.DestroyTexture(system.texture)
	return .None
}

poll_events :: proc() -> (event: Event, event_found: bool) {
	sdl_event: sdl2.Event
	if !sdl2.PollEvent(&sdl_event) do return event, false

	#partial switch sdl_event.type {
	case .QUIT:
		return EventQuit{}, true
	case .KEYDOWN:
		if key, key_found := map_sdl_key(sdl_event.key.keysym.sym); key_found {
			return EventKey{key, true}, true
		}
	case .KEYUP:
		if key, key_found := map_sdl_key(sdl_event.key.keysym.sym); key_found {
			return EventKey{key, false}, true
		}
	}

	return event, false
}

render :: proc(system: ^System, buffer: []bool) -> Error {
	for pixel, i in buffer {
		system.graphics_buffer[i] = pixel ? 0xFFFFFFFF : 0x00000000
	}

	sdl2.UpdateTexture(
		system.texture,
		nil,
		raw_data(system.graphics_buffer[:]),
		i32(system.config.window_width) * 4,
	)
	sdl2.RenderClear(system.renderer)
	sdl2.RenderCopy(system.renderer, system.texture, nil, nil)
	sdl2.RenderPresent(system.renderer)
	return .None
}

@(private)
init_window :: proc(system: ^System) -> bool {
	system.window = sdl2.CreateWindow(
		strings.clone_to_cstring(system.config.window_title, context.temp_allocator),
		sdl2.WINDOWPOS_UNDEFINED,
		sdl2.WINDOWPOS_UNDEFINED,
		i32(system.config.window_width * system.config.display_scale),
		i32(system.config.window_height * system.config.display_scale),
		sdl2.WINDOW_SHOWN,
	)
	return system.window != nil
}

@(private)
init_renderer :: proc(system: ^System) -> bool {
	system.renderer = sdl2.CreateRenderer(system.window, -1, sdl2.RENDERER_ACCELERATED)
	return system.renderer != nil
}

@(private)
init_texture :: proc(system: ^System) -> bool {
	system.texture = sdl2.CreateTexture(
		system.renderer,
		sdl2.PixelFormatEnum.RGBA8888,
		sdl2.TextureAccess.STREAMING,
		i32(system.config.window_width),
		i32(system.config.window_height),
	)
	return system.texture != nil
}

@(private)
map_sdl_key :: proc(k: sdl2.Keycode) -> (u8, bool) {
	#partial switch k {
	case .X:
		return 0x0, true
	case .NUM1:
		return 0x1, true
	case .NUM2:
		return 0x2, true
	case .NUM3:
		return 0x3, true
	case .Q:
		return 0x4, true
	case .W:
		return 0x5, true
	case .E:
		return 0x6, true
	case .A:
		return 0x7, true
	case .S:
		return 0x8, true
	case .D:
		return 0x9, true
	case .Z:
		return 0xA, true
	case .C:
		return 0xB, true
	case .NUM4:
		return 0xC, true
	case .R:
		return 0xD, true
	case .F:
		return 0xE, true
	case .V:
		return 0xF, true
	}
	return 0, false
}
