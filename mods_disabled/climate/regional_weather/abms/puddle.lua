local BLOCK_PREFIX = "regional_weather:puddle_"
local VARIANT_COUNT = 39
local CHECK_DISTANCE = 4
local MAX_AMOUNT = 3

local GROUND_COVERS = {
	"group:soil",
	"group:stone",
	"group:sand",
	"group:wood",
	"default:permafrost",
	"default:permafrost_with_moss",
	"default:permafrost_with_stones"
}

local S = regional_weather.i18n

-- clean up puddles if disabled
if not regional_weather.settings.puddles then
	-- set all puddle nodes to air
	minetest.register_alias("regional_weather:puddle", "air")
	for i = 1, VARIANT_COUNT do
		for flip = 0, 1 do
			local name = BLOCK_PREFIX .. i
			if flip == 1 then
				name = name .. "_flipped"
			end
			minetest.register_alias(name, "air")
		end
	end

	-- return air instead of a puddle
	function regional_weather.get_random_puddle()
		return { name = "air" }
	end

	-- end puddle execution
	return
end

local node_box = {
	type  = "fixed",
	fixed = { -0.5, -0.5, -0.5, 0.5, -0.49, 0.5 }
}

local apply_water_group
if regional_weather.settings.puddles_water then
	apply_water_group = 1
end

for i = 1, VARIANT_COUNT do
	for flip = 0, 1 do
		local name = BLOCK_PREFIX .. i
		local index = i
		if i < 10 then index = "0" .. i end
		local texture = "weather_puddle_" .. index .. ".png^[opacity:128"
		if flip == 1 then
			name = name .. "_flipped"
			texture = texture .. "^[transformFX"
		end
		minetest.register_node(name, {
			description = S("Puddle"),
			tiles = { texture },
			drawtype = "nodebox",
			pointable = false,
			buildable_to = true,
			floodable = true,
			walkable = false,
			sunlight_propagates = true,
			paramtype = "light",
			paramtype2 = "facedir",
			use_texture_alpha = true,
			node_box = node_box,
			groups = {
				not_in_creative_inventory = 1,
				crumbly = 3,
				attached_node = 1,
				slippery = 1,
				flora = 1,
				water = apply_water_group,
				weather_puddle = 1
			},
			drop = "",
			sounds = {
				footstep = {
					name = "weather_puddle",
					gain = 0.8
				}
			}
		})
	end
end

minetest.register_alias("regional_weather:puddle", BLOCK_PREFIX .. "14")

function regional_weather.get_random_puddle()
	local index = math.random(1, VARIANT_COUNT)
	local rotation = math.random(0, 3) * 90
	local flip = math.random(0, 1)
	local name = BLOCK_PREFIX .. index
	if flip == 1 then
		name = name .. "_flipped"
	end
	local param2 = minetest.dir_to_facedir(minetest.yaw_to_dir(rotation))
	return { name = name, param2 = param2 }
end

-- Makes Puddles when raining
climate_api.register_abm({
	label			= "create rain puddles",
	nodenames	= GROUND_COVERS,
	neighbors	= { "air" },
	interval	= 8,
	chance		= 150,
	catch_up	= false,

	 conditions	= {
		 min_height		= regional_weather.settings.min_height,
		 max_height		= regional_weather.settings.max_height,
		 min_humidity	= 55,
		 min_heat			= 30,
		 daylight			= 15,
		 indoors			= false
	 },

	 pos_override = function(pos)
		 return vector.add(pos, { x = 0, y = 1, z = 0 })
	 end,

   action = function (pos, node, env)
		 -- only override air nodes
		 if minetest.get_node(pos).name ~= "air" then return end
		 -- do not place puddle if area is not fully loaded
		 if minetest.find_node_near(pos, CHECK_DISTANCE, "ignore") then return end
		 -- do not place puddle if already enpugh puddles
		 local pos1 = vector.add(pos, { x = -CHECK_DISTANCE, y = -1, z = -CHECK_DISTANCE })
		 local pos2 = vector.add(pos, { x =  CHECK_DISTANCE, y =  1, z =  CHECK_DISTANCE })
		 local preplaced = minetest.find_nodes_in_area(pos1, pos2, "group:weather_puddle")
		 if preplaced ~= nil and #preplaced >= MAX_AMOUNT then return end
		 minetest.set_node(pos, regional_weather.get_random_puddle())
	 end
})

-- Makes puddles dry up when not raining
climate_api.register_abm({
	label = "remove rain puddles",
	nodenames	= { "group:weather_puddle" },
	interval	= 25,
	chance		= 30,
	catch_up	= true,

	action = function (pos, node, env)
		minetest.remove_node(pos)
	end
})
