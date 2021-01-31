
local sbox = {
	type = "fixed",
	fixed = {-5/16, -8/16, -6/16, 5/16, -1/32, 5/16},
}

local crystal_list = {   
	{"ghost_crystal", "ghost_crystal.png",},
	{"red_crystal", "red_crystal.png",},
	{"rose_quartz", "rose_quartz.png",},
}

for i in ipairs(crystal_list) do
	local name = crystal_list[i][1]
	local texture = crystal_list[i][2]

	minetest.register_node(":crystals:"..name.."_1", {
		description = "Glowing Crystal",
		drawtype = "mesh",
		mesh = "crystal_shape01.obj",
		tiles = {"crystals_"..texture,},
		paramtype = "light",
		paramtype2 = "facedir",
		selection_box = sbox,
		walkable = false,
		light_source = 10,
		use_texture_alpha = true,
		visual_scale = 10,
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3,},
		sounds = default.node_sound_glass_defaults(),
	})

	minetest.register_node(":crystals:"..name.."_2", {
		description = "Glowing Crystal",
		drawtype = "mesh",
		mesh = "crystal_shape02.obj",
		tiles = {"crystals_"..texture,},
		paramtype = "light",
		paramtype2 = "facedir",
		selection_box = sbox,
		walkable = false,
		light_source = 10,
		use_texture_alpha = true,
		visual_scale = 10,
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3,},
		sounds = default.node_sound_glass_defaults(),
	})
end


