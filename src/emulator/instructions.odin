package emulator

import "../shared"

Instruction :: union {
	Null,

	// Flow Control
	Jump, // 1NNN
	JumpWithOffset, // BNNN
	CallSubroutine, // 2NNN
	ReturnFromSubroutine, // 00EE

	// Conditional Skips
	SkipIfEqualValue, // 3XKK
	SkipIfNotEqualValue, // 4XKK
	SkipIfEqualRegister, // 5XY0
	SkipIfNotEqualRegister, // 9XY0
	SkipIfKeyPressed, // EX9E
	SkipIfKeyNotPressed, // EXA1

	// Register Operations
	SetRegisterValue, // 6XKK
	SetRegisterRegister, // 8XY0
	AddValue, // 7XKK
	AddRegister, // 8XY4
	SubtractRegister, // 8XY5
	SubtractRegisterReversed, // 8XY7

	// Bitwise Operations
	OrRegister, // 8XY1
	AndRegister, // 8XY2
	XorRegister, // 8XY3
	ShiftRight, // 8XY6
	ShiftLeft, // 8XYE

	// Memory & Index
	SetIndex, // ANNN
	AddToIndex, // FX1E
	SetIndexToFontChar, // FX29
	StoreBCD, // FX33
	StoreRegisters, // FX55
	LoadRegisters, // FX65

	// Graphics & Display
	ClearDisplay, // 00E0
	DrawSprite, // DXYN

	// System & Timers
	SetDelayTimer, // FX15
	SetSoundTimer, // FX18
	ReadDelayTimer, // FX07
	WaitForKey, // FX0A
	Random, // CXKK
}

Null :: struct {}

// Flow Control
Jump :: struct {
	addr: u16,
}

JumpWithOffset :: struct {
	addr: u16,
}

CallSubroutine :: struct {
	addr: u16,
}

ReturnFromSubroutine :: struct {}

// Conditional Skips
SkipIfEqualValue :: struct {
	vx:    u8,
	value: u8,
}

SkipIfNotEqualValue :: struct {
	vx:    u8,
	value: u8,
}

SkipIfEqualRegister :: struct {
	vx: u8,
	vy: u8,
}

SkipIfNotEqualRegister :: struct {
	vx: u8,
	vy: u8,
}

SkipIfKeyPressed :: struct {
	vx: u8,
}

SkipIfKeyNotPressed :: struct {
	vx: u8,
}

// Register Operations
SetRegisterValue :: struct {
	vx:    u8,
	value: u8,
}
SetRegisterRegister :: struct {
	vx: u8,
	vy: u8,
}
AddValue :: struct {
	vx:    u8,
	value: u8,
}
AddRegister :: struct {
	vx: u8,
	vy: u8,
}
SubtractRegister :: struct {
	vx: u8,
	vy: u8,
}
SubtractRegisterReversed :: struct {
	vx: u8,
	vy: u8,
}

// Bitwise Operations
OrRegister :: struct {
	vx: u8,
	vy: u8,
}

AndRegister :: struct {
	vx: u8,
	vy: u8,
}

XorRegister :: struct {
	vx: u8,
	vy: u8,
}

ShiftRight :: struct {
	vx: u8,
	vy: u8,
}

ShiftLeft :: struct {
	vx: u8,
	vy: u8,
}

// Memory & Index
SetIndex :: struct {
	addr: u16,
}

AddToIndex :: struct {
	vx: u8,
}

SetIndexToFontChar :: struct {
	vx: u8,
}

StoreBCD :: struct {
	vx: u8,
}

StoreRegisters :: struct {
	vx: u8,
}

LoadRegisters :: struct {
	vx: u8,
}

// Graphics & Display
ClearDisplay :: struct {}

DrawSprite :: struct {
	vx:     u8,
	vy:     u8,
	height: u8,
}

// System & Timers
SetDelayTimer :: struct {
	vx: u8,
}

SetSoundTimer :: struct {
	vx: u8,
}

ReadDelayTimer :: struct {
	vx: u8,
}

WaitForKey :: struct {
	vx: u8,
}

Random :: struct {
	vx:   u8,
	mask: u8,
}

decode_instruction :: proc(
	raw_instruction: u16,
) -> (
	instruction: Instruction,
	error: shared.Error,
) {
	nibble := (raw_instruction & 0xF000) >> 12
	x := u8((raw_instruction & 0x0F00) >> 8)
	y := u8((raw_instruction & 0x00F0) >> 4)
	n := u8(raw_instruction & 0x000F)
	nn := u8(raw_instruction & 0x00FF)
	nnn := raw_instruction & 0x0FFF

	switch nibble {
	case 0x0:
		if nn == 0xE0 do return ClearDisplay{}, .None
		if nn == 0xEE do return ReturnFromSubroutine{}, .None
	case 0x1:
		return Jump{addr = nnn}, .None
	case 0x2:
		return CallSubroutine{addr = nnn}, .None
	case 0x3:
		return SkipIfEqualValue{vx = x, value = nn}, .None
	case 0x4:
		return SkipIfNotEqualValue{vx = x, value = nn}, .None
	case 0x5:
		return SkipIfEqualRegister{vx = x, vy = y}, .None
	case 0x6:
		return SetRegisterValue{vx = x, value = nn}, .None
	case 0x7:
		return AddValue{vx = x, value = nn}, .None
	case 0x8:
		switch n {
		case 0x0:
			return SetRegisterRegister{vx = x, vy = y}, .None
		case 0x1:
			return OrRegister{vx = x, vy = y}, .None
		case 0x2:
			return AndRegister{vx = x, vy = y}, .None
		case 0x3:
			return XorRegister{vx = x, vy = y}, .None
		case 0x4:
			return AddRegister{vx = x, vy = y}, .None
		case 0x5:
			return SubtractRegister{vx = x, vy = y}, .None
		case 0x6:
			return ShiftRight{vx = x, vy = y}, .None
		case 0x7:
			return SubtractRegisterReversed{vx = x, vy = y}, .None
		case 0xE:
			return ShiftLeft{vx = x, vy = y}, .None
		}
	case 0x9:
		return SkipIfNotEqualRegister{vx = x, vy = y}, .None
	case 0xA:
		return SetIndex{addr = nnn}, .None
	case 0xB:
		return JumpWithOffset{addr = nnn}, .None
	case 0xC:
		return Random{vx = x, mask = nn}, .None
	case 0xD:
		return DrawSprite{vx = x, vy = y, height = n}, .None
	case 0xE:
		if nn == 0x9E do return SkipIfKeyPressed{vx = x}, .None
		if nn == 0xA1 do return SkipIfKeyNotPressed{vx = x}, .None
	case 0xF:
		switch nn {
		case 0x07:
			return ReadDelayTimer{vx = x}, .None
		case 0x0A:
			return WaitForKey{vx = x}, .None
		case 0x15:
			return SetDelayTimer{vx = x}, .None
		case 0x18:
			return SetSoundTimer{vx = x}, .None
		case 0x1E:
			return AddToIndex{vx = x}, .None
		case 0x29:
			return SetIndexToFontChar{vx = x}, .None
		case 0x33:
			return StoreBCD{vx = x}, .None
		case 0x55:
			return StoreRegisters{vx = x}, .None
		case 0x65:
			return LoadRegisters{vx = x}, .None
		}
	}
	return Null{}, .InvalidInstruction
}
