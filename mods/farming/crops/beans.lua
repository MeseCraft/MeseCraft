--[[
	All textures by
	(C) Auke Kok <sofar@foo-projects.org>
	CC-BY-SA-3.0
]]

local S = farming.intllib

-- place beans
local function place_beans(itemstack, placer, pointed_thing, plantname)

	local pt = pointed_thing

	-- check if pointing at a node
	if not pt or pt.type ~= "node" then
		return
	end

	local under = minetest.get_node(pt.under)

	-- return if any of the nodes are not registered
	if not minetest.registered_nodes[under.name] then
		return
	end

	-- am I right-clicking on something that has a custom on_place set?
	-- thanks to Krock for helping with this issue :)
	local def = minetest.registered_nodes[under.name]
	if placer and itemstack and def and def.on_rightclick then
		return def.on_rightclick(pt.under, under, placer, itemstack)
	end

	-- is player planting crop?
	local name = placer and placer:get_player_name() or ""

	-- check for protection
	if minetest.is_protected(pt.under, name) then
		return
	end

	-- check if pointing at bean pole
	if under.name ~= "farming:beanpole" then
		return
	end

	-- add the node and remove 1 item from the itemstack
	minetest.set_node(pt.under, {name = plantname})

	minetest.sound_play("default_place_node", {pos = pt.under, gain = 1.0})

	if placer or not farming.is_creative(placer:get_player_name()) then

		itemstack:take_item()

		-- check for refill
		if itemstack:get_count() == 0 then

			minetest.after(0.20,
				farming.refill_plant,
				placer,
				"farming:beans",
				placer:get_wield_index()
			)
		end
	end

	return itemstack
end

-- beans
minetest.register_craftitem("farming:beans", {
	description = S("Green Beans"),
	inventory_image = "farming_beans.png",
	groups = {seed = 2, food_beans = 1, flammable = 2},
	on_use = minetest.item_eat(1),
	on_place = function(itemstack, placer, pointed_thing)
		return place_beans(itemstack, placer, pointed_thing, "farming:beanpole_1")
	end
})

-- beans can be used for green dye
minetest.register_craft({
	output = "dye:green",
	recipe = {
		{"farming:beans"}
	}
})

-- beanpole
minetest.register_node("farming:beanpole", {
	description = S("Bean Pole (place on soil before planting beans)"),
	drawtype = "plantlike",
	tiles = {"farming_beanpole.png"},
	inventory_image = "farming_beanpole.png",
	visual_scale = 1.90,
	paramtype = "light",
	walkable = false,
	buildable_to = true,
	sunlight_propagates = true,
	drop = "farming:beanpole",
	selection_box = farming.select,
	groups = {snappy = 3, flammable = 2, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_place = function(itemstack, placer, pointed_thing)

		local pt = pointed_thing

		-- check if pointing at a node
		if not pt or pt.type ~= "node" then
			return
		end

		local under = minetest.get_node(pt.under)

		-- return if any of the nodes are not registered
		if not minetest.registered_nodes[under.name] then
			return
		end

		-- am I right-clicking on something that has a custom on_place set?
		-- thanks to Krock for helping with this issue :)
		local def = minetest.registered_nodes[under.name]
		if def and def.on_rightclick then
			return def.on_rightclick(pt.under, under, placer, itemstack)
		end

		if minetest.is_protected(pt.above, placer:get_player_name()) then
			return
		end

		local nodename = under.name

		if minetest.get_item_group(nodename, "soil") < 2 then
			return
		end

		local top = {
			x = pointed_thing.above.x,
			y = pointed_thing.above.y + 1,
			z = pointed_thing.above.z
		}

		nodename = minetest.get_node(top).name

		if nodename ~= "air" then
			return
		end

		minetest.set_node(pointed_thing.above, {name = "farming:beanpole"})

		if not farming.is_creative(placer:get_player_name()) then
			itemstack:take_item()
		end

		return itemstack
	end
})

minetest.register_craft({
	output = "farming:beanpole",
	recipe = {
		{"", "", ""},
		{"default:stick", "", "default:stick"},
		{"default:stick", "", "default:stick"}
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "farming:beanpole",
	burntime = 10
})

-- green bean definition
local def = {
	drawtype = "plantlike",
	tiles = {"farming_beanpole_1.png"},
	visual_scale = 1.90,
	paramtype = "light",
	walkable = false,
	buildable_to = true,
	sunlight_propagates = true,
	drop = {
		items = {
			{items = {"farming:beanpole"}, rarity = 1}
		}
	},
	selection_box = farming.select,
	groups = {
		snappy = 3, flammable = 3, not_in_creative_inventory = 1,
		attached_node = 1, growing = 1, plant = 1
	},
	sounds = default.node_sound_leaves_defaults()
}

-- stage 1
minetest.register_node("farming:beanpole_1", table.copy(def))

-- stage2
def.tiles = {"farming_beanpole_2.png"}
minetest.register_node("farming:beanpole_2", table.copy(def))

-- stage 3
def.tiles = {"farming_beanpole_3.png"}
minetest.register_node("farming:beanpole_3", table.copy(def))

-- stage 4
def.tiles = {"farming_beanpole_4.png"}
minetest.register_node("farming:beanpole_4", table.copy(def))

-- stage 5 (final)
def.tiles = {"farming_beanpole_5.png"}
def.groups.growing = nil
def.drop = {
	items = {
		{items = {"farming:beanpole"}, rarity = 1},
		{items = {"farming:beans 3"}, rarity = 1},
		{items = {"farming:beans 2"}, rarity = 2},
		{items = {"farming:beans 2"}, rarity = 3}
	}
}
minetest.register_node("farming:beanpole_5", table.copy(def))

-- add to registered_plants
farming.registered_plants["farming:beans"] = {
	crop = "farming:beanpole",
	seed = "farming:beans",
	minlight = 13,
	maxlight = 15,
	steps = 5
}

-- wild green bean bush (this is what you find on the map)
minetest.register_node("farming:beanbush", {
	drawtype = "plantlike",
	tiles = {"farming_beanbush.png"},
	paramtype = "light",
	waving = 1,
	walkable = false,
	buildable_to = true,
	sunlight_propagates = true,
	drop = {
		items = {
			{items = {"farming:beans 1"}, rarity = 1},
			{items = {"farming:beans 1"}, rarity = 2},
			{items = {"farming:beans 1"}, rarity = 3}
		}
	},
	selection_box = farming.select,
	groups = {
		snappy = 3, flammable = 2, plant = 1, attached_node = 1,
		not_in_creative_inventory = 1
	},
	sounds = default.node_sound_leaves_defaults()
})
