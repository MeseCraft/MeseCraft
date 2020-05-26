unused_args = false
allow_defined_top = true
max_line_length = 999

globals = {
    "minetest", "lavastuff",
}

read_globals = {
    string = {fields = {"split"}},
    table = {fields = {"copy", "getn"}},

    -- Builtin
    "vector", "ItemStack",
    "dump", "DIR_DELIM", "VoxelArea", "Settings",

    -- MTG
    "default", "sfinv", "creative", "stairs",

    -- Other mods
    "armor", "stairsplus", "toolranks",
}