local modname = minetest.get_current_modname()
local S = minetest.get_translator(modname)
local modpath = minetest.get_modpath(modname)

dofile(modpath.."/wisp.lua")

local gas_desc
local gas_usage

local seep_desc
local seep_usage

if minetest.get_modpath("doc") then
	gas_desc = S("Gaseous hydrocarbons formed from the detritus of long dead plants and animals processed by heat and pressure deep within the earth.")
	gas_usage = S("Gas is highly hazardous. Heavier than air, it pools in deep caverns and asphyxiates the unwary.")
	if minetest.get_modpath("tnt") then
		gas_usage = gas_usage .. " " .. S("When exposed to air and an ignition source it can produce a deadly explosion.")
	end
	
	seep_desc = S("Some coal deposits have cracks that seep a steady flow of mine gas.")
	seep_usage = S("Mining out such a deposit seals the crack.")
end


minetest.register_alias("oil:gas", "mine_gas:gas")
minetest.register_alias("oil:gas_seep", "mine_gas:gas_seep")

minetest.register_node("mine_gas:gas", {
	description = S("Mine Gas"),
	_doc_items_longdesc = gas_desc,
	_doc_items_usagehelp = gas_usage,
	walkable = false,
	pointable = false,
	diggable = false,
	is_ground_content = false,
	buildable_to = true,
	drawtype = "glasslike",
	drowning = 1,
	post_effect_color = {a = 20, r = 20, g = 20, b = 250},
	tiles = {"mine_gas.png^[opacity:28"},
	use_texture_alpha = "blend",
	groups = {not_in_creative_inventory=1, ropes_can_extend_into=1},
	paramtype = "light",
	drop = {},
	sunlight_propagates = true,
	--on_blast = function() end, -- unaffected by explosions
})

minetest.register_node("mine_gas:gas_seep", {
	description = S("Gas Seep"),
	_doc_items_longdesc = seep_desc,
	_doc_items_usagehelp = seep_usage,
	tiles = {"default_stone.png^default_mineral_coal.png^[combine:16x80:0,-16=crack_anylength.png"},
	groups = {cracky = 3},
	drop = 'default:coal_lump',
	sounds = default.node_sound_stone_defaults(),
	is_ground_content = true,
})

minetest.register_on_dignode(function(pos, oldnode, digger)
	if minetest.get_item_group(oldnode.name, "digtron") > 0 then
		-- skip digtron moved nodes
		return;
	end

	local np = minetest.find_node_near(pos, 1,{"mine_gas:gas"})
	if np ~= nil then
		minetest.set_node(pos, {name = "mine_gas:gas"})
		return
	end
end)

local directions = {
	{x=1, y=0, z=0},
	{x=-1, y=0, z=0},
	{x=0, y=0, z=1},
	{x=0, y=0, z=-1},
}

local gas_node = {name="mine_gas:gas"}
minetest.register_abm({
    label = "mine_gas:gas movement",
    nodenames = {"mine_gas:gas"},
    neighbors = {"group:liquid", "air"},
    interval = 1.0,
    chance = 1,
    catch_up = true,
    action = function(pos, node)
		local next_pos = {x=pos.x, y=pos.y+1, z=pos.z}
		local next_node = minetest.get_node(next_pos)
		if minetest.get_item_group(next_node.name, "liquid") > 0 then
			minetest.swap_node(next_pos, gas_node)
			minetest.swap_node(pos, next_node)
		else
			next_pos.y = pos.y-1
			next_node = minetest.get_node(next_pos)
			if next_node.name == "air" then
				minetest.swap_node(next_pos, gas_node)
				minetest.swap_node(pos, next_node)			
			else
				local dir = directions[math.random(1,4)]
				local next_pos = vector.add(pos, dir)
				local next_node = minetest.get_node(next_pos)
				if next_node.name == "air" or  minetest.get_item_group(next_node.name, "liquid") > 0 then
					if next_node.name == "air" or math.random() < 0.5 then -- gas never "climbs" above air.
						minetest.swap_node(next_pos, gas_node)
						minetest.swap_node(pos, next_node)
					else
						-- this can get gas to rise up out of the surface of liquid, preventing it from forming a permanent hole.
						next_pos.y = next_pos.y + 1
						next_node = minetest.get_node(next_pos)
						if next_node.name == "air" then
							minetest.swap_node(next_pos, gas_node)
							minetest.swap_node(pos, next_node)
						end
					end
				end
			end
		end
	end,
})

minetest.register_abm({
	label = "mine_gas:gas snuffing torches",
	nodenames = {"group:torch"},
	neighbors = {"mine_gas:gas"},
	interval = 1.0,
	chance = 1,
	catch_up = true,
	action = function(pos, node)
		if not minetest.find_node_near(pos, 1, "air") then
			local torch_node = minetest.get_node(pos)
			local drops = minetest.get_node_drops(torch_node.name, "")
			for _, dropped_item in pairs(drops) do
				minetest.add_item(pos, dropped_item)
	        end
			minetest.set_node(pos, {name="mine_gas:gas"})
			minetest.sound_play(
				"default_cool_lava",
				{pos = pos, max_hear_distance = 16, gain = 0.1}
			)
		end	
	end,
})

if minetest.get_modpath("tnt") then
	minetest.register_abm({
		label = "mine_gas:gas ignition",
		nodenames = {"group:torch", "group:igniter"},
		neighbors = {"mine_gas:gas"},
		interval = 1.0,
		chance = 1,
		catch_up = true,
		action = function(pos, node)
			if minetest.find_node_near(pos, 1, "air") then
				tnt.boom(pos, {radius=1, damage_radius=6})
				-- One in a hundred explosions will spawn a gas wisp
				if math.random() < 0.01 then
					minetest.set_node(pos, {name="mine_gas:gas_wisp"})
				end
			end	
		end,
	})
end

local orthogonal = {
	{x=0,y=0,z=1},
	{x=0,y=1,z=0},
	{x=1,y=0,z=0},
	{x=0,y=0,z=-1},
	{x=0,y=-1,z=0},
	{x=-1,y=0,z=0},
}

minetest.register_lbm({
    label = "shut down gas seeps near lava",
    name = "mine_gas:shut_down_lava_adjacent",
    nodenames = {"mine_gas:gas_seep"},
    run_at_every_load = true,
    action = function(pos, node)
		minetest.after(math.random()*60, function()
			if minetest.find_node_near(pos, 30, "group:lava") then
				minetest.set_node(pos, {name="default:stone_with_coal"})
			end
		end)
	end,
})

minetest.register_abm({
	label = "mine_gas:gas seep",
	nodenames = {"mine_gas:gas_seep"},
	neighbors = {"air"},
	interval = 1.0,
	chance = 1,
	catch_up = true,
	action = function(pos, node)
		local target_pos = vector.add(pos,orthogonal[math.random(1,6)])
		if minetest.get_node(target_pos).name == "air" then
			minetest.swap_node(target_pos, {name="mine_gas:gas"})
			if math.random() < 0.5 then
				minetest.sound_play(
					"mine_gas_seep_hiss",
					{pos = pos, max_hear_distance = 8, gain = 0.05}
				)
			end
		end	
	end,
})