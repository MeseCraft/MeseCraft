
unused = false
max_line_length = 240

globals = {
	"drawers"
}

read_globals = {
	-- Stdlib
	string = {fields = {"split"}},
	table = {fields = {"copy", "getn"}},

	-- Minetest
	"vector", "ItemStack",
	"dump", "VoxelArea",

	-- deps
	"minetest",
	"core",
	"default",
	"mcl_core",
	"mcl_sounds",
	"pipeworks",
	"screwdriver",
	"intllib",
	"digilines",
	"mesecon"
}
