--License for code WTFPL and otherwise stated in readmes
mobs:register_mob("mesecraft_mobs:pig", {
	type = "animal",
	runaway = true,
	hp_min = 10,
	hp_max = 10,
	collisionbox = {-0.45, -0.01, -0.45, 0.45, 0.865, 0.45},
	visual = "mesh",
	mesh = "mesecraft_mobs_pig.b3d",
	textures = {{
		"blank.png", -- baby
		"mesecraft_mobs_pig.png", -- base
		"blank.png", -- saddle
	}},
	visual_size = {x=2.5, y=2.5},
	makes_footstep_sound = true,
	walk_velocity = 1,
	run_velocity = 3,
	drops = {
		{name = "mesecraft_mobs:pork_raw", chance = 1, min = 1, max = 3,},
	},
	water_damage = 1,
	lava_damage = 4,
	light_damage = 0,
	fear_height = 2,
	jump = false,
	stepheight = 0.75,
	knock_back = false,
	sounds = {
		random = "mesecraft_mobs_pig_random",
		death = "mesecraft_mobs_pig_death",
		distance = 16,
	},
	animation = {
		stand_speed = 40,
		walk_speed = 40,
		run_speed = 50,
		stand_start = 0,
		stand_end = 0,
		walk_start = 0,
		walk_end = 40,
		run_start = 0,
		run_end = 40,
	},
	follow = "default:apple",
	view_range = 5,
	on_rightclick = function(self, clicker)
		if not clicker or not clicker:is_player() then
			return
		end

		local wielditem = clicker:get_wielded_item()
		-- Feed pig
		if wielditem:get_name() ~= "default:apple" then
			if mobs:feed_tame(self, clicker, 1, true, true) then return end
		end
		if mobs:protect(self, clicker) then return end

		if self.child then
			return
		end
	end,
})
-- Spawn parameters.
mobs:spawn_specific("mesecraft_mobs:pig", {"default:dirt_with_grass","ethereal:prairie_dirt"}, {"air"}, 9, 15, 240, 3000, 3, 1, 20, true)

-- spawn eggs
mobs:register_egg("mesecraft_mobs:pig", "Pig Spawn Egg", "wool_pink.png", 1)
