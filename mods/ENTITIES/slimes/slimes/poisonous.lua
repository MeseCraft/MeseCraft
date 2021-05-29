mobs:register_mob("slimes:poisonous_slime", {
	group_attack = true,
	type = "monster",
	passive = false,
	attack_animals = true,
	attack_npcs = true,
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
	blood_texture = "slime_goo.png^[colorize:"..slimes.colors["poisonous"],
	textures = {
		{"slime_goo_block.png^[colorize:"..slimes.colors["poisonous"],"slime_goo_block.png^[colorize:"..slimes.colors["poisonous"],"slime_goo_block.png^[colorize:"..slimes.colors["poisonous"]},
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
		{name = "slimes:poisonous_goo", chance = 1, min = 0, max = 2},
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

minetest.override_item("slimes:poisonous_goo", {on_use = function(item, player, ...)
	minetest.item_eat(1)(item, player,...)
	slimes.poisoned_players[player:get_player_name()] = 6
end})

slimes.poisoned_players = {}
minetest.register_on_punchplayer(function(player, hitter)
	if not hitter then return end
	local e = hitter:get_luaentity()
	if e and e.name == "slimes:poisonous_slime" and math.random() >= 0.67 then
		slimes.poisoned_players[player:get_player_name()] = math.random(3, 8)
	end
end)

minetest.register_globalstep(function(dt)
	for name, time in pairs(slimes.poisoned_players) do
		if time < dt then
			local player = minetest.get_player_by_name(name)
			if player then player:set_hp(0) end
			slimes.poisoned_players[name] = nil
		else
			slimes.poisoned_players[name] = time - dt
		end
	end
end)

minetest.register_on_leaveplayer(function(player)
	if slimes.poisoned_players[player:get_player_name()] then 
		player:set_hp(0) -- You are NOT getting away.
	end
	slimes.poisoned_players[player:get_player_name()] = nil
end)

minetest.register_on_dieplayer(function(player)
	slimes.poisoned_players[player:get_player_name()] = nil
end)

local g = table.copy(minetest.registered_nodes["slimes:poisonous_goo_block"].groups)
g.harmful_slime = slimes.medium_dmg
minetest.override_item("slimes:poisonous_goo_block", {groups=table.copy(g)})

mobs:spawn({
	name = "slimes:poisonous_slime",
	nodes = {
		"default:dirt_with_rainforest_litter"
	},
	min_light = 0,
	max_light = 16,
	chance = slimes.uncommon,
	active_object_count = slimes.uncommon_max,
	min_height = -31000,
	max_height = 31000,
})
