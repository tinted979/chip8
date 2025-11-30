package emulator

import "../shared"

// [1NNN] Jump to NNN (addr).
op_jump :: proc(e: ^Emulator, i: Jump) -> shared.Error {
	e.program_counter = i.addr
	return .None
}

// [BNNN] Jump to NNN (addr) + Register V0.
op_jump_with_offset :: proc(e: ^Emulator, i: JumpWithOffset) -> shared.Error {
	v0 := get_register(&e.registers, .V0)
	e.program_counter = i.addr + u16(v0)
	return .None
}

// [2NNN] Call subroutine at NNN (addr).
op_call_subroutine :: proc(e: ^Emulator, i: CallSubroutine) -> shared.Error {
	push_stack(&e.stack, e.program_counter) or_return
	e.program_counter = i.addr
	return .None
}

// [00EE] Return from subroutine.
op_return_from_subroutine :: proc(e: ^Emulator, i: ReturnFromSubroutine) -> shared.Error {
	e.program_counter = pop_stack(&e.stack) or_return
	return .None
}
