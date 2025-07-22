package debug

import "core:fmt"
import "core:log"

DEBUG_TOOLS :: #config(DEBUG_TOOLS, false)

when DEBUG_TOOLS {
	assert :: proc(condition: bool, format: string, args: ..any, location := #caller_location) {
		fmt.assertf(condition = condition, fmt = format, args = args, loc = location)
	}

	log :: proc(fmt: string, args: ..any, location := #caller_location) {
		log.debugf(fmt_str = fmt, args = args, location = location)
	}
	warn :: proc(condition: bool, fmt: string, args: ..any, location := #caller_location) {
		if !condition {
			log.debugf(fmt_str = fmt, args = args, location = location)
		}
	}
} else {
	assert :: proc(condition: bool, message: string, args: ..any, location := #caller_location) {
	}

	log :: proc(fmt: string, args: ..any, location := #caller_location) {
	}

	warn :: proc(condition: bool, fmt: string, args: ..any, location := #caller_location) {
	}
}
