package parser

import "core:fmt"
import "core:os"

import "../shared"

parse_rom_file :: proc(path: string) -> ([]byte, shared.Error) {
	data, ok := os.read_entire_file(path)
	if !ok {
		return nil, .FileNotFound
	}
	return data, .None
}
