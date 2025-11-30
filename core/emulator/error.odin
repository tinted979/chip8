package emulator

Error :: enum {
	None,
	MemoryOutOfBounds,
	InvalidInstruction,
	StackOverflow,
	StackUnderflow,
	InvalidRegisterValue,
	InvalidKeyCode,
}
