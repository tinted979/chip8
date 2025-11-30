package chip8

import "core:fmt"

import "core/emulator"
import "core/parser"
import "core/system"

ROM_PATH :: "roms/tetris.ch8"
CYCLES_PER_FRAME :: 11

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

	running := true
	for running {
		for {
			event, event_found := system.poll_events()
			if !event_found do break

			switch e in event {
			case system.EventQuit:
				running = false
				break
			case system.EventKey:
				if e.pressed {
					fmt.println("Key pressed: ", e.key)
				} else {
					fmt.println("Key released: ", e.key)
				}
			}
		}

		if system_error = system.render(
			system_instance,
			emulator.get_display_buffer(emulator_instance),
		); system_error != .None {
			fmt.println("System Error: ", system_error); break
		}
	}
}
