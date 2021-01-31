
local S = farming.intllib

-- add soil types to existing dirt blocks
minetest.override_item("default:dirt", {
	soil = {
		base = "default:dirt",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.override_item("default:dirt_with_grass", {
	soil = {
		base = "default:dirt_with_grass",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.override_item("default:dirt_with_dry_grass", {
	soil = {
		base = "default:dirt_with_dry_grass",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.override_item("default:dirt_with_rainforest_litter", {
	soil = {
		base = "default:dirt_with_rainforest_litter",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.override_item("default:dirt_with_coniferous_litter", {
	soil = {
		base = "default:dirt_with_coniferous_litter",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.override_item("default:dry_dirt", {
	soil = {
		base = "default:dry_dirt",
		dry = "farming:dry_soil",
		wet = "farming:dry_soil_wet"
	}
})

minetest.override_item("default:dry_dirt_with_dry_grass", {
	soil = {
		base = "default:dry_dirt_with_dry_grass",
		dry = "farming:dry_soil",
		wet = "farming:dry_soil_wet"
	}
})

-- normal soil
minetest.register_node("farming:soil", {
	description = S("Soil"),
	tiles = {"default_dirt.png^farming_soil.png", "default_dirt.png"},
	drop = "default:dirt",
	groups = {crumbly = 3, not_in_creative_inventory = 1, soil = 2, field = 1},
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "default:dirt",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

-- wet soil
minetest.register_node("farming:soil_wet", {
	description = S("Wet Soil"),
	tiles = {
		"default_dirt.png^farming_soil_wet.png",
		"default_dirt.png^farming_soil_wet_side.png"},
	drop = "default:dirt",
	groups = {crumbly = 3, not_in_creative_inventory = 1, soil = 3, field = 1},
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "default:dirt",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

-- savanna soil
if minetest.registered_nodes["default:dry_dirt"] then
minetest.register_node("farming:dry_soil", {
	description = S("Savanna Soil"),
	tiles = {
		"default_dry_dirt.png^farming_soil.png",
		"default_dry_dirt.png"},
	drop = "default:dry_dirt",
	groups = {crumbly = 3, not_in_creative_inventory = 1, soil = 2, field = 1},
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "default:dry_dirt",
		dry = "farming:dry_soil",
		wet = "farming:dry_soil_wet"
	}
})

minetest.register_node("farming:dry_soil_wet", {
	description = S("Wet Savanna Soil"),
	tiles = {
		"default_dry_dirt.png^farming_soil_wet.png",
		"default_dry_dirt.png^farming_soil_wet_side.png"},
	drop = "default:dry_dirt",
	groups = {crumbly = 3, not_in_creative_inventory = 1, soil = 3, field = 1},
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "default:dry_dirt",
		dry = "farming:dry_soil",
		wet = "farming:dry_soil_wet"
	}
})
end

-- sand is not soil, change existing sand-soil to use dry soil
minetest.register_alias("farming:desert_sand_soil", "farming:dry_soil")
minetest.register_alias("farming:desert_sand_soil_wet", "farming:dry_soil_wet")

-- if water near soil then change to wet soil
minetest.register_abm({
	nodenames = {"group:field"},
	interval = 15,
	chance = 4,
	catch_up = false,

	action = function(pos, node)

		local ndef = minetest.registered_nodes[node.name]
		if not ndef or not ndef.soil or not ndef.soil.wet
		or not ndef.soil.base or not ndef.soil.dry then return end

		pos.y = pos.y + 1
		local nn = minetest.get_node_or_nil(pos)
		pos.y = pos.y - 1

		if nn then nn = nn.name else return end

		-- what's on top of soil, if solid/not plant change soil to dirt
		if minetest.registered_nodes[nn]
		and minetest.registered_nodes[nn].walkable
		and minetest.get_item_group(nn, "plant") == 0 then
			minetest.set_node(pos, {name = "default:dirt"})
			return
		end

		-- if map around soil not loaded then skip until loaded
		if minetest.find_node_near(pos, 3, {"ignore"}) then
			return
		end

		-- check if water is within 3 nodes horizontally and 1 below
		if #minetest.find_nodes_in_area(
				{x = pos.x + 3, y = pos.y - 1, z = pos.z + 3},
				{x = pos.x - 3, y = pos.y    , z = pos.z - 3},
				{"group:water"}) > 0 then

			minetest.set_node(pos, {name = ndef.soil.wet})

		elseif node.name == ndef.soil.wet then
			minetest.set_node(pos, {name = ndef.soil.dry})

		elseif node.name == ndef.soil.dry
		and minetest.get_item_group(nn, "plant") == 0 then
			minetest.set_node(pos, {name = ndef.soil.base})
		end
	end
})
