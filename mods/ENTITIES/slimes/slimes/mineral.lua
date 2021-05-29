mobs:register_mob("slimes:mineral_slime", {
	group_attack = true,
	type = "animal",
	passive = false,
	attack_animals = false,
	attack_npcs = false,
	attack_monsters = false,
	attack_type = "dogfight",
	reach = 2,
	damage = slimes.medium_dmg,
	hp_min = 20,
	hp_max = 40,
	armor = 180,
	collisionbox = {-0.4, -0.02, -0.4, 0.4, 0.8, 0.4},
	visual_size = {x = 4, y = 4},
	visual = "mesh",
	mesh = "slime_land.b3d",
	blood_texture = "slime_goo.png^[colorize:"..slimes.colors["mineral"],
	textures = {
		{"slime_goo_block.png^[colorize:"..slimes.colors["mineral"],"slime_goo_block.png^[colorize:"..slimes.colors["mineral"],"slime_goo_block.png^[colorize:"..slimes.colors["mineral"]},
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
	--fly_in = {"default:water_source", "default:water_flowing", "default:river_water_source", "default:river_water_flowing"},
	drops = {
		{name = "slimes:mineral_goo", chance = 1, min = 0, max = 2},
	},
	water_damage = 0,
	lava_damage = 8,
	light_damage = 0,
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

minetest.register_craft({
	type = "cooking",
	output = "default:steel_ingot",
	recipe = "slimes:mineral_goo"
})

mobs:spawn({
	name = "slimes:mineral_slime",
	nodes = {
		"default:stone"
	},
	min_light = 0,
	max_light = 16,
	chance = slimes.common,
	active_object_count = slimes.common_max,
	min_height = -31000,
	max_height = -24,
})
