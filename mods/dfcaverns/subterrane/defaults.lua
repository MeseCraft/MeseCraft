subterrane.defaults = {
	--y_max = Must be provided by the user
	--y_min = Must be provided by the user
	cave_threshold = 0.5,
	warren_region_threshold = 0.25,
	warren_region_variability_threshold = 0.25,
	warren_threshold = 0.25,
	boundary_blend_range = 128,
	perlin_cave = {
		offset = 0,
		scale = 1,
		spread = {x=256, y=256, z=256},
		seed = -400000000089,
		octaves = 3,
		persist = 0.67
	},
	perlin_wave = {
		offset = 0,
		scale = 1,
		spread = {x=512, y=256, z=512}, -- squashed 2:1
		seed = 59033,
		octaves = 6,
		persist = 0.63
	},
	perlin_warren_area = {
		offset = 0,
		scale = 1,
		spread = {x=1024, y=128, z=1024},
		seed = -12554445,
		octaves = 2,
		persist = 0.67
	},
	perlin_warrens = {
		offset = 0,
		scale = 1,
		spread = {x=32, y=12, z=32},
		seed = 600089,
		octaves = 3,
		persist = 0.67
	},
	--solidify_lava =
	columns = {
		maximum_radius = 10,
		minimum_radius = 4,
		node = "default:stone",
		weight = 0.25,
		maximum_count = 50,
		minimum_count = 0,
	},
	--double_frequency = -- when set to true, uses the absolute value of the cavern field to determine where to place caverns instead. This effectively doubles the number of large non-connected caverns.
	--decorate = -- optional, a function that is given a table of indices and a variety of other mapgen information so that it can place custom decorations on floors and ceilings.
}

local recurse_defaults
recurse_defaults = function(target_table, default_table)
	for k, v in pairs(default_table) do
		if target_table[k] == nil then
			target_table[k] = v -- TODO: deep copy if v is a table.
		elseif type(target_table[k]) == "table" then
			recurse_defaults(target_table[k], v)
		end
	end
end

subterrane.set_defaults = function(cave_layer_def)
	recurse_defaults(cave_layer_def, subterrane.defaults)
end