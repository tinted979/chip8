package chip8

import "core:fmt"
import "core:time"

import "src/emulator"
import "src/parser"
import "src/shared"
import "src/system"


ROM_PATH :: "roms/tetris.ch8"

main :: proc() {
	fmt.println("Starting...")

	emulator_instance, emulator_error := emulator.create()
	if emulator_error != .None {
		fmt.println("Emulator Error: ", emulator_error)
		return
	}; defer if emulator_error = emulator.destroy(emulator_instance); emulator_error != .None {
		fmt.println("Emulator Error: ", emulator_error)
	}

	system_instance, system_error := system.create()
	if system_error != .None {
		fmt.println("System Error: ", system_error)
		return
	}; defer if system_error = system.destroy(system_instance); system_error != .None {
		fmt.println("System Error: ", system_error)
	}

	rom_data, parser_error := parser.parse_rom_file(ROM_PATH)
	if parser_error != .None {
		fmt.println("Parser Error: ", parser_error)
		return
	}

	if emulator_error = emulator.load_rom(rom_data); emulator_error != .None {
		fmt.println("Emulator Error: ", emulator_error)
		return
	}

	target_frame_duration := time.Duration(time.Second) / shared.DEFAULT_TARGET_FPS
	running := true
	for running {
		frame_start := time.tick_now()

		for {
			event, event_found := system.poll_events()
			if !event_found do break

			switch e in event {
			case system.EventQuit:
				running = false
				break
			case system.EventKey:
				if emulator_error = emulator.set_key_state(emulator_instance, e.key, e.pressed);
				   emulator_error != .None {
					fmt.println("Emulator Error: ", emulator_error)
					running = false
					break
				}
			}
		}

		for _ in 0 ..< shared.CYCLES_PER_FRAME {
			if emulator_error = emulator.cycle(emulator_instance); emulator_error != .None {
				fmt.println("Emulator Error: ", emulator_error)
				running = false
				break
			}
		}
		emulator.update_timers(emulator_instance)

		if system_error = system.render(
			system_instance,
			emulator.get_display_buffer(emulator_instance),
		); system_error != .None {
			fmt.println("System Error: ", system_error)
			running = false
			break
		}

		elapsed := time.tick_diff(frame_start, time.tick_now())
		if elapsed < target_frame_duration {
			time.accurate_sleep(target_frame_duration - elapsed)
		}
	}
}
