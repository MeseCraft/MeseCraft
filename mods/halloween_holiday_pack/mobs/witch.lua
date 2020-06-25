--original base concept code by maikerumine, License WTFPL
--witch arrow texture and arrow shoot sound from gadgets_modpack by clockgen.
--sounds from snowsong mc pack.
--todo: drops

--Witch for halloween event (Oct 20 - Nov 3).
mobs:register_mob("halloween_holiday_pack:witch", {
	type = "monster",
	hp_min = 20,
	hp_max = 20,
        collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
	visual = "mesh",
	mesh = "mobs_character.b3d",
	textures = {
		{"mobs_creatures_witch.png"},
	},
	makes_footstep_sound = true,
	damage = 6,
	reach = 2,
	walk_velocity = 1.2,
	run_velocity = 2.4,
	pathfinding = 1,
	group_attack = true,
	suffocation = false,
	knockback = true,
	attack_type = "dogshoot",
	arrow = "halloween_holiday_pack:witch_curse",
	shoot_interval = 2,
	dogshoot_switch = 2,
	dogshoot_count = 0,
	dogshoot_count_max =5,
	shoot_offset = 1.5,
	drops = {
                {name = "halloween_holiday_pack:candycorn", chance = 4, min = 1, max = 2},
                {name = "halloween_holiday_pack:caramel_apple", chance = 4, min = 1, max = 2},
                {name = "halloween_holiday_pack:halloween_chocolate", chance = 4, min = 1, max = 2},
                {name = "halloween_holiday_pack:lolipop", chance = 4, min = 1, max = 2},
                {name = "magic_materials:magic_flower", chance = 10, min = 1, max = 1},
                {name = "magic_materials:magic_mushroom", chance = 10, min = 1, max = 2},
                {name = "magic_materials:magic_root", chance = 10, min = 1, max = 2},
		{name = "gadgets_consumables:potion_mana_regen_02", chance = 10, min = 1, max = 1},
                {name = "gadgets_consumables:potion_gravity_02", chance = 10, min = 1, max = 1},
                {name = "halloween_holiday_pack:mask_cat", chance = 100, min = 1, max = 1},
                {name = "halloween_holiday_pack:suit_harry", chance = 100, min = 1, max = 1},
                {name = "bweapons_magic_pack:staff_void", chance = 100, min = 1, max = 1},
	},
	sounds = {
		random = "mobs_creatures_witch_random",
		death = "mobs_creatures_witch_death",
		damage = "mobs_creatures_witch_damage",
		shoot_attack = "mobs_creatures_witch_shoot_attack",
		attack = "mobs_creatures_witch_attack",
		distance = 16,
	},
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
	water_damage = 5,
	lava_damage = 5,
	light_damage = 5,
	view_range = 16,
	fear_height = 4,
	    -- Only spawn around Halloween date/time (Oct 20th - Nov 3rd, 2 weeks).
	do_custom = function(self)
	        local date = os.date("*t")
		        if not (date.month == 10 and date.day >= 20) or (date.month == 11 and date.day <= 3) then
		                       self.object:remove()
		        end
	    end,
})
-- Witch's Arrow
mobs:register_arrow(":halloween_holiday_pack:witch_curse", {
	visual = "sprite",
	visual_size = {x = 1, y = 1},
	textures = {"mobs_creatures_witch_arrow.png"},
	velocity = 10,

	-- direct hit, no fire... just plenty of pain
	hit_player = function(self, player)
		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 8},
		}, nil)
	end,

	hit_mob = function(self, player)
		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 8},
		}, nil)
	end,

	-- node hit, bursts into flame
	hit_node = function(self, pos, node)
		--fire:permanent_flame(pos, 1, 1, 0) --causes crash.
	end
})

-- spawn egg
mobs:register_egg("halloween_holiday_pack:witch", "Witch Spawn Egg", "mobs_creatures_witch_arrow.png", 1)

-- World spawning parameters for the witch.
mobs:spawn_specific("halloween_holiday_pack:witch", {"group:cracky", "group:crumbly", "group:shovely", "group:pickaxey"}, {"air"}, 0, 5, 240, 3000, 2, -30912, 30192, false)
