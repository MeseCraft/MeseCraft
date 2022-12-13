mobs:register_mob("slimes:icy_slime", {
	group_attack = true,
	type = "monster",
	passive = false,
	attack_animals = false,
	attack_npcs = false,
	attack_monsters = false,
	attack_type = "dogfight",
	reach = 2,
	damage = slimes.strong_dmg,
	hp_min = 20,
	hp_max = 40,
	armor = 180,
        collisionbox = {-0.4, -0.02, -0.4, 0.4, 0.8, 0.4},
	visual_size = {x = 4, y = 4},
	visual = "mesh",
	mesh = "slime_land.b3d",
	blood_texture = "slime_goo.png^[colorize:"..slimes.colors["icy"],
	textures = {
		{"slime_goo_block.png^[colorize:"..slimes.colors["icy"],"slime_goo_block.png^[colorize:"..slimes.colors["icy"],"slime_goo_block.png^[colorize:"..slimes.colors["icy"]},
	},
        sounds = {
                jump = "mobs_monster_slime_jump",
                attack = "mobs_monster_slime_attack",
                damage = "mobs_monster_slime_damage",
                death = "mobs_monster_slime_death",
        },
	makes_footstep_sound = false,
	walk_velocity = 0.5,
	run_velocity = 1.25,
	jump_height = 7,
	jump = true,
	view_range = 15,
	--floats = 0,
	--fly_in = {"default:water_source", "default:water_flowing", "default:river_water_source", "default:river_water_flowing"},
	drops = {
		{name = "slimes:icy_goo", chance = 1, min = 0, max = 2},
	},
	water_damage = 0,
	lava_damage = 256,
	light_damage = 0,
	replace_rate = 2,
	replace_what = {
		{"default:water_source", "default:ice", -1},
		{"default:water_flowing", "default:ice", -1},
		{"default:river_water_source", "default:ice", -1},
		{"default:river_water_flowing", "default:ice", -1}
	},
	animation = {
		idle_start = 0,
		idle_end = 20,
		move_start = 21,
		move_end = 41,
		fall_start = 42,
		fall_end = 62,
		jump_start = 63,
		jump_end = 83
	},
	do_custom = function(self)
		slimes.animate(self)
		slimes.absorb_nearby_items(self)
	end,
	on_die = function(self, pos)
		slimes.drop_items(self, pos)
	end
})


mobs:spawn({
	name = "slimes:icy_slime",
	nodes = {"group:snowy", "default:ice"},
	min_light = 0,
	max_light = 16,
	chance = slimes.uncommon,
	active_object_count = slimes.uncommon_max,
	min_height = -31000,
	max_height = 31000,
})
