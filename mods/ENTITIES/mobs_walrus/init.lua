mobs:register_mob("arctic_life:walrus", {
	type = "animal",
	passive = false,
	attack_type = "dogfight",
	reach = 2,
	damage = 5,
	hp_min = 15,
	hp_max = 45,
	armor = 200,
	collisionbox = {-0.35, -0.5, -0.35, 0.35, 0.4, 0.35},
	visual = "mesh",
	mesh = "arctic_life_walrus.b3d",
	drawtype = "front",
	textures = {
		{"arctic_life_walrus1.png"},
		{"arctic_life_walrus2.png"},
	},
	blood_texture = "mobs_blood.png",
	visual_size = {x=10,y=10},
	makes_footstep_sound = false,
	sounds = {
		random = "walrus_random.ogg",
      war_cry = 'walrus_war_cry.ogg',
      attack = 'walrus_attack.ogg'
	},
	-- speed and jump
	walk_velocity = 1,
	run_velocity = 2,
	jump = true,
	jump_height = 1,
	stepheight = 1.1,
	floats = 1,
	-- drops raw meat when dead
	drops = {
		{name = "mobs:meat_raw",
		chance = 1, min = 2, max = 5},
	},
	-- damaged by
	water_damage = 0,
	lava_damage = 5,
	light_damage = 0,
	-- model animation
	animation = {
		speed_normal = 15,	speed_run = 15,
		stand_start = 0,		stand_end = 50, -- head down/up
		walk_start = 55,		walk_end = 95, -- walk
		run_start = 55,		run_end = 95, -- walk
		punch_start = 100,		punch_end = 145, -- attack
	},
	follow = "farming:wheat", view_range = 7,
	replace_rate = 50,
	replace_what = {"group:flora"},
	replace_with = "air",
})

mobs:register_spawn("arctic_life:walrus", {"default:snow", "default:ice"}, 20, 0, 20000, 1, 100)
mobs:register_egg("arctic_life:walrus", "Walrus", "default_grass.png", 1)
