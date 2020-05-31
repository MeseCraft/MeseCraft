
--[[

Copyright (C) 2015 - Auke Kok <sofar@foo-projects.org>

"crops" is free software; you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as
published by the Free Software Foundation; either version 2.1
of the license, or (at your option) any later version.

--]]

crops = {}
crops.plants = {}
crops.settings = {}

local settings = {}
settings.easy = {
	chance = 4,
	interval = 30,
	light = 8,
	watercan = 25,
	watercan_max = 90,
	watercan_uses = 20,
	damage_chance = 8,
	damage_interval = 30,
	damage_tick_min = 0,
	damage_tick_max = 1,
	damage_max = 25,
	hydration = false,
}
settings.normal = {
	chance = 8,
	interval = 30,
	light = 10,
	watercan = 25,
	watercan_max = 90,
	watercan_uses = 20,
	damage_chance = 8,
	damage_interval = 30,
	damage_tick_min = 0,
	damage_tick_max = 5,
	damage_max = 50,
	hydration = true,
}
settings.difficult = {
	chance = 16,
	interval = 30,
	light = 13,
	watercan = 25,
	watercan_max = 100,
	watercan_uses = 20,
	damage_chance = 4,
	damage_interval = 30,
	damage_tick_min = 3,
	damage_tick_max = 7,
	damage_max = 100,
	hydration = true,
}


local worldpath = minetest.get_worldpath()
local modpath = minetest.get_modpath(minetest.get_current_modname())

-- Load support for intllib.
local S, _ = dofile(modpath .. "/intllib.lua")
crops.intllib = S


dofile(modpath .. "/crops_settings.txt")

if io.open(worldpath .. "/crops_settings.txt", "r") == nil then
	io.input(modpath .. "/crops_settings.txt")
	io.output(worldpath .. "/crops_settings.txt")

	local size = 4096
	while true do
		local buf = io.read(size)
		if not buf then
			io.close()
			break
		end
		io.write(buf)
	end
else
	dofile(worldpath .. "/crops_settings.txt")
end

if not crops.difficulty then
	crops.difficulty = "normal"
	minetest.log("error", "[crops] "..S("Defaulting to \"normal\" difficulty settings"))
end
crops.settings = settings[crops.difficulty]
if not crops.settings then
	minetest.log("error", "[crops] "..S("Defaulting to \"normal\" difficulty settings"))
	crops.settings = settings.normal
end
if crops.settings.hydration then
	minetest.log("action", "[crops] "..S("Hydration and dehydration mechanics are enabled."))
end

local find_plant = function(node)
	for i = 1,table.getn(crops.plants) do
		if crops.plants[i].name == node.name then
			return crops.plants[i]
		end
	end
	minetest.log("error", "[crops] "..S("Unable to find plant \"@1\" in crops table", node.name))
	return nil
end

crops.register = function(plantdef)
	table.insert(crops.plants, plantdef)
end

crops.plant = function(pos, node)
	minetest.set_node(pos, node)
	local meta = minetest.get_meta(pos)
	local plant = find_plant(node)
	meta:set_int("crops_water", math.max(plant.properties.waterstart, 1))
	meta:set_int("crops_damage", 0)
end

crops.can_grow = function(pos)
	if minetest.get_node_light(pos) < crops.settings.light then
		return false
	end
	local node = minetest.get_node(pos)
	local plant = find_plant(node)
	if not plant then
		return false
	end
	local meta = minetest.get_meta(pos)
	if crops.settings.hydration then
		local water = meta:get_int("crops_water")
		if water < plant.properties.wither or water > plant.properties.soak then
			if math.random(0,1) == 0 then
				return false
			end
		end
		-- growing costs water!
		meta:set_int("crops_water", math.max(1, water - 10))
	end

	-- damaged plants are less likely to grow
	local damage = meta:get_int("crops_damage")
	if not damage == 0 then
		if math.random(math.min(50, damage), 100) > 75 then
			return false
		end
	end

	-- allow the plant to grow
	return true
end

crops.particles = function(pos, flag)
	if flag == 0 then
		-- wither (0)
		minetest.add_particlespawner({
			amount = 1 * crops.settings.interval,
			time = crops.settings.interval,
			minpos = { x = pos.x - 0.4, y = pos.y - 0.4, z = pos.z - 0.4 },
			maxpos = { x = pos.x + 0.4, y = pos.y + 0.4, z = pos.z + 0.4 },
			minvel = { x = 0, y = 0.2, z = 0 },
			maxvel = { x = 0, y = 0.4, z = 0 },
			minacc = { x = 0, y = 0, z = 0 },
			maxacc = { x = 0, y = 0.2, z = 0 },
			minexptime = 3,
			maxexptime = 5,
			minsize = 1,
			maxsize = 2,
			collisiondetection = false,
			texture = "crops_wither.png",
			vertical = true,
		})
	elseif flag == 1 then
		-- soak (1)
		minetest.add_particlespawner({
			amount = 8 * crops.settings.interval,
			time = crops.settings.interval,
			minpos = { x = pos.x - 0.4, y = pos.y - 0.4, z = pos.z - 0.4 },
			maxpos = { x = pos.x + 0.4, y = pos.y - 0.4, z = pos.z + 0.4 },
			minvel = { x = -0.04, y = 0, z = -0.04 },
			maxvel = { x = 0.04, y = 0, z = 0.04 },
			minacc = { x = 0, y = 0, z = 0 },
			maxacc = { x = 0, y = 0, z = 0 },
			minexptime = 3,
			maxexptime = 5,
			minsize = 1,
			maxsize = 2,
			collisiondetection = false,
			texture = "crops_soak.png",
			vertical = false,
		})
	elseif flag == 2 then
		-- watering (2)
		minetest.add_particlespawner({
			amount = 30,
			time = 3,
			minpos = { x = pos.x - 0.4, y = pos.y - 0.4, z = pos.z - 0.4 },
			maxpos = { x = pos.x + 0.4, y = pos.y + 0.4, z = pos.z + 0.4 },
			minvel = { x = 0, y = 0.0, z = 0 },
			maxvel = { x = 0, y = 0.0, z = 0 },
			minacc = { x = 0, y = -9.81, z = 0 },
			maxacc = { x = 0, y = -9.81, z = 0 },
			minexptime = 2,
			maxexptime = 2,
			minsize = 1,
			maxsize = 3,
			collisiondetection = false,
			texture = "crops_watering.png",
			vertical = true,
		})
	else
		-- withered/rotting (3)
		minetest.add_particlespawner({
			amount = 20,
			time = 30,
			minpos = { x = pos.x + 0.3, y = pos.y - 0.5, z = pos.z - 0.5 },
			maxpos = { x = pos.x + 0.5, y = pos.y + 0.5, z = pos.z + 0.5 },
			minvel = { x = -0.6, y = -0.1, z = -0.2 },
			maxvel = { x = -0.4, y = 0.1, z = 0.2 },
			minacc = { x = 0.4, y = 0, z = -0.1 },
			maxacc = { x = 0.5, y = 0, z = 0.1 },
			minexptime = 2,
			maxexptime = 4,
			minsize = 1,
			maxsize = 1,
			collisiondetection = false,
			texture = "crops_flies.png",
			vertical = true,
		})
		minetest.add_particlespawner({
			amount = 20,
			time = 30,
			minpos = { x = pos.x - 0.3, y = pos.y - 0.5, z = pos.z - 0.5 },
			maxpos = { x = pos.x - 0.5, y = pos.y + 0.5, z = pos.z + 0.5 },
			minvel = { x = 0.6, y = -0.1, z = -0.2 },
			maxvel = { x = 0.4, y = 0.1, z = 0.2 },
			minacc = { x = -0.4, y = 0, z = -0.1 },
			maxacc = { x = -0.5, y = 0, z = 0.1 },
			minexptime = 2,
			maxexptime = 4,
			minsize = 1,
			maxsize = 1,
			collisiondetection = false,
			texture = "crops_flies.png",
			vertical = true,
		})
		minetest.add_particlespawner({
			amount = 20,
			time = 30,
			minpos = { x = pos.x - 0.5, y = pos.y - 0.5, z = pos.z + 0.3 },
			maxpos = { x = pos.x + 0.5, y = pos.y + 0.5, z = pos.z + 0.5 },
			minvel = { z = -0.6, y = -0.1, x = -0.2 },
			maxvel = { z = -0.4, y = 0.1, x = 0.2 },
			minacc = { z = 0.4, y = 0, x = -0.1 },
			maxacc = { z = 0.5, y = 0, x = 0.1 },
			minexptime = 2,
			maxexptime = 4,
			minsize = 1,
			maxsize = 1,
			collisiondetection = false,
			texture = "crops_flies.png",
			vertical = true,
		})
		minetest.add_particlespawner({
			amount = 20,
			time = 30,
			minpos = { x = pos.x - 0.5, y = pos.y - 0.5, z = pos.z - 0.3 },
			maxpos = { x = pos.x + 0.5, y = pos.y + 0.5, z = pos.z - 0.5 },
			minvel = { z = 0.6, y = -0.1, x = -0.2 },
			maxvel = { z = 0.4, y = 0.1, x = 0.2 },
			minacc = { z = -0.4, y = 0, x = -0.1 },
			maxacc = { z = -0.5, y = 0, x = 0.1 },
			minexptime = 2,
			maxexptime = 4,
			minsize = 1,
			maxsize = 1,
			collisiondetection = false,
			texture = "crops_flies.png",
			vertical = true,
		})
	end
end

crops.die = function(pos)
	crops.particles(pos, 3)
	local node = minetest.get_node(pos)
	local plant = find_plant(node)
	plant.properties.die(pos)
	minetest.sound_play("crops_flies", {pos=pos, gain=0.8})
end

if crops.settings.hydration then
	dofile(modpath .. "/tools.lua")
end

-- crop nodes, crafts, craftitems
dofile(modpath .. "/melon.lua")
dofile(modpath .. "/pumpkin.lua")
--dofile(modpath .. "/corn.lua")
dofile(modpath .. "/tomato.lua")
dofile(modpath .. "/potato.lua")
--dofile(modpath .. "/polebean.lua")

local nodenames = {}
for i = 1,table.getn(crops.plants) do
	table.insert(nodenames, crops.plants[i].name)
end

-- water handling code
if crops.settings.hydration then
	minetest.register_abm({
		nodenames = nodenames,
		interval = crops.settings.damage_interval,
		chance = crops.settings.damage_chance,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local meta = minetest.get_meta(pos)
			local water = meta:get_int("crops_water")
			local damage = meta:get_int("crops_damage")

			-- get plant specific data
			local plant = find_plant(node)
			if plant == nil then
				return
			end

			-- increase water for nearby water sources
			local f = minetest.find_node_near(pos, 1, {"default:water_source", "default:water_flowing"})
			if not f == nil then
				water = math.min(100, water + 2)
			else
				f = minetest.find_node_near(pos, 2, {"default:water_source", "default:water_flowing"})
				if not f == nil then
					water = math.min(100, water + 1)
				end
			end

			if minetest.get_node_light(pos, nil) < plant.properties.night then
				-- compensate for light: at night give some water back to the plant
				water = math.min(100, water + 1)
			else
				-- dry out the plant
				water = math.max(1, water - plant.properties.wateruse)
			end

			meta:set_int("crops_water", water)

			-- for convenience, copy water attribute to top half
			if not plant.properties.doublesize == nil and plant.properties.doublesize then
				local above = { x = pos.x, y = pos.y + 1, z = pos.z}
				local abovemeta = minetest.get_meta(above)
				abovemeta:set_int("crops_water", water)
			end

			if water <= plant.properties.wither_damage then
				crops.particles(pos, 0)
				damage = damage + math.random(crops.settings.damage_tick_min, crops.settings.damage_tick_max)
			elseif water <= plant.properties.wither then
				crops.particles(pos, 0)
				return
			elseif water >= plant.properties.soak_damage then
				crops.particles(pos, 1)
				damage = damage + math.random(crops.settings.damage_tick_min, crops.settings.damage_tick_max)
			elseif water >= plant.properties.soak then
				crops.particles(pos, 1)
				return
			end
			meta:set_int("crops_damage", math.min(crops.settings.damage_max, damage))

			-- is it dead?
			if damage >= 100 then
				crops.die(pos)
			end
		end
	})
end

-- cooking recipes that mix craftitems
dofile(modpath .. "/cooking.lua")
dofile(modpath .. "/mapgen.lua")

minetest.log("action", "[crops] "..S("Loaded!"))
