local S = minetest.get_translator("mtg_plus")

local metal_sounds, wood_sounds
if default.node_sound_metal_defaults then
	metal_sounds = default.node_sound_metal_defaults()
else
	metal_sounds = default.node_sound_stone_defaults()
end
wood_sounds = default.node_sound_wood_defaults()

-- Ladders
minetest.register_node("mtg_plus:ladder_papyrus", {
	description = S("Papyrus Ladder"),
	_doc_items_longdesc = S("A particulary strong piece of ladder which allows you to move vertically."),
	drawtype = "signlike",
	tiles = {"mtg_plus_ladder_papyrus.png"},
	inventory_image = "mtg_plus_ladder_papyrus.png",
	wield_image = "mtg_plus_ladder_papyrus.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	is_ground_content = false,
	selection_box = { type = "wallmounted", },
	groups = { snappy = 2, choppy = 1, flammable = 2 },
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:ladder_papyrus 2",
	recipe = { {"default:papyrus", "", "default:papyrus"},
	{"farming:string", "default:papyrus", "farming:string"},
	{"default:papyrus", "", "default:papyrus"}},
})

minetest.register_craft({
	type = "fuel",
	recipe = "mtg_plus:ladder_papyrus",
	burntime = 2,
})

local simple_ladders = {
	{ "gold", "metal", S("Golden Ladder"), "default:gold_ingot", { cracky = 3 }, true },
	{ "bronze", "metal", S("Bronze Ladder"), "default:bronze_ingot", { cracky = 2 } },
	{ "copper", "metal", S("Copper Ladder"), "default:copper_ingot", { cracky = 2 } },
	{ "tin", "metal", S("Tin Ladder"), "default:tin_ingot", { cracky = 2 } },
	{ "aspen_wood", "wood", S("Aspen Wood Ladder"), "default:aspen_wood", { choppy = 3, flammable = 1 }, nil, 5 },
	{ "acacia_wood", "wood", S("Acacia Wood Ladder"), "default:acacia_wood", { choppy = 3, flammable = 1 }, nil, 8 },
	{ "pine_wood", "wood", S("Pine Wood Ladder"), "default:pine_wood", { choppy = 3, flammable = 1 }, nil, 6 },
	{ "junglewood", "wood", S("Jungle Wood Ladder"), "default:junglewood", { choppy = 3, flammable = 1 }, nil, 9 },
}

for m=1, #simple_ladders do
	local ladder = simple_ladders[m]
	local longdesc
	if ladder[6] then
		longdesc = S("A luxurious piece of ladder which allows you to move vertically.")
	else
		longdesc = S("A piece of ladder which allows you to move vertically.")
	end
	if ladder[2] == "metal" then
		sounds = metal_sounds
	else
		sounds = wood_sounds
	end
	minetest.register_node("mtg_plus:ladder_"..ladder[1], {
		description = ladder[3],
		_doc_items_longdesc = longdesc,
		drawtype = "signlike",
		tiles = {"mtg_plus_ladder_"..ladder[1]..".png"},
		selection_box = { type = "wallmounted", },
		inventory_image = "mtg_plus_ladder_"..ladder[1]..".png",
		wield_image = "mtg_plus_ladder_"..ladder[1]..".png",
		paramtype = "light",
		paramtype2 = "wallmounted",
		sunlight_propagates = true,
		walkable = false,
		climbable = true,
		is_ground_content = false,
		groups = ladder[5],
		sounds = sounds,
	})
	if ladder[2] == "metal" then
		minetest.register_craft({
			output = "mtg_plus:ladder_"..ladder[1].." 15",
			recipe = {
				{ladder[4], "", ladder[4]},
				{ladder[4], ladder[4], ladder[4]},
				{ladder[4], "", ladder[4]},
			},
		})
	else
		minetest.register_craft({
			output = "mtg_plus:ladder_"..ladder[1].." 9",
			recipe = {
				{"group:stick", "", "group:stick"},
				{"group:stick", ladder[4], "group:stick"},
				{"group:stick", "", "group:stick"},
			},
		})
		if ladder[7] ~= nil then
			minetest.register_craft({
				type = "fuel",
				recipe = "mtg_plus:ladder_"..ladder[1],
				burntime = ladder[7],
			})
		end
	end
end

-- Tweak the default ladder
minetest.override_item("default:ladder_wood", { description = S("Apple Wood Ladder") })
minetest.register_craft({
	output = "default:ladder_wood 9",
	recipe = {
		{"group:stick", "", "group:stick"},
		{"group:stick", "default:wood", "group:stick"},
		{"group:stick", "", "group:stick"},
	},
})

-- The default stick-only recipe for default ladder will be intentionally kept for
-- convenience.
