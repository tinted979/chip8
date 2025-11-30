package emulator

import "../shared"

Memory :: struct {
	bytes: [shared.MEMORY_SIZE]u8,
}

init_memory :: proc(memory: ^Memory) {
	memory^ = {}
}

read_byte :: proc(memory: ^Memory, address: u16) -> (u8, Error) {
	if address >= shared.MEMORY_SIZE {
		return 0, .MemoryOutOfBounds
	}
	return memory.bytes[address], .None
}

write_byte :: proc(memory: ^Memory, address: u16, value: u8) -> Error {
	if address >= shared.MEMORY_SIZE {
		return .MemoryOutOfBounds
	}
	memory.bytes[address] = value
	return .None
}

read_word :: proc(memory: ^Memory, address: u16) -> (u16, Error) {
	if address + 1 >= shared.MEMORY_SIZE {
		return 0, .MemoryOutOfBounds
	}
	high_byte := u16(memory.bytes[address])
	low_byte := u16(memory.bytes[address + 1])
	return high_byte << 8 | low_byte, .None
}
