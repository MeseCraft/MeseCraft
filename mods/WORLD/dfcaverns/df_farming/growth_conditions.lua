df_farming.growth_permitted = {}

local growable = {[df_dependencies.node_name_dirt_wet] = true, [df_dependencies.node_name_dirt] = true}
local check_farm_plant_soil = function(pos)
	return growable[minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name]
end

df_farming.growth_permitted["df_farming:cave_wheat_seed"] = check_farm_plant_soil
df_farming.growth_permitted["df_farming:dimple_cup_seed"] = check_farm_plant_soil
df_farming.growth_permitted["df_farming:pig_tail_seed"] = check_farm_plant_soil
df_farming.growth_permitted["df_farming:quarry_bush_seed"] = check_farm_plant_soil
df_farming.growth_permitted["df_farming:sweet_pod_seed"] = check_farm_plant_soil
df_farming.growth_permitted["df_farming:plump_helmet_spawn"] = check_farm_plant_soil