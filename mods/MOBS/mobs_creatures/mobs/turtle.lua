--###################
--################### TURTLE
--###################
-- from mobs_mc
--turtle moves on land from 0 to 80
--turtle swims 90 to 170
-- drops seagrass
-- TODO, drops, attributions, swim & land walk, coral&sea spawning.
mobs:register_mob("mobs_creatures:turtle", {
	type = "animal",
	passive = true,
	runaway = true,
	stepheight = 1.2,
	hp_min = 30,
	hp_max = 30,
	armor = 100,
	collisionbox = {-0.35, -0.01, -0.35, 0.35, 1, 0.35},
	visual = "mesh",
	mesh = "mobs_creatures_turtle.b3d",
	textures = {
		{"mobs_creatures_turtle.png"},
	},
	visual_size = {x=3, y=3},
	walk_velocity = 0.6,
	run_velocity = 2,
	jump = false,
	fly = true,
	fly_in = "default:water_source",
	animation = {
	        stand_speed = 25,
	        walk_speed = 25,
		run_speed = 50,
		fly_speed = 25,
		stand_start = 0,
	        stand_end = 0,
		walk_start = 0,
	        walk_end = 80,
		run_start = 0,
	        run_end = 80,
		fly_start = 90,
		fly_end = 170,
	},
})
-- Register spawning parameters.
mobs:spawn_specific("mobs_creatures:turtle", {"default:coral_brown", "default:coral_orange","default:coral_cyan","default:coral_green","default:coral_pink", "decorations_sea:seagrass_02", "decorations_sea:seagrass_03", "decorations_sea:seagrass_05", "decorations_sea:seagrass_06", "decorations_sea:coral_plantlike_01", "decorations_sea:coral_plantlike_02", "decorations_sea:coral_plantlike_03", "decorations_sea:coral_plantlike_04", "decorations_sea:coral_plantlike_05"}, {"default:water_flowing","default:water_source", "default:sand"}, 7, 16, 120, 120, 6, -100, -2)

-- Register spawn egg.
mobs:register_egg("mobs_creatures:turtle", "Turtle Spawn Egg", "default_water.png", 1)
