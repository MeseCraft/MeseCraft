
local S = ethereal.intllib

-- Ice Brick
minetest.register_node("ethereal:icebrick", {
	description = S("Ice Brick"),
	tiles = {"brick_ice.png"},
	paramtype = "light",
	freezemelt = "default:water_source",
	is_ground_content = false,
	groups = {cracky = 3, puts_out_fire = 1, cools_lava = 1},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_craft({
	output = "ethereal:icebrick 4",
	recipe = {
		{"default:ice", "default:ice"},
		{"default:ice", "default:ice"},
	}
})

-- Snow Brick
minetest.register_node("ethereal:snowbrick", {
	description = S("Snow Brick"),
	tiles = {"brick_snow.png"},
	paramtype = "light",
	freezemelt = "default:water_source",
	is_ground_content = false,
	groups = {crumbly = 3, puts_out_fire = 1, cools_lava = 1},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_snow_footstep", gain = 0.15},
		dug = {name = "default_snow_footstep", gain = 0.2},
		dig = {name = "default_snow_footstep", gain = 0.2},
	}),
})

minetest.register_craft({
	output = "ethereal:snowbrick 4",
	recipe = {
		{"default:snowblock", "default:snowblock"},
		{"default:snowblock", "default:snowblock"},
	}
})

-- If Crystal Spike, Crystal Dirt, Snow near Water, change Water to Ice
minetest.register_abm({
	label = "Ethereal freeze water",
	nodenames = {
		"ethereal:crystal_spike", "default:snow", "default:snowblock",
		"ethereal:snowbrick"
	},
	neighbors = {"default:water_source", "default:river_water_source"},
	interval = 15,
	chance = 4,
	catch_up = false,
	action = function(pos, node)

		local near = minetest.find_node_near(pos, 1,
			{"default:water_source", "default:river_water_source"})

		if near then
			minetest.swap_node(near, {name = "default:ice"})
		end
	end,
})

-- If Heat Source near Ice or Snow then melt.
minetest.register_abm({
	label = "Ethereal melt snow/ice",
	nodenames = {
		"default:ice", "default:snowblock", "default:snow",
		"default:dirt_with_snow", "ethereal:snowbrick", "ethereal:icebrick"
	},
	neighbors = {
		"fire:basic_fire", "default:lava_source", "default:lava_flowing",
		"default:furnace_active", "default:torch", "default:torch_wall",
		"default:torch_ceiling"
	},
	interval = 5,
	chance = 4,
	catch_up = false,
	action = function(pos, node)

		local water_node = "default:water"

		if pos.y > 2 then
			water_node = "default:river_water"
		end

		if node.name == "default:ice"
		or node.name == "default:snowblock"
		or node.name == "ethereal:icebrick"
		or node.name == "ethereal:snowbrick" then
			minetest.swap_node(pos, {name = water_node.."_source"})

		elseif node.name == "default:snow" then
			minetest.swap_node(pos, {name = water_node.."_flowing"})

		elseif node.name == "default:dirt_with_snow" then
			minetest.swap_node(pos, {name = "default:dirt_with_grass"})
		end

		ethereal.check_falling(pos)
	end,
})

-- If Water Source near Dry Dirt, change to normal Dirt
minetest.register_abm({
	label = "Ethereal wet dry dirt",
	nodenames = {
		"ethereal:dry_dirt", "default:dirt_with_dry_grass",
		"default:dry_dirt", "default:dry_dirt_with_dry_grass"
	},
	neighbors = {"group:water"},
	interval = 15,
	chance = 2,
	catch_up = false,
	action = function(pos, node)

		if node.name == "ethereal:dry_dirt"
		or node.name == "default:dry_dirt" then
			minetest.swap_node(pos, {name = "default:dirt"})
		else
			minetest.swap_node(pos, {name = "default:dirt_with_dry_grass"})
		end
	end,
})

-- If torch touching water then drop as item (when enabled)
if ethereal.torchdrop == true then

local torch_drop = "default:torch"
local drop_sound = "fire_extinguish_flame"

if minetest.get_modpath("real_torch") then
	torch_drop = "real_torch:torch"
	drop_sound = "real_torch_extinguish"
end

minetest.register_abm({
	label = "Ethereal drop torch",
	nodenames = {"default:torch", "default:torch_wall", "default:torch_ceiling",
	"real_torch:torch", "real_torch:torch_wall", "real_torch:torch_ceiling"},
	neighbors = {"group:water"},
	interval = 5,
	chance = 1,
	catch_up = false,
	action = function(pos, node)

		local num = #minetest.find_nodes_in_area(
			{x = pos.x - 1, y = pos.y, z = pos.z},
			{x = pos.x + 1, y = pos.y, z = pos.z},
			{"group:water"})

		if num == 0 then
			num = num + #minetest.find_nodes_in_area(
				{x = pos.x, y = pos.y, z = pos.z - 1},
				{x = pos.x, y = pos.y, z = pos.z + 1},
				{"group:water"})
		end

		if num == 0 then
			num = num + #minetest.find_nodes_in_area(
				{x = pos.x, y = pos.y + 1, z = pos.z},
				{x = pos.x, y = pos.y + 1, z = pos.z},
				{"group:water"})
		end

		if num > 0 then

			minetest.set_node(pos, {name = "air"})

			minetest.sound_play({name = drop_sound, gain = 0.2},
				{pos = pos, max_hear_distance = 10})

			minetest.add_item(pos, {name = torch_drop})
		end
	end,
})

end
