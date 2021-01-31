mobs:register_mob("tmw_slimes:savannah_slime", {
	group_attack = true,
	type = "monster",
	passive = false,
	attack_animals = false,
	attack_npcs = false,
	attack_monsters = false,
	attack_type = "dogfight",
	reach = 2,
	damage = tmw_slimes.strong_dmg,
	hp_min = 20,
	hp_max = 40,
	armor = 180,
        collisionbox = {-0.4, -0.02, -0.4, 0.4, 0.8, 0.4},
	visual_size = {x = 4, y = 4},
	visual = "mesh",
	mesh = "slime_land.b3d",
	blood_texture = "tmw_slime_goo.png^[colorize:"..tmw_slimes.colors["savannah"],
	textures = {
		{"tmw_slime_goo_block.png^[colorize:"..tmw_slimes.colors["savannah"],"tmw_slime_goo_block.png^[colorize:"..tmw_slimes.colors["savannah"],"tmw_slime_goo_block.png^[colorize:"..tmw_slimes.colors["savannah"]},
	},
        sounds = {
                jump = "mobs_monster_slime_jump",
                attack = "mobs_monster_slime_attack",
                damage = "mobs_monster_slime_damage",
                death = "mobs_monster_slime_death",
        },
	makes_footstep_sound = false,
	walk_velocity = 0.5,
	run_velocity = 1.8,
	jump_height = 7,
	jump = true,
	view_range = 15,
	drops = {
		{name = "tmw_slimes:savannah_goo", chance = 1, min = 0, max = 2},
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
		tmw_slimes.animate(self)
		tmw_slimes.absorb_nearby_items(self)
	end,
	on_die = function(self, pos)
		tmw_slimes.drop_items(self, pos)
	end
})

minetest.override_item("tmw_slimes:savannah_goo", {on_use = minetest.item_eat(1)})

if minetest.registered_items["mesecons_materials:glue"] then
	minetest.register_craft({
		type = "cooking",
		output = "mesecons_materials:glue",
		recipe = "tmw_slimes:savannah_goo"
	})
end

mobs:spawn({
	name = "tmw_slimes:savannah_slime",
	nodes = {
		"default:dirt_with_dry_grass", "default:dry_dirt_with_dry_grass", "default:dry_dirt"
	},
	min_light = 0,
	max_light = 16,
	chance = tmw_slimes.uncommon,
	active_object_count = tmw_slimes.uncommon_max,
	min_height = -31000,
	max_height = 31000,
})
