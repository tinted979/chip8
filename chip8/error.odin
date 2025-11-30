package chip8

Error :: enum {
	None,
	InvalidAddress,
	InvalidOpcode,
	InvalidKey,
	InvalidRegister,
	InvalidPixel,
	StackOverflow,
	StackUnderflow,
	RomTooLarge,
	RomLoadFailed,
	FontSetLoadFailed,
	RomNotLoaded,
}

error_none :: #force_inline proc() -> Error {
	return .None
}

expect :: #force_inline proc(condition: bool, error: Error) -> Error {
	if condition do return error_none()
	return error
}
