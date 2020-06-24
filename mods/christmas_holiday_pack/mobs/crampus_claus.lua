mobs:register_mob('christmas_holiday_pack:crampus_claus', {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	reach = 2,
	damage = 12,
	hp_min = 30,
	hp_max = 30,
	armor = 50,
	knock_back = true,
        collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
        visual = "mesh",
        mesh = "mobs_character.b3d",
        textures = {
                {"christmas_holiday_pack_crampus_claus.png"},
        },
	blood_texture = "mobs_blood.png",
	makes_footstep_sound = true,
	sounds = {
	             distance = "16",
--	             war_cry = "mobs_creatures_bogeyman_warcry",
	             random = "mobs_creatures_bogeyman_random",
	             attack = "mobs_creatures_bogeyman_attack",
	             damage = "mobs_creatures_bogeyman_damage",
	             death = "mobs_creatures_bogeyman_death",
	},
	walk_velocity = 1,
	run_velocity = 2.75,
	jump = true,
	floats = true,
	suffocation = true,
	view_range = 16,
	drops = {
	{name = "mobs_creatures:rotten_flesh", chance = 1, min = 0, max = 1},
	{name = "mobs_creatures:bone", chance = 2, min = 0, max = 1},
	{name = "default:gold_ingot", chance = 8, min = 1, max = 1},
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
        do_custom = function(self)
                local date = os.date("*t")
                if not (date.month == 12 and date.day >= 1) or (date.month == 12 and date.day <= 31) then
                                self.object:remove()
                end
        end,
})

--Spawn Eggs
mobs:register_egg("christmas_holiday_pack:crampus_claus", "Crampus Claus Spawn Egg", "wool_brown.png", 1)

--Spawn Functions
mobs:spawn_specific("christmas_holiday_pack:crampus_claus", {"default:dirt_with_snow","default:snow","default:ice"}, {"air"}, 0, 7, 480, 1000, 2, -500 ,100)
