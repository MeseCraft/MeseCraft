--These nodes used to be defined by subterrane but were pulled due to not wanting to force all mods that use it to create these nodes.
--For backwards compatibility they can still be defined here, however.

local enable_legacy = minetest.settings:get_bool("subterrane_enable_legacy_dripstone", false)

if enable_legacy then

local modname = minetest.get_current_modname()
local S = minetest.get_translator(modname)

subterrane.register_stalagmite_nodes("subterrane:dry_stal", {
	description = S("Dry Dripstone"),
	tiles = {
		"default_stone.png^[brighten",
	},
	groups = {cracky = 3, stone = 2},
	sounds = default.node_sound_stone_defaults(),
})

local flowstone_drops
if minetest.get_modpath("default") then
	flowstone_drops = 'default:cobble'
end

minetest.register_node("subterrane:dry_flowstone", {
	description = S("Dry Flowstone"),
	tiles = {"default_stone.png^[brighten"},
	groups = {cracky = 3, stone = 1},
	drop = flowstone_drops,
	sounds = default.node_sound_stone_defaults(),
})

-----------------------------------------------

subterrane.register_stalagmite_nodes("subterrane:wet_stal", {
	description = S("Wet Dripstone"),
	tiles = {
		"default_stone.png^[brighten^subterrane_dripstone_streaks.png",
	},
	groups = {cracky = 3, stone = 2, subterrane_wet_dripstone = 1},
	sounds = default.node_sound_stone_defaults(),
}, "subterrane:dry_stal")

minetest.register_node("subterrane:wet_flowstone", {
	description = S("Wet Flowstone"),
	tiles = {"default_stone.png^[brighten^subterrane_dripstone_streaks.png"},
	groups = {cracky = 3, stone = 1, subterrane_wet_dripstone = 1},
	drop = flowstone_drops,
	sounds = default.node_sound_stone_defaults(),
})

end

function subterrane:small_stalagmite(vi, area, data, param2_data, param2, height, stalagmite_id)
	subterrane.stalagmite(vi, area, data, param2_data, param2, height, stalagmite_id)
end

function subterrane:giant_stalagmite(vi, area, data, min_height, max_height, base_material, root_material, shaft_material)
	subterrane.big_stalagmite(vi, area, data, min_height, max_height, base_material, root_material, shaft_material)
end

function subterrane:giant_stalactite(vi, area, data, min_height, max_height, base_material, root_material, shaft_material)
	subterrane.big_stalactite(vi, area, data, min_height, max_height, base_material, root_material, shaft_material)
end

function subterrane:giant_shroom(vi, area, data, stem_material, cap_material, gill_material, stem_height, cap_radius, ignore_bounds)
	subterrane.giant_mushroom(vi, area, data, stem_material, cap_material, gill_material, stem_height, cap_radius, ignore_bounds)
end

--FUNCTIONS--

local grid_size = mapgen_helper.block_size * 4

function subterrane:vertically_consistent_randomp(pos)
	local next_seed = math.floor(math.random() * 2^31)
	math.randomseed(minetest.hash_node_position({x=pos.x, y=0, z=pos.z}))
	local output = math.random()
	math.randomseed(next_seed)
	return output
end

function subterrane:vertically_consistent_random(vi, area)
	local pos = area:position(vi)
	return subterrane:vertically_consistent_randomp(pos)
end

subterrane.get_point_heat = function(pos, points)
	local heat = 0
	for _, point in ipairs(points) do
		local axis_point = {x=point.x, y=pos.y, z=point.z}
		local radius = point.y
		if (pos.x >= axis_point.x-radius and pos.x <= axis_point.x+radius
			and pos.z >= axis_point.z-radius and pos.z <= axis_point.z+radius) then
			
			local dist = vector.distance(pos, axis_point)
			if dist < radius then
				heat = math.max(heat, 1 - dist/radius)
			end

		end
	end
	return heat
end

-- Unfortunately there's no easy way to override a single biome, so do it by wiping everything and re-registering
-- Not only that, but the decorations also need to be wiped and re-registered - it appears they keep
-- track of the biome they belong to via an internal ID that gets changed when the biomes
-- are re-registered, resulting in them being left assigned to the wrong biomes.
function subterrane:override_biome(biome_def)

	--Minetest 0.5 adds this "unregister biome" method
	if minetest.unregister_biome and biome_def.name then
		minetest.unregister_biome(biome_def.name)
		minetest.register_biome(biome_def)
		return
	end	

	local registered_biomes_copy = {}
	for old_biome_key, old_biome_def in pairs(minetest.registered_biomes) do
		registered_biomes_copy[old_biome_key] = old_biome_def
	end
	local registered_decorations_copy = {}
	for old_decoration_key, old_decoration_def in pairs(minetest.registered_decorations) do
		registered_decorations_copy[old_decoration_key] = old_decoration_def
	end

	registered_biomes_copy[biome_def.name] = biome_def

	minetest.clear_registered_decorations()
	minetest.clear_registered_biomes()
	for biome_key, new_biome_def in pairs(registered_biomes_copy) do
		minetest.register_biome(new_biome_def)
	end
	for decoration_key, new_decoration_def in pairs(registered_decorations_copy) do
		minetest.register_decoration(new_decoration_def)
	end
end
