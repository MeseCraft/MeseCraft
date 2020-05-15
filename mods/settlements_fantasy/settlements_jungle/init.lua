local modpath = minetest.get_modpath(minetest.get_current_modname())

-- internationalization boilerplate
local S, NS = settlements.S, settlements.NS

local schem_path = modpath.."/schematics/"

-- Node initialization
local function fill_chest(pos)
	-- fill chest
	local inv = minetest.get_inventory( {type="node", pos=pos} )
	-- always
	inv:add_item("main", "default:apple "..math.random(1,3))
	-- low value items
	if math.random(0,1) < 1 then
		inv:add_item("main", "farming:bread "..math.random(0,3))
	end
	-- medium value items
	if math.random(0,3) < 1 then
		inv:add_item("main", "fire:flint_and_steel "..math.random(0,1))
		inv:add_item("main", "bucket:bucket_empty "..math.random(0,1))
	end
end

local initialize_node = function(pos, node, node_def, settlement_info)
	-- when chest is found -> fill with stuff
	if node.name == "default:chest" then
		fill_chest(pos)
	end
end

local jungle_hut_complex = {
	name = "jungle_tree_hut_complex",
	schematic = dofile(schem_path.."jungle_tree_hut_complex.lua"),
	buffer = 1,
	max_num = 0.1,
	force_place = false,
	platform_clear_above = false,
	platform_fill_below = false,
	height_adjust = 1, -- adjusts the y axis of where the schematic is built
	initialize_node = initialize_node,
}

local jungle_settlements = {
	description = S("jungle settlement"),
	surface_materials = {
		"default:dirt_with_rainforest_litter",
	},
	ignore_surface_materials = {
		"default:jungletree",
	},

	platform_shallow = "default:dirt_with_rainforest_litter",
	platform_deep = "default:stone",

	building_count_min = 3,
	building_count_max = 12,

	altitude_min = 2,
	altitude_max = 300,

	central_schematics = {
		jungle_hut_complex,
	},

	schematics = {
		jungle_hut_complex,
		{
			name = "jungle_tree_hut",
			schematic = dofile(schem_path.."jungle_tree_hut.lua"),
			buffer = 0,
			max_num = 1,
			force_place = false,
			platform_clear_above = false,
		},
	},

	generate_name = function(pos)
		if minetest.get_modpath("namegen") then
			return namegen.generate("jungle_camps")
		end
		return S("Jungle settlement")
	end,
}

if minetest.get_modpath("namegen") then
	namegen.parse_lines(io.lines(modpath.."/namegen_jungle.cfg"))
end
settlements.register_settlement("jungle", jungle_settlements)
