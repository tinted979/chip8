package emulator

import "../shared"
import "core:math/rand"

// [FX15] Set the delay timer to the value of VX.
op_set_delay_timer :: proc(e: ^Emulator, i: SetDelayTimer) -> shared.Error {
	set_time(&e.delay_timer, u8(get_register(&e.registers, register_from_u8(i.vx) or_return)))
	return .None
}

// [FX18] Set the sound timer to the value of VX.
op_set_sound_timer :: proc(e: ^Emulator, i: SetSoundTimer) -> shared.Error {
	set_time(&e.sound_timer, u8(get_register(&e.registers, register_from_u8(i.vx) or_return)))
	return .None
}

// [FX07] Set VX to the value of the delay timer.
op_read_delay_timer :: proc(e: ^Emulator, i: ReadDelayTimer) -> shared.Error {
	set_register(&e.registers, register_from_u8(i.vx) or_return, get_time(&e.delay_timer))
	return .None
}

// [FX0A] Wait for a key press, store the value of the key in VX.
op_wait_for_key :: proc(e: ^Emulator, i: WaitForKey) -> shared.Error {
	for key in 0 ..< shared.KEYPAD_SIZE {
		if is_pressed(&e.keypad, shared.key_from_u8(u8(key)) or_return) {
			set_register(&e.registers, register_from_u8(i.vx) or_return, u8(key))
			return .None
		}
	}

	e.program_counter -= 2
	return .None
}

// [CXKK] Set VX to the result of a random number masked by KK.
op_random :: proc(e: ^Emulator, i: Random) -> shared.Error {
	set_register(&e.registers, register_from_u8(i.vx) or_return, u8(rand.int_max(256)) & i.mask)
	return .None
}
