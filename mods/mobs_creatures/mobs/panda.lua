
-- Panda by AspireMint (CC BY-SA 3.0)

mobs:register_mob("mobs_creatures:panda", {
stepheight = 0.6,
	type = "animal",
	passive = false,
	attack_type = "dogfight",
	group_attack = false,
	owner_loyal = true,
	attack_npcs = false,
	reach = 2,
	damage = 3,
	hp_min = 10,
	hp_max = 24,
	armor = 200,
	collisionbox = {-0.4, -0.45, -0.4, 0.4, 0.45, 0.4},
	visual = "mesh",
	mesh = "mobs_creatures_panda.b3d",
	textures = {
		{"mobs_creatures_panda.png"},
	},
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_creatures_panda_random",
		attack = "mobs_creatures_panda_random",
	},
	walk_chance = 25,
	walk_velocity = 0.5,
	run_velocity = 1.5,
	jump = false,
	jump_height = 6,
	follow = {"ethereal:bamboo"},
	view_range = 8,
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 1, max = 2},
	},
	water_damage = 0,
	lava_damage = 5,
	light_damage = 0,
	fear_height = 6,
	animation = {
		speed_normal = 15,
		stand_start = 130,
		stand_end = 270,
		stand1_start = 0,
		stand1_end = 0,
		stand2_start = 1,
		stand2_end = 1,
		stand3_start = 2,
		stand3_end = 2,
		walk_start = 10,
		walk_end = 70,
		run_start = 10,
		run_end = 70,
		punch_start = 80,
		punch_end = 120,
		-- 0 = rest, 1 = hiding (covers eyes), 2 = surprised
	},
	on_rightclick = function(self, clicker)

		if mobs:feed_tame(self, clicker, 20, true, true) then return end
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 0, 5, 50, false, nil) then return end
	end,
})

if minetest.get_modpath("ethereal") then

	mobs:spawn({
		name = "mobs_creatures:panda",
		nodes = {"ethereal:bamboo_dirt"},
		neighbors = {"group:grass"},
		min_light = 14,
		interval = 60,
		chance = 8000, -- 15000
		min_height = 10,
		max_height = 80,
		day_toggle = true,
	})
end

mobs:register_egg("mobs_creatures:panda", "Panda", "wool_white.png", 1)
