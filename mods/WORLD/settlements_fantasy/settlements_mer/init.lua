local modpath = minetest.get_modpath(minetest.get_current_modname())

-- internationalization boilerplate
local S, NS = settlements.S, settlements.NS

local schem_path = modpath.."/schematics/"

local coralpalace = {
	name = "coralpalace",
	schematic = dofile(schem_path.."coral_palace.lua"),
	buffer = 2,
	max_num = 0.1,
	platform_clear_above = false,
}


local mer_settlements = {
	description = S("coral village"),

	surface_materials = {
		"default:sand",
		"default:dirt",
	},

	platform_shallow = "default:sand",
	platform_deep = "default:stone",
	platform_air = "default:water_source",

	building_count_min = 3,
	building_count_max = 12,

	altitude_min = -50,
	altitude_max = -10,

	replacements = {
		["default:coral_orange"] = {
			"default:coral_orange",
			"default:coral_brown",
		},
	},

	central_schematics = {
		coralpalace,
	},

	schematics = {
		coralpalace,
		{
			name = "coralhut",
			schematic = dofile(schem_path.."coral_hut.lua"),
			buffer = 1,
			max_num = 1,
			platform_clear_above = false,
		},
	},

	generate_name = function(pos)
		if minetest.get_modpath("namegen") then
			return namegen.generate("mer_settlements")
		end
		return S("Mer camp")
	end,
}

if minetest.get_modpath("namegen") then
	namegen.parse_lines(io.lines(modpath.."/namegen_mer.cfg"))
end
settlements.register_settlement("mer", mer_settlements)
