--License for code WTFPL and otherwise stated in license.
mobs:register_mob("mobs_creatures:giant_bat", {
	type = "monster",
	passive = false,
        knock_back = false,
	hp_min = 50,
	hp_max = 50,
	attack_type = "dogfight",
	damage = 12,
	reach = 2,
	armor = 175,
	collisionbox = {-0.5, -0.02, -0.5, 0.5, 1.6, 0.5},
	visual = "mesh",
	mesh = "mobs_creatures_bat.b3d",
	textures = {
		{"mobs_creatures_bat.png"},
	},
	visual_size = {x=4, y=4},
	sounds = {
		random = "mobs_creatures_bat_random", 
		attack = "mobs_creatures_bat_attack",
		damage = "mobs_creatures_bat_damage",
		death = "mobs_creatures_bat_death",
		jump = "mobs_creatures_bat_jump",
		attack = "mobs_creatures_bat_attack",
		distance = 16,
	},
	walk_velocity = 2.5,
	run_velocity = 4.0,
	stand_chance = 10,
	-- TODO: Hang upside down
	animation = {
		walk_speed = 80, stand_speed = 80, run_speed = 80,
		stand_start = 0,		stand_end = 40,
		walk_start = 0,		walk_end = 40,
		run_start = 0,		run_end = 40,
	},
	water_damage = 1,
	lava_damage = 4,
	light_damage = 0,
	fall_damage = 0,
	view_range = 16,
	fly = true,
	fly_in = "air",
})


-- Spawning

--[[ If the game has been launched between the 20th of October and the 3rd of November system time,
-- the maximum spawn light level is increased. ]]
local date = os.date("*t")
local maxlight
if (date.month == 10 and date.day >= 20) or (date.month == 11 and date.day <= 3) then
	maxlight = 6
else
	maxlight = 3
end

-- Spawn on solid blocks at or below Sea level and the selected light level
mobs:spawn_specific("mobs_creatures:giant_bat", {"group:stone"}, {"air"}, 0, 7, 480, 25000, 2, -6500, -500)

-- spawn eggs
mobs:register_egg("mobs_creatures:giant_bat", "Giant Bat Spawn Egg", "wool_black.png", 1)
