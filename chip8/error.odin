package chip8

Error :: enum {
	None,
	InvalidAddress,
	InvalidOpcode,
	InvalidKey,
	InvalidRegister,
	StackOverflow,
	StackUnderflow,
	RomTooLarge,
	RomLoadFailed,
	FontSetLoadFailed,
	RomNotLoaded,
}
