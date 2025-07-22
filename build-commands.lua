return {
    ["Build"] = {
        {
            command = "odin build tags -o:none -out:bin/tags.exe -debug -define:DEBUG_TOOLS=true",
            error_pattern = "^(.*)%((%d+):(%d+)%)%s(.*)$",
        }
    },
}
