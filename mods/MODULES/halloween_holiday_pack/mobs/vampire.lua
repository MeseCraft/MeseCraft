mobs:register_mob('halloween_holiday_pack:vampire', {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	reach = 2,
	damage = 7,
	hp_min = 50,
	hp_max = 50,
	armor = 100,
	knock_back = true,
        collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
        visual = "mesh",
        mesh = "mobs_character.b3d",
        textures = {
                {"mesecraft_mobs_vampire.png"},
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
	suffocation = false,
	view_range = 16,
	drops = {
	{name = "mesecraft_mobs:bucket_blood", chance = 50, min = 1, max = 1},
	{name = "mesecraft_mobs:bone", chance = 2, min = 0, max = 1},
        {name = "farming:garlic", chance = 25, min = 1, max = 1},
        {name = "halloween_holiday_pack:candycorn", chance = 4, min = 1, max = 2},
        {name = "halloween_holiday_pack:caramel_apple", chance = 4, min = 1, max = 2},
        {name = "halloween_holiday_pack:halloween_chocolate", chance = 4, min = 1, max = 2},
        {name = "halloween_holiday_pack:lolipop", chance = 4, min = 1, max = 2},
        {name = "clothing:cape_black", chance = 50, min = 1, max = 1},
        {name = "halloween_holiday_pack:suit_vampire", chance = 100, min = 1, max = 1},
	},
	lava_damage = 5,
	water_damage = 2,
	light_damage = 10,
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
	custom_attack = function(self)	-- Vampiric Attack
				self.attack:punch(self.object, 1.0,  {full_punch_interval=1.0, damage_groups = {fleshy=self.damage}   	}, nil)
				if self.sounds.attack then
				                    minetest.sound_play(self.sounds.attack, {
				                    object = self.object,
				                    max_hear_distance = self.sounds.distance
				                    })
					            end
		                self.health = math.min(self.object:get_hp()+math.random(1,6),50) --Regenerate Health
	end,
	on_die = function(self,pos)
			        minetest.add_entity(pos, "mesecraft_mobs:bat")
	end,
	-- Only spawn around Halloween date/time (Oct 10th - Nov 1st, 3 weeks).
	do_custom = function(self)
	        local date = os.date("*t")
	        if not (date.month == 10 and date.day >= 10) or (date.month == 11 and date.day <= 1) then
	                       self.object:remove()
	        end
	end,
})

--Spawn Egg
mobs:register_egg("halloween_holiday_pack:vampire", "Vampire Spawn Egg", "wool_black.png", 1)

--mobs:spawn_specfic(name, nodes, neighbors, min_light, max_light, interval,chance, active_object_count, min_height, max_height, day_toggle, on_spawn)
--Spawn Functions
mobs:spawn_specific("halloween_holiday_pack:vampire", {"group:cracky", "group:crumbly", "group:shovely", "group:pickaxey"}, {"air"}, 0, 6, 180, 5000, 3, -30192, 30912, false)
