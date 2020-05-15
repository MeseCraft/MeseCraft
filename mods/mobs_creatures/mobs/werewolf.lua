-- Random howl sounds by klankbeeld - https://freesound.org/people/klankbeeld/sounds/133763/
-- hit sounds by robinhood76 - https://freesound.org/people/Robinhood76/sounds/161488/
-- Warcry sound by missozzy - https://freesound.org/people/missozzy/sounds/169985/
mobs:register_mob('mobs_creatures:werewolf', {
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
        {name = "mobs_creatures:candycorn", chance = 4, min = 1, max = 2},
        {name = "mobs_creatures:caramel_apple", chance = 4, min = 1, max = 2},
        {name = "mobs_creatures:halloween_chocolate", chance = 4, min = 1, max = 2},
        {name = "mobs_creatures:lolipop", chance = 4, min = 1, max = 2},	
        {name = "clothing:pants_blue", chance = 50, min = 1, max = 1},
        {name = "halloween:suit_wearwolf", chance = 100, min = 1, max = 1},
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
})
--Spawn Eggs
mobs:register_egg("mobs_creatures:werewolf", "Werewolf Spawn Egg", "mobs_meat_raw.png", 1)

-- Spawn Werewolf between (Oct 20 - Nov 3).
local date = os.date("*t")
if (date.month == 10 and date.day >= 20) or (date.month == 11 and date.day <= 3) then
        --Spawn Functions
	mobs:spawn_specific("mobs_creatures:werewolf", {"group:flora", "group:leaves"}, {"air"}, 0, 4, 480, 4000, 1, -30912, 30912, false)
else
        return
end


