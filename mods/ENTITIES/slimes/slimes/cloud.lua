mobs:register_mob("slimes:cloud_slime", {
	group_attack = true,
	type = "animal",
	passive = false,
	attack_animals = false,
	attack_npcs = false,
	attack_monsters = false,
	attack_type = "dogfight",
	reach = 3,
	damage = slimes.strong_dmg,
	hp_min = 20,
	hp_max = 40,
	armor = 180,
        collisionbox = {-0.4, -0.02, -0.4, 0.4, 0.8, 0.4},
	visual_size = {x = 4, y = 4},
	visual = "mesh",
	mesh = "slime_liquid.b3d",
	blood_texture = "slime_goo.png^[colorize:"..slimes.colors["cloud"],
	textures = {
		{"slime_goo_block.png^[colorize:"..slimes.colors["cloud"],"slime_goo_block.png^[colorize:"..slimes.colors["cloud"].."^[colorize:#FFF:96"},
	},
        sounds = {
                jump = "mobs_monster_slime_jump",
                attack = "mobs_monster_slime_attack",
                damage = "mobs_monster_slime_damage",
                death = "mobs_monster_slime_death",
        },
	makes_footstep_sound = false,
	walk_velocity = 0.75,
	run_velocity = 5,
	jump_height = 7,
	jump = true,
	view_range = 15,
	fly = true,
	fly_in = {"air", "default:water_source", "default:water_flowing", "default:river_water_source", "default:river_water_flowing"},
	drops = {
		{name = "slimes:cloud_goo", chance = 1, min = 0, max = 2},
	},
	water_damage = 0,
	lava_damage = 8,
	light_damage = 0,
	animation = {
		idle_start = 0,
		idle_end = 19,
		move_start = 21,
		move_end = 41,
		fall_start = 42,
		fall_end = 62,
		jump_start = 63,
		jump_end = 83
	},
	do_custom = function(self)
	--	slimes.animate(self)
		slimes.absorb_nearby_items(self)
	end,
	on_die = function(self, pos)
		slimes.drop_items(self, pos)
	end
})

minetest.override_item("slimes:cloud_goo", {on_use = minetest.item_eat(0)})

mobs:spawn({
	name = "slimes:cloud_slime",
	nodes = {
		"default:silver_sand",
		"air"
	},
	min_light = 0,
	max_light = 16,
	chance = slimes.rare,
	active_object_count = slimes.rare_max,
	min_height = 130,
	max_height = 1000,
})
