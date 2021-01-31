-- These nodes are only present to work around https://github.com/minetest/minetest/issues/7864
-- somehow, placing lava that's a light source is sometimes killing the game.
-- This causes the mod to place non-glowing lava on mapgen that is immediately replaced with
-- the regular stuff as soon as the chunk is loaded.
-- Once that issue is resolved, this should be got rid of.

local simple_copy
simple_copy = function(t)
	local r = {}
	for k, v in pairs(t) do
		if type(v) == "table" then
			r[k] = simple_copy(v)
		else
			r[k] = v
		end
	end
	return r
end

local source_def = simple_copy(minetest.registered_nodes["default:lava_source"])
source_def.light_source = nil
source_def.liquid_alternative_flowing = "magma_conduits:lava_flowing"
source_def.liquid_alternative_source = "magma_conduits:lava_source"
source_def.groups.not_in_creative_inventory = 1

minetest.register_node("magma_conduits:lava_source", source_def)

local flowing_def = simple_copy(minetest.registered_nodes["default:lava_flowing"])
flowing_def.light_source = nil
flowing_def.liquid_alternative_flowing = "magma_conduits:lava_flowing"
flowing_def.liquid_alternative_source = "magma_conduits:lava_source"

minetest.register_node("magma_conduits:lava_flowing", flowing_def)

minetest.register_lbm({
	label = "convert magma_conduits lava",
	name = "magma_conduits:convert_lava",
	nodenames = {"magma_conduits:lava_source"},
	run_at_every_load = true,
	action = function(pos, node)
		minetest.set_node(pos, {name="default:lava_source"})
	end,
})

minetest.register_lbm({
	label = "convert magma_conduits flowing lava",
	name = "magma_conduits:convert_flowing_lava",
	nodenames = {"magma_conduits:lava_flowing"},
	run_at_every_load = true,
	action = function(pos, node)
		minetest.set_node(pos, {name="default:lava_flowing"})
	end,
})

-- Mapgen v7 has a glitch where it will sometimes cut slices out of default:stone placed by this mod
-- *after* mapgen is finished. The slices are taken at maxp.y or minp.y and match the
-- rivers formed by the "ridges" flag, if you disable "ridges" they don't occur.
-- Some annoying hackery is needed to patch those slices back up
-- again, and I only want to do that hackery if we're actually in mapgen v7.
-- https://github.com/minetest/minetest/issues/7878
if minetest.get_mapgen_setting("mg_name") == "v7" then

	local stone_def = simple_copy(minetest.registered_nodes["default:stone"])
	stone_def.is_ground_content = false

	minetest.register_node("magma_conduits:stone", stone_def)
	minetest.register_lbm({
		label = "convert magma_conduits stone",
		name = "magma_conduits:convert_stone",
		nodenames = {"magma_conduits:stone"},
		run_at_every_load = true,
		action = function(pos, node)
			minetest.set_node(pos, {name="default:stone"})
		end,
	})
end