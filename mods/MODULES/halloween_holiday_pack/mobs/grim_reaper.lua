-- Death (Grim Reaper)
mobs:register_mob("halloween_holiday_pack:grim_reaper", {
	type = "monster",
	hp_min = 100,
	hp_max = 100,
	pathfinding = 1,
        collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
	visual = "mesh",
	mesh = "mobs_character.b3d",
	textures = {
		{"mesecraft_mobs_grim_reaper.png"},
	},
	visual_size = {x=1, y=1},
	makes_footstep_sound = true,
	armor = 100,
	knock_back = true,
        sounds = {
                random = "mesecraft_mobs_skeleton_random",
                death = "mesecraft_mobs_skeleton_death",
                damage = "mesecraft_mobs_skeleton_damage",
                attack = "mesecraft_mobs_skeleton_attack",
                jump = "mesecraft_mobs_skeleton_jump",
                distance = 16,
        },
	walk_velocity = 1.0,
	run_velocity = 1.0,
	damage = 100,
	reach = 3,
	drops = {
		{name = "farming:hoe_steel", chance = 2, min = 1, max = 1,},
		{name = "mesecraft_bones:bones", chance = 1, min = 1, max = 1,},
                {name = "halloween_holiday_pack:candycorn", chance = 4, min = 1, max = 2},
                {name = "halloween_holiday_pack:caramel_apple", chance = 4, min = 1, max = 2},
                {name = "halloween_holiday_pack:halloween_chocolate", chance = 4, min = 1, max = 2},
                {name = "halloween_holiday_pack:lolipop", chance = 4, min = 1, max = 2},
		{name = "halloween_holiday_pack:suit_reaper", chance = 100, min = 1, max = 1},
                {name = "halloween_holiday_pack:suit_skeleton", chance = 100, min = 1, max = 1},
	},
        animation = {
                speed_normal = 15,
                speed_run = 15,
                stand_start = 0,
                stand_end = 79,
                walk_start = 168,
                walk_end = 187,
                run_start = 168,
                run_end = 187,
                punch_start = 0,
                punch_end = 79,
        },
	water_damage = 5,
	lava_damage = 0,
	light_damage = 5,
	view_range = 32,
	attack_type = "dogfight",
	shoot_interval = 2.5,
	blood_amount = 0,
	fear_height = 4,
	    -- Only spawn around Halloween date/time (Oct 10th - Nov 1st, 3 weeks).
	    do_custom = function(self)
		        local date = os.date("*t")
		        if not (date.month == 10 and date.day >= 10) or (date.month == 11 and date.day <= 1) then
		                       self.object:remove()
		        end
	    end,
})
-- spawn eggs
mobs:register_egg("halloween_holiday_pack:grim_reaper", "Grim Reaper Spawn Egg", "wool_black.png", 1)

--mobs:spawn_specfic(name, nodes, neighbors, min_light, max_light, interval,chance, active_object_count, min_height, max_height, day_toggle, on_spawn)
-- World spawning parameters for Death.
mobs:spawn_specific("halloween_holiday_pack:grim_reaper", {"mesecraft_bones:bones"}, {"air"}, 0, 5, 120, 1000, 1, -30912, 30912, false)
