local modpath = minetest.get_modpath(minetest.get_current_modname())

-- internationalization boilerplate
local S, NS = settlements.S, settlements.NS

local schem_path = modpath.."/schematics/"

local ruin_settlements = {
	description = S("ruins"),
	surface_materials = {
		"default:permafrost",
		"default:permafrost_with_stones",
		"default:permafrost_with_moss",
	},

	platform_shallow = "default:gravel",
	platform_deep = "default:stone",

	building_count_min = 3,
	building_count_max = 15,

	altitude_min = 2,
	altitude_max = 300,

	schematics = {
		{
			name = "ruin_small",
			schematic = dofile(schem_path.."ruin_small.lua"),
			buffer = 1,
			max_num = 0.7,
			platform_clear_above = false,
		},
		{
			name = "ruin_med",
			schematic = dofile(schem_path.."ruin_med.lua"),
			buffer = 1,
			max_num = 0.4,
			platform_clear_above = false,
		},
		{
			name = "ruin_monolith",
			schematic = dofile(schem_path.."ruin_monolith.lua"),
			buffer = 1,
			max_num = 0.1,
			platform_clear_above = false,
		},
		{
			name = "ruin_tower",
			schematic = dofile(schem_path.."ruin_tower.lua"),
			buffer = 1,
			max_num = 0.4,
			platform_clear_above = false,
		},
	},

	generate_name = function(pos)
		if minetest.get_modpath("namegen") then
			return namegen.generate("ruin_settlement")
		end
		return S("Ruins")
	end,
}

if minetest.get_modpath("namegen") then
	namegen.parse_lines(io.lines(modpath.."/namegen_ruins.cfg"))
end

settlements.register_settlement("ruins", ruin_settlements)
