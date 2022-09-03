subterrane.dependencies = {}

local default_modpath = minetest.get_modpath("default")
local mcl_core_modpath = minetest.get_modpath("mcl_core")

assert(default_modpath or mcl_core_modpath, "[subterrane] This mod requires either minetest_game (default) or Mineclone2 (mcl_core) to be installed")

if default_modpath then

subterrane.dependencies.stone = "default:stone"
subterrane.dependencies.clay = "default:clay"
subterrane.dependencies.desert_stone = "default:desert_stone"
subterrane.dependencies.sandstone = "default:sandstone"
subterrane.dependencies.water = "default:water_source"
subterrane.dependencies.obsidian = "default:obsidian"

elseif mcl_core_modpath then

subterrane.dependencies.stone = "mcl_core:stone"
subterrane.dependencies.clay = "mcl_core:clay"
subterrane.dependencies.desert_stone = "mcl_core:redsandstone"
subterrane.dependencies.sandstone = "mcl_core:sandstone"
subterrane.dependencies.water = "mcl_core:water_source"
subterrane.dependencies.obsidian = "mcl_core:obsidian"

end

minetest.after(0, function() subterrane.dependencies = nil end) -- ensure these are only used during initialization, to avoid polluting the global namespace with irrelevancies