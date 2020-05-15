-- LARGE SHARK
-- revert to old model and texture.
mobs:register_mob("mobs_creatures:shark", {
	type = "monster",
	attack_type = "dogfight",
	damage = 15,
	reach = 3,
	hp_min = 10,
	hp_max = 10,
	armor = 150,
	collisionbox = {-0.75, -0.5, -0.75, 0.75, 0.5, 0.75},
	visual = "mesh",
	mesh = "mobs_creatures_shark.b3d",
	rotate = 90,
	textures = 	{"mobs_creatures_shark.png"},
	sounds = {
	        attack = "mobs_creatures_shark_attack",
	        damage = "mobs_creatures_shark_damage",
	        death = "mobs_creatures_shark_death",
        },
	makes_footstep_sound = false,
	walk_velocity = 2,
	run_velocity = 3,
	fly = true,
	fly_in = "default:water_source",
	fall_speed = -1,
	rotate = 270,
	view_range = 15,
	water_damage = 0,
	lava_damage = 10,
	light_damage = 0,
	animation = {
		walk_speed = 40,
		run_speed = 80,
		fly_speed = 40,
		walk_start = 1,
		walk_end = 59,
		run_start = 1,
		run_end = 59,
		fly_start = 1,
		fly_end = 59,
	},
	jump = false,
	stepheight = 0.1,
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 1, max = 3},
	},
})			
--name, nodes, neighbours, minlight, maxlight, interval, chance, active_object_count, min_height, max_height
mobs:spawn_specific("mobs_creatures:shark", {"default:sand_with_kelp", "default:wood", "default:tree", "default:coral_brown", "default:coral_orange","default:coral_cyan","default:coral_green","default:coral_pink", "decorations_sea:coral_01", "decorations_sea:coral_02", "decorations_sea:coral_03", "decorations_sea:coral_04", "decorations_sea:coral_05", "decorations_sea:coral_06", "decorations_sea:coral_07", "decorations_sea:coral_08", "decorations_sea:coral_plantlike_01", "decorations_sea:coral_plantlike_02", "decorations_sea:coral_plantlike_03", "decorations_sea:coral_plantlike_04", "decorations_sea:coral_plantlike_05", "decorations_sea:seagrass_01", "decorations_sea:seagrass_02", "decorations_sea:seagrass_03", "decorations_sea:seashell_01_node", "decorations_sea:seashell_02_node", "decorations_sea:seashell_03_node"}, {"default:water_flowing","default:water_source"}, 1, 16, 120, 250, 3, -200, -3)
mobs:register_egg("mobs_creatures:shark", "Shark Spawn Egg", "default_water.png", 1)
