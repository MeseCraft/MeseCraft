mobs:register_mob('mesecraft_mobs:zombie', {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	reach = 2,
	damage = 8,
	hp_min = 20,
	hp_max = 30,
	armor = 100,
	knock_back = true,
        collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
        visual = "mesh",
        mesh = "mobs_character.b3d",
        textures = {
                {"mesecraft_mobs_zombie.png"},
        },
	blood_texture = "mobs_blood.png",
	makes_footstep_sound = true,
	sounds = {
		random ="mesecraft_mobs_zombie_random",
		warcry = "mesecraft_mobs_zombie_warcry",
		attack = "mesecraft_mobs_zombie_attack",
		damage = "mesecraft_mobs_zombie_damage",
		death = "mesecraft_mobs_zombie_death",
	},
	walk_velocity = 1,
	run_velocity = 2.75,
	jump = true,
	floats = true,
	suffocation = true,
	view_range = 16,
	drops = {
	{name = "mesecraft_mobs:rotten_flesh", chance = 1, min = 0, max = 1},
	{name = "mesecraft_mobs:bone", chance = 2, min = 0, max = 1},
	},
	lava_damage = 5,
	water_damage = 2,
	light_damage = 5,
	fall_damage = 2,
        animation = {
                speed_normal = 30,
                speed_run = 30,
                stand_start = 0,
                stand_end = 79,
                walk_start = 168,
                walk_end = 187,
                run_start = 168,
                run_end = 187,
                punch_start = 200,
                punch_end = 219,
        },
})

--Spawn Functions
mobs:spawn_specific("mesecraft_mobs:zombie", {"default:dirt_with_grass","default:dirt","default:stone"}, {"air"}, 0, 7, 60, 2000, 4, -500 ,100)

--Spawn Eggs
mobs:register_egg("mesecraft_mobs:zombie", "Zombie Spawn Egg", "wool_red.png", 1)
