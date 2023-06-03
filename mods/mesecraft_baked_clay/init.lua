-- 5.x translation
S = minetest.get_translator("mesecraft_baked_clay")

-- list of clay colours
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
	{"dark_green", "Dark Green"}
}

-- check mod support
local techcnc_mod = minetest.get_modpath("technic_cnc")
local stairs_mod = minetest.get_modpath("stairs")
local stairsplus_mod = minetest.get_modpath("moreblocks")
		and minetest.global_exists("stairsplus")

-- scroll through colours
for _, clay in pairs(clay) do

	-- register node
	minetest.register_node("mesecraft_baked_clay:" .. clay[1], {
		description = S(clay[2] .. " Baked Clay"),
		tiles = {"mesecraft_baked_clay_" .. clay[1] ..".png"},
		groups = {cracky = 3, bakedclay = 1},
		sounds = default.node_sound_stone_defaults()
	})

	-- register craft recipe
	if clay[1] ~= "natural" then

		minetest.register_craft({
			output = "mesecraft_baked_clay:" .. clay[1] .. " 8",
			recipe = {
				{"group:bakedclay", "group:bakedclay", "group:bakedclay"},
				{"group:bakedclay", "dye:" .. clay[1], "group:bakedclay"},
				{"group:bakedclay", "group:bakedclay", "group:bakedclay"}
			}
		})
	end

	-- stairs plus
	if stairsplus_mod then

		stairsplus:register_all("mesecraft_baked_clay", "baked_clay_" .. clay[1],
				"mesecraft_baked_clay:" .. clay[1], {
			description = clay[2] .. " Baked Clay",
			tiles = {"mesecraft_baked_clay_" .. clay[1] .. ".png"},
			groups = {cracky = 3},
			sounds = default.node_sound_stone_defaults()
		})

		stairsplus:register_alias_all("bakedclay", clay[1],
				"mesecraft_baked_clay", "baked_clay_" .. clay[1])

		minetest.register_alias("stairs:slab_bakedclay_".. clay[1],
				"mesecraft_baked_clay:slab_baked_clay_" .. clay[1])

		minetest.register_alias("stairs:stair_bakedclay_".. clay[1],
				"mesecraft_baked_clay:stair_baked_clay_" .. clay[1])

	-- stairs redo
	elseif stairs_mod and stairs.mod then

		stairs.register_all("bakedclay_" .. clay[1], "mesecraft_baked_clay:" .. clay[1],
			{cracky = 3},
			{"mesecraft_baked_clay_" .. clay[1] .. ".png"},
			clay[2] .. " Baked Clay",
			default.node_sound_stone_defaults())

	-- default stairs
	elseif stairs_mod then

		stairs.register_stair_and_slab("bakedclay_".. clay[1], "mesecraft_baked_clay:".. clay[1],
			{cracky = 3},
			{"mesecraft_baked_clay_" .. clay[1] .. ".png"},
			clay[2] .. " Baked Clay Stair",
			clay[2] .. " Baked Clay Slab",
			default.node_sound_stone_defaults())
	end

	-- register bakedclay for use in technic_cnc mod after all mods loaded
	if techcnc_mod then

		core.register_on_mods_loaded(function()

			technic_cnc.register_all("mesecraft_baked_clay:" .. clay[1],
				{cracky = 3, not_in_creative_inventory = 1},
				{"mesecraft_baked_clay_" .. clay[1] .. ".png"},
				clay[2] .. " Baked Clay")
		end)
	end
end

-- cook clay block into white baked clay
minetest.register_craft({
	type = "cooking",
	output = "mesecraft_baked_clay:natural",
	recipe = "default:clay"
})

-- register a few extra dye colour options
minetest.register_craft( {
	type = "shapeless",
	output = "dye:green 4",
	recipe = {"default:cactus"}
})

minetest.register_craft( {
	type = "shapeless",
	output = "dye:brown 4",
	recipe = {"default:dry_shrub"}
})

-- only add light grey recipe if unifieddye mod isnt present (conflict)
if not minetest.get_modpath("unifieddyes") then

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
end

-- 2x2 red baked clay makes 16x clay brick
minetest.register_craft( {
	output = "default:clay_brick 16",
	recipe = {
		{"mesecraft_baked_clay:red", "mesecraft_baked_clay:red"},
		{"mesecraft_baked_clay:red", "mesecraft_baked_clay:red"}
	}
})

-- get mod path
local path = minetest.get_modpath("mesecraft_baked_clay")

-- add new flowers
dofile(path .. "/flowers.lua")

minetest.log("info", "MeseCraft Flowers loaded successfully!")