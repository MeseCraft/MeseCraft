local modpath = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(modpath.."/intllib.lua")

if ropes.bridges_enabled then

local bridge_on_place = function(itemstack, placer, pointed_thing)
    -- Shall place item and return the leftover itemstack.
    -- The placer may be any ObjectRef or nil.
    -- default: minetest.item_place
	if placer == nil then
		return minetest.item_place(itemstack, placer, pointed_thing)
	end
	
	local above = pointed_thing.above
	local under = pointed_thing.under
	
	if above.x == under.x and above.z == under.z and above.y > under.y then
		-- we're aimed downward at a buildable node from above.
		-- determine the direction the placer lies relative to this node.
		local new_under = vector.new(under)
		local placer_pos = placer:get_pos()
		local diff_x = placer_pos.x - under.x
		local diff_z = placer_pos.z - under.z
		if math.abs(diff_x) > math.abs(diff_z) then
			-- placer is displaced along the X axis relative to the target
			if diff_x > 0 then
				new_under.x = under.x - 1
			else
				new_under.x = under.x + 1
			end				
		else
			-- placer is displaced along the Z axis relative to the target
			if diff_z > 0 then
				new_under.z = under.z - 1
			else
				new_under.z = under.z + 1
			end	
		end
		if minetest.registered_nodes[minetest.get_node(new_under).name].buildable_to then
			local new_pointed_thing = {type="node", under=new_under, above={x=new_under.x, y=new_under.y+1, z=new_under.z}}
			return minetest.item_place(itemstack, placer, new_pointed_thing)
		end
	end
	
	return minetest.item_place(itemstack, placer, pointed_thing)
end

minetest.register_node("ropes:wood_bridge", {
	description = S("Wooden Bridge"),
	_doc_items_longdesc = ropes.doc.wooden_bridge_longdesc,
	_doc_items_usagehelp = ropes.doc.wooden_bridge_usagehelp,
	tiles = {
		"default_wood.png", "default_wood.png",
		"default_wood.png^[transformR270", "default_wood.png^[transformR90",
		"default_wood.png^[transformR270", "default_wood.png^[transformR90",
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy = 2, flammable = 2, oddly_breakable_by_hand = 1, flow_through = 1, fence = 1, wall = 1},
	sounds = default.node_sound_wood_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.375, -0.5, 0.5, 0.5, 0.5}, -- Platform
			{-0.375, -0.5, -0.5, 0.375, -0.375, -0.4375}, -- x beam4
			{-0.375, -0.5, 0.4375, 0.375, -0.375, 0.5}, -- x beam3
			{0.375, -0.5, -0.4375, 0.5, -0.375, 0.4375}, -- z beam2
			{-0.5, -0.5, -0.4375, -0.375, -0.375, 0.4375}, -- z beam1
			{0.375, -0.5, -0.5, 0.5, 0.375, -0.4375}, -- upright4
			{0.375, -0.5, 0.4375, 0.5, 0.375, 0.5}, -- upright3
			{-0.5, -0.5, -0.5, -0.375, 0.375, -0.4375}, -- upright2
			{-0.5, -0.5, 0.4375, -0.375, 0.375, 0.5}, -- upright1
		}
	},
	on_place = bridge_on_place,
})

minetest.register_craft({
	output = "ropes:wood_bridge 5",
	recipe = {
		{"group:stick", "stairs:slab_wood", "group:stick"},
		{"group:stick", "", "group:stick"},
		{"group:stick", "group:stick", "group:stick"},
	}
})

end
