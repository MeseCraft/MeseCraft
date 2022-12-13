--[[

  Nether mod for minetest

  Copyright (C) 2013 PilzAdam

  Permission to use, copy, modify, and/or distribute this software for
  any purpose with or without fee is hereby granted, provided that the
  above copyright notice and this permission notice appear in all copies.

  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
  WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR
  BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES
  OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
  WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
  ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
  SOFTWARE.

]]--

local S = nether.get_translator

-- Portal/wormhole nodes

nether.register_wormhole_node("nether:portal", {
	description = S("Nether Portal"),
	post_effect_color = {
		-- post_effect_color can't be changed dynamically in Minetest like the portal colour is.
		-- If you need a different post_effect_color then use register_wormhole_node to create
		-- another wormhole node and set it as the wormhole_node_name in your portaldef.
		-- Hopefully this colour is close enough to magenta to work with the traditional magenta
		-- portals, close enough to red to work for a red portal, and also close enough to red to
		-- work with blue & cyan portals - since blue portals are sometimes portrayed as being red
		-- from the opposite side / from the inside.
		a = 160, r = 128, g = 0, b = 80
	}
})

local portal_animation2 = {
	name = "nether_portal_alt.png",
	animation = {
		type = "vertical_frames",
		aspect_w = 16,
		aspect_h = 16,
		length = 0.5,
	},
}

nether.register_wormhole_node("nether:portal_alt", {
	description = S("Portal"),
	tiles = {
		"nether_transparent.png",
		"nether_transparent.png",
		"nether_transparent.png",
		"nether_transparent.png",
		portal_animation2,
		portal_animation2
	},
	post_effect_color = {
		-- hopefully blue enough to work with blue portals, and green enough to
		-- work with cyan portals.
		a = 120, r = 0, g = 128, b = 188
	}
})


-- Nether nodes

minetest.register_node("nether:rack", {
	description = S("Netherrack"),
	tiles = {"nether_rack.png"},
	is_ground_content = true,
	groups = {cracky = 3, level = 2},
	sounds = default.node_sound_stone_defaults(),
})

-- Deep Netherrack, found in the mantle / central magma layers
minetest.register_node("nether:rack_deep", {
	description = S("Deep Netherrack"),
	_doc_items_longdesc = S("Netherrack from deep in the mantle"),
	tiles = {"nether_rack_deep.png"},
	is_ground_content = true,
	groups = {cracky = 3, level = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("nether:sand", {
	description = S("Nethersand"),
	tiles = {"nether_sand.png"},
	is_ground_content = true,
	groups = {crumbly = 3, level = 2, falling_node = 1},
	sounds = default.node_sound_gravel_defaults({
		footstep = {name = "default_gravel_footstep", gain = 0.45},
	}),
})

minetest.register_node("nether:glowstone", {
	description = S("Glowstone"),
	tiles = {"nether_glowstone.png"},
	is_ground_content = true,
	light_source = 14,
	paramtype = "light",
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_glass_defaults(),
})

-- Deep glowstone, found in the mantle / central magma layers
minetest.register_node("nether:glowstone_deep", {
	description = S("Deep Glowstone"),
	tiles = {"nether_glowstone_deep.png"},
	is_ground_content = true,
	light_source = 14,
	paramtype = "light",
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("nether:brick", {
	description = S("Nether Brick"),
	tiles = {"nether_brick.png"},
	is_ground_content = false,
	groups = {cracky = 2, level = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("nether:brick_compressed", {
	description = S("Compressed Netherbrick"),
	tiles = {"nether_brick_compressed.png"},
	groups = {cracky = 3, level = 2},
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),
})

-- A decorative node which can only be obtained from dungeons or structures
minetest.register_node("nether:brick_cracked", {
	description = S("Cracked Nether Brick"),
	tiles = {"nether_brick_cracked.png"},
	is_ground_content = false,
	groups = {cracky = 2, level = 2},
	sounds = default.node_sound_stone_defaults(),
})

local fence_texture =
	"default_fence_overlay.png^nether_brick.png^default_fence_overlay.png^[makealpha:255,126,126"

minetest.register_node("nether:fence_nether_brick", {
	description = S("Nether Brick Fence"),
	drawtype = "fencelike",
	tiles = {"nether_brick.png"},
	inventory_image = fence_texture,
	wield_image = fence_texture,
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
	},
	groups = {cracky = 2, level = 2},
	sounds = default.node_sound_stone_defaults(),
})


-- Register stair and slab

stairs.register_stair_and_slab(
	"nether_brick",
	"nether:brick",
	{cracky = 2, level = 2},
	{"nether_brick.png"},
	S("Nether Stair"),
	S("Nether Slab"),
	default.node_sound_stone_defaults(),
	nil,
	S("Inner Nether Stair"),
	S("Outer Nether Stair")
)

stairs.register_stair(
	"netherrack",
	"nether:rack",
	{cracky = 2, level = 2},
	{"nether_rack.png"},
	S("Netherrack stair"),
	default.node_sound_stone_defaults()
)

-- StairsPlus

if minetest.get_modpath("moreblocks") then
	stairsplus:register_all(
		"nether", "brick", "nether:brick", {
			description = S("Nether Brick"),
			groups = {cracky = 2, level = 2},
			tiles = {"nether_brick.png"},
			sounds = default.node_sound_stone_defaults(),
	})
end


-- Mantle nodes

-- Nether basalt is intended as a valuable material and possible portalstone - an alternative to
-- obsidian that's available for other mods to use.
-- It cannot be found in the regions of the nether where Nether portals link to, so requires a journey to obtain.
minetest.register_node("nether:basalt", {
	description = S("Nether Basalt"),
	_doc_items_longdesc = S("Columns of dark basalt found only in magma oceans deep within the Nether."),
	tiles = {
		"nether_basalt.png",
		"nether_basalt.png",
		"nether_basalt_side.png",
		"nether_basalt_side.png",
		"nether_basalt_side.png",
		"nether_basalt_side.png"
	},
	is_ground_content = true,
	groups = {cracky = 1, level = 3}, -- set proper digging times and uses, and maybe explosion immune if api handles that
	on_blast = function() --[[blast proof]] end,
	sounds = default.node_sound_stone_defaults(),
})

-- Potentially a portalstone, but will also be a stepping stone between basalt
-- and chiseled basalt.
-- It can only be introduced by the biomes-based mapgen, since it requires the
-- MT 5.0 world-align texture features.
minetest.register_node("nether:basalt_hewn", {
	description = S("Hewn Basalt"),
	_doc_items_longdesc = S("A rough cut solid block of Nether Basalt."),
	tiles = {{
		name        = "nether_basalt_hewn.png",
		align_style = "world",
		scale       = 2
	}},
	inventory_image = minetest.inventorycube(
		"nether_basalt_hewn.png^[sheet:2x2:0,0",
		"nether_basalt_hewn.png^[sheet:2x2:0,1",
		"nether_basalt_hewn.png^[sheet:2x2:1,1"
	),
	is_ground_content = false,
	groups = {cracky = 1, level = 2},
	on_blast = function() --[[blast proof]] end,
	sounds = default.node_sound_stone_defaults(),
})

-- Chiselled basalt is intended as a portalstone - an alternative to obsidian that's
-- available for other mods to use. It is crafted from Hewn Basalt.
-- It should only be introduced by the biomes-based mapgen, since in future it may
-- require the MT 5.0 world-align texture features.
minetest.register_node("nether:basalt_chiselled", {
	description = S("Chiselled Basalt"),
	_doc_items_longdesc = S("A finely finished block of solid Nether Basalt."),
	tiles = {
		"nether_basalt_chiselled_top.png",
		"nether_basalt_chiselled_top.png" .. "^[transformFY",
		"nether_basalt_chiselled_side.png",
		"nether_basalt_chiselled_side.png",
		"nether_basalt_chiselled_side.png",
		"nether_basalt_chiselled_side.png"
	},
	inventory_image = minetest.inventorycube(
		"nether_basalt_chiselled_top.png",
		"nether_basalt_chiselled_side.png",
		"nether_basalt_chiselled_side.png"
	),
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {cracky = 1, level = 2},
	on_blast = function() --[[blast proof]] end,
	sounds = default.node_sound_stone_defaults(),
})


-- Lava-sea source
-- This is a lava source using a different animated texture so that each node
-- is out of phase in its animation from its neighbor. This prevents the magma
-- ocean from visually clumping together into a patchwork of 16x16 squares.
-- It can only be used by the biomes-based mapgen, since it requires the MT 5.0
-- world-align texture features.
local lavasea_source = {}
local lava_source = minetest.registered_nodes["default:lava_source"]
for key, value in pairs(lava_source) do lavasea_source[key] = value end
lavasea_source.name = nil
lavasea_source.tiles = {
	{
		name             = "nether_lava_source_animated.png",
		backface_culling = false,
		align_style      = "world",
		scale            = 2,
		animation = {
			type     = "vertical_frames",
			aspect_w = 32,
			aspect_h = 32,
			length   = 3.0,
		},
	},
	{
		name             = "nether_lava_source_animated.png",
		backface_culling = true,
		align_style      = "world",
		scale            = 2,
		animation = {
			type     = "vertical_frames",
			aspect_w = 32,
			aspect_h = 32,
			length   = 3.0,
		},
	},
}
lavasea_source.groups = { not_in_creative_inventory = 1 } -- Avoid having two lava source blocks in the inv.
for key, value in pairs(lava_source.groups) do lavasea_source.groups[key] = value end
lavasea_source.liquid_alternative_source = "nether:lava_source"
lavasea_source.inventory_image = minetest.inventorycube(
	"nether_lava_source_animated.png^[sheet:2x16:0,0",
	"nether_lava_source_animated.png^[sheet:2x16:0,1",
	"nether_lava_source_animated.png^[sheet:2x16:1,1"
)
minetest.register_node("nether:lava_source", lavasea_source)


-- a place to store the original ABM function so nether.cool_lava() can call it
local original_cool_lava_action

nether.cool_lava = function(pos, node)

	local pos_above = {x = pos.x, y = pos.y + 1, z = pos.z}
	local node_above = minetest.get_node(pos_above)

	-- Evaporate water sitting above lava, if it's in the Nether.
	-- (we don't want Nether mod to affect overworld lava mechanics)
	if minetest.get_item_group(node_above.name, "water") > 0 and
		pos.y < nether.DEPTH_CEILING and pos.y > nether.DEPTH_FLOOR then
		-- cools_lava might be a better group to check for, but perhaps there's
		-- something in that group that isn't a liquid and shouldn't be evaporated?
		minetest.swap_node(pos_above, {name="air"})
	end

	-- add steam to cooling lava
	minetest.add_particlespawner({
		amount = 20,
		time = 0.15,
		minpos = {x=pos.x - 0.4, y=pos.y - 0,   z=pos.z - 0.4},
		maxpos = {x=pos.x + 0.4, y=pos.y + 0.5, z=pos.z + 0.4},
		minvel = {x = -0.5, y = 0.5, z = -0.5},
		maxvel = {x =  0.5, y = 1.5, z =  0.5},
		minacc = {x = 0, y = 0.1, z = 0},
		maxacc = {x = 0, y = 0.2, z = 0},
		minexptime = 0.5,
		maxexptime = 1.3,
		minsize = 1.5,
		maxsize = 3.5,
		texture = "nether_particle_anim4.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 7,
			aspect_h = 7,
			length = 1.4,
		}
	})

	if node.name == "nether:lava_source" or node.name == "nether:lava_crust" then
		-- use swap_node to avoid triggering the lava_crust's after_destruct
		minetest.swap_node(pos, {name = "nether:basalt"})

		minetest.sound_play("default_cool_lava",
			{pos = pos, max_hear_distance = 16, gain = 0.25}, true)
	else
		-- chain the original ABM action to handle conventional lava
		original_cool_lava_action(pos, node)
	end
end


minetest.register_on_mods_loaded(function()

	-- register a bucket of Lava-sea source - but make it just the same bucket as default lava.
	-- (by doing this in register_on_mods_loaded we don't need to declare a soft dependency)
	if minetest.get_modpath("bucket") and minetest.global_exists("bucket") and type(bucket.liquids) == "table" then
		local lava_bucket = bucket.liquids["default:lava_source"]
		if lava_bucket ~= nil then
			local lavasea_bucket = {}
			for key, value in pairs(lava_bucket) do lavasea_bucket[key] = value end
			lavasea_bucket.source = "nether:lava_source"
			bucket.liquids[lavasea_bucket.source] = lavasea_bucket
		end
	end

	-- include "nether:lava_source" in any "default:lava_source" ABMs
	local function include_nether_lava(set_of_nodes)
		if (type(set_of_nodes) == "table") then
			for _, nodename in pairs(set_of_nodes) do
				if nodename == "default:lava_source" then
					-- I'm amazed this works, but it does
					table.insert(set_of_nodes, "nether:lava_source")
					break;
				end
			end
		end
	end

	for _, abm in pairs(minetest.registered_abms) do
		include_nether_lava(abm.nodenames)
		include_nether_lava(abm.neighbors)
		if abm.label == "Lava cooling" and abm.action ~= nil then
			-- lets have lava_crust cool as well
			original_cool_lava_action = abm.action
			abm.action = nether.cool_lava
			table.insert(abm.nodenames, "nether:lava_crust")
		end
	end
	for _, lbm in pairs(minetest.registered_lbms) do
		include_nether_lava(lbm.nodenames)
	end
	--minetest.log("minetest.registered_abms" .. dump(minetest.registered_abms))
	--minetest.log("minetest.registered_lbms" .. dump(minetest.registered_lbms))
end)

-- creates a lava splash, and leaves lava_source in place of the lava_crust
local function smash_lava_crust(pos, playsound)

	local lava_particlespawn_def = {
		amount = 6,
		time = 0.1,
		minpos = {x=pos.x - 0.5, y=pos.y + 0.3, z=pos.z - 0.5},
		maxpos = {x=pos.x + 0.5, y=pos.y + 0.5, z=pos.z + 0.5},
		minvel = {x = -1.5, y = 1.5, z = -1.5},
		maxvel = {x =  1.5, y = 5,   z =  1.5},
		minacc = {x = 0, y = -10, z = 0},
		maxacc = {x = 0, y = -10, z = 0},
		minexptime = 1,
		maxexptime = 1,
		minsize = .2,
		maxsize = .8,
		texture = "^[colorize:#A00:255",
		glow = 8
	}
	minetest.add_particlespawner(lava_particlespawn_def)
	lava_particlespawn_def.texture = "^[colorize:#FB0:255"
	lava_particlespawn_def.maxvel.y = 3
	lava_particlespawn_def.glow = 12
	minetest.add_particlespawner(lava_particlespawn_def)

	minetest.set_node(pos, {name = "default:lava_source"})

	if math.random(1, 3) == 1 and minetest.registered_nodes["fire:basic_flame"] ~= nil then
		-- occasionally brief flames will be seen when breaking lava crust
		local posAbove = {x = pos.x, y = pos.y + 1, z = pos.z}
		if minetest.get_node(posAbove).name == "air" then
			minetest.set_node(posAbove, {name = "fire:basic_flame"})
			minetest.get_node_timer(posAbove):set(math.random(7, 15) / 10, 0)
			--[[ commented out because the flame sound plays for too long
			if minetest.global_exists("fire") and fire.update_player_sound ~= nil then
				-- The fire mod only updates its sound every 3 seconds, these flames will be
				-- out by then, so start the sound immediately
				local players = minetest.get_connected_players()
				for n = 1, #players do fire.update_player_sound(players[n]) end
			end]]
		end
	end

	if playsound then
		minetest.sound_play(
			"nether_lava_bubble",
			-- this sample was encoded at 3x speed to reduce .ogg file size
			-- at the expense of higher frequencies, so pitch it down ~3x
			{pos = pos, pitch = 0.3, max_hear_distance = 8, gain = 0.4}
		)
	end
end


-- lava_crust nodes can only be used in the biomes-based mapgen, since they require
-- the MT 5.0 world-align texture features.
minetest.register_node("nether:lava_crust", {
	description = S("Lava Crust"),
	_doc_items_longdesc = S("A thin crust of cooled lava with liquid lava beneath"),
	_doc_items_usagehelp = S("Lava crust is strong enough to walk on, but still hot enough to inflict burns."),
	tiles = {
		{
			name="nether_lava_crust_animated.png",
			backface_culling=true,
			tileable_vertical=true,
			tileable_horizontal=true,
			align_style="world",
			scale=2,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 1.8,
			},
		}
	},
	inventory_image = minetest.inventorycube(
		"nether_lava_crust_animated.png^[sheet:2x48:0,0",
		"nether_lava_crust_animated.png^[sheet:2x48:0,1",
		"nether_lava_crust_animated.png^[sheet:2x48:1,1"
	),
	collision_box = {
		type = "fixed",
		fixed = {
			-- Damage is calculated "starting 0.1 above feet
			-- and progressing upwards in 1 node intervals", so
			-- lower this node's collision box by more than 0.1
			-- to ensure damage will be taken when standing on
			-- the node.
			{-0.5, -0.5, -0.5, 0.5, 0.39, 0.5}
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			-- Keep the selection box matching the visual node,
			-- rather than the collision_box.
			{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
		},
	},

	after_destruct = function(pos, oldnode)
		smash_lava_crust(pos, true)
	end,
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
	end,
	on_blast = function(pos, intensity)
		smash_lava_crust(pos, false)
	end,

	paramtype = "light",
	light_source = default.LIGHT_MAX - 3,
	buildable_to = false,
	walkable = true,
	is_ground_content = true,
	drop = {
		items = {{
			-- Allow SilkTouch-esque "pickaxes of preservation" to mine the lava crust intact, if PR #10141 gets merged.
			tools = {"this line will block early MT versions which don't respect the tool_groups restrictions"},
			tool_groups = {{"pickaxe", "preservation"}},
			items = {"nether:lava_crust"}
		}}
	},
	--liquid_viscosity = 7,
	damage_per_second = 2,
	groups = {oddly_breakable_by_hand = 3, cracky = 3, explody = 1, igniter = 1},
})


-- Fumaroles (Chimney's)

local function fumarole_startTimer(pos, timeout_factor)

	if timeout_factor == nil then timeout_factor = 1 end
	local next_timeout = (math.random(50, 900) / 10) * timeout_factor

	minetest.get_meta(pos):set_float("expected_timeout", next_timeout)
	minetest.get_node_timer(pos):start(next_timeout)
end

-- Create an LBM to start fumarole node timers
minetest.register_lbm({
	label = "Start fumarole smoke",
	name  = "nether:start_fumarole",
	nodenames = {"nether:fumarole"},
	run_at_every_load = true,
	action = function(pos, node)
		local node_above = minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z})
		if node_above.name == "air" then --and node.param2 % 4 == 0 then
			fumarole_startTimer(pos)
		end
	end
})

local function set_fire(pos, extinguish)
	local posBelow  = {x = pos.x, y = pos.y - 1, z = pos.z}

	if extinguish then
		if minetest.get_node(pos).name      == "fire:permanent_flame" then minetest.set_node(pos,      {name="air"}) end
		if minetest.get_node(posBelow).name == "fire:permanent_flame" then minetest.set_node(posBelow, {name="air"}) end

	elseif minetest.get_node(posBelow).name == "air" then
		minetest.set_node(posBelow, {name="fire:permanent_flame"})
	elseif minetest.get_node(pos).name == "air" then
		minetest.set_node(pos, {name="fire:permanent_flame"})
	end
end

local function fumarole_onTimer(pos, elapsed)

	local expected_timeout = minetest.get_meta(pos):get_float("expected_timeout")
	if elapsed > expected_timeout + 10 then
		-- The timer didn't fire when it was supposed to, so the chunk was probably inactive and has
		-- just been approached again, meaning *every* fumarole's on_timer is about to go off.
		-- Skip this event and restart the clock for a future random interval.
		fumarole_startTimer(pos, 1)
		return false
	end

	-- Fumaroles in the Nether can catch fire.
	-- (if taken to the surface and used as cottage chimneys, they don't catch fire)
	local inNether = pos.y <= nether.DEPTH and pos.y >= nether.DEPTH_FLOOR
	local canCatchFire = inNether and minetest.registered_nodes["fire:permanent_flame"] ~= nil
	local smoke_offset   = 0
	local timeout_factor = 1
	local smoke_time_adj = 1

	local posAbove = {x = pos.x, y = pos.y + 1, z = pos.z}
	local extinguish = minetest.get_node(posAbove).name ~= "air"

	if extinguish or (canCatchFire and math.floor(elapsed) % 7 == 0) then

		if not extinguish then
			-- fumarole gasses are igniting
			smoke_offset   = 1
			timeout_factor = 0.22 -- reduce burning time
		end

		set_fire(posAbove, extinguish)
		set_fire({x = pos.x + 1, y = pos.y + 1, z = pos.z},     extinguish)
		set_fire({x = pos.x - 1, y = pos.y + 1, z = pos.z},     extinguish)
		set_fire({x = pos.x,     y = pos.y + 1, z = pos.z + 1}, extinguish)
		set_fire({x = pos.x,     y = pos.y + 1, z = pos.z - 1}, extinguish)

	elseif inNether then

		if math.floor(elapsed) % 3 == 1 then
			-- throw up some embers / lava splash
			local embers_particlespawn_def = {
				amount = 6,
				time = 0.1,
				minpos = {x=pos.x - 0.1, y=pos.y + 0.0, z=pos.z - 0.1},
				maxpos = {x=pos.x + 0.1, y=pos.y + 0.2, z=pos.z + 0.1},
				minvel = {x = -.5, y = 4.5, z = -.5},
				maxvel = {x =  .5, y = 7,   z =  .5},
				minacc = {x = 0, y = -10, z = 0},
				maxacc = {x = 0, y = -10, z = 0},
				minexptime = 1.4,
				maxexptime = 1.4,
				minsize = .2,
				maxsize = .8,
				texture = "^[colorize:#A00:255",
				glow = 8
			}
			minetest.add_particlespawner(embers_particlespawn_def)
			embers_particlespawn_def.texture = "^[colorize:#A50:255"
			embers_particlespawn_def.maxvel.y = 3
			embers_particlespawn_def.glow = 12
			minetest.add_particlespawner(embers_particlespawn_def)

		else
			-- gas noises
			minetest.sound_play("nether_fumarole", {
				pos = pos,
				max_hear_distance = 60,
				gain = 0.24,
				pitch = math.random(35, 95) / 100
			})
		end

	else
		-- we're not in the Nether, so can afford to be a bit more smokey
		timeout_factor = 0.4
		smoke_time_adj = 1.3
	end

	-- let out some smoke
	minetest.add_particlespawner({
		amount = 12 * smoke_time_adj,
		time = math.random(40, 60) / 10 * smoke_time_adj,
		minpos = {x=pos.x - 0.2, y=pos.y + smoke_offset, z=pos.z - 0.2},
		maxpos = {x=pos.x + 0.2, y=pos.y + smoke_offset, z=pos.z + 0.2},
		minvel = {x=0, y=0.7, z=-0},
		maxvel = {x=0, y=0.8, z=-0},
		minacc = {x=0.0,y=0.0,z=-0},
		maxacc = {x=0.0,y=0.1,z=-0},
		minexptime = 5,
		maxexptime = 5.5,
		minsize = 1.5,
		maxsize = 7,
		texture = "nether_smoke_puff.png",
	})

	fumarole_startTimer(pos, timeout_factor)
	return false
end


minetest.register_node("nether:fumarole", {
	description=S("Fumarolic Chimney"),
	_doc_items_longdesc = S("A vent in the earth emitting steam and gas"),
	_doc_items_usagehelp = S("Can be repurposed to provide puffs of smoke in a chimney"),
	tiles = {"nether_rack.png"},
	on_timer = fumarole_onTimer,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		fumarole_onTimer(pos, 1)
		return false
	end,
	is_ground_content = true,
	groups = {cracky = 3, level = 2, fumarole=1},
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5000, -0.5000, -0.5000, -0.2500, 0.5000, 0.5000},
			{-0.5000, -0.5000, -0.5000, 0.5000, 0.5000, -0.2500},
			{-0.5000, -0.5000, 0.2500, 0.5000, 0.5000, 0.5000},
			{0.2500, -0.5000, -0.5000, 0.5000, 0.5000, 0.5000}
		}
	},
	selection_box = {type = 'fixed', fixed = {-.5, -.5, -.5, .5, .5, .5}}
})

minetest.register_node("nether:fumarole_slab", {
	description=S("Fumarolic Chimney Slab"),
	_doc_items_longdesc = S("A vent in the earth emitting steam and gas"),
	_doc_items_usagehelp = S("Can be repurposed to provide puffs of smoke in a chimney"),
	tiles = {"nether_rack.png"},
	is_ground_content = true,
	on_timer = fumarole_onTimer,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		fumarole_onTimer(pos, 1)
		return false
	end,
	groups = {cracky = 3, level = 2, fumarole=1},
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5000, -0.5000, -0.5000, -0.2500, 0.000, 0.5000},
			{-0.5000, -0.5000, -0.5000, 0.5000, 0.000, -0.2500},
			{-0.5000, -0.5000, 0.2500, 0.5000, 0.000, 0.5000},
			{0.2500, -0.5000, -0.5000, 0.5000, 0.000, 0.5000}
		}
	},
	selection_box = {type = 'fixed', fixed = {-.5, -.5, -.5, .5, 0, .5}},
	collision_box = {type = 'fixed', fixed = {-.5, -.5, -.5, .5, 0, .5}}
})

minetest.register_node("nether:fumarole_corner", {
	description=S("Fumarolic Chimney Corner"),
	tiles = {"nether_rack.png"},
	is_ground_content = true,
	groups = {cracky = 3, level = 2, fumarole=1},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.2500, -0.5000, 0.5000, 0.000, 0.5000, 0.000},
			{-0.5000, -0.5000, 0.2500, 0.000, 0.5000, 0.000},
			{-0.5000, -0.5000, 0.2500, 0.000, 0.000, -0.5000},
			{0.000, -0.5000, -0.5000, 0.5000, 0.000, 0.5000}
		}
	},
	selection_box = {
		type = 'fixed',
		fixed = {
			{-.5, -.5, -.5, .5, 0, .5},
			{0, 0, .5, -.5, .5, 0},
		}
	}

})

-- nether:airlike_darkness is an air node through which light does not propagate.
-- Use of it should be avoided when possible as it has the appearance of a lighting bug.
-- Fumarole decorations use it to stop the propagation of light from the lava below,
-- since engine limitations mean any mesh or nodebox node will light up if it has lava
-- below it.
local airlike_darkness = {}
for k,v in pairs(minetest.registered_nodes["air"]) do airlike_darkness[k] = v end
airlike_darkness.paramtype = "none"
minetest.register_node("nether:airlike_darkness", airlike_darkness)
