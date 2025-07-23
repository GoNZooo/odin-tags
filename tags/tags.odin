package tags

import "core:fmt"
import "core:log"
import "core:odin/ast"
import "core:odin/parser"
import "core:os"
import "core:os/os2"
import "core:strings"

import "../cli"
import "../debug"

Cli_Input_Options :: struct {
	output_path: string `cli:"o,output-path/required"`,
}

Visitor_Data :: struct {
	depth: u32,
}

main :: proc() {
	context.logger = log.create_console_logger()

	if len(os.args) < 2 {
		fmt.printfln("Usage: %s <package-paths ...>", os.args[0])

		os.exit(1)
	}

	options, paths, cli_error := cli.parse_arguments_as_type(os.args[1:], Cli_Input_Options)
	if cli_error != nil {
		fmt.printfln("Unable to parse CLI arguments: %v", cli_error)

		os.exit(1)
	}

	if len(paths) == 0 {
		fmt.printfln("No paths passed for tag generation")

		os.exit(1)
	}

	s: strings.Builder
	strings.builder_init_none(&s, allocator = context.allocator)

	for path in paths {
		package_write(&s, package_path = path)
	}

	tag_output := strings.to_string(s)
	write_ok := os.write_entire_file(options.output_path, transmute([]byte)tag_output)
	if !write_ok {
		fmt.printfln("Unable to write to output file '%s'", options.output_path)

		os.exit(1)
	}
}

@(private = "file")
package_write :: proc(
	s: ^strings.Builder,
	package_path: string,
	allocator := context.allocator,
) -> (
	error: os2.Error,
) {
	package_value, parse_ok := parser.parse_package_from_path(package_path)
	if parse_ok {
		declarations_write(s, package_value)
	}

	files := os2.read_all_directory_by_path(package_path, allocator = allocator) or_return
	for f in files {
		#partial switch f.type {
		case .Directory:
			package_write(s, package_path = f.fullpath, allocator = allocator) or_return
		}
	}

	return nil
}

@(private = "file")
declarations_write :: proc(s: ^strings.Builder, pkg: ^ast.Package) {
	for _, file in pkg.files {
		for declaration in file.decls {
			#partial switch t in declaration.derived_stmt {
			case ^ast.Import_Decl:

			case ^ast.Value_Decl:
				if len(t.values) == 0 {
					continue
				}

				name := file.src[t.names[0].pos.offset:t.names[0].end.offset]
                line_number := declaration.pos.line
				#partial switch tt in t.values[0].derived_expr {
				case ^ast.Proc_Lit:
					d := declaration
					function_text := file.src[d.pos.offset:tt.type.pos.offset]
					function_write(s, file_path = file.fullpath, name = name, function_text = function_text, line_number = line_number)

				case ^ast.Distinct_Type:
					d := declaration
					text := file.src[d.pos.offset:d.end.offset]
					plain_write(s, file_path = file.fullpath, name = name, text = text, line_number = line_number)

				case ^ast.Struct_Type:
					type_write(s, file_path = file.fullpath, name = name, line_number = line_number)

				case ^ast.Union_Type:
					type_write(s, file_path = file.fullpath, name = name, line_number = line_number)

				case ^ast.Enum_Type:
					type_write(s, file_path = file.fullpath, name = name, line_number = line_number)

				case ^ast.Proc_Group:
					type_write(s, file_path = file.fullpath, name = name, line_number = line_number)

				case ^ast.Bit_Field_Type:
					type_write(s, file_path = file.fullpath, name = name, line_number = line_number)

				case ^ast.Basic_Lit:
					d := declaration
					text := file.src[d.pos.offset:d.pos.offset + len(name) + 3]
					plain_write(s, file_path = file.fullpath, name = name, text = text, line_number = line_number)

				case ^ast.Array_Type:
					d := declaration
					text := file.src[d.pos.offset:tt.open.offset]
					plain_write(s, file_path = file.fullpath, name = name, text = text, line_number = line_number)

				case ^ast.Matrix_Type:
					d := declaration
					text := file.src[d.pos.offset:d.end.offset]
					plain_write(s, file_path = file.fullpath, name = name, text = text, line_number = line_number)

				case ^ast.Map_Type:
					d := declaration
					text := file.src[d.pos.offset:d.end.offset]
					plain_write(s, file_path = file.fullpath, name = name, text = text, line_number = line_number)

				case ^ast.Pointer_Type:
					d := declaration
					text := file.src[d.pos.offset:d.end.offset]
					plain_write(s, file_path = file.fullpath, name = name, text = text, line_number = line_number)

				case ^ast.Binary_Expr:
					d := declaration
					text := file.src[d.pos.offset:d.pos.offset + len(name) + 3]
					plain_write(s, file_path = file.fullpath, name = name, text = text, line_number = line_number)

				case ^ast.Unary_Expr:
					d := declaration
					text := file.src[d.pos.offset:d.end.offset]
					plain_write(s, file_path = file.fullpath, name = name, text = text, line_number = line_number)

				case ^ast.Bit_Set_Type:
					d := declaration
					text := file.src[d.pos.offset:d.end.offset]
					plain_write(s, file_path = file.fullpath, name = name, text = text, line_number = line_number)

				case ^ast.Comp_Lit:
					d := declaration
					end_offset := len(tt.elems) >= 1 ? tt.open.offset : d.end.offset
					text := file.src[d.pos.offset:end_offset]
					plain_write(s, file_path = file.fullpath, name = name, text = text, line_number = line_number)

				case ^ast.Ident:
					d := declaration
					text := file.src[d.pos.offset:d.end.offset]
					plain_write(s, file_path = file.fullpath, name = name, text = text, line_number = line_number)

				case ^ast.Type_Cast:
					d := declaration
					text := file.src[d.pos.offset:d.end.offset]
					plain_write(s, file_path = file.fullpath, name = name, text = text, line_number = line_number)

				case ^ast.Ternary_When_Expr:
					d := declaration
					text := file.src[d.pos.offset:d.pos.offset + len(name) + 3]
					plain_write(s, file_path = file.fullpath, name = name, text = text, line_number = line_number)

				case ^ast.Ternary_If_Expr:
					d := declaration
					text := file.src[d.pos.offset:d.end.offset]
					plain_write(s, file_path = file.fullpath, name = name, text = text, line_number = line_number)

				case ^ast.Helper_Type:
					d := declaration
					text := file.src[d.pos.offset: tt.type.pos.offset]
					plain_write(s, file_path = file.fullpath, name = name, text = text, line_number = line_number)

				case ^ast.Proc_Type:
					d := declaration
					text := file.src[d.pos.offset:d.pos.offset + len(name) + 3]
					plain_write(s, file_path = file.fullpath, name = name, text = text, line_number = line_number)

				case ^ast.Selector_Expr:
					d := declaration
					text := file.src[d.pos.offset:d.end.offset]
					plain_write(s, file_path = file.fullpath, name = name, text = text, line_number = line_number)

				case ^ast.Call_Expr:
					d := declaration
					text := file.src[d.pos.offset:d.end.offset]
					plain_write(s, file_path = file.fullpath, name = name, text = text, line_number = line_number)

				case ^ast.Multi_Pointer_Type:
					d := declaration
					text := file.src[d.pos.offset:d.end.offset]
					plain_write(s, file_path = file.fullpath, name = name, text = text, line_number = line_number)

				case ^ast.Paren_Expr:
					d := declaration
					text := file.src[d.pos.offset:tt.open.offset]
					plain_write(s, file_path = file.fullpath, name = name, text = text, line_number = line_number)

				case ^ast.Tag_Expr:
					d := declaration
					text := file.src[d.pos.offset:d.end.offset]
					plain_write(s, file_path = file.fullpath, name = name, text = text, line_number = line_number)

				case ^ast.Dynamic_Array_Type:
					d := declaration
					text := file.src[d.pos.offset:d.end.offset]
					plain_write(s, file_path = file.fullpath, name = name, text = text, line_number = line_number)

				case ^ast.Slice_Expr:
					d := declaration
					text := file.src[d.pos.offset:tt.open.offset]
					plain_write(s, file_path = file.fullpath, name = name, text = text, line_number = line_number)

				case:
					debug.log("other(%s)=%v", name, tt)
				}

			case:
			//debug.log("other=%v", t)
			}
		}
	}
}

@(private = "file")
function_write :: proc(s: ^strings.Builder, file_path: string, name: string, function_text: string, line_number: int) {
	sanitized_function_text, _ := strings.replace_all(function_text, "\r", "")

	strings.write_string(s, name)
	strings.write_byte(s, '\t')
	strings.write_string(s, file_path)
	strings.write_string(s, "\t/^")
	strings.write_string(s, sanitized_function_text)
	strings.write_string(s, "/;\"\tline:")
    strings.write_int(s, line_number)
    strings.write_byte(s, '\n')
}

@(private = "file")
type_write :: proc(s: ^strings.Builder, file_path: string, name: string, line_number: int) {
	strings.write_string(s, name)
	strings.write_byte(s, '\t')
	strings.write_string(s, file_path)
	strings.write_string(s, "\t/^")
	strings.write_string(s, name)
	strings.write_string(s, " ::")
	strings.write_string(s, "/;\"\tline:")
    strings.write_int(s, line_number)
    strings.write_byte(s, '\n')
}

@(private = "file")
plain_write :: proc(s: ^strings.Builder, file_path: string, name: string, text: string, line_number: int) {
	strings.write_string(s, name)
	strings.write_byte(s, '\t')
	strings.write_string(s, file_path)
	strings.write_string(s, "\t/^")
	strings.write_string(s, text)
	strings.write_string(s, "/;\"\tline:")
    strings.write_int(s, line_number)
    strings.write_byte(s, '\n')
}
