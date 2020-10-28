mobs:register_mob('halloween_holiday_pack:halloween_zombie', {
		type = "monster",
		passive = false,
		attack_type = "dogfight",
		reach = 2,
		damage = 4,
		hp_min = 10,
		hp_max = 20,
		armor = 125,
		knock_back = true,
	        collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
	        visual = "mesh",
	        mesh = "mobs_character.b3d",
	        textures = {
	                {"mobs_creatures_zombie_halloween_1.png"},
	                {"mobs_creatures_zombie_halloween_2.png"},
	                {"mobs_creatures_zombie_halloween_3.png"},
	                {"mobs_creatures_zombie_halloween_4.png"},
	        },
		blood_texture = "mobs_blood.png",
		makes_footstep_sound = true,
		sounds = {
			random ="mobs_creatures_zombie_random",
			warcry = "mobs_creatures_zombie_warcry",
			attack = "mobs_creatures_zombie_attack",
			damage = "mobs_creatures_zombie_damage",
			death = "mobs_creatures_zombie_death",
		},
		walk_velocity = 1,
		run_velocity = 2.75,
		jump = true,
		floats = true,
		suffocation = false,
		view_range = 16,
		drops = {
		{name = "mobs_creatures:rotten_flesh", chance = 1, min = 1, max = 1},
		{name = "mobs_creatures:bone", chance = 2, min = 1, max = 1},
                {name = "halloween_holiday_pack:candycorn", chance = 4, min = 1, max = 2},
                {name = "halloween_holiday_pack:caramel_apple", chance = 4, min = 1, max = 2},
                {name = "halloween_holiday_pack:halloween_chocolate", chance = 4, min = 1, max = 2},
                {name = "halloween_holiday_pack:lolipop", chance = 4, min = 1, max = 2},
                {name = "church_grave:grave", chance = 50, min = 1, max = 1},
                {name = "halloween_holiday_pack:suit_dark_unicorn", chance = 100, min = 1, max = 1},
                {name = "halloween_holiday_pack:suit_unicorn", chance = 100, min = 1, max = 1},
                {name = "halloween_holiday_pack:suit_dino", chance = 100, min = 1, max = 1},
                {name = "halloween_holiday_pack:suit_dino_pink", chance = 100, min = 1, max = 1},
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
	    -- Only spawn around Halloween date/time (Oct 10th - Nov 1st, 3 weeks).
	    do_custom = function(self)
		        local date = os.date("*t")
		        if not (date.month == 10 and date.day >= 10) or (date.month == 11 and date.day <= 1) then
		                       self.object:remove()
		        end
	    end,
	})
--Spawn Eggs
mobs:register_egg("halloween_holiday_pack:halloween_zombie", "Halloween Zombie Spawn Egg", "wool_red.png", 1)

--mobs:spawn_specfic(name, nodes, neighbors, min_light, max_light, interval,chance, active_object_count, min_height, max_height, day_toggle, on_spawn)
--Spawn Functions
mobs:spawn_specific("halloween_holiday_pack:halloween_zombie", {"group:cracky", "group:crumbly", "group:shovely", "group:pickaxey"}, {"air"}, 0, 6, 60, 1000, 4, -30912, 30912, false)
