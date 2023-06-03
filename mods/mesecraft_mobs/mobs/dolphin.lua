--###################
--################### DOLPHIN
--###################
-- originally from mc_mobs
--dolphin tail moves up and down 0 to 80
--dolphin tail moves up and down also body moves up and down 100 to 180

mobs:register_mob("mesecraft_mobs:dolphin", {
	type = "animal",
	group_attack = true,
	passive = true,
	runaway = true,
	attack_type = "dogfight",
	damage = 7,
	reach = 2,
	hp_min = 10,
	hp_max = 10,
	armor = 75,
	collisionbox = {-0.35, -0.01, -0.35, 0.35, 1, 0.35},
	visual = "mesh",
	mesh = "mesecraft_mobs_dolphin.b3d",
	textures = {
		{"mesecraft_mobs_dolphin.png"},
	},
        drops = {
               {name = "mesecraft_mobs:cod_raw", chance = 1, min = 0, max = 4},
        },
	visual_size = {x=3, y=3},
	walk_velocity = 0.6,
	run_velocity = 2,
	jump = false,
	fly = true,
	fly_in = "default:water_source",
	fall_speed = 0,
	stepheight = 0.1,
	view_range = 16,
	water_damage = 0,
	lava_damage = 10,
	light_damage = 0,
	animation = {
	        stand_speed = 25,
	        walk_speed = 25,
		run_speed = 50,
		stand_start = 0,
	        stand_end = 0,
		walk_start = 0,
	        walk_end = 80,
		run_start = 100,
	        run_end = 180,
	},
})
-- Register spawning conditions. -- prefers warmer waters
mobs:spawn_specific("mesecraft_mobs:dolphin",  {"default:wood", "default:tree", "default:coral_brown", "default:coral_orange","default:coral_cyan","default:coral_green","default:coral_pink", "decorations_sea:seagrass_02", "decorations_sea:seagrass_03", "decorations_sea:seagrass_05", "decorations_sea:seagrass_06", "decorations_sea:coral_plantlike_01", "decorations_sea:coral_plantlike_02", "decorations_sea:coral_plantlike_03", "decorations_sea:coral_plantlike_04", "decorations_sea:coral_plantlike_05"}, {"default:water_flowing","default:water_source"}, 1, 16, 60, 250, 4, -100, -2)

-- Register spawn egg.
mobs:register_egg("mesecraft_mobs:dolphin", "Dolphin Spawn Egg", "default_water.png", 1)

