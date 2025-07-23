# odin-tags

Basic ctags generation for Odin packages

## Build

```bash
$ odin build tags -o:speed -out:bin/tags.exe
```

## Usage

Run the program with whichever packages you want to generate tags for, while also specifying your
output file via the `-o/--output-path` CLI option:

```bash
$ tags.exe --output-path tags my_package C:\users\ricka\code\odin\Odin\core\ C:\users\ricka\code\odin\Odin\vendor\
```

The `tags` file will now have things like the following in it:

```
IResource_UUID_STRING	C:\users\ricka\code\odin\Odin\vendor\directx\d3d12\d3d12.odin	/^IResource_UUID_STRING ::/;"	line:2375
IResource_UUID	C:\users\ricka\code\odin\Odin\vendor\directx\d3d12\d3d12.odin	/^IResource_UUID := &IID{0x696442be, 0xa72e, 0x4059, {0xbc, 0x79, 0x5b, 0x5c, 0x98, 0x04, 0x0f, 0xad}}/;"	line:2376
IResource	C:\users\ricka\code\odin\Odin\vendor\directx\d3d12\d3d12.odin	/^IResource ::/;"	line:2377
IResource_VTable	C:\users\ricka\code\odin\Odin\vendor\directx\d3d12\d3d12.odin	/^IResource_VTable ::/;"	line:2381
ICommandAllocator_UUID_STRING	C:\users\ricka\code\odin\Odin\vendor\directx\d3d12\d3d12.odin	/^ICommandAllocator_UUID_STRING ::/;"	line:2393
ICommandAllocator_UUID	C:\users\ricka\code\odin\Odin\vendor\directx\d3d12\d3d12.odin	/^ICommandAllocator_UUID := &IID{0x6102dee4, 0xaf59, 0x4b09, {0xb9, 0x99, 0xb4, 0x4d, 0x73, 0xf0, 0x9b, 0x24}}/;"	line:2394
ICommandAllocator	C:\users\ricka\code\odin\Odin\vendor\directx\d3d12\d3d12.odin	/^ICommandAllocator ::/;"	line:2395
```

This will allow you to use the file as a basic symbol index for Vim/Neovim (or anything that
supports ctags).
