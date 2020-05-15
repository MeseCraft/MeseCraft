if magma_conduits.config.glowing_rock then

local modpath = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(modpath.."/intllib.lua")

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

magma_conduits.make_hot_node_def = function(name, original_def)
	original_def.groups = original_def.groups or {}
	local hot_node_def = simple_copy(original_def)

	local hot_name = name .. "_glowing"
	original_def.groups.lava_heatable = 1
	original_def._magma_conduits_heats_to = hot_name
	
	hot_node_def.groups.lava_heated = 1
	hot_node_def.groups.not_in_creative_inventory = 1
	hot_node_def._magma_conduits_cools_to = name
	hot_node_def.description = S("Hot @1", hot_node_def.description)
	
	for k, v in ipairs(hot_node_def.tiles) do
		hot_node_def.tiles[k] = v .. "^magma_conduits_lava_overlay.png"
	end
	hot_node_def.light_source = 6
	if hot_node_def.drop == nil then
		hot_node_def.drop = name
	end
	
	return hot_name, hot_node_def
end

minetest.register_node("magma_conduits:hot_cobble", {
	description = S("Hot Cobble"),
	_doc_items_longdesc = S("Hot stone riven with cracks and seeping traces of lava."),
	_doc_items_usagehelp = S("When normal stone is heated by lava it is converted into this. Beware when digging here!"),
	tiles = {"magma_conduits_hot_cobble.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 2, lava_heated=1, not_in_creative_inventory=1},
	_magma_conduits_cools_to = "default:cobble",
	sounds = default.node_sound_stone_defaults(),
	light_source = 6,
	drop = "default:cobble",
})

minetest.register_node("magma_conduits:glow_obsidian", {
	description = S("Hot Obsidian"),
	_doc_items_longdesc = S("Obsidian heated to a dull red glow."),
	_doc_items_usagehelp = S("When normal obsidian is heated by lava it is converted into this. Beware when digging here!"),
	tiles = {"magma_conduits_glow_obsidian.png"},
	is_ground_content = true,
	sounds = default.node_sound_stone_defaults(),
	groups = {cracky=1, lava_heated=1, level=2, not_in_creative_inventory=1},
	_magma_conduits_cools_to = "default:obsidian",
	light_source = 6,
	drop = "default:obsidian",
})

-- can't use minetest.override_item to change group memberships here due to issue https://github.com/minetest/minetest/issues/5518

local make_heatable = function(nodename, heats_to)
	local original_def = minetest.registered_nodes[nodename]
	if original_def ~= nil then
		local def = simple_copy(original_def)
		def.groups.lava_heatable = 1
		def._magma_conduits_heats_to = heats_to
		minetest.register_node(":"..nodename, def)
	end
end

make_heatable("default:obsidian", "magma_conduits:glow_obsidian")

make_heatable("default:stone", "magma_conduits:hot_cobble")
make_heatable("default:cobble", "magma_conduits:hot_cobble")
make_heatable("default:mossycobble", "magma_conduits:hot_cobble")
make_heatable("default:stone_with_coal", "magma_conduits:hot_cobble")
make_heatable("default:stone_with_diamond", "magma_conduits:hot_cobble")

make_heatable("default:permafrost", "default:dirt")
make_heatable("default:permafrost_with_stones", "default:dirt")
make_heatable("default:permafrost_with_moss", "default:dirt")

minetest.register_abm{
    label = "magma_conduits lava heating neighbors",
	nodenames = {"group:lava_heatable"},
	neighbors = {"default:lava_source", "default:lava_flowing"},
	interval = 10,
	chance = 5,
	action = function(pos)
		local name = minetest.get_node(pos).name
		local def = minetest.registered_nodes[name]
		
		if def.groups.lava_heatable then
			local target = def._magma_conduits_heats_to
			if target then
				minetest.set_node(pos, {name = target})
			else
				minetest.log("error", name .. " is in group lava_heatable but doesn't have a _magma_conduits_heats_to property defined in its definition")
			end
		end
	end,
}

minetest.register_abm{
    label = "magma_conduits cooling stuff heated by lava",
	nodenames = {"group:lava_heated"},
	interval = 100,
	chance = 10,
	action = function(pos)
		if not minetest.find_node_near(pos, 2, {"default:lava_source", "default:lava_flowing"}, false) then
			local name = minetest.get_node(pos).name
			local def = minetest.registered_nodes[name]
			local target = def._magma_conduits_cools_to
			if target then
				minetest.set_node(pos, {name = target})
			else
				minetest.log("error", name .. " is in group lava_heated but doesn't have a _magma_conduits_cools_to property defined in its definition")
			end
		end
	end,
}

else

minetest.register_alias("magma_conduits:hot_cobble", "default:cobble")
minetest.register_alias("magma_conduits:glow_obsidian", "default:obsidian")

end
