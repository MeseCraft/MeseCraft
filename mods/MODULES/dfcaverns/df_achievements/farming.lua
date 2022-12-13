local S = minetest.get_translator(minetest.get_current_modname())
local nethercap_name = df_dependencies.nethercap_name

local hoe_texture = df_dependencies.texture_tool_steelhoe
local soil_texture = df_dependencies.texture_farming_soil
local ice_texture = df_dependencies.texture_ice
local coal_ore = "(".. df_dependencies.texture_stone .."^".. df_dependencies.texture_mineral_coal ..")"

local make_texture = function(plant_texture, bg_tex)
	bg_tex = bg_tex or soil_texture
	return "dfcaverns_awards_backgroundx32.png^[combine:32x32:3,4="..bg_tex.."^[combine:32x32:3,2="..plant_texture.."^[combine:32x32:14,13="..hoe_texture.."^dfcaverns_awards_foregroundx32.png"
end

-- forestry

local plant_node_achievements =
{
	["df_trees:black_cap_sapling"] = {achievement="dfcaverns_plant_black_cap",
		title=S("Plant Black Cap"), icon=make_texture("dfcaverns_black_cap_sapling.png", coal_ore), _dfcaverns_achievements={"dfcaverns_plant_all_upper_trees", "dfcaverns_plant_all_underground_trees"}, difficulty = 1,},
	["df_trees:fungiwood_sapling"] = {achievement="dfcaverns_plant_fungiwood",
		title=S("Plant Fungiwood"), icon=make_texture("dfcaverns_fungiwood_sapling.png"), _dfcaverns_achievements={"dfcaverns_plant_all_upper_trees", "dfcaverns_plant_all_underground_trees"}, difficulty = 1,},
	["df_trees:goblin_cap_sapling"] = {achievement="dfcaverns_plant_goblin_cap",
		title=S("Plant Goblin Cap"), icon=make_texture("dfcaverns_goblin_cap_sapling.png"), _dfcaverns_achievements={"dfcaverns_plant_all_upper_trees", "dfcaverns_plant_all_underground_trees"}, difficulty = 1,},
	["df_trees:nether_cap_sapling"] = {achievement="dfcaverns_plant_nethercap",
		title=S("Plant @1", nethercap_name), icon=make_texture("dfcaverns_nether_cap_sapling.png", ice_texture), _dfcaverns_achievements={"dfcaverns_plant_all_upper_trees", "dfcaverns_plant_all_underground_trees"}, difficulty = 1,},
	["df_trees:spore_tree_sapling"] = {achievement="dfcaverns_plant_spore_tree",
		title=S("Plant Spore Tree"), icon=make_texture("dfcaverns_spore_tree_sapling.png"), _dfcaverns_achievements={"dfcaverns_plant_all_upper_trees", "dfcaverns_plant_all_underground_trees"}, difficulty = 1,},
	["df_trees:tower_cap_sapling"] = {achievement="dfcaverns_plant_tower_cap",
		title=S("Plant Tower Cap"), icon=make_texture("dfcaverns_tower_cap_sapling.png"), _dfcaverns_achievements={"dfcaverns_plant_all_upper_trees", "dfcaverns_plant_all_underground_trees"}, difficulty = 1,},
	["df_trees:tunnel_tube_sapling"] = {achievement="dfcaverns_plant_tunnel_tube",
		title=S("Plant Tunnel Tube"), icon=make_texture("dfcaverns_tunnel_tube_sapling.png"), _dfcaverns_achievements={"dfcaverns_plant_all_upper_trees", "dfcaverns_plant_all_underground_trees"}, difficulty = 1,},
	["df_trees:torchspine_ember"] = {achievement="dfcaverns_plant_torchspine",
		title=S("Plant Torchspine"), icon=make_texture("dfcaverns_torchspine_achievement.png", coal_ore), _dfcaverns_achievements={"dfcaverns_plant_all_upper_trees", "dfcaverns_plant_all_underground_trees"}, difficulty = 1,},
	["df_trees:spindlestem_seedling"] = {achievement="dfcaverns_plant_spindlestem",
		title=S("Plant Spindlestem"), icon=make_texture("dfcaverns_spindlestem_achievement.png"), _dfcaverns_achievements={"dfcaverns_plant_all_upper_trees", "dfcaverns_plant_all_underground_trees"}, difficulty = 1,},
	["df_trees:blood_thorn"] = {achievement="dfcaverns_plant_bloodthorn",
		title=S("Plant Bloodthorn"), icon=make_texture("dfcaverns_bloodthorn_achievement.png"), _dfcaverns_achievements={"dfcaverns_plant_all_upper_trees", "dfcaverns_plant_all_underground_trees"}, difficulty = 1,},
	["df_primordial_items:giant_hypha_apical_meristem"] = {achievement="dfcaverns_plant_giant_mycelium",
		title=S("Plant Primordial Mycelium"), icon=make_texture("dfcaverns_mush_soil.png"), secret = true, _dfcaverns_achievements={"dfcaverns_plant_all_primordial", "dfcaverns_plant_all_underground_trees"}, difficulty = 3,},
	["df_primordial_items:fern_sapling"] = {achievement="dfcaverns_plant_primordial_fern",
		title=S("Plant Primordial Fern"), icon=make_texture("dfcaverns_jungle_fern_03.png"), secret = true, _dfcaverns_achievements={"dfcaverns_plant_all_primordial", "dfcaverns_plant_all_underground_trees"}, difficulty = 3,},
	["df_primordial_items:jungle_mushroom_sapling"] = {achievement="dfcaverns_plant_primordial_jungle_mushroom",
		title=S("Plant Primordial Jungle Mushroom"), icon=make_texture("dfcaverns_jungle_mushroom_02.png"), secret = true, _dfcaverns_achievements={"dfcaverns_plant_all_primordial", "dfcaverns_plant_all_underground_trees"}, difficulty = 3,},
	["df_primordial_items:jungletree_sapling"] = {achievement="dfcaverns_plant_primordial_jungletree",
		title=S("Plant Primordial Jungle Tree"), icon=make_texture("dfcaverns_jungle_sapling.png"), secret = true, _dfcaverns_achievements={"dfcaverns_plant_all_primordial", "dfcaverns_plant_all_underground_trees"}, difficulty = 3,},
	["df_primordial_items:mush_sapling"] = {achievement="dfcaverns_plant_primordial_mushroom",
		title=S("Plant Primordial Mushroom"), icon=make_texture("dfcaverns_mush_sapling.png"), secret = true, _dfcaverns_achievements={"dfcaverns_plant_all_primordial", "dfcaverns_plant_all_underground_trees"}, difficulty = 3,},
	["df_farming:cave_wheat_seed"] = {achievement="dfcaverns_plant_cave_wheat",
		title=S("Plant Cave Wheat"), icon=make_texture("dfcaverns_cave_wheat_8.png"), _dfcaverns_achievements={"dfcaverns_plant_all_farmables"}, difficulty = 1,},
	["df_farming:dimple_cup_seed"] = {achievement="dfcaverns_plant_dimple_cup",
		title=S("Plant Dimple Cup"), icon=make_texture("dfcaverns_dimple_cup_4.png"), _dfcaverns_achievements={"dfcaverns_plant_all_farmables"}, difficulty = 1,},
	["df_farming:pig_tail_seed"] = {achievement="dfcaverns_plant_pig_tail",
		title=S("Plant Pig Tail"), icon=make_texture("dfcaverns_pig_tail_8.png"), _dfcaverns_achievements={"dfcaverns_plant_all_farmables"}, difficulty = 1,},
	["df_farming:plump_helmet_spawn"] = {achievement="dfcaverns_plant_plump_helmet",
		title=S("Plant Plump Helmet"), icon=make_texture("dfcaverns_plump_helmet_achievement.png"), _dfcaverns_achievements={"dfcaverns_plant_all_farmables"}, difficulty = 1,},
	["df_farming:quarry_bush_seed"] = {achievement="dfcaverns_plant_quarry_bush",
		title=S("Plant Quarry Bush"), icon=make_texture("dfcaverns_quarry_bush_5.png"), _dfcaverns_achievements={"dfcaverns_plant_all_farmables"}, difficulty = 1,},
	["df_farming:sweet_pod_seed"] = {achievement="dfcaverns_plant_sweet_pod",
		title=S("Plant Sweet Pod"), icon=make_texture("dfcaverns_sweet_pod_6.png"), _dfcaverns_achievements={"dfcaverns_plant_all_farmables"}, difficulty = 1,},
}

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	local player_name = placer:get_player_name()
	if player_name == nil then return end
	local player_awards = awards.player(player_name)
	local achievement = plant_node_achievements[newnode.name]
	if not achievement then return end
	local achievement_name = achievement.achievement
	if not player_awards.unlocked or player_awards.unlocked[achievement_name] ~= achievement_name then
		-- all of the growable plants in DFCaverns are timer-based. If you place
		-- a seedling or seed and the resulting node has a timer running, then
		-- it's passed the checks to see if it was placed in a growable area.
		if minetest.get_node_timer(pos):is_started() then
			awards.unlock(player_name, achievement_name)
		end
	end
end)

for seed_item, def in pairs(plant_node_achievements) do
	awards.register_achievement(def.achievement, {
		title = def.title,
		description = S("Plant a @1 in a place where it can grow.", minetest.registered_items[seed_item].description),
		icon = def.icon,
		secret = def.secret,
		_dfcaverns_achievements = def._dfcaverns_achievements,
	})
end

awards.register_achievement("dfcaverns_plant_all_upper_trees", {
	title = S("Fungal Arborist"),
	description = S("Plant one of every kind of 'tree' found in the caverns above the Sunless Sea."),
	icon = "dfcaverns_awards_backgroundx32.png^"
		.."(dfcaverns_awards_cavern_towercapx32.png^dfcaverns_awards_cavern_fungiwoodx32.png^dfcaverns_awards_cavern_goblincapx32.png)^[transformFX"
		.."^[combine:32x32:16,15="..hoe_texture.."^dfcaverns_awards_foregroundx32.png",
	difficulty = 1 / df_achievements.get_child_achievement_count("dfcaverns_plant_all_upper_trees"),
	trigger = {
		type="dfcaverns_achievements",
		achievement_name="dfcaverns_plant_all_upper_trees",
		target=df_achievements.get_child_achievement_count("dfcaverns_plant_all_upper_trees"),
	},
})

awards.register_achievement("dfcaverns_plant_all_primordial", {
	title = S("Primordial Arborist"),
	description = S("Plant one of every kind of 'tree' from the Primordial caverns."),
	icon = "dfcaverns_awards_backgroundx32.png^"
		.."(dfcaverns_awards_cavern_primordial_mushx32.png^dfcaverns_awards_cavern_junglex32.png)^[transformFX"
		.."^[combine:32x32:16,15="..hoe_texture.."^dfcaverns_awards_foregroundx32.png",
	secret = true,
	difficulty = 3 / df_achievements.get_child_achievement_count("dfcaverns_plant_all_primordial"),
	trigger = {
		type="dfcaverns_achievements",
		achievement_name="dfcaverns_plant_all_primordial",
		target=df_achievements.get_child_achievement_count("dfcaverns_plant_all_primordial"),
	},
})

awards.register_achievement("dfcaverns_plant_all_underground_trees", {
	title = S("Underground Arborist"),
	description = S("Plant one of every kind of 'tree' found in the caverns beneath the surface."),
	icon = "dfcaverns_awards_backgroundx32.png^"
		.."(dfcaverns_awards_cavern_towercapx32.png^dfcaverns_awards_cavern_fungiwoodx32.png^dfcaverns_awards_cavern_goblincapx32.png)^[transformFX"
		.. "^dfcaverns_awards_cavern_primordial_mushx32.png^dfcaverns_awards_cavern_junglex32.png"
		.."^[combine:32x32:16,15="..hoe_texture.."^dfcaverns_awards_foregroundx32.png",
	difficulty = 4 / df_achievements.get_child_achievement_count("dfcaverns_plant_all_underground_trees"),
	trigger = {
		type="dfcaverns_achievements",
		achievement_name="dfcaverns_plant_all_underground_trees",
		target=df_achievements.get_child_achievement_count("dfcaverns_plant_all_underground_trees"),
	},
})

awards.register_achievement("dfcaverns_plant_all_farmables", {
	title = S("Underground Farmer"),
	description = S("Plant one of every kind of small farmable plant found in the caverns beneath the surface."),
	icon = "dfcaverns_awards_backgroundx32.png"
		.."^[combine:32x32:0,0="..soil_texture
		.."^[combine:32x32:0,16="..soil_texture
		.."^[combine:32x32:16,0="..soil_texture
		.."^[combine:32x32:16,16="..soil_texture
		.."^[combine:32x32:0,0=dfcaverns_cave_wheat_8.png"
		.."^[combine:32x32:16,0=dfcaverns_dimple_cup_4.png"
		.."^[combine:32x32:8,8=dfcaverns_plump_helmet_achievement.png"
		.."^[combine:32x32:0,16=dfcaverns_sweet_pod_6.png"
		.."^[combine:32x32:16,16=dfcaverns_quarry_bush_5.png"		
		.."^[combine:32x32:16,15="..hoe_texture.."^dfcaverns_awards_foregroundx32.png",
	difficulty = 1 / df_achievements.get_child_achievement_count("dfcaverns_plant_all_farmables"),
	trigger = {
		type="dfcaverns_achievements",
		achievement_name="dfcaverns_plant_all_farmables",
		target=df_achievements.get_child_achievement_count("dfcaverns_plant_all_farmables"),
	},
})