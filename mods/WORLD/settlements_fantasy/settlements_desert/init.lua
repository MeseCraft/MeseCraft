local modpath = minetest.get_modpath(minetest.get_current_modname())

-- internationalization boilerplate
local S, NS = settlements.S, settlements.NS

-- Node initialization
local function fill_chest(pos)
	-- fill chest
	local inv = minetest.get_inventory( {type="node", pos=pos} )
	-- always
	inv:add_item("main", "default:apple "..math.random(1,3))
	-- low value items
	if math.random(0,1) < 1 then
		inv:add_item("main", "farming:bread "..math.random(0,3))
		inv:add_item("main", "default:steel_ingot "..math.random(0,3))
	end
	-- medium value items
	if math.random(0,3) < 1 then
		inv:add_item("main", "default:pick_steel "..math.random(0,1))
		inv:add_item("main", "default:pick_bronze "..math.random(0,1))
		inv:add_item("main", "fire:flint_and_steel "..math.random(0,1))
		inv:add_item("main", "bucket:bucket_empty "..math.random(0,1))
		inv:add_item("main", "default:sword_steel "..math.random(0,1))
	end
end

local function generate_book(pos, town_name)
	local callbacks = {}
	table.insert(callbacks, {func = settlements.generate_travel_guide, param1=pos, param2=town_name})
	if settlements.generate_ledger then
		table.insert(callbacks, {func = settlements.generate_ledger, param1="kings", param2=town_name})
		table.insert(callbacks, {func = settlements.generate_ledger, param1="night", param2=town_name})
	end
	local callback = callbacks[math.random(#callbacks)]
	return callback.func(callback.param1, callback.param2)
end

local function fill_shelf(pos, town_name)
	local inv = minetest.get_inventory( {type="node", pos=pos} )
	for i = 1, math.random(2, 8) do
		local book = generate_book(pos, town_name)
		if book then
			inv:add_item("books", book)
		end
	end
end

local generate_books = minetest.settings:get_bool("settlements_generate_books", true)

local initialize_node = function(pos, node, node_def, settlement_info)
	-- when chest is found -> fill with stuff
	if node.name == "default:chest" then
		fill_chest(pos)
	end
	if generate_books and node.name == "default:bookshelf" then
		fill_shelf(pos, settlement_info.name)
	end
end

local schem_path = modpath.."/schematics/"

local bazaar = {
	name = "desert_bazaar",
	schematic = dofile(schem_path.."desert_bazaar.lua"),
	buffer = 1,
	max_num = 0.1,
	initialize_node = initialize_node,
}
local desert_hut = {
	name = "desert_hut",
	schematic = dofile(schem_path.."desert_hut.lua"),
	buffer = 1,
	max_num = 0.9,
	initialize_node = initialize_node,
}

local desert_settlements = {
	description = S("desert village"),

	surface_materials = {
		"default:desert_sand",
	},
	ignore_surface_materials = {
		"default:cactus",
	},

	platform_shallow = "default:desert_sand",
	platform_deep = "default:stone",
	path_material = "default:desert_sandstone",

	replace_with_surface_material = "default:dirt_with_grass",

	building_count_min = 3,
	building_count_max = 20,

	altitude_min = 2,
	altitude_max = 300,

	central_schematics = {
		bazaar,
		desert_hut,
	},

	schematics = {
		desert_hut,
		bazaar,
		{
			name = "desert_watchtower",
			schematic = dofile(schem_path.."desert_watchtower.lua"),
			buffer = 1,
			max_num = 0.15,
		},
	},

	generate_name = function(pos)
		if minetest.get_modpath("namegen") then
			return namegen.generate("desert_settlement")
		end
		return S("Desert settlement")
	end,

	generate_book = generate_book,
}

if minetest.get_modpath("namegen") then
	namegen.parse_lines(io.lines(modpath.."/namegen_desert.cfg"))
end

settlements.register_settlement("desert", desert_settlements)
