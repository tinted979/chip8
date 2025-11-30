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

create :: proc() -> (system: ^System, error: shared.Error) {
	system = new(System)
	system.config = default_config()
	if !init_window(system) do return system, .FailedToInitializeWindow
	if !init_renderer(system) do return system, .FailedToInitializeRenderer
	if !init_texture(system) do return system, .FailedToInitializeTexture
	return system, .None
}

destroy :: proc(system: ^System) -> shared.Error {
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

render :: proc(system: ^System, buffer: []bool) -> shared.Error {
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
map_sdl_key :: proc(k: sdl2.Keycode) -> (shared.Key, bool) {
	#partial switch k {
	case .X:
		return shared.Key.Key0, true
	case .NUM1:
		return shared.Key.Key1, true
	case .NUM2:
		return shared.Key.Key2, true
	case .NUM3:
		return shared.Key.Key3, true
	case .Q:
		return shared.Key.Key4, true
	case .W:
		return shared.Key.Key5, true
	case .E:
		return shared.Key.Key6, true
	case .A:
		return shared.Key.Key7, true
	case .S:
		return shared.Key.Key8, true
	case .D:
		return shared.Key.Key9, true
	case .Z:
		return shared.Key.KeyA, true
	case .C:
		return shared.Key.KeyB, true
	case .NUM4:
		return shared.Key.KeyC, true
	case .R:
		return shared.Key.KeyD, true
	case .F:
		return shared.Key.KeyE, true
	case .V:
		return shared.Key.KeyF, true
	}
	return {}, false
}
