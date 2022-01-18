local BLOCK_PREFIX = "regional_weather:snow_cover_"
local CHECK_DISTANCE = 5
local MAX_AMOUNT = 20

local S = regional_weather.i18n

if not minetest.get_modpath("default")
or default.node_sound_snow_defaults == nil
or not regional_weather.settings.snow then
	for i = 1,5 do
		minetest.register_alias(BLOCK_PREFIX .. i, "air")
	end
	return
end

local destruction_handler = function(pos)
	pos.y = pos.y - 1
	if minetest.get_node(pos).name == "default:dirt_with_snow" then
		minetest.set_node(pos, {name = "default:dirt_with_grass"})
	end
end

for i = 1,5 do
	local node_box = {
		type  = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.2*i - 0.5, 0.5}
	}

	minetest.register_node(BLOCK_PREFIX .. i, {
		description = S("Snow Cover"),
		tiles = { "default_snow.png" },
		drawtype = "nodebox",
		buildable_to = i < 3,
		floodable = true,
		walkable = i > 3,
		paramtype = "light",
		node_box = node_box,
		groups = {
			not_in_creative_inventory = 1,
			crumbly = 3,
			falling_node = 1,
			snowy = 1,
			weather_snow_cover = i
		},
		sounds = default.node_sound_snow_defaults(),
		drop = "default:snow " .. math.ceil(i / 2),
		on_construct = function(pos)
			pos.y = pos.y - 1
			if minetest.get_node(pos).name == "default:dirt_with_grass" then
				minetest.set_node(pos, {name = "default:dirt_with_snow"})
			end
		end,
		on_destruct = destruction_handler,
		on_flood = destruction_handler
	})
end

climate_api.register_abm({
	label			= "create snow covers",
	nodenames	= {
		"group:soil",
		"group:leaves",
		"group:stone",
		"default:snowblock",
		"group:coverable_by_snow"
	},
	neighbors	= { "air" },
	interval	= 25,
	chance		= 80,
	catch_up	= false,

	 conditions	= {
		 min_height		= regional_weather.settings.min_height,
		 max_height		= regional_weather.settings.max_height,
		 min_humidity	= 55,
		 max_heat			= 30,
		 not_biome		= {
			"cold_desert",
			"cold_desert_ocean",
			"desert",
			"desert_ocean",
			"sandstone_desert",
			"sandstone_desert_ocean"
		},
		daylight = 15,
		indoors = false
	 },

	 pos_override = function(pos)
		 return vector.add(pos, { x = 0, y = 1, z = 0 })
	 end,

   action = function (pos, node, env)
		 -- only override air nodes
		 if node.name ~= "air" then return end
		 -- do not place snow if area is not fully loaded
		 if minetest.find_node_near(pos, CHECK_DISTANCE, "ignore") then return end
		 -- do not place snow if already enpugh snow
		 local pos1 = vector.add(pos, { x = -CHECK_DISTANCE, y = -1, z = -CHECK_DISTANCE })
		 local pos2 = vector.add(pos, { x =  CHECK_DISTANCE, y =  1, z =  CHECK_DISTANCE })
		 local preplaced = minetest.find_nodes_in_area(pos1, pos2, "group:weather_snow_cover")
		 if preplaced ~= nil and #preplaced >= MAX_AMOUNT then return end
		 minetest.set_node(pos, { name = BLOCK_PREFIX .. "1" })
	 end
})

if regional_weather.settings.snow_griefing then
	climate_api.register_abm({
		label			= "replace flora with snow covers and stack covers higher",
		nodenames	= {
			"group:flora",
			"group:grass",
			"group:plant",
			"group:weather_snow_cover"
		},
		neighbors	= { "air" },
		interval	= 25,
		chance		= 160,
		catch_up	= false,

		 conditions	= {
			 min_height		= regional_weather.settings.min_height,
			 max_height		= regional_weather.settings.max_height,
			 min_humidity	= 55,
			 max_heat			= 30,
			 not_biome		= {
				"cold_desert",
				"cold_desert_ocean",
				"desert",
				"desert_ocean",
				"sandstone_desert",
				"sandstone_desert_ocean"
			},
			daylight = 15,
			indoors = false
		 },

	   action = function (pos, node, env)
			 local value = minetest.get_item_group(node.name, "weather_snow_cover") or 0
			 if value == 0 then
				 -- do not override plants unless marked as buildable_to
				 local def = minetest.registered_nodes[node.name]
				 if def == nil or not def.buildable_to then return end
				 -- do not override plants of the frost_resistance group
				 local resistance = minetest.get_item_group(node.name, "frost_resistance") or 0
				 if resistance > 0 then return end
			 end
			 -- do not place snow if area is not fully loaded
			 if minetest.find_node_near(pos, CHECK_DISTANCE, "ignore") then return end
			 -- do not place snow if already enpugh snow
			 local pos1 = vector.add(pos, { x = -CHECK_DISTANCE, y = -1, z = -CHECK_DISTANCE })
			 local pos2 = vector.add(pos, { x =  CHECK_DISTANCE, y =  1, z =  CHECK_DISTANCE })
			 local preplaced = minetest.find_nodes_in_area(pos1, pos2, "group:weather_snow_cover")
			 if preplaced ~= nil and #preplaced >= MAX_AMOUNT then return end
			 if value < 5 then
				 minetest.set_node(pos, { name = BLOCK_PREFIX .. (value + 1) })
			 end
		 end
	})
end

climate_api.register_abm({
	label			= "melt snow covers",
	nodenames	= { "group:weather_snow_cover" },
	interval	= 25,
	chance		= 85,
	catch_up	= true,

   action = function (pos, node, env)
			local value = minetest.get_item_group(node.name, "weather_snow_cover")
			if value == nil then value = 0 end
			if value > 1 then
				minetest.set_node(pos, { name = BLOCK_PREFIX .. (value - 1) })
			elseif regional_weather.settings.puddles then
				minetest.set_node(pos, regional_weather.get_random_puddle())
			else
				minetest.set_node(pos, { name = "air" })
			end
	 end
})
