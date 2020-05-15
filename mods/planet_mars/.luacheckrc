unused_args = false
allow_defined_top = true

globals = {
	"planetoids",
	"vacuum",
	"skybox"
}

read_globals = {
	-- Stdlib
	string = {fields = {"split"}},
	table = {fields = {"copy", "getn"}},

	-- Minetest
	"minetest",
	"vector", "ItemStack",
	"dump", "VoxelArea",

	-- Deps
	"default", "gravity_manager", "bamboo"
}
