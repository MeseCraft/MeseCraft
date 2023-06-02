--###################
--################### Snapper
--###################
-- from mc mobs (tropicalfishB)
-- TODO: Drops, color textures.
mobs:register_mob("mesecraft_mobs:snapper", {
	type = "animal",
	passive = true,
	runaway = true,
        runaway_from = {"player"},
	stepheight = 0.1,
	hp_min = 3,
	hp_max = 3,
	armor = 200,
	collisionbox = {-0.35, -0.01, -0.35, 0.35, 0.5, 0.35},
	visual = "mesh",
	mesh = "mesecraft_mobs_snapper.b3d",
    textures = {
        { "mesecraft_mobs_snapper_1.png"},
	{ "mesecraft_mobs_snapper_2.png"},
        { "mesecraft_mobs_snapper_3.png"},
        { "mesecraft_mobs_snapper_4.png"},
        { "mesecraft_mobs_snapper_5.png"},
        { "mesecraft_mobs_snapper_6.png"},
	},
	visual_size = {x=3, y=3},
        drops = {
               {name = "mesecraft_mobs:snapper_raw", chance = 1, min = 1, max = 1},
               {name = "bonemeal:bonemeal", chance = 20, min = 1, max = 1},
        },
	walk_velocity = 0.6,
	run_velocity = 2.75,
	jump = false,
	fly = true,
	fly_in = "default:water_source",
	fall_speed = 0,
	view_range = 6,
	water_damage = 0,
	lava_damage = 10,
	light_damage = 0,
	animation = {
	        stand_speed = 25,
	        walk_speed = 25,
		run_speed = 50,
		stand_start = 0,
	        stand_end = 20,
		walk_start = 0,
	        walk_end = 20,
		run_start = 0,
	        run_end = 20,
	},
})
-- Register spawning conditions. -- spawns in tropical and warm, near coral.
mobs:spawn_specific("mesecraft_mobs:snapper",      {"default:wood", "default:tree", "default:coral_brown", "default:coral_orange","default:coral_cyan","default:coral_green","default:coral_pink", "decorations_sea:seagrass_02", "decorations_sea:seagrass_03", "decorations_sea:seagrass_05", "decorations_sea:seagrass_06", "decorations_sea:coral_plantlike_01", "decorations_sea:coral_plantlike_02", "decorations_sea:coral_plantlike_03", "decorations_sea:coral_plantlike_04", "decorations_sea:coral_plantlike_05"}, {"default:water_flowing","default:water_source"}, 1, 16, 120, 120, 16, -200, -1)
-- Register spawn egg.
mobs:register_egg("mesecraft_mobs:snapper", "Snapper Spawn Egg", "default_water.png", 1)
