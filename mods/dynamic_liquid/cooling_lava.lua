if not minetest.get_modpath("default") then return end

local new_lava_cooling = minetest.settings:get_bool("dynamic_liquid_new_lava_cooling", true)
if not new_lava_cooling then return end

local falling_obsidian = minetest.settings:get_bool("dynamic_liquid_falling_obsidian", false)

-- The existing cool_lava ABM is hard-coded to respond to water nodes
-- and overriding node groups doesn't appear to work:
-- https://github.com/minetest/minetest/issues/5518
-- So modifying the lava-cooling system requires some unfortunate
-- workarounds. Most notable is the "dynamic_cools_lava" group;
-- the "cools_lava" group can't be removed from flowing water for ABM
-- purposes so this redundancy is required.

-- Mods can hook into this system by adding the group
-- "dynamic_cools_lava_flowing" and/or "dynamic_cools_lava_source"
-- to nodes that should cool lava and
-- "dynamic_lava_flowing_destroys" and/or "dynamic_lava_source_destroys"
-- to nodes that should be destroyed by proximity to lava.

local particles = minetest.settings:get_bool("enable_particles", true)

local steam = function(pos)
	if particles then
	minetest.add_particlespawner({
		amount = 6,
		time = 1,
		minpos = pos,
		maxpos = pos,
		minvel = {x=-2, y=0, z=-2},
		maxvel = {x=2, y=1, z=2},
		minacc = {x=0, y=2, z=0},
		maxacc = {x=0, y=2, z=0},
		minexptime = 1,
		maxexptime = 4,
		minsize = 16,
		maxsize = 16,
		collisiondetection = false,
		vertical = false,
		texture = "smoke_puff.png",
	})
	end
end

default.cool_lava = function(pos, node)
	-- no-op disables default cooling ABM
end

-------------------------------------------------------------------------------------------------

local dynamic_cools_lava_flowing = {"group:dynamic_cools_lava_flowing", "group:cools_lava"}

-- Flowing lava will turn these blocks into steam.
local dynamic_lava_flowing_destroys = {
	"group:dynamic_lava_flowing_destroys",
	"default:water_flowing",
	"default:river_water_flowing",
	"default:snow",
	"default:snowblock"
}

local all_flowing_nodes = {unpack(dynamic_cools_lava_flowing)}
for i = 1, #dynamic_lava_flowing_destroys do
    all_flowing_nodes[#dynamic_cools_lava_flowing + i] = dynamic_lava_flowing_destroys[i]
end

local cool_lava_flowing = function(pos, node)
	local cooler_adjacent = minetest.find_node_near(pos, 1, dynamic_cools_lava_flowing)
	
	if cooler_adjacent ~= nil then
		-- pulling nearby sources into position is necessary to break certain classes of
		-- flow "deadlock". Weird, but what're you gonna do.
		local nearby_source = minetest.find_node_near(pos, 1, "default:lava_source")
		if nearby_source then
			minetest.set_node(pos, {name="default:lava_source"})
			minetest.set_node(nearby_source, {name="air"})
			steam(nearby_source)
		else
			minetest.set_node(pos, {name = "air"})
			steam(pos)
		end
	end
	
	local evaporate_list = minetest.find_nodes_in_area(
		vector.add(pos,{x=-1, y=-1, z=-1}),
		vector.add(pos,{x=1, y=1, z=1}),
		dynamic_lava_flowing_destroys
	)
	for _, loc in pairs(evaporate_list) do
		minetest.set_node(loc, {name="air"})
		steam(loc)
	end	

	minetest.sound_play("default_cool_lava",
		{pos = pos, max_hear_distance = 16, gain = 0.25})
end

minetest.register_abm({
	label = "Lava flowing cooling",
	nodenames = {"default:lava_flowing"},
	neighbors = all_flowing_nodes,
	interval = 1,
	chance = 1,
	catch_up = false,
	action = function(...)
		cool_lava_flowing(...)
	end,
})

-------------------------------------------------------------------------------------------------

local dynamic_cools_lava_source = {"group:dynamic_cools_lava_source"}
for name, node_def in pairs(minetest.registered_nodes) do
	-- We don't want "flowing" nodes to cool lava source blocks, otherwise when water falls onto a large pool of lava there's
	-- way too many blocks turned to obsidian.
	if minetest.get_item_group(name, "cools_lava") > 0 and name ~= "default:water_flowing" and name ~= "default:river_water_flowing" then
		table.insert(dynamic_cools_lava_source, name)
	end
end

-- lava source blocks will turn these blocks into steam.
local dynamic_lava_source_destroys = {
	"group:dynamic_lava_source_destroys",
	"default:water_source",
	"default:river_water_source",
	"default:water_flowing",
	"default:river_water_flowing",
	"default:ice",
	"default:snow",
	"default:snowblock"
}

local all_source_nodes = {unpack(dynamic_cools_lava_source)}
for i = 1, #dynamic_lava_source_destroys do
    all_source_nodes[#dynamic_cools_lava_source + i] = dynamic_lava_source_destroys[i]
end

local is_pos_in_list = function(pos, list)
	for _, loc in pairs(list) do
		if vector.equals(pos, loc) then return true end
	end
	return false
end

local function shuffle_array(a)
    local rand = math.random
    local iterations = #a
    local j
    
    for i = iterations, 2, -1 do
        j = rand(i)
        a[i], a[j] = a[j], a[i]
    end
end

local cool_lava_source = function(pos, node)
	local cooler_list = minetest.find_nodes_in_area(
		vector.add(pos,{x=-1, y=-1, z=-1}),
		vector.add(pos,{x=1, y=1, z=1}),
		dynamic_cools_lava_source)
	local evaporate_list = minetest.find_nodes_in_area(
		vector.add(pos,{x=-1, y=-1, z=-1}),
		vector.add(pos,{x=1, y=1, z=1}),
		dynamic_lava_source_destroys
	)
	
	shuffle_array(cooler_list)
	
	local obsidian_location = nil
	for _, loc in pairs(cooler_list) do
		if is_pos_in_list(loc, evaporate_list) then
			if loc.y < pos.y then
				if loc.z == pos.z and loc.x == pos.x then
					obsidian_location = loc -- best outcome, directly below us. End loop immediately.
					break
				else
					obsidian_location = loc -- next-best outcome, in the tier below us.
				end
			elseif loc.y == pos.y and obsidian_location == nil then
				obsidian_location = loc -- On the same level as us, acceptable if nothing else comes along.
			end			
		end
	end
	if obsidian_location == nil and #cooler_list > 0 then
		obsidian_location = pos -- there's an adjacent cooler node, but it's above us. Turn into obsidian in place.
	end
	
	for _, loc in pairs(evaporate_list) do
		minetest.set_node(loc, {name="air"})
		steam(loc)
	end	

	if obsidian_location ~= nil then
		minetest.set_node(pos, {name = "air"})
		minetest.set_node(obsidian_location, {name = "default:obsidian"})
		if minetest.spawn_falling_node and falling_obsidian then -- TODO cutting-edge dev function, so check if it exists for the time being. Remove check when 0.4.16 is released.
			minetest.spawn_falling_node(obsidian_location)
		end
	elseif #evaporate_list > 0 then
		-- Again, this weird bit is necessary for breaking certain types of flow deadlock
		local loc = evaporate_list[math.random(1,#evaporate_list)]
		if loc.y <= pos.y then
			minetest.set_node(pos, {name = "air"})
			minetest.set_node(loc, {name = "default:lava_source"})
		end
	end
	
	minetest.sound_play("default_cool_lava",
		{pos = pos, max_hear_distance = 16, gain = 0.25})
end


minetest.register_abm({
	label = "Lava source cooling",
	nodenames = {"default:lava_source"},
	neighbors = all_source_nodes,
	interval = 1,
	chance = 1,
	catch_up = false,
	action = function(...)
		cool_lava_source(...)
	end,
})