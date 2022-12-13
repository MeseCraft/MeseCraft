if ropes.ropeLadderLength == 0 and not ropes.create_all_definitions then
	return
end

-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

if ropes.ropeLadderLength > 0 then
	minetest.register_craft({
		output = "ropes:ropeladder_top",
		recipe =  {
			{'','group:stick',''},
			{'group:vines','group:stick','group:vines'},
			{'','group:stick',''},
		}
	})
end

minetest.register_craft({
	type = "fuel",
	recipe = "ropes:ropeladder_top",
	burntime = ropes.ladder_burn_time,
})

local rope_ladder_top_def = {
	description = S("Rope Ladder"),
	_doc_items_longdesc = ropes.doc.ropeladder_longdesc,
    _doc_items_usagehelp = ropes.doc.ropeladder_usage,
	drawtype = "signlike",
	tiles = {"default_ladder_wood.png^ropes_ropeladder_top.png"},
	is_ground_content = false,
	inventory_image = "default_ladder_wood.png^ropes_ropeladder_top.png",
	wield_image = "default_ladder_wood.png^ropes_ropeladder_top.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	climbable = true,
	sunlight_propagates = true,
	selection_box = {
		type = "wallmounted",
		--wall_top = = <default>
		--wall_bottom = = <default>
		--wall_side = = <default>

	},
	groups = { choppy=2, oddly_breakable_by_hand=1,flammable=2},
	sounds = default.node_sound_wood_defaults(),
	
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type == "node" then
			local target_node = minetest.get_node(pointed_thing.under)
			local target_def = minetest.registered_nodes[target_node.name]
			if target_def.walkable == false then
				return itemstack
			end
		end
		return minetest.item_place(itemstack, placer, pointed_thing)
	end,

	after_place_node = function(pos, placer)
		local pos_below = {x=pos.x, y=pos.y-1, z=pos.z}
		local node_below = minetest.get_node(pos_below)
		local this_node = minetest.get_node(pos)
		local placer_name = placer:get_player_name()
		-- param2 holds the facing direction of this node. If it's 0 or 1 the node is "flat" and we don't want the ladder to extend.
		if node_below.name == "air" and this_node.param2 > 1
		  and (not minetest.is_protected(pos_below, placer_name)
		  or minetest.check_player_privs(placer_name, "protection_bypass")) then
			minetest.add_node(pos_below, {name="ropes:ropeladder_bottom", param2=this_node.param2})
			local meta = minetest.get_meta(pos_below)
			meta:set_int("length_remaining", ropes.ropeLadderLength)
			meta:set_string("placer", placer_name)
		end
	end,
	after_destruct = function(pos)
		local pos_below = {x=pos.x, y=pos.y-1, z=pos.z}
		ropes.destroy_rope(pos_below, {"ropes:ropeladder", "ropes:ropeladder_bottom", "ropes:ropeladder_falling"})
	end,
}

if ropes.ropeLadderLength == 0 then
	rope_ladder_top_def.groups.not_in_creative_inventory = 1
end

minetest.register_node("ropes:ropeladder_top", rope_ladder_top_def)

minetest.register_node("ropes:ropeladder", {
	description = S("Rope Ladder"),
	_doc_items_create_entry = false,
	drop = "",
	drawtype = "signlike",
	tiles = {"default_ladder_wood.png^ropes_ropeladder.png"},
	is_ground_content = false,
	inventory_image = "default_ladder_wood.png^ropes_ropeladder.png",
	wield_image = "default_ladder_wood.png^ropes_ropeladder.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	climbable = true,
	sunlight_propagates = true,
	selection_box = {
		type = "wallmounted",
		--wall_top = = <default>
		--wall_bottom = = <default>
		--wall_side = = <default>
	},
	groups = {choppy=2, flammable=2, not_in_creative_inventory=1},
	sounds = default.node_sound_wood_defaults(),
	
	after_destruct = function(pos)
		ropes.hanging_after_destruct(pos, "ropes:ropeladder_falling", "ropes:ropeladder", "ropes:ropeladder_bottom")
	end,
})

local ladder_extender = ropes.make_rope_on_timer("ropes:ropeladder")

minetest.register_node("ropes:ropeladder_bottom", {
	description = S("Rope Ladder"),
	_doc_items_create_entry = false,
	drop = "",
	drawtype = "signlike",
	tiles = {"default_ladder_wood.png^ropes_ropeladder_bottom.png"},
	is_ground_content = false,
	inventory_image = "default_ladder_wood.png^ropes_ropeladder_bottom.png",
	wield_image = "default_ladder_wood.png^ropes_ropeladder_bottom.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	climbable = true,
	sunlight_propagates = true,
	selection_box = {
		type = "wallmounted",
		--wall_top = = <default>
		--wall_bottom = = <default>
		--wall_side = = <default>

	},
	groups = {choppy=2, flammable=2, not_in_creative_inventory=1},
	sounds = default.node_sound_wood_defaults(),
	on_construct = function( pos )
		local timer = minetest.get_node_timer( pos )
		timer:start( 1 )
	end,
	on_timer = ladder_extender,
	
	after_destruct = function(pos)
		ropes.hanging_after_destruct(pos, "ropes:ropeladder_falling", "ropes:ropeladder", "ropes:ropeladder_bottom")
	end,
})

minetest.register_node("ropes:ropeladder_falling", {
	description = S("Rope Ladder"),
	_doc_items_create_entry = false,
	drop = "",
	drawtype = "signlike",
	tiles = {"default_ladder_wood.png^ropes_ropeladder.png"},
	is_ground_content = false,
	inventory_image = "default_ladder_wood.png^ropes_ropeladder.png",
	wield_image = "default_ladder_wood.png^ropes_ropeladder.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	climbable = true,
	sunlight_propagates = true,
	selection_box = {
		type = "wallmounted",
		--wall_top = = <default>
		--wall_bottom = = <default>
		--wall_side = = <default>

	},
	groups = {flammable=2, not_in_creative_inventory=1},
	sounds = default.node_sound_wood_defaults(),
	on_construct = function( pos )
		local timer = minetest.get_node_timer( pos )
		timer:start( 1 )
	end,
	on_timer = function( pos, elapsed )
		local pos_below = {x=pos.x, y=pos.y-1, z=pos.z}
		local node_below = minetest.get_node(pos_below)

		if (node_below.name ~= "ignore") then
			ropes.destroy_rope(pos_below, {'ropes:ropeladder', 'ropes:ropeladder_bottom', 'ropes:ropeladder_falling'})
			minetest.swap_node(pos, {name="air"})
		else
			local timer = minetest.get_node_timer( pos )
			timer:start( 1 )
		end
	end
})
