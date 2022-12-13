mobs:register_mob("slimes:lava_slime", {
	group_attack = true,
	type = "monster",
	passive = false,
	attack_animals = true,
	attack_npcs = true,
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
	mesh = "slime_liquid.b3d",
	blood_texture = "slime_goo.png^[colorize:"..slimes.colors["lava"],
	textures = {
		{"slime_goo_block.png^[colorize:"..slimes.colors["lava"],"slime_goo_block.png^[colorize:"..slimes.colors["lava"].."^[colorize:#FFF:96"},
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
	--fly = true,
	--fly_in = {"default:water_source", "default:water_flowing", "default:river_water_source", "default:river_water_flowing"},
	drops = {
		{name = "slimes:lava_goo", chance = 1, min = 0, max = 2},
	},
	water_damage = 10,
	lava_damage = 0,
	light_damage = 0,
	replace_rate = 2,
	replace_what = {
		{"air", "fire:basic_flame", 0},
	},
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
		self.stomach = nil
	end,
	-- Nope, sorry. This is a lava slime. Your items are GONE.
	--[[on_die = function(self, pos)
		slimes.drop_items(self, pos)
	end]]
})

minetest.registered_entities["slimes:lava_slime"].glow = 10

minetest.override_item("slimes:lava_goo", {on_use = minetest.item_eat(-20)})

local g = table.copy(minetest.registered_nodes["slimes:lava_goo_block"].groups)
g.harmful_slime = slimes.strong_dmg
minetest.override_item("slimes:lava_goo_block", {groups=table.copy(g)})

mobs:spawn({
	name = "slimes:lava_slime",
	nodes = {
		"group:lava",
	},
	min_light = 0,
	max_light = 16,
	chance = slimes.pervasive,
	active_object_count = slimes.pervasive_max,
	min_height = -30000,
	max_height = 31000,
})
