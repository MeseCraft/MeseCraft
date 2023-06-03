--License for code WTFPL and otherwise stated in license.
mobs:register_mob("mesecraft_mobs:bat", {
	type = "animal",
	passive = false,
	hp_min = 6,
	hp_max = 6,
	damage = 2,
	armor = 200,
	collisionbox = {-0.25, -0.01, -0.25, 0.25, 0.89, 0.25},
	visual = "mesh",
	mesh = "mesecraft_mobs_bat.b3d",
	textures = {
		{"mesecraft_mobs_bat.png"},
	},
	visual_size = {x=1, y=1},
	sounds = {
		random = "mesecraft_mobs_bat_random", 
		attack = "mesecraft_mobs_bat_attack",
		damage = "mesecraft_mobs_bat_damage",
		death = "mesecraft_mobs_bat_death",
		jump = "mesecraft_mobs_bat_jump",
		attack = "mesecraft_mobs_bat_attack",
		distance = 16,
	},
	walk_velocity = 4.5,
	run_velocity = 6.0,
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
        do_custom = function(self, dtime)
                self.egg_timer = (self.egg_timer or 0) + dtime
                if self.egg_timer < 10 then
                       return
                end
                self.egg_timer = 0

                if self.child
                or math.random(1, 100) > 1 then
                        return
                end

                local pos = self.object:get_pos()

                minetest.add_item(pos, "mesecraft_mobs:poop_turd")

                minetest.sound_play("mesecraft_mobs_common_poop", {
                        pos = pos,
                        gain = 1.0,
                        max_hear_distance = 8,
                })
        end,
})


-- Spawning

--[[ If the game has been launched between the 20th of October and the 3rd of November system time,
-- the spawn rate is increased. ]]
local date = os.date("*t")
if (date.month == 10 and date.day >= 20) or (date.month == 11 and date.day <= 3) then
	-- Spawn on solid blocks at or below Sea level and the selected light level
	mobs:spawn_specific("mesecraft_mobs:bat", {"group:stone", "group:leaves"}, {"air"}, 0, 7, 60, 5000, 8, -11000, 230)
else
	-- Spawn on solid blocks at or below Sea level and the selected light level
	mobs:spawn_specific("mesecraft_mobs:bat", {"group:stone", "group:leaves"}, {"air"}, 0, 5, 60, 10000, 2, -11000, 230)
end

-- spawn eggs
mobs:register_egg("mesecraft_mobs:bat", "Bat", "wool_black.png", 1)
