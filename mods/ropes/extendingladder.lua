local modpath = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(modpath.."/intllib.lua")

if ropes.extending_ladder_enabled then

local wood_recipe = {
		{"group:stick", "group:stick", "group:stick"},
		{"group:stick", "", "group:stick"},
		{"group:stick", "", "group:stick"},
	}
local wood_name = S("Wooden Extendable Ladder")

local steel_recipe = {
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "", "default:steel_ingot"},
		{"default:steel_ingot", "", "default:steel_ingot"},
	}
local steel_name = S("Steel Extendable Ladder")

if ropes.replace_default_ladders then

minetest.unregister_item("default:ladder_wood")
minetest.unregister_item("default:ladder_steel")
minetest.clear_craft({output = "default:ladder_wood"})
minetest.clear_craft({output = "default:ladder_steel"})

local wallmounted_to_facedir =
{[0] = 15, -- ceiling
[1] = 13, -- floor
[2] = 1, -- +X
[3] = 3, -- -X
[4] = 0, -- +Z
[5] = 2, -- -Z
}

minetest.register_lbm({
    label = "Switch from wallmounted default ladders to rope mod extending ladders",
    name = "ropes:wallmounted_ladder_to_facedir_ladder",
    nodenames = {"default:ladder_wood", "default:ladder_steel"},
    run_at_every_load = false,
    action = function(pos, node)
		local new_node = {param2 = wallmounted_to_facedir[node.param2]}
		if (node.name == "default:ladder_wood") then
			new_node.name = "ropes:ladder_wood"
		else
			new_node.name = "ropes:ladder_steel"
		end
		minetest.set_node(pos, new_node)
	end,
})

wood_recipe = {
		{"group:stick", "", "group:stick"},
		{"group:stick", "group:stick", "group:stick"},
		{"group:stick", "", "group:stick"},
	}
wood_name = S("Wooden Ladder")

steel_recipe = {
		{'default:steel_ingot', '', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
		{'default:steel_ingot', '', 'default:steel_ingot'},
	}
steel_name = S("Steel Ladder")

end

minetest.register_craft({
	output = "ropes:ladder_wood 5",
	recipe = wood_recipe,
})

minetest.register_craft({
	output = 'ropes:ladder_steel 15',
	recipe = steel_recipe,
})

local ladder_extender = function(pos, node, clicker, itemstack, pointed_thing, ladder_node, standing_limit)
	-- on_rightclick can be called by other mods, make sure we have all the parameters we need
	if pointed_thing == nil or itemstack == nil then
		return itemstack
	end

	local clicked_stack = ItemStack(itemstack)
	
	-- true if we're pointing up at the ladder from below and there's a buildable space below it
	-- this check allows us to extend ladders downward
	local pointing_directly_below = 
		pointed_thing.above.x == pos.x and
		pointed_thing.above.z == pos.z and
		pointed_thing.above.y == pos.y - 1 and
		minetest.registered_nodes[minetest.get_node(pointed_thing.above).name].buildable_to
	
	if clicked_stack:get_name() == ladder_node and not pointing_directly_below then
		local param2 = minetest.get_node(pos).param2
		local dir = minetest.facedir_to_dir(param2)
		local scan_limit = pos.y + 6 -- Only add ladder segments up to five nodes above the one clicked on
		pos.y = pos.y + 1
		while pos.y < scan_limit and minetest.get_node(pos).name == ladder_node do
			param2 = minetest.get_node(pos).param2
			pos.y = pos.y + 1
		end
		if pos.y < scan_limit and minetest.registered_nodes[minetest.get_node(pos).name].buildable_to then
			
			-- scan downward behind the ladder to find support
			local behind_pos = vector.add(pos, minetest.facedir_to_dir(param2))
			local target_height = pos.y - standing_limit - 1
			while behind_pos.y > target_height and minetest.registered_nodes[minetest.get_node(behind_pos).name].buildable_to do
				behind_pos.y = behind_pos.y - 1
			end
		
			-- If there's enough support, build a new ladder segment
			if behind_pos.y > target_height then
				if minetest.is_protected(pos, clicker:get_player_name()) then
					minetest.record_protection_violation(clicker:get_player_name())
				else
					minetest.set_node(pos, {name=ladder_node, param2=param2})
					if not minetest.settings:get_bool("creative_mode") then
						clicked_stack:take_item(1)
					end
				end
			end
		end
	elseif clicked_stack:get_definition().type == "node" then
		return minetest.item_place_node(itemstack, clicker, pointed_thing)
	end
	return clicked_stack
end

minetest.register_node("ropes:ladder_wood", {
	description = wood_name,
	_doc_items_longdesc = ropes.doc.ladder_longdesc,
	_doc_items_usagehelp = ropes.doc.ladder_usagehelp,
	tiles = {"default_wood.png","default_wood.png","default_wood.png^[transformR270","default_wood.png^[transformR270","default_ladder_wood.png"},
	inventory_image = "default_ladder_wood.png",
	wield_image = "default_ladder_wood.png",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	is_ground_content = false,
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, 0.375, -0.25, 0.5, 0.5}, -- Upright1
			{0.25, -0.5, 0.375, 0.375, 0.5, 0.5}, -- Upright2
			{-0.4375, 0.3125, 0.4375, 0.4375, 0.4375, 0.5}, -- Rung_4
			{-0.4375, -0.1875, 0.4375, 0.4375, -0.0625, 0.5}, -- Rung_2
			{-0.4375, -0.4375, 0.4375, 0.4375, -0.3125, 0.5}, -- Rung_1
			{-0.4375, 0.0625, 0.4375, 0.4375, 0.1875, 0.5}, -- Rung_3
		}
	},
	groups = {choppy = 2, oddly_breakable_by_hand = 3, flammable = 2, flow_through = 1},
	sounds = default.node_sound_wood_defaults(),
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		return ladder_extender(pos, node, clicker, itemstack, pointed_thing, "ropes:ladder_wood", ropes.extending_wood_ladder_limit)
	end,
})

minetest.register_node("ropes:ladder_steel", {
	description = steel_name,
	_doc_items_longdesc = ropes.doc.ladder_longdesc,
	_doc_items_usagehelp = ropes.doc.ladder_usagehelp,
	tiles = {"default_steel_block.png","default_steel_block.png","default_steel_block.png","default_steel_block.png","default_ladder_steel.png"},
	inventory_image = "default_ladder_steel.png",
	wield_image = "default_ladder_steel.png",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	is_ground_content = false,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, 0.3125, -0.25, 0.5, 0.5}, -- Upright1
			{0.25, -0.5, 0.3125, 0.4375, 0.5, 0.5}, -- Upright2
			{-0.25, 0.3125, 0.375, 0.25, 0.4375, 0.5}, -- Rung_4
			{-0.25, -0.1875, 0.375, 0.25, -0.0625, 0.5}, -- Rung_2
			{-0.25, -0.4375, 0.375, 0.25, -0.3125, 0.5}, -- Rung_1
			{-0.25, 0.0625, 0.375, 0.25, 0.1875, 0.5}, -- Rung_3
		}
	},
	groups = {cracky = 2, flow_through = 1},
	sounds = default.node_sound_metal_defaults(),
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		return ladder_extender(pos, node, clicker, itemstack, pointed_thing, "ropes:ladder_steel", ropes.extending_steel_ladder_limit)
	end,
})

else

-- Table of possible wallmounted values
local facedir_to_wallmounted = {
	4, -- +Z
	2, -- +X
	5, -- -Z
	3, -- -X
	1, -- -Y
	0, -- +Y
}
-- Mapping from facedir value to index in facedir_to_dir.
local facedir_to_wallmounted_map = {
	[0]=1, 2, 3, 4,
	5, 2, 6, 4,
	6, 2, 5, 4,
	1, 5, 3, 6,
	1, 6, 3, 5,
	1, 4, 3, 2,
}

minetest.register_lbm({
    label = "Switch from ropes ladders to wallmounted default ladders",
    name = "ropes:facedir_ladder_to_wallmounted_ladder",
    nodenames = {"ropes:ladder_wood", "ropes:ladder_steel"},
    run_at_every_load = false,
    action = function(pos, node)
		local new_node = {param2 = facedir_to_wallmounted[facedir_to_wallmounted_map[node.param2 % 32]]}
		if (node.name == "ropes:ladder_wood") then
			new_node.name = "default:ladder_wood"
		else
			new_node.name = "default:ladder_steel"
		end
		minetest.set_node(pos, new_node)
	end,
})

end
