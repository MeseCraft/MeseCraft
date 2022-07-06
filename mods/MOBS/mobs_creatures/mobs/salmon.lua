--###################
--################### SALMON
--###################
-- from mc_mobs

mobs:register_mob("mobs_creatures:salmon", {
	type = "animal",
	passive = true,
	runaway = true,
	runaway_from = {"player"},
	stepheight = 0.1,
	hp_min = 3,
	hp_max = 3,
	armor = 200,
	collisionbox = {-0.35, -0.01, -0.35, 0.35, 1, 0.35},
	visual = "mesh",
	mesh = "mobs_creatures_salmon.b3d",
	textures = {
		{"mobs_creatures_salmon.png"},
	},
	visual_size = {x=3, y=3},
        drops = {
               {name = "mobs_creatures:salmon_raw", chance = 1, min = 1, max = 1},
               {name = "bonemeal:bonemeal", chance = 20, min = 1, max = 1},
        },
	walk_velocity = 0.6,
	run_velocity = 2.75,
	jump = false,
	makes_footstep_sound = false,
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

-- Register spawning conditions. -- spawns in cold and mild areas.
mobs:spawn_specific("mobs_creatures:salmon", {"default:sand_with_kelp", "default:ice", "default:snow", "default:wood", "default:tree","decorations_sea:seagrass_01", "decorations_sea:seagrass_03", "decorations_sea:seashell_01_node", "decorations_sea:seashell_02_node", "decorations_sea:seashell_03_node"}, {"default:water_flowing", "default:water_source"}, 1, 16, 60, 100, 16, -200, -1)

-- Register spawn egg.
mobs:register_egg("mobs_creatures:salmon", "Salmon Spawn Egg", "default_water.png", 1)
