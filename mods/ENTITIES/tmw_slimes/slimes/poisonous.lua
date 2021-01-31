mobs:register_mob("tmw_slimes:poisonous_slime", {
	group_attack = true,
	type = "monster",
	passive = false,
	attack_animals = true,
	attack_npcs = true,
	attack_monsters = false,
	attack_type = "dogfight",
	reach = 2,
	damage = tmw_slimes.medium_dmg,
	hp_min = 20,
	hp_max = 40,
	armor = 180,
        collisionbox = {-0.4, -0.02, -0.4, 0.4, 0.8, 0.4},
	visual_size = {x = 4, y = 4},
	visual = "mesh",
	mesh = "slime_land.b3d",
	blood_texture = "tmw_slime_goo.png^[colorize:"..tmw_slimes.colors["poisonous"],
	textures = {
		{"tmw_slime_goo_block.png^[colorize:"..tmw_slimes.colors["poisonous"],"tmw_slime_goo_block.png^[colorize:"..tmw_slimes.colors["poisonous"],"tmw_slime_goo_block.png^[colorize:"..tmw_slimes.colors["poisonous"]},
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
		{name = "tmw_slimes:poisonous_goo", chance = 1, min = 0, max = 2},
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

minetest.override_item("tmw_slimes:poisonous_goo", {on_use = function(item, player, ...)
	minetest.item_eat(1)(item, player,...)
	tmw_slimes.poisoned_players[player:get_player_name()] = 6
end})

tmw_slimes.poisoned_players = {}
minetest.register_on_punchplayer(function(player, hitter)
	if not hitter then return end
	local e = hitter:get_luaentity()
	if e and e.name == "tmw_slimes:poisonous_slime" and math.random() >= 0.67 then
		tmw_slimes.poisoned_players[player:get_player_name()] = math.random(3, 8)
	end
end)

minetest.register_globalstep(function(dt)
	for name, time in pairs(tmw_slimes.poisoned_players) do
		if time < dt then
			local player = minetest.get_player_by_name(name)
			if player then player:set_hp(0) end
			tmw_slimes.poisoned_players[name] = nil
		else
			tmw_slimes.poisoned_players[name] = time - dt
		end
	end
end)

minetest.register_on_leaveplayer(function(player)
	if tmw_slimes.poisoned_players[player:get_player_name()] then 
		player:set_hp(0) -- You are NOT getting away.
	end
	tmw_slimes.poisoned_players[player:get_player_name()] = nil
end)

minetest.register_on_dieplayer(function(player)
	tmw_slimes.poisoned_players[player:get_player_name()] = nil
end)

local g = table.copy(minetest.registered_nodes["tmw_slimes:poisonous_goo_block"].groups)
g.harmful_slime = tmw_slimes.medium_dmg
minetest.override_item("tmw_slimes:poisonous_goo_block", {groups=table.copy(g)})

mobs:spawn({
	name = "tmw_slimes:poisonous_slime",
	nodes = {
		"default:dirt_with_rainforest_litter"
	},
	min_light = 0,
	max_light = 16,
	chance = tmw_slimes.uncommon,
	active_object_count = tmw_slimes.uncommon_max,
	min_height = -31000,
	max_height = 31000,
})
