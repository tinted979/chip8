package platform

import "core:strings"
import "vendor:sdl2"

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
