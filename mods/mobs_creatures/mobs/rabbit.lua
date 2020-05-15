--License for code WTFPL and otherwise stated in readmes
mobs:register_mob("mobs_creatures:rabbit",{
	type = "animal",
	passive = true,
	reach = 1,
	hp_min = 3,
	hp_max = 3,
	collisionbox = {-0.2, -0.01, -0.2, 0.2, 0.49, 0.2},
	visual = "mesh",
	mesh = "mobs_creatures_rabbit.b3d",
	textures = {
        {"mobs_creatures_rabbit_brown.png"},
        {"mobs_creatures_rabbit_gold.png"},
        {"mobs_creatures_rabbit_white.png"},
        {"mobs_creatures_rabbit_white_splotched.png"},
        {"mobs_creatures_rabbit_salt.png"},
        {"mobs_creatures_rabbit_black.png"},
	{"mobs_creatures_rabbit_toast.png"},
	},
	visual_size = {x=1.5, y=1.5},
	sounds = {
	random = "mobs_creatures_rabbit_random",
	jump = "mobs_creatures_rabbit_jump",
	damage = "mobs_creatures_rabbit_pain",
	death = "mobs_creatures_rabbit_death",	
	},
	makes_footstep_sound = false,
	walk_velocity = 1,
	run_velocity = 4,
	floats = 1,
	runaway = true,
        runaway_from = {"player"},
	jump = true,
	drops = {
		{name = "mobs_creatures:rabbit_raw", chance = 1, min = 0, max = 1},
		{name = "mobs_creatures:rabbit_hide", chance = 1, min = 0, max = 1},
	},
	water_damage = 4,
	lava_damage = 4,
	light_damage = 0,
	fear_height = 4,
	animation = {
		speed_normal = 25,		speed_run = 50,
		stand_start = 0,		stand_end = 0,
		walk_start = 0,		walk_end = 20,
		run_start = 0,		run_end = 20,
	},
	-- Follow (yellow) dangelions, carrots and golden carrots
	follow = {"default:apple","farming:carrot"},
	view_range = 8,
	-- Eat carrots and reduce their growth stage by 1
	replace_rate = 10,
	replace_what = {
                -- Farming Redo carrots
                {"farming:carrot_8", "farming:carrot_7", 0},
                {"farming:carrot_7", "farming:carrot_6", 0},
                {"farming:carrot_6", "farming:carrot_5", 0},
                {"farming:carrot_5", "farming:carrot_4", 0},
                {"farming:carrot_4", "farming:carrot_3", 0},
                {"farming:carrot_3", "farming:carrot_2", 0},
                {"farming:carrot_2", "farming:carrot_1", 0},
                {"farming:carrot_1", "air", 0},
		},
	on_rightclick = function(self, clicker)
		-- Feed, tame protect or capture
		if mobs:feed_tame(self, clicker, 1, true, true) then return end
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 0, 50, 80, false, nil) then return end
	end,
})
-- Mob spawning rules.
-- Different skins depending on spawn location

local spawn = {
	name = "mobs_creatures:rabbit",
	neighbors = {"air"},
	chance = 8000,
	active_object_count = 5,
	min_light = 3,
	max_light = 15,
	min_height = 1,
	max_height = 200,
}
local spawn_desert = table.copy(spawn)
spawn_desert.nodes = {"default:desert_sand", "group:sand"}
spawn_desert.on_spawn = function(self, pos)
	local texture = "mobs_creatures_rabbit_gold.png"
	self.base_texture = {"mobs_creatures_rabbit_gold.png"}
	self.object:set_properties({textures = self.base_texture})
end
mobs:spawn(spawn_desert)

local spawn_snow = table.copy(spawn)
spawn_snow.nodes = {"default:snow", "default:snowblock", "default:dirt_with_snow"}
spawn_snow.on_spawn = function(self, pos)
	local texture
	local r = math.random(1, 100)
	-- 80% white fur
	if r <= 80 then
		texture = "mobs_creatures_rabbit_white.png"
	-- 20% black and white fur
	else
		texture = "mobs_creatures_rabbit_white_splotched.png"
	end
	self.base_texture = { texture }
	self.object:set_properties({textures = self.base_texture})
end
mobs:spawn(spawn_snow)

local spawn_grass = table.copy(spawn)
spawn_grass.nodes = {"default:dirt_with_grass","ethereal:prairie_dirt"}
spawn_grass.on_spawn = function(self, pos)
	local texture
	local r = math.random(1, 100)
	-- 50% brown fur
	if r <= 50 then
		texture = "mobs_creatures_rabbit_brown.png"
	-- 40% salt fur
	elseif r <= 90 then
		texture = "mobs_creatures_rabbit_salt.png"
	-- 10% black fur
	else
		texture = "mobs_creatures_rabbit_black.png"
	end
	self.base_texture = { texture }
	self.object:set_properties({textures = self.base_texture})
end
mobs:spawn(spawn_grass)

-- Spawn egg
mobs:register_egg("mobs_creatures:rabbit", "Rabbit Spawn Egg", "wool_brown.png", 1)
