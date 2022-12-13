local S = minetest.get_translator(minetest.get_current_modname())

local invulnerable = df_underworld_items.config.invulnerable_slade and not minetest.settings:get_bool("creative_mode")

local server_diggable_only = function(pos, player)
	if player then
		return minetest.check_player_privs(player, "server")
	end
	return false
end

local add_immortality = function(slade_def)
	slade_def.groups.immortal = 1
	slade_def.can_dig = server_diggable_only
	return slade_def
end

local slade_groups = {cracky=3, stone=1, slade=1, pit_plasma_resistant=1, mese_radiation_shield=1,creative_breakable=1, building_block=1, material_stone=1}

local slade_def = {
	description = S("Slade"),
	_doc_items_longdesc = df_underworld_items.doc.slade_desc,
	_doc_items_usagehelp = df_underworld_items.doc.slade_usage,
	tiles = {"dfcaverns_slade.png"},
	groups = slade_groups,
	sounds = df_dependencies.sound_stone({ footstep = { name = "bedrock2_step", gain = 1 } }),
	is_ground_content = false,
	_mcl_blast_resistance = 8,
	_mcl_hardness = 5,
	on_blast = function(pos, intensity)
		if intensity >= 1.0 then
			minetest.set_node(pos, {name="df_underworld_items:slade_sand"})
			minetest.check_for_falling(pos)
		end
	end,
}
if invulnerable then
	add_immortality(slade_def)
	slade_def._mcl_blast_resistance = 8
	slade_def._mcl_hardness = 5
end
minetest.register_node("df_underworld_items:slade", slade_def)

local slade_brick_def = {
	description = S("Slade Brick"),
	_doc_items_longdesc = df_underworld_items.doc.slade_desc,
	_doc_items_usagehelp = df_underworld_items.doc.slade_usage,
	tiles = {"dfcaverns_slade_brick.png"},
	groups = slade_groups,
	sounds = df_dependencies.sound_stone({ footstep = { name = "bedrock2_step", gain = 1 } }),
	is_ground_content = false,
	_mcl_blast_resistance = 8,
	_mcl_hardness = 5,
}
if invulnerable then
	add_immortality(slade_brick_def)
end
minetest.register_node("df_underworld_items:slade_brick", slade_brick_def)

-- can't use "wall=1" because MCL has special handling for nodes in that group that explodes if it tries handling this one.
-- fortunately minetest_game walls also connect to group fence, so this should be fine.
local slade_wall_groups = {fence=1}
for key, val in pairs(slade_groups) do
	slade_wall_groups[key]=val
end
local slade_wall_def = {
	description = S("Slade Wall"),
	drawtype = "nodebox",
	node_box = {
		type = "connected",
		fixed = {{-1/4, -1/2, -1/4, 1/4, 1/2, 1/4}},
		-- connect_bottom =
		connect_front = {{-3/16, -1/2, -1/2,  3/16, 3/8, -1/4}},
		connect_left = {{-1/2, -1/2, -3/16, -1/4, 3/8,  3/16}},
		connect_back = {{-3/16, -1/2,  1/4,  3/16, 3/8,  1/2}},
		connect_right = {{ 1/4, -1/2, -3/16,  1/2, 3/8,  3/16}},
	},
	connects_to = { "group:wall", "group:stone", "group:fence" },
	paramtype = "light",
	tiles = {"dfcaverns_slade_brick.png"},
	walkable = true,
	is_ground_content = false,
	groups = slade_wall_groups,
	sounds = df_dependencies.sound_stone({ footstep = { name = "bedrock2_step", gain = 1 } }),
	_mcl_blast_resistance = 8,
	_mcl_hardness = 5,
}
if invulnerable then
	add_immortality(slade_wall_def)
end
minetest.register_node("df_underworld_items:slade_wall", slade_wall_def)

minetest.register_node("df_underworld_items:slade_sand", {
	description = S("Slade Sand"),
	_doc_items_longdesc = df_underworld_items.doc.slade_desc,
	_doc_items_usagehelp = df_underworld_items.doc.slade_usage,
	tiles = {"dfcaverns_slade_sand.png"},
	is_ground_content = false,
	groups = {crumbly = 3, falling_node = 1, slade=1, pit_plasma_resistant=1, mese_radiation_shield=1,handy=1,shovely=3, sand=1, enderman_takable=1, building_block=1, material_sand=1, crush_after_fall=1, falling_node_damage=1},
	sounds = df_dependencies.sound_gravel({footstep = {name = df_dependencies.soundfile_gravel_footstep, gain = 0.45},}),
	_mcl_blast_resistance = 8,
	_mcl_hardness = 3,
})

local slade_block_def = {
	description = S("Slade Block"),
	_doc_items_longdesc = df_underworld_items.doc.slade_desc,
	_doc_items_usagehelp = df_underworld_items.doc.slade_usage,
	tiles = {"dfcaverns_slade_block.png"},
	groups = slade_groups,
	sounds = df_dependencies.sound_stone({ footstep = { name = "bedrock2_step", gain = 1 } }),
	is_ground_content = false,
	_mcl_blast_resistance = 1200,
	_mcl_hardness = 50,
}
if invulnerable then
	add_immortality(slade_block_def)
	slade_block_def.on_blast = function() end
end
minetest.register_node("df_underworld_items:slade_block", slade_block_def)


local slade_seal_def = {
	description = S("Slade Seal"),
	_doc_items_longdesc = df_underworld_items.doc.slade_seal_desc,
	_doc_items_usagehelp = df_underworld_items.doc.slade_usage,
	tiles = {"dfcaverns_slade_block.png^dfcaverns_seal.png", "dfcaverns_slade_block.png"},
	groups = slade_groups,
	sounds = df_dependencies.sound_stone({ footstep = { name = "bedrock2_step", gain = 1 } }),
	is_ground_content = false,
	_mcl_blast_resistance = 1200,
	_mcl_hardness = 50,
}
if invulnerable then
	slade_seal_def.on_blast = function() end
	add_immortality(slade_seal_def)
end
minetest.register_node("df_underworld_items:slade_seal", slade_seal_def)

minetest.register_craft({
	type = "shapeless",
	output = "df_underworld_items:slade_brick",
	recipe = {
		"df_underworld_items:slade_sand",
		df_dependencies.node_name_bucket_lava,
	},
	replacements = {{df_dependencies.node_name_bucket_lava, df_dependencies.node_name_bucket_empty}},
})

minetest.register_abm{
	label = "slade seal scratching",
	nodenames = {"df_underworld_items:slade_seal"},
	interval = 10,
	chance = 20,
	catch_up = false,
	action = function(pos)
		minetest.sound_play({name="dfcaverns_grinding_stone"},
		{
			pos = pos,
			gain = 0.05,
			max_hear_distance = 32,
		}
	)
	end,
}


-- Register stair and slab

df_dependencies.register_stairs("slade_brick")

if invulnerable then
	for name, def in pairs(minetest.registered_nodes) do
		if (name:sub(1,7) == "stairs:" and name:sub(-11) == "slade_block") or 
			name:sub(1,11) == "mcl_stairs:" and name:sub(-11) == "slade_brick" then
				minetest.override_item(name, {can_dig = server_diggable_only})			
		end
	end
end


if minetest.get_modpath("mesecons_mvps") and df_underworld_items.config.invulnerable_slade then
	mesecon.register_mvps_stopper("df_underworld_items:slade")
end