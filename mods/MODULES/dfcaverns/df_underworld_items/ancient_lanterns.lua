local S = minetest.get_translator(minetest.get_current_modname())

local lantern_nodebox = {
	{-0.5, -0.5, -0.5, -0.3125, 0.5, -0.3125},
	{-0.5, -0.5, 0.3125, -0.3125, 0.5, 0.5},
	{0.3125, -0.5, 0.3125, 0.5, 0.5, 0.5},
	{0.3125, -0.5, -0.5, 0.5, 0.5, -0.3125},
	{-0.3125, 0.3125, -0.5, 0.3125, 0.5, -0.3125},
	{-0.3125, 0.3125, 0.3125, 0.3125, 0.5, 0.5},
	{0.3125, 0.3125, -0.3125, 0.5, 0.5, 0.3125},
	{-0.5, 0.3125, -0.3125, -0.3125, 0.5, 0.3125},
	{-0.5, -0.5, -0.3125, -0.3125, -0.3125, 0.3125},
	{0.3125, -0.5, -0.3125, 0.5, -0.3125, 0.3125},
	{-0.3125, -0.5, 0.3125, 0.3125, -0.3125, 0.5},
	{-0.3125, -0.5, -0.5, 0.3125, -0.3125, -0.3125},
	{-0.375, -0.375, -0.375, 0.375, 0.375, 0.375},
}

local mese_crystal_node = df_dependencies.node_name_mese_crystal
local brick_texture = "dfcaverns_slade_brick.png"
local lantern_texture = df_dependencies.texture_meselamp
local ancient_lantern_sound = df_dependencies.sound_stone({ footstep = { name = "bedrock2_step", gain = 1 } })

local invulnerable = df_underworld_items.config.invulnerable_slade and not minetest.settings:get_bool("creative_mode")

local can_dig
if invulnerable then
	can_dig = function(pos, player)
		return minetest.check_player_privs(player, "server")
	end
end

local slade_mcl_blast_resistance = 1200
local slade_mcl_hardness = 50
local slade_groups = {stone=1, slade=1, pit_plasma_resistant=1, mese_radiation_shield=1, cracky = 3, creative_breakable=1, building_block=1, material_stone=1}
if invulnerable then
	slade_groups.immortal = 1
	slade_mcl_blast_resistance = 3600000
	slade_mcl_hardness = -1
end

-- override this to allow achievements to be recorded without requiring a dependency
df_underworld_items.ancient_lantern_fixed = function(pos, player) end

local punch_fix = function(pos, node, puncher, pointed_thing)
	local wielded = puncher:get_wielded_item()
	if wielded:get_name() == mese_crystal_node then
		minetest.set_node(pos, {name="df_underworld_items:ancient_lantern_slade"})
		minetest.get_node_timer(pos):stop()
		if not minetest.is_creative_enabled(puncher:get_player_name()) then
			wielded:take_item()
			puncher:set_wielded_item(wielded)
		end
		df_underworld_items.ancient_lantern_fixed(pos, puncher)
		return
	end
	minetest.node_punch(pos, node, puncher, pointed_thing)
end

minetest.register_node("df_underworld_items:ancient_lantern_slade", {
	description = S("Ancient Lantern"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {brick_texture .. "^(" .. lantern_texture .. "^[mask:dfcaverns_lantern_mask.png)"},
	is_ground_content = false,
	groups = slade_groups,
	sounds = ancient_lantern_sound,
	drawtype= "nodebox",
	light_source = minetest.LIGHT_MAX,
	node_box = {
		type = "fixed",
		fixed = lantern_nodebox,
	},
	can_dig = can_dig,
	_mcl_blast_resistance = slade_mcl_blast_resistance,
	_mcl_hardness = slade_mcl_hardness,
})

minetest.register_node("df_underworld_items:ancient_lantern_slade_worn", {
	description = S("Ancient Lantern"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {brick_texture .. "^(" .. lantern_texture .. "^[multiply:#FF8888^[mask:dfcaverns_lantern_mask.png)"},
	is_ground_content = false,
	groups = slade_groups,
	sounds = ancient_lantern_sound,
	drawtype= "nodebox",
	light_source = 6,
	node_box = {
		type = "fixed",
		fixed = lantern_nodebox,
	},
	_mcl_blast_resistance = slade_mcl_blast_resistance,
	_mcl_hardness = slade_mcl_hardness,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(100, 200))
	end,
	on_timer = function(pos, elapsed)
		minetest.swap_node(pos, {name="df_underworld_items:ancient_lantern_slade_burnt_out"})
		if math.random() < 0.1 then
			minetest.get_node_timer(pos):start(math.random(30, 60))
		else
			minetest.get_node_timer(pos):start(0.25)
		end
	end,
	on_punch = punch_fix,
	can_dig = can_dig,
})

minetest.register_node("df_underworld_items:ancient_lantern_slade_burnt_out", {
	description = S("Ancient Lantern"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {brick_texture .. "^(" .. lantern_texture .. "^[multiply:#884444^[mask:dfcaverns_lantern_mask.png)"},
	is_ground_content = false,
	groups = slade_groups,
	sounds = ancient_lantern_sound,
	drawtype= "nodebox",
	light_source = 0,
	node_box = {
		type = "fixed",
		fixed = lantern_nodebox,
	},
	drops = "df_underworld_items:ancient_lantern_slade_worn",
	_mcl_blast_resistance = slade_mcl_blast_resistance,
	_mcl_hardness = slade_mcl_hardness,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(100, 200))
	end,
	on_timer = function(pos, elapsed)
		minetest.swap_node(pos, {name="df_underworld_items:ancient_lantern_slade_worn"})
		if math.random() < 0.1 then
			minetest.get_node_timer(pos):start(math.random(300, 600))
		else
			minetest.get_node_timer(pos):start(0.25)
		end
	end,
	on_punch = punch_fix,
	can_dig = can_dig,
})

--minetest.register_craft({
--	output = "df_underworld_items:ancient_lantern_slade",
--	type = "shapeless",
--	recipe = {
--		"group:df_underworld_items_ancient_lantern",
--		mese_crystal_node,
--	}
--})