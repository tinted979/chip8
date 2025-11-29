package main

import "chip8"
import "core:fmt"
import "core:time"
import "vendor:sdl2"

import "platform"

VIDEO_SCALE :: 20
TARGET_FPS :: 60
CYCLES_PER_FRAME :: 9

main :: proc() {
	p, err := platform.init("Chip-8", chip8.DISPLAY_WIDTH, chip8.DISPLAY_HEIGHT, VIDEO_SCALE)
	if err != .SUCCESS {
		fmt.println("Failed to initialize platform")
		return
	}
	defer platform.destroy(&p)

	c := chip8.create()
	defer chip8.destroy(c)

	success := chip8.load_rom(c, "roms/Brix.ch8")
	if !success {
		return
	}

	target_frame_duration := time.Duration(time.Second) / TARGET_FPS

	running := true
	for running {
		frame_start := time.tick_now()

		event: platform.Event
		for platform.poll_event(&p, &event) {
			#partial switch event.type {
			case .QUIT:
				running = false
			case .KEY_DOWN:
				chip8.keypad_set_pressed(&c.keypad, u8(event.key), true)
			case .KEY_UP:
				chip8.keypad_set_pressed(&c.keypad, u8(event.key), false)
			}
		}

		for _ in 0 ..< CYCLES_PER_FRAME {
			chip8.cycle(c)
		}

		chip8.update_timers(c)

		err := platform.update(&p, c.display[:])
		if err != .SUCCESS {
			fmt.println("Failed to update platform")
			return
		}

		elapsed := time.tick_diff(frame_start, time.tick_now())
		if elapsed < target_frame_duration {
			time.accurate_sleep(target_frame_duration - elapsed)
		}
	}
}
