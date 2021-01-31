if minetest.get_modpath("fire") then
	minetest.register_abm({
		nodenames = {"fire:basic_flame"}, --Extinguish fire
		interval = 6,
		chance = 2,
		action = function(pos)
			pos.y=pos.y+1
			if minetest.get_node_light(pos) == 15 and snowdrift.get_precip(pos) ~= "none" and pos.y < snowdrift.upperLimit then
				minetest.remove_node(pos)
			end
		end
	})
end

minetest.register_abm({
	label = "Grow grass in rain",
	nodenames = {"group:grass"}, --Grow grass
	interval = 30,
	chance = 50,
	action = function(pos, node)
		if minetest.get_node_light(pos) == 15 and snowdrift.get_precip(pos) == "rain" and pos.y < snowdrift.upperLimit then
			local level = tonumber(string.sub(node.name, -1))
			if not level then return end 
			if string.sub(node.name, 1, -2) == "default:grass_" and minetest.registered_nodes["default:grass_"..(level+1)] then
				node.name = "default:grass_"..(level+1)
				minetest.set_node(pos, node)
			end
			
		end
	end
})

minetest.register_abm({
	label = "Spawn grass in rain",
	nodenames = {"default:dirt_with_grass"},
	neighbors={"air"},
	interval = 60,
	chance = 50,
	action = function(pos, node)
		pos.y = pos.y + 1
		if minetest.get_node(pos).name == "air" and minetest.get_node_light(pos) == 15 and snowdrift.get_precip(pos) == "rain" and pos.y < snowdrift.upperLimit then
			minetest.set_node(pos, {name="default:grass_1"})
		end
	end
})

minetest.register_abm({
	label = "Shorten grass in sun",
	nodenames = {"default:grass_5"},
	interval = 30,
	chance = 60,
	action = function(pos, node)
		if not (minetest.get_node_light(pos, 0.5) == 15 and snowdrift.get_precip(pos) == "rain") then
			local reduce = math.random(1,4)
			node.name = "default:grass_"..(reduce)
			minetest.set_node(pos, node)
		end
	end
})

minetest.register_abm({
	label = "Remove grass_1 in sun",
	nodenames = {"default:grass_1"},
	interval = 30,
	chance = 50,
	action = function(pos, node)
		if not (minetest.get_node_light(pos, 0.5) == 15 and snowdrift.get_precip(pos) == "rain") then
			minetest.remove_node(pos)
		end
	end
})

local mossy = {
	["default:cobble"]="default:mossycobble",
}

if minetest.get_modpath("walls") then
	mossy["walls:cobble"]="walls:mossycobble"
end

if minetest.get_modpath("stairs") then
	stairs.register_stair_and_slab(
		"mossycobble",
		"default:mossycobble",
		{cracky = 3},
		{"default_mossycobble.png"},
		"Mossy Cobblestone Stair",
		"Mossy Cobblestone Slab",
		default.node_sound_stone_defaults()
	)
	mossy["stairs:stair_cobble"] = "stairs:stair_mossycobble"
	mossy["stairs:stair_inner_cobble"] = "stairs:stair_inner_mossycobble"
	mossy["stairs:stair_outer_cobble"] = "stairs:stair_outer_mossycobble"
	mossy["stairs:slab_cobble"] = "stairs:slab_mossycobble"
end

local mossible = {}
for k,_ in pairs(mossy) do
	mossible[#mossible + 1] = k
end

minetest.register_abm({
	nodenames = mossible, --Mossify cobble
	interval = 30,
	chance = 30,
	action = function(pos, node)
		pos.y=pos.y+1
		if pos.y < snowdrift.upperLimit and minetest.get_node_light(pos, 0.5) == 15 and snowdrift.get_precip(pos) == "rain" then
			pos.y=pos.y-1
			node.name=mossy[node.name]
			minetest.set_node(pos, node)
		end
	end
})