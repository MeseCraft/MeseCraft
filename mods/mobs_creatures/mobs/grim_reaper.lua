-- Death (Grim Reaper)
mobs:register_mob("mobs_creatures:grim_reaper", {
	type = "monster",
	hp_min = 100,
	hp_max = 100,
	pathfinding = 1,
        collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
	visual = "mesh",
	mesh = "mobs_character.b3d",
	textures = {
		{"mobs_creatures_grim_reaper.png"},
	},
	visual_size = {x=1, y=1},
	makes_footstep_sound = true,
	armor = 50,
	knock_back = false,
        sounds = {
                random = "mobs_creatures_skeleton_random",
                death = "mobs_creatures_skeleton_death",
                damage = "mobs_creatures_skeleton_damage",
                attack = "mobs_creatures_skeleton_attack",
                jump = "mobs_creatures_skeleton_jump",
                distance = 16,
        },
	walk_velocity = 1.0,
	run_velocity = 1.0,
	damage = 100,
	reach = 3,
	drops = {
		{name = "farming:hoe_steel", chance = 2, min = 1, max = 1,},
		{name = "bones:bones", chance = 1, min = 1, max = 1,},
                {name = "mobs_creatures:candycorn", chance = 4, min = 1, max = 2},
                {name = "mobs_creatures:caramel_apple", chance = 4, min = 1, max = 2},
                {name = "mobs_creatures:halloween_chocolate", chance = 4, min = 1, max = 2},
                {name = "mobs_creatures:lolipop", chance = 4, min = 1, max = 2},
		{name = "halloween:suit_reaper", chance = 100, min = 1, max = 1},
                {name = "halloween:suit_skeleton", chance = 100, min = 1, max = 1},
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
})
-- spawn eggs
mobs:register_egg("mobs_creatures:grim_reaper", "Grim Reaper Spawn Egg", "wool_black.png", 1)

-- Only spawn Death around Halloween date/time (Oct 20th - Nov 3rd, 2 weeks).
local date = os.date("*t")
if (date.month == 10 and date.day >= 20) or (date.month == 11 and date.day <= 3) then
        -- World spawning parameters for Death.
	mobs:spawn_specific("mobs_creatures:grim_reaper", {"group:cracky", "group:crumbly", "group:shovely", "group:pickaxey"}, {"air"}, 0, 5, 240, 18000, 1, -30912, 30912, false)
else
        return
end
