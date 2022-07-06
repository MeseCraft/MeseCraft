--ASTRONAUT
-- TODO, DROPS, SOUNDS, ATTRIBUTIONS, trader
mobs:register_mob('mobs_creatures:astronaut', {
	type = "npc",
	attack_type = "dogfight",
	passive = false,
	attacks_monsters = true,
	attack_animals = false,
	attack_npcs = false,
	reach = 2,
	damage = 7,
	hp_min = 15,
	hp_max = 20,
	armor = 115,
	knock_back = false,
        collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
        visual = "mesh",
        mesh = "mobs_character.b3d",
        textures = {
                {"mobs_creatures_astronaut.png"},
        },
	blood_texture = "mobs_blood.png",
	makes_footstep_sound = true,
	sounds = {
		random ="mobs_creatures_astronaut_random",
--		warcry = "mobs_creatures_zombie_warcry",
--		attack = "mobs_creatures_zombie_attack",
--		damage = "mobs_creatures_zombie_damage",
--		death = "mobs_creatures_zombie_death",
	},
	walk_velocity = 1,
	run_velocity = 3,
	jump = true,
	floats = true,
	suffocation = false,
	view_range = 16,
	drops = {
--	{name = "mobs_creatures:rotten_flesh", chance = 5, min = 0, max = 1}
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
        on_rightclick = function(self, clicker)
                mobs_trader(self, clicker, entity, mobs.lunar_human)
	end,

})

--Spawn Functions
mobs:spawn_specific("mobs_creatures:astronaut", {"default:gravel"}, {"vacuum:vacuum"}, 7, 16, 600, 1000, 1, 3000 ,3500)

--Spawn Eggs
mobs:register_egg("mobs_creatures:astronaut", "Astronaut Spawn Egg", "wool_white.png", 1)

-------- CREDITS & ATTRIBUTIONS --------
-- Trader concept by FreeGamers.org
-- Texture by iMorph
-- Sounds by craigsmith - https://freesound.org/people/craigsmith/sounds/438900/
