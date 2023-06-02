mobs:register_mob('christmas_holiday_pack:zombie_elf', {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	reach = 2,
	damage = 4,
	hp_min = 10,
	hp_max = 20,
	armor = 125,
	knock_back = true,
        collisionbox = {-0.24,-0.75,-0.24, 0.24,0.6,0.24},
        visual = "mesh",
	visual_size = { x=0.75, y=0.75},
        mesh = "mobs_character.b3d",
        textures = {
                {"christmas_holiday_pack_zombie_elf.png"},
        },
	blood_texture = "mobs_blood.png",
	makes_footstep_sound = true,
	sounds = {
		random ="mesecraft_mobs_fire_imp_random",
		warcry = "mesecraft_mobs_fire_imp_warcry",
		attack = "christmas_holiday_pack_sleighbell",
		damage = "christmas_holiday_pack_sleighbell",
		death = "mesecraft_mobs_fire_imp_death",
	},
	walk_velocity = 2,
	run_velocity = 3.25,
	jump = true,
	floats = true,
	suffocation = true,
	view_range = 16,
	drops = {
	{name = "christmas_holiday_pack:present_01", chance = 2, min = 1, max = 1},
	{name = "christmas_holiday_pack:present_02", chance = 2, min = 1, max = 1},
	{name = "christmas_holiday_pack:present_03", chance = 8, min = 1, max = 1},
	{name = "christmas_holiday_pack:present_04", chance = 8, min = 1, max = 1},
	},
	lava_damage = 5,
	water_damage = 2,
	light_damage = 5,
	fall_damage = 2,
        animation = {
                speed_normal = 30,
                speed_run = 50,
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
                if not (date.month == 12) then
                                self.object:remove()
                end
        end,
})

--Spawn Eggs
mobs:register_egg("christmas_holiday_pack:zombie_elf", "Zombie Elf Spawn Egg", "wool_green.png", 1)

--Spawn Functions
mobs:spawn_specific("christmas_holiday_pack:zombie_elf", {"default:snow", "default:snowblock", "default:dirt_with_snow"}, {"air"}, 7, 16, 120, 500, 3, 2, 200)
