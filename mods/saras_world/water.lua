-- If Water Source near Dry Dirt, change to normal Dirt
minetest.register_abm({
	label = "Water wet dry dirt",
	nodenames = {
		"default:dirt_with_dry_grass",
		"default:dry_dirt", "default:dry_dirt_with_dry_grass"
	},
	neighbors = {"group:water"},
	interval = 15,
	chance = 2,
	catch_up = false,
	action = function(pos, node)

		if node.name == "default:dry_dirt" then
			minetest.swap_node(pos, {name = "default:dirt"})
		else
			minetest.swap_node(pos, {name = "default:dirt_with_grass"})
		end
	end,
})

-- If Heat Source near Ice or Snow then melt.
minetest.register_abm({
	label = "Water melt snow/ice",
	nodenames = {"default:ice", "default:snowblock", "default:snow", "default:dirt_with_snow"},
	neighbors = {
		"fire:basic_fire", "default:lava_source", "default:lava_flowing",
		"default:furnace_active", "default:torch", "default:torch_wall",
		"default:torch_ceiling", "fire:permanent_flame"
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
		or node.name == "default:snowblock" then
			minetest.swap_node(pos, {name = water_node.."_source"})

		elseif node.name == "default:snow" then
			minetest.swap_node(pos, {name = water_node.."_flowing"})

		elseif node.name == "default:dirt_with_snow" then
			minetest.swap_node(pos, {name = "default:dirt_with_grass"})
		end

		saras_world.check_falling(pos)
	end,
})

-- If Snow near Water, change Water to Ice
minetest.register_abm({
	label = "Ice freeze water",
	nodenames = {"default:snow", "default:snowblock"},
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

