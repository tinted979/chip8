package main

import "chip8"
import "core:fmt"
import "core:mem"
import "core:time"
import "platform"

VIDEO_SCALE :: 20
TARGET_FPS :: 60
CYCLES_PER_FRAME :: 9

main :: proc() {
	when ODIN_DEBUG {
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 {
				fmt.println(len(track.allocation_map), "allocations not freed")
				for _, entry in track.allocation_map {
					fmt.println(entry.size, "bytes at", entry.location)
				}
			}

			mem.tracking_allocator_destroy(&track)
		}
	}

	// Initialize platform.
	platform_instance, error := platform.init(
		"Chip-8",
		chip8.DISPLAY_WIDTH,
		chip8.DISPLAY_HEIGHT,
		VIDEO_SCALE,
	)
	if error != .SUCCESS {
		fmt.println("Failed to initialize platform")
		return
	}
	defer platform.destroy(&platform_instance)

	// Initialize chip instance.
	chip_instance := new(chip8.Chip8)
	defer free(chip_instance)

	// Load ROM.
	if error := chip8.load_rom(chip_instance, "roms/Brix.ch8"); error != .None {
		fmt.println("Failed to load ROM")
		return
	}

	target_frame_duration := time.Duration(time.Second) / TARGET_FPS
	running := true
	for running {
		frame_start := time.tick_now()

		// Poll events.
		event: platform.Event
		for platform.event_poll(&platform_instance, &event) {
			#partial switch event.type {
			case .QUIT:
				running = false
			case .KEY_DOWN:
				chip8.keypad_set_pressed(
					&chip_instance.keypad,
					platform.key_to_u8(event.key),
					true,
				)
			case .KEY_UP:
				chip8.keypad_set_pressed(
					&chip_instance.keypad,
					platform.key_to_u8(event.key),
					false,
				)
			}
		}

		// Cycle chip.
		for _ in 0 ..< CYCLES_PER_FRAME {
			if error := chip8.cycle(chip_instance); error != .None {
				fmt.println("Failed to cycle chip")
				return
			}
		}
		if error := chip8.update_timers(chip_instance); error != .None {
			fmt.println("Failed to update timers")
			return
		}

		// Update platform display buffer.
		error := platform.update(&platform_instance, chip_instance.display[:])
		if error != .SUCCESS {
			fmt.println("Failed to update platform")
			return
		}

		// Sleep to maintain target FPS.
		elapsed := time.tick_diff(frame_start, time.tick_now())
		if elapsed < target_frame_duration {
			time.accurate_sleep(target_frame_duration - elapsed)
		}
	}
}
