mobs:register_mob('mobs_creatures:frankenstein', {
	type = "animal",
	passive = false,
	attack_type = "dogfight",
	reach = 2,
	damage = 10,
	hp_min = 50,
	hp_max = 50,
	armor = 75,
	knock_back = false,
        collisionbox = {-0.44,-1.25,-0.44, 0.44,1.0,0.44},
	visual_size = {x=1.25, y=1.25},
        visual = "mesh",
        mesh = "mobs_character.b3d",
        textures = {
                {"mobs_creatures_frankenstein.png"},
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
	walk_velocity = 1.25,
	run_velocity = 2.5,
	jump = true,
	floats = true,
	suffocation = false,
	view_range = 16,
	drops = {
	{name = "mobs_creatures:rotten_flesh", chance = 1, min = 1, max = 1},
        {name = "farming:string", chance = 1, min = 1, max = 1},
	{name = "mobs_creatures:bone", chance = 4, min = 1, max = 1},
        {name = "flowers:rose", chance = 10, min = 1, max = 1},
        {name = "default:book", chance = 10, min = 1, max = 1},
        {name = "church_grave:grave_fancy", chance = 25, min = 1, max = 1},
        {name = "mobs_creatures:candycorn", chance = 4, min = 1, max = 2},
        {name = "mobs_creatures:caramel_apple", chance = 4, min = 1, max = 2},
        {name = "mobs_creatures:halloween_chocolate", chance = 4, min = 1, max = 2},
        {name = "mobs_creatures:lolipop", chance = 4, min = 1, max = 2},
        {name = "halloween:suit_frank", chance = 100, min = 1, max = 1},
        {name = "halloween:suit_totoro", chance = 100, min = 1, max = 1},
	},
	lava_damage = 5,
	water_damage = 2,
	light_damage = 0,
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
})

--Spawn Eggs
mobs:register_egg("mobs_creatures:frankenstein", "Frankenstein Spawn Egg", "wool_green.png", 1)

-- Only spawn Pumpbooms around Halloween date/time (Oct 20th - Nov 3rd, 2 weeks).
local date = os.date("*t")
if (date.month == 10 and date.day >= 20) or (date.month == 11 and date.day <= 3) then
	--Spawn Functions
	mobs:spawn_specific("mobs_creatures:frankenstein", {"group:cracky", "group:crumbly", "group:shovely", "group:pickaxey"}, {"air"}, 0, 6, 120, 6000, 1, -30912, 30912, false)
else
        return
end

