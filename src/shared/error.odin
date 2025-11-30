package shared

Error :: enum {
	None,
	MemoryOutOfBounds,
	InvalidInstruction,
	StackOverflow,
	StackUnderflow,
	InvalidRegisterValue,
	InvalidKeyCode,
	FailedToInitializeWindow,
	FailedToInitializeRenderer,
	FailedToInitializeTexture,
}
