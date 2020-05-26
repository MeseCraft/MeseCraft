
local S = ethereal.intllib

-- Seaweed
minetest.register_node("ethereal:seaweed", {
	description = S("Seaweed"),
	drawtype = "plantlike",
	tiles = {"seaweed.png"},
	inventory_image = "seaweed.png",
	wield_image = "seaweed.png",
	paramtype = "light",
	walkable = false,
	climbable = true,
	drowning = 1,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3}
	},
	post_effect_color = {a = 64, r = 100, g = 100, b = 200},
	groups = {food_seaweed = 1, snappy = 3, flammable = 3},
	on_use = minetest.item_eat(1),
	sounds = default.node_sound_leaves_defaults(),
	after_dig_node = function(pos, node, metadata, digger)
		default.dig_up(pos, node, digger)
	end,
})

minetest.register_craft( {
	type = "shapeless",
	output = "dye:dark_green 3",
	recipe = {"ethereal:seaweed",},
})

-- agar powder
minetest.register_craftitem("ethereal:agar_powder", {
	description = S("Agar Powder"),
	inventory_image = "ethereal_agar_powder.png",
	groups = {food_gelatin = 1, flammable = 2},
})

minetest.register_craft({
	output = "ethereal:agar_powder 3",
	recipe = {
		{"group:food_seaweed", "group:food_seaweed", "group:food_seaweed"},
		{"bucket:bucket_water", "bucket:bucket_water", "default:torch"},
		{"bucket:bucket_water", "bucket:bucket_water", "default:torch"},
	},
	replacements = {
		{"bucket:bucket_water", "bucket:bucket_empty 4"},
	},
})

-- Blue Coral
minetest.register_node("ethereal:coral2", {
	description = S("Blue Coral"),
	drawtype = "plantlike",
	tiles = {"coral2.png"},
	inventory_image = "coral2.png",
	wield_image = "coral2.png",
	paramtype = "light",
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 1 / 4, 6 / 16},
	},
	light_source = 3,
	groups = {snappy = 3},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_craft( {
	type = "shapeless",
	output = "dye:cyan 3",
	recipe = {"ethereal:coral2",},
})

-- Orange Coral
minetest.register_node("ethereal:coral3", {
	description = S("Orange Coral"),
	drawtype = "plantlike",
	tiles = {"coral3.png"},
	inventory_image = "coral3.png",
	wield_image = "coral3.png",
	paramtype = "light",
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 1 / 4, 6 / 16},
	},
	light_source = 3,
	groups = {snappy = 3},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_craft( {
	type = "shapeless",
	output = "dye:orange 3",
	recipe = {"ethereal:coral3",},
})

-- Pink Coral
minetest.register_node("ethereal:coral4", {
	description = S("Pink Coral"),
	drawtype = "plantlike",
	tiles = {"coral4.png"},
	inventory_image = "coral4.png",
	wield_image = "coral4.png",
	paramtype = "light",
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 8 / 16, 6 / 16},
	},
	light_source = 3,
	groups = {snappy = 3},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_craft( {
	type = "shapeless",
	output = "dye:pink 3",
	recipe = {"ethereal:coral4",},
})

-- Green Coral
minetest.register_node("ethereal:coral5", {
	description = S("Green Coral"),
	drawtype = "plantlike",
	tiles = {"coral5.png"},
	inventory_image = "coral5.png",
	wield_image = "coral5.png",
	paramtype = "light",
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 3 / 16, 6 / 16},
	},
	light_source = 3,
	groups = {snappy = 3},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_craft( {
	type = "shapeless",
	output = "dye:green 3",
	recipe = {"ethereal:coral5",},
})

-- Undersea Sand
minetest.register_node("ethereal:sandy", {
	description = S("Sandy"),
	tiles = {"default_sand.png"},
	is_ground_content = true,
	groups = {
		crumbly = 3, falling_node = 1, sand = 1, not_in_creative_inventory = 1
	},
	drop = "default:sand",
	sounds = default.node_sound_sand_defaults(),
})

-- randomly generate coral or seaweed and have seaweed grow up to 14 high
if ethereal.sealife == 1 then
minetest.register_abm({
	label = "Grow coral/seaweed",
	nodenames = {"ethereal:sandy"},
	neighbors = {"group:water"},
	interval = 15,
	chance = 10,
	catch_up = false,
	action = function(pos, node)

		local sel = math.random(1, 6)

		pos.y = pos.y + 1

		local nod = minetest.get_node(pos).name

		if nod == "default:water_source"
		and sel == 6 then

			minetest.swap_node(pos, {name = "ethereal:sponge_wet"})

			return
		end

		if nod == "default:water_source"
		and sel > 1 then

			minetest.swap_node(pos, {name = "ethereal:coral" .. sel})

			return
		end

		if nod == "ethereal:seaweed"
		or sel == 1 then

			local height = 0
			local high = 14

			while height < high
			and minetest.get_node(pos).name == "ethereal:seaweed" do
				height = height + 1
				pos.y = pos.y + 1
			end

			if pos.y < 1
			and height < high
			and minetest.get_node(pos).name == "default:water_source" then

				minetest.swap_node(pos, {name = "ethereal:seaweed"})
			end

		end

	end,
})
end

-- sponges

minetest.register_node("ethereal:sponge_air", {
	drawtype = "airlike",
	paramtype = "light",
	walkable = false,
	buildable_to = true,
	sunlight_propagates = true,
	pointable = false,
	drop = "",
	groups = {not_in_creative_inventory = 1},
})


minetest.register_node("ethereal:sponge", {
	description = S("Sponge"),
	tiles = {"ethereal_sponge.png"},
	groups = {crumbly = 3},
	sounds = default.node_sound_sand_defaults(),

	after_place_node = function(pos, placer, itemstack, pointed_thing)

		-- get player name
		local name = placer:get_player_name()

		-- is area protected
		if minetest.is_protected(pos, name) then
			return
		end

		-- get water nodes within range
		local num = minetest.find_nodes_in_area(
			{x = pos.x - 3, y = pos.y - 3, z = pos.z - 3},
			{x = pos.x + 3, y = pos.y + 3, z = pos.z + 3},
			{"group:water"})

		-- no water
		if #num == 0 then return end

		-- replace water nodes with sponge air
		for _, w in pairs(num) do

			if not minetest.is_protected(pos, name) then
				minetest.swap_node(w, {name = "ethereal:sponge_air"})
			end
		end

		-- replace dry sponge with wet sponge
		minetest.swap_node(pos, {name="ethereal:sponge_wet"})
	end
})


minetest.register_node("ethereal:sponge_wet", {
	description = S("Wet sponge"),
	tiles = {"ethereal_sponge_wet.png"},
	groups = {crumbly = 3},
	sounds = default.node_sound_sand_defaults(),
})

-- cook wet sponge into dry sponge
minetest.register_craft({
	type = "cooking",
	recipe = "ethereal:sponge_wet",
	output = "ethereal:sponge",
	cooktime = 3,
})

-- use leaf decay to remove sponge air nodes
default.register_leafdecay({
	trunks = {"ethereal:sponge_wet"},
	leaves = {"ethereal:sponge_air"},
	radius = 3
})

-- dry sponges can be used as fuel
minetest.register_craft({
	type = "fuel",
	recipe = "ethereal:sponge",
	burntime = 5,
})
