--MCmobs v0.4
--maikerumine
--made for MC like Survival game
--License for code WTFPL and otherwise stated in readmes
--###################
--################### PARROT
--###################
mobs:register_mob("mobs_creatures:parrot", {
	type = "animal",
	passive = true,
	hp_min = 6,
	hp_max = 6,
	collisionbox = {-0.25, -0.01, -0.25, 0.25, 0.89, 0.25},
	visual = "mesh",
	mesh = "mobs_creatures_parrot.b3d",
	textures = {{"mobs_creatures_parrot_blue.png"},{"mobs_creatures_parrot_green.png"},{"mobs_creatures_parrot_grey.png"},{"mobs_creatures_parrot_red_blue.png"},{"mobs_creatures_parrot_yellow_blue.png"}},
	visual_size = {x=3, y=3},
	walk_velocity = 4,
	run_velocity = 6,
	drops = {
		{name = "mobs_creatures:chicken_feather",
		chance = 2,
		min = 0,
		max = 2,},
	},
    	animation = {
		stand_speed = 40,
		walk_speed = 40,
		stand_start = 60,
		stand_end = 80,
		walk_start = 60,
		walk_end = 80,
		--run_start = 0,
		--run_end = 20,
		--fly_start = 30,
		--fly_end = 45,
	},
	water_damage = 0,
	lava_damage = 4,
	light_damage = 0,
	step_height = 0,
	fall_damage = 0,
	fall_speed = 0,
	attack_type = "dogfight",
	floats = 1,
	fly = true,
	view_range = 16,
	follow = { "farming:seed_wheat", "farming:seed_cotton" },
	on_rightclick = function(self, clicker)
		if self._doomed then return end
		local item = clicker:get_wielded_item()
		-- Feed to tame, but not breed
		if mobs:feed_tame(self, clicker, 1, false, true) then return end
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 0, 50, 80, false, nil) then return end
	end,

})

-- Spawn disabled because parrots are not very smart.
mobs:spawn_specific("mobs_creatures:parrot", {"default:dirt_with_rainforest_litter", "default:jungleleaves", "default:junglewood"}, {"air"}, 0, 15, 240, 4000, 4, 10, 120)

-- spawn eggs
mobs:register_egg("mobs_creatures:parrot", "Parrot", "wool_red.png", 1)
