package main

import "chip8"
import "core:fmt"
import "core:time"
import "vendor:sdl2"

VIDEO_SCALE :: 20
TARGET_FPS :: 60
CYCLES_PER_FRAME :: 11

main :: proc() {
	if sdl2.Init(sdl2.INIT_VIDEO) != 0 {
		fmt.println("Failed to initialize SDL2")
		return
	}
	defer sdl2.Quit()

	window := sdl2.CreateWindow(
		"Chip-8",
		sdl2.WINDOWPOS_UNDEFINED,
		sdl2.WINDOWPOS_UNDEFINED,
		chip8.DISPLAY_WIDTH * VIDEO_SCALE,
		chip8.DISPLAY_HEIGHT * VIDEO_SCALE,
		sdl2.WINDOW_SHOWN,
	)
	if window == nil {
		return
	}
	defer sdl2.DestroyWindow(window)

	renderer := sdl2.CreateRenderer(window, -1, sdl2.RENDERER_ACCELERATED)
	if renderer == nil {
		return
	}
	defer sdl2.DestroyRenderer(renderer)

	texture := sdl2.CreateTexture(
		renderer,
		sdl2.PixelFormatEnum.RGBA8888,
		sdl2.TextureAccess.STREAMING,
		chip8.DISPLAY_WIDTH,
		chip8.DISPLAY_HEIGHT,
	)
	if texture == nil {
		return
	}
	defer sdl2.DestroyTexture(texture)

	c := chip8.create()
	defer chip8.destroy(c)

	success := chip8.load_rom(c, "roms/tetris.ch8")
	if !success {
		return
	}

	target_frame_duration := time.Duration(time.Second) / TARGET_FPS
	last_frame_time := time.tick_now()

	running := true
	for running {
		frame_start := time.tick_now()

		event: sdl2.Event
		for sdl2.PollEvent(&event) {
			#partial switch event.type {
			case sdl2.EventType.QUIT:
				running = false
			case sdl2.EventType.KEYDOWN:
				key, success := chip8.kp_get_mapping(event.key.keysym.sym)
				if !success {
					continue
				}
				chip8.kp_set_pressed(&c.keypad, key, true)
			case sdl2.EventType.KEYUP:
				key, success := chip8.kp_get_mapping(event.key.keysym.sym)
				if !success {
					continue
				}
				chip8.kp_set_pressed(&c.keypad, key, false)
			}
		}

		for _ in 0 ..< CYCLES_PER_FRAME {
			chip8.cycle(c)
		}

		chip8.update_timers(c)

		sdl2.UpdateTexture(
			texture,
			nil,
			rawptr(&c.display[0]),
			size_of(c.display[0]) * chip8.DISPLAY_WIDTH,
		)
		sdl2.RenderClear(renderer)
		sdl2.RenderCopy(renderer, texture, nil, nil)
		sdl2.RenderPresent(renderer)

		frame_end := time.tick_now()
		elapsed := time.tick_diff(frame_start, frame_end)
		if elapsed < target_frame_duration {
			sleep_time := target_frame_duration - elapsed
			time.accurate_sleep(sleep_time)
		}

		last_frame_time = frame_end
	}
}
