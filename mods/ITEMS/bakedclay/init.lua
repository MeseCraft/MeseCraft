
-- Baked Clay by TenPlus1

local clay = {
	{"natural", "Natural"},
	{"white", "White"},
	{"grey", "Grey"},
	{"black", "Black"},
	{"red", "Red"},
	{"yellow", "Yellow"},
	{"green", "Green"},
	{"cyan", "Cyan"},
	{"blue", "Blue"},
	{"magenta", "Magenta"},
	{"orange", "Orange"},
	{"violet", "Violet"},
	{"brown", "Brown"},
	{"pink", "Pink"},
	{"dark_grey", "Dark Grey"},
	{"dark_green", "Dark Green"},
}

local techcnc_mod = minetest.get_modpath("technic_cnc")
local stairs_mod = minetest.get_modpath("stairs")
local stairsplus_mod = minetest.get_modpath("moreblocks")
	and minetest.global_exists("stairsplus")

for _, clay in pairs(clay) do

	-- node definition

	minetest.register_node("bakedclay:" .. clay[1], {
		description = clay[2] .. " Baked Clay",
		tiles = {"baked_clay_" .. clay[1] ..".png"},
		groups = {cracky = 3, bakedclay = 1},
		sounds = default.node_sound_stone_defaults(),
	})

	-- craft from dye and any baked clay
	if clay[1] ~= "natural" then
		minetest.register_craft({
			output = "bakedclay:" .. clay[1] .. " 8",
			recipe = {
				{"group:bakedclay", "group:bakedclay", "group:bakedclay"},
				{"group:bakedclay", "dye:" .. clay[1], "group:bakedclay"},
				{"group:bakedclay", "group:bakedclay", "group:bakedclay"}
			},
		})
	end

	-- register stairsplus stairs if found
	if stairsplus_mod then

		stairsplus:register_all("bakedclay", "baked_clay_" .. clay[1], "bakedclay:" .. clay[1], {
			description = clay[2] .. " Baked Clay",
			tiles = {"baked_clay_" .. clay[1] .. ".png"},
			groups = {cracky = 3},
			sounds = default.node_sound_stone_defaults(),
		})

		stairsplus:register_alias_all("bakedclay", clay[1], "bakedclay", "baked_clay_" .. clay[1])
		minetest.register_alias("stairs:slab_bakedclay_".. clay[1], "bakedclay:slab_baked_clay_" .. clay[1])
		minetest.register_alias("stairs:stair_bakedclay_".. clay[1], "bakedclay:stair_baked_clay_" .. clay[1])

	-- register all stair types for stairs redo
	elseif stairs_mod and stairs.mod then

		stairs.register_all("bakedclay_" .. clay[1], "bakedclay:" .. clay[1],
			{cracky = 3},
			{"baked_clay_" .. clay[1] .. ".png"},
			clay[2] .. " Baked Clay",
			default.node_sound_stone_defaults())

	-- register stair and slab using default stairs
	elseif stairs_mod then

		stairs.register_stair_and_slab("bakedclay_".. clay[1], "bakedclay:".. clay[1],
			{cracky = 3},
			{"baked_clay_" .. clay[1] .. ".png"},
			clay[2] .. " Baked Clay Stair",
			clay[2] .. " Baked Clay Slab",
			default.node_sound_stone_defaults())
	end

	-- register bakedclay for use in technic_cnc mod
	if techcnc_mod then

		technic_cnc.register_all("bakedclay:" .. clay[1],
		{cracky = 3, not_in_creative_inventory = 1},
		{"baked_clay_" .. clay[1] .. ".png"},
		clay[2] .. " Baked Clay")
	end
end

-- cook clay block into white baked clay

minetest.register_craft({
	type = "cooking",
	output = "bakedclay:natural",
	recipe = "default:clay",
})

-- register a few extra dye colour options

minetest.register_craft( {
	type = "shapeless",
	output = "dye:dark_grey 3",
	recipe = {"dye:black", "dye:black", "dye:white"}
})

minetest.register_craft( {
	type = "shapeless",
	output = "dye:grey 3",
	recipe = {"dye:black", "dye:white", "dye:white"}
})

minetest.register_craft( {
	type = "shapeless",
	output = "dye:green 4",
	recipe = {"default:cactus"}
})

minetest.register_craft( {
	type = "shapeless",
	output = "dye:black 4",
	recipe = {"default:coal_lump"}
})

minetest.register_craft( {
	type = "shapeless",
	output = "dye:brown 4",
	recipe = {"default:dry_shrub"}
})

-- 2x2 red bakedclay makes 16x clay brick
minetest.register_craft( {
	output = "default:clay_brick 16",
	recipe = {
		{"bakedclay:red", "bakedclay:red"},
		{"bakedclay:red", "bakedclay:red"},
	}
})

-- register some new flowers to fill in missing dye colours
-- flower registration (borrowed from default game)

local function add_simple_flower(name, desc, box, f_groups)

	f_groups.snappy = 3
	f_groups.flower = 1
	f_groups.flora = 1
	f_groups.attached_node = 1

	minetest.register_node("bakedclay:" .. name, {
		description = desc,
		drawtype = "plantlike",
		waving = 1,
		tiles = {"baked_clay_" .. name .. ".png"},
		inventory_image = "baked_clay_" .. name .. ".png",
		wield_image = "baked_clay_" .. name .. ".png",
		sunlight_propagates = true,
		paramtype = "light",
		walkable = false,
		buildable_to = true,
		stack_max = 99,
		groups = f_groups,
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = box
		}
	})
end

local flowers = {
	{"delphinium", "Blue Delphinium", {-0.15, -0.5, -0.15, 0.15, 0.3, 0.15}, {color_cyan = 1}},
	{"thistle", "Thistle", {-0.15, -0.5, -0.15, 0.15, 0.2, 0.15}, {color_magenta = 1}},
	{"lazarus", "Lazarus Bell", {-0.15, -0.5, -0.15, 0.15, 0.2, 0.15}, {color_pink = 1}},
	{"mannagrass", "Reed Mannagrass", {-0.15, -0.5, -0.15, 0.15, 0.2, 0.15}, {color_dark_green = 1}},
}

for _,item in pairs(flowers) do
	add_simple_flower(unpack(item))
end

-- mapgen for new flowers

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.004,
		spread = {x = 100, y = 100, z = 100},
		seed = 7133,
		octaves = 3,
		persist = 0.6
	},
	y_min = 10,
	y_max = 90,
	decoration = "bakedclay:delphinium",
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass", "default:dirt_with_dry_grass"},
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.004,
		spread = {x = 100, y = 100, z = 100},
		seed = 7134,
		octaves = 3,
		persist = 0.6
	},
	y_min = 15,
	y_max = 90,
	decoration = "bakedclay:thistle",
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass", "default:dirt_with_rainforest_litter"},
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.01,
		spread = {x = 100, y = 100, z = 100},
		seed = 7135,
		octaves = 3,
		persist = 0.6
	},
	y_min = 1,
	y_max = 90,
	decoration = "bakedclay:lazarus",
	spawn_by = "default:jungletree",
	num_spawn_by = 1,
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass", "default:sand"},
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.009,
		spread = {x = 100, y = 100, z = 100},
		seed = 7136,
		octaves = 3,
		persist = 0.6
	},
	y_min = 1,
	y_max = 15,
	decoration = "bakedclay:mannagrass",
	spawn_by = "group:water",
	num_spawn_by = 1,
})

-- add lucky blocks

if minetest.get_modpath("lucky_block") then
local p = "bakedclay:"
lucky_block:add_blocks({
	{"dro", {"bakedclay:"}, 10, true},
	{"fal", {p.."black", p.."blue", p.."brown", p.."cyan", p.."dark_green",
		p.."dark_grey", p.."green", p.."grey", p.."magenta", p.."orange",
		p.."pink", p.."red", p.."violet", p.."white", p.."yellow", p.."natural"}, 0},
	{"fal", {p.."black", p.."blue", p.."brown", p.."cyan", p.."dark_green",
		p.."dark_grey", p.."green", p.."grey", p.."magenta", p.."orange",
		p.."pink", p.."red", p.."violet", p.."white", p.."yellow", p.."natural"}, 0, true},
	{"dro", {p.."delphinium"}, 5},
	{"dro", {p.."lazarus"}, 5},
	{"dro", {p.."mannagrass"}, 5},
	{"dro", {p.."thistle"}, 6},
	{"flo", 5, {p.."natural", p.."black", p.."blue", p.."brown", p.."cyan",
		p.."dark_green", p.."dark_grey", p.."green", p.."grey", p.."magenta",
		p.."orange", p.."pink", p.."red", p.."violet", p.."white", p.."yellow"}, 2},
	{"nod", "default:chest", 0, {
		{name = p.."natural", max = 30},
		{name = p.."black", max = 30},
		{name = p.."blue", max = 30},
		{name = p.."brown", max = 30},
		{name = p.."cyan", max = 30},
		{name = p.."dark_green", max = 30},
		{name = p.."dark_grey", max = 30},
		{name = p.."green", max = 30},
		{name = p.."grey", max = 30},
		{name = p.."magenta", max = 30},
		{name = p.."orange", max = 30},
		{name = p.."pink", max = 30},
		{name = p.."red", max = 30},
		{name = p.."violet", max = 30},
		{name = p.."white", max = 30},
		{name = p.."yellow", max = 30},
	}},
})
end

print ("[MOD] Baked Clay loaded")
