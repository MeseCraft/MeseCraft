-- Definitions for standard minetest_game wooden and steel wall signs

signs_lib.register_sign("default:sign_wall_wood", {
	description = "Wooden wall sign",
	inventory_image = "signs_lib_sign_wall_wooden_inv.png",
	tiles = {
		"signs_lib_sign_wall_wooden.png",
		"signs_lib_sign_wall_wooden_edges.png",
		-- items 3 - 5 are not set, so signs_lib will use its standard pole
		-- mount, hanging, and yard sign stick textures.
	},
	entity_info = "standard",
	allow_hanging = true,
	allow_widefont = true,
	allow_onpole = true,
	allow_onpole_horizontal = true,
	allow_yard = true
})

signs_lib.register_sign("default:sign_wall_steel", {
	description = "Steel wall sign",
	inventory_image = "signs_lib_sign_wall_steel_inv.png",
	tiles = {
		"signs_lib_sign_wall_steel.png",
		"signs_lib_sign_wall_steel_edges.png",
		nil, -- not set, so it'll use the standard pole mount texture
		nil, -- not set, so it'll use the standard hanging chains texture
		"default_steel_block.png" -- for the yard sign's stick
	},
	groups = signs_lib.standard_steel_groups,
	sounds = signs_lib.standard_steel_sign_sounds,
	locked = true,
	entity_info = "standard",
	allow_hanging = true,
	allow_widefont = true,
	allow_onpole = true,
	allow_onpole_horizontal = true,
	allow_yard = true
})

minetest.register_alias("signs:sign_hanging",                   "default:sign_wood_hanging")
minetest.register_alias("basic_signs:hanging_sign",             "default:sign_wood_hanging")
minetest.register_alias("signs:sign_yard",                      "default:sign_wood_yard")
minetest.register_alias("basic_signs:yard_sign",                "default:sign_wood_yard")

minetest.register_alias("default:sign_wall_wood_onpole",        "default:sign_wood_onpole")
minetest.register_alias("default:sign_wall_wood_onpole_horiz",  "default:sign_wood_onpole_horiz")
minetest.register_alias("default:sign_wall_wood_hanging",       "default:sign_wood_hanging")
minetest.register_alias("default:sign_wall_wood_yard",          "default:sign_wood_yard")

minetest.register_alias("default:sign_wall_steel_onpole",       "default:sign_steel_onpole")
minetest.register_alias("default:sign_wall_steel_onpole_horiz", "default:sign_steel_onpole_horiz")
minetest.register_alias("default:sign_wall_steel_hanging",      "default:sign_steel_hanging")
minetest.register_alias("default:sign_wall_steel_yard",         "default:sign_steel_yard")


table.insert(signs_lib.lbm_restore_nodes, "signs:sign_hanging")
table.insert(signs_lib.lbm_restore_nodes, "basic_signs:hanging_sign")
table.insert(signs_lib.lbm_restore_nodes, "signs:sign_yard")
table.insert(signs_lib.lbm_restore_nodes, "basic_signs:yard_sign")
table.insert(signs_lib.lbm_restore_nodes, "default:sign_wood_yard")
table.insert(signs_lib.lbm_restore_nodes, "default:sign_wall_wood_yard")

-- insert the old wood sign-on-fencepost into signs_lib's conversion LBM

table.insert(signs_lib.old_fenceposts_with_signs, "signs:sign_post")
signs_lib.old_fenceposts["signs:sign_post"] = "default:fence_wood"
signs_lib.old_fenceposts_replacement_signs["signs:sign_post"] = "default:sign_wall_wood_onpole"
