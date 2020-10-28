-- Random howl sounds by klankbeeld - https://freesound.org/people/klankbeeld/sounds/133763/
-- hit sounds by robinhood76 - https://freesound.org/people/Robinhood76/sounds/161488/
-- Warcry sound by missozzy - https://freesound.org/people/missozzy/sounds/169985/
-- todo spawn a villager/npc when killed?
mobs:register_mob('halloween_holiday_pack:werewolf', {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	reach = 3,
	damage = 10,
	hp_min = 50,
	hp_max = 50,
	armor = 75,
	knock_back = false,
        collisionbox = {-0.5,-1.5,-0.5, 0.5,1.2,0.5},
        visual = "mesh",
        mesh = "mobs_character.b3d",
	visual_size = {x=1.5, y=1.5},
        textures = {
                {"mobs_creatures_werewolf.png"},
        },
	blood_texture = "mobs_blood.png",
	makes_footstep_sound = true,
	sounds = {
		random ="mobs_creatures_werewolf_random",
		attack = "mobs_creatures_bogeyman_attack",
		damage = "mobs_creatures_werewolf_damage",
		death = "mobs_creatures_bogeyman_death",
		distance = 32,
	},
	walk_velocity = 2.0,
	run_velocity = 3.5,
	jump = true,
	floats = true,
	suffocation = false,
	view_range = 16,
	drops = {
	{name = "mobs:meat_raw", chance = 1, min = 1, max = 1},
	{name = "mobs_creatures:bone", chance = 2, min = 1, max = 1},
        {name = "halloween_holiday_pack:candycorn", chance = 4, min = 1, max = 2},
        {name = "halloween_holiday_pack:caramel_apple", chance = 4, min = 1, max = 2},
        {name = "halloween_holiday_pack:halloween_chocolate", chance = 4, min = 1, max = 2},
        {name = "halloween_holiday_pack:lolipop", chance = 4, min = 1, max = 2},	
        {name = "clothing:pants_blue", chance = 50, min = 1, max = 1},
        {name = "halloween_holiday_pack:suit_wearwolf", chance = 100, min = 1, max = 1},
	},
	lava_damage = 5,
	water_damage = 2,
	light_damage = 5,
	fall_damage = 2,
        animation = {
                speed_normal = 30,
                speed_run = 45,
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
mobs:register_egg("halloween_holiday_pack:werewolf", "Werewolf Spawn Egg", "mobs_meat_raw.png", 1)

--mobs:spawn_specfic(name, nodes, neighbors, min_light, max_light, interval,chance, active_object_count, min_height, max_height, day_toggle, on_spawn)
--Spawn Functions
mobs:spawn_specific("halloween_holiday_pack:werewolf", {"group:flora", "group:leaves"}, {"air"}, 0, 4, 240, 2000, 1, -30912, 30912, false)
