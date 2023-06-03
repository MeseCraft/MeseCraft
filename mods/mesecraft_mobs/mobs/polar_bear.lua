--License for code WTFPL and otherwise stated in readmes
mobs:register_mob("mesecraft_mobs:polar_bear", {
	type = "animal",
	runaway = false,
	passive = false,
	stepheight = 1.2,
	hp_min = 50,
	hp_max = 50,
	collisionbox = {-0.7, -0.01, -0.7, 0.7, 1.39, 0.7},
	visual = "mesh",
	mesh = "mesecraft_mobs_polarbear.b3d",
	textures = {
		{"mesecraft_mobs_polarbear.png"},
	},
	visual_size = {x=3.0, y=3.0},
	makes_footstep_sound = true,
	damage = 7,
	reach = 2,
	walk_velocity = 1.2,
	run_velocity = 2.4,
	group_attack = true,
	attack_type = "dogfight",
	drops = {
		{name = "mobs_creatuers:meat", chance = 1, min = 1, max = 2,},		
	},
	water_damage = 0,
	floats = 1,
	lava_damage = 5,
	light_damage = 0,
	fear_height = 4,
	sounds = {
		random = "mesecraft_mobs_polarbear_random",
		damage = "mesecraft_mobs_polarbear_damage",
		attack = "mesecraft_mobs_polarbear_attack",
		jump = "mesecraft_mobs_polarbear_jump",
		death = "mesecraft_mobs_polarbear_death",
		distance = 16,
	},
	animation = {
		speed_normal = 25,		speed_run = 50,
		stand_start = 0,		stand_end = 0,
		walk_start = 0,		walk_end = 40,
		run_start = 0,		run_end = 40,
	},

	view_range = 16,
})

-- spawn
mobs:spawn_specific("mesecraft_mobs:polar_bear", {"default:snowblock", "default:dirt_with_snow"}, {"air"}, 0, 15, 240, 2000, 2, 1,15)

-- spawn egg
mobs:register_egg("mesecraft_mobs:polar_bear", "Polar Bear", "wool_white.png", 1)
