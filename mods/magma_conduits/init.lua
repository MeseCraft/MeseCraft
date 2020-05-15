magma_conduits = {}

local modpath = minetest.get_modpath(minetest.get_current_modname())
dofile(modpath.."/config.lua")
dofile(modpath.."/voxelarea_iterator.lua")
dofile(modpath.."/hot_rock.lua")

if magma_conduits.config.remove_default_lava then
	minetest.register_alias_force("mapgen_lava_source", "air")
end

if magma_conduits.config.magma_veins then
	dofile(modpath.."/magma_veins.lua")
end
if magma_conduits.config.volcanoes then
	dofile(modpath.."/volcanoes.lua")
end
if magma_conduits.config.cook_soil then
	dofile(modpath.."/cook_soil.lua")
end

