local modpath = minetest.get_modpath(minetest.get_current_modname())

-- internationalization boilerplate
local S, NS = settlements.S, settlements.NS

local schem_path = modpath.."/schematics/"

if minetest.get_modpath("namegen") then
	namegen.parse_lines(io.lines(modpath.."/namegen_inuit.cfg"))
end

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

local inuit_settlements = {
	description = S("cluster of igloos"),
	surface_materials = {
		"default:snowblock",
	},
	replace_with_surface_material = "default:ice",

	platform_shallow = "default:snowblock",
	platform_deep = "default:ice",

	building_count_min = 3,
	building_count_max = 9,

	altitude_min = 2,
	altitude_max = 300,

	schematics = {
		{
			name = "igloo",
			schematic = dofile(schem_path.."arctic_igloo.lua"),
			buffer = 2,
			max_num = 1,
			initialize_node = initialize_node,
		},
	},

	generate_name = function(pos)
		if minetest.get_modpath("namegen") then
			return namegen.generate("inuit_camps")
		end
		return S("Inuit camp")
	end,
}

settlements.register_settlement("inuit", inuit_settlements)
