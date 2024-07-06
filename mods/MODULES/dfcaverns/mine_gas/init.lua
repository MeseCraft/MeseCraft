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
	groups = {not_in_creative_inventory=1, ropes_can_extend_into=1, not_solid=1, not_opaque=1},
	paramtype = "light",
	drop = {},
	sunlight_propagates = true,
	--on_blast = function() end, -- unaffected by explosions
})

minetest.register_node("mine_gas:gas_seep", {
	description = S("Gas Seep"),
	_doc_items_longdesc = seep_desc,
	_doc_items_usagehelp = seep_usage,
	tiles = {df_dependencies.texture_stone.."^"..df_dependencies.texture_mineral_coal.."^[combine:16x80:0,-16=crack_anylength.png"},
	groups = {cracky = 3, pickaxey=1, building_block=1, material_stone=1},
	drop = df_dependencies.node_name_coal_lump,
	sounds = df_dependencies.sound_stone(),
	is_ground_content = true,
	_mcl_blast_resistance = 5,
	_mcl_hardness = 3,
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

local soundfile_cool_lava = df_dependencies.soundfile_cool_lava

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
				soundfile_cool_lava,
				{pos = pos, max_hear_distance = 16, gain = 0.1}
			)
		end	
	end,
})

local tnt_boom = df_dependencies.tnt_boom

if tnt_boom then
	minetest.register_abm({
		label = "mine_gas:gas ignition",
		nodenames = {"group:torch", "group:igniter", "group:fire"}, -- checking for ignition sources because there will be fewer than there are gas nodes
		neighbors = {"mine_gas:gas"},
		interval = 1.0,
		chance = 1,
		catch_up = true,
		action = function(pos, node)
			if minetest.find_node_near(pos, 1, "air") then
				tnt_boom(pos, {radius=1, damage_radius=6})
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

LinkedEl = {}

function LinkedEl.new(next, value)
	local out = nil
	if next then
		out = {prev=next.prev, next=next, value=value}
		next.prev = out
		if out.prev then
			out.prev.next = out
		end
	else
		out = {prev=nil, next=nil, value=value}
	end
	return out
end

function LinkedEl.pluck(el)
	if el.next then
		el.next.prev = el.prev
	end
	if el.prev then
		el.prev.next = el.next
	end
	el.next = nil
	el.prev = nil
end

LList = {}

function LList.push(q, value)
	local el = LinkedEl.new(q.first, value)
	if not q.first then
		q.last = el
	end
	q.first = el
	q.count = q.count + 1
end

function LList.remove(q, it, rev)
	local out = nil
	if rev then
		out = it.prev
	else
		out = it.next
	end
	
	if it == q.last then
		q.last = it.prev
	end
	if it == q.first then
		q.first = it.next
	end
	
	LinkedEl.pluck(it)
	q.count = q.count - 1
	return out
end

local lava_positions = {first=nil, last=nil, count=0, cleaning=false}

function pdist2(p1, p2)
	return (p2.x - p1.x)^2 + (p2.y - p1.y)^2 + (p2.z - p1.z)^2
end

local active_block_range2 = (16*minetest.settings:get("active_block_range") )^2
minetest.register_lbm({
    label = "track lava positions for mine_gas:shut_down_lava_adjacent",
    name = "mine_gas:track_lava_positions",
    nodenames = {"group:lava"},
    run_at_every_load = true,
    action = function(pos, node)
		if lava_positions.count >= 500 and not lava_positions.cleaning then
			lava_positions.cleaning = true
			minetest.after(3, function()
			local it = lava_positions.last
			while it do
				local dist2 = pdist2(pos, lava_positions.last.value)
				if dist2 >= active_block_range2 or dist2 < 1 then
					--clean up duplicates and positions which are too far from current node
					it = LList.remove(lava_positions, it, true)
				else
					it = it.prev
				end
			end
			LList.push(lava_positions, pos)
			lava_positions.cleaning = false
			end)
		end
		LList.push(lava_positions, pos)
	end,
})

local stone_with_coal = df_dependencies.node_name_stone_with_coal
minetest.register_lbm({
    label = "shut down gas seeps near lava",
    name = "mine_gas:shut_down_lava_adjacent",
    nodenames = {"mine_gas:gas_seep"},
    run_at_every_load = true,
    action = function(pos, node)
		local it = lava_positions.first
		while not it == nil do
			local lava_pos = it.value
			if pdist2(pos, lava_pos) < 900 then
				minetest.set_node(pos, {name=stone_with_coal})
				break
			end
			it = it.next
		end
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
