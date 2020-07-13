
local S = mobs.intllib

-- Sleeping and Awake animation sets

local animation_awake = {
		speed_normal = 15,
		speed_sprint = 30,
		stand_start = 60,
		stand_end = 140,
		walk_start = 1,
		walk_end = 50,
		punch_start = 150,
		punch_end = 180,
		punch_loop = false,
		}
local animation_sleep = {
                stand_speed = 5,
		speed_normal = 15,
		speed_sprint = 30,
		stand_start = 185,
		stand_end = 200,
		walk_start = 185,
		walk_end = 200,
		punch_loop = false,
		}

-- Brachiosaurus by ElCeejo

mobs:register_mob("paleotest:brachiosaurus", {
	type = "animal",
	hp_min = 146,
	hp_max = 146,
	armor = 80,
	passive = false,
	walk_velocity = 1,
	run_velocity = 2,
        walk_chance = 10,
        jump = false,
        jump_height = 1.1,
        stepheight = 1.1,
        runaway = false,
        pushable = false,
        view_range = 10,
        knock_back = 0,
        damage = 22,
	fear_height = 4,
	fall_speed = -8,
	fall_damage = 35,
	water_damage = 15,
	lava_damage = 5,
	light_damage = 0,
        suffocation = false,
        floats = 0,
	follow = {"default:leaves"},
        reach = 10,
        owner_loyal = false,
	attack_type = "dogfight",
	pathfinding = 0,
	makes_footstep_sound = true,
	sounds = {
		random = "paleotest_brachiosaurus",
	},
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 13, max = 15},
	},
	visual = "mesh",
	visual_size = {x=20, y=20},
	collisionbox = {-2.3, -1.0, -2.3, 2.3, 3.9, 2.3},
	textures = {
		{"paleotest_brachiosaurus1.png"},
		{"paleotest_brachiosaurus2.png"},
	},
	child_texture = {
		{"paleotest_brachiosaurus3.png"},
	},
	mesh = "paleotest_brachiosaurus.b3d",
	animation = {
		speed_normal = 15,
		speed_sprint = 30,
		stand_start = 60,
		stand_end = 140,
		walk_start = 1,
		walk_end = 50,
		punch_start = 150,
		punch_end = 180,
		punch_loop = false,
	},

	on_rightclick = function(self, clicker)

		-- feed or tame
		if mobs:feed_tame(self, clicker, 8, true, true) then return end
		if mobs:protect(self, clicker) then return end

		if self.owner == "" then
			self.owner = clicker:get_player_name()
		else
			if self.order == "follow" then
				self.order = "stand"
			else
				self.order = "follow"

			end

		end

	end,

	do_custom = function(self, dtime)

-- Diurnal mobs sleep at night and awake at day

	if self.time_of_day > 0.2
	and self.time_of_day < 0.8 then
   
        self.view_range = 10
        self.walk_chance = 10
        self.jump = false
        self.animation = animation_awake
	mobs:set_animation(self, self.animation.current)
	elseif self.time_of_day > 0.0
	and self.time_of_day < 1.0 then
     
        self.view_range = 0
        self.walk_chance = 0
        self.jump = false
        self.animation = animation_sleep
	mobs:set_animation(self, self.animation.current)
	end

-- Baby mobs are passive

	if self.child == true then

	self.type = "animal"
	self.passive = true
        self.attack_animals = false
	self.walk_velocity = 0.3
	self.run_velocity = 0.3
			return
		end
	end,
})

local wild_spawn = minetest.settings:get_bool("wild_spawning")

if wild_spawn then

mobs:spawn({
	name = "paleotest:brachiosaurus",
	nodes = "default:dirt_with_grass",
        neighbours = "group:grass",
	min_light = 14,
	interval = 60,
	chance = 8000, -- 15000
	min_height = 0,
	max_height = 200,
	day_toggle = true,
})

end

mobs:register_egg("paleotest:brachiosaurus", S("Brachiosaurus"), "default_jungletree.png", 1)

-- Brachiosaurus by ElCeejo

mobs:register_mob("paleotest:Brachiosaurus_egg", {
	type = "nil",
	hp_min = 5,
	hp_max = 5,
	armor = 200,
	passive = true,
	walk_velocity = 0,
	run_velocity = 0,
	jump = false,
	runaway = false,
        pushable = true,
	fear_height = 5,
	fall_damage = 0,
	fall_speed = -8,
	water_damage = 1,
	lava_damage = 5,
	light_damage = 0,
	collisionbox = {-0.2, -0.5, -0.2, 0.2, 0, 0.2},
	visual = "mesh",
	mesh = "paleotest_egg.b3d",
	textures = {
		{"paleotest_egg1.png"},
	},
	makes_footstep_sound = false,
	animation = {
		speed_normal = 1,
		stand_start = 1,
		stand_end = 1, -- 20
		walk_start = 1,
		walk_end = 1,
	},


	do_custom = function(self, dtime)

		self.egg_timer = (self.egg_timer or 1000) + dtime
		if self.egg_timer < 1000 then
			return
		end
		self.egg_timer = 1000

		if self.child
		or math.random(1, 1000) > 1 then
			return
		end

		local pos = self.object:get_pos()

		mob = minetest.add_entity(pos, "paleotest:brachiosaurus")
                ent2 = mob:get_luaentity()
		self.object:remove()

		mob:set_properties({
			textures = ent2.child_texture[1],
			visual_size = {
				x = ent2.base_size.x / 12,
				y = ent2.base_size.y / 12
			},
			collisionbox = {
				ent2.base_colbox[1] / 12,
				ent2.base_colbox[2] / 12,
				ent2.base_colbox[3] / 12,
				ent2.base_colbox[4] / 12,
				ent2.base_colbox[5] / 12,
				ent2.base_colbox[6] / 12
			},
		})

		ent2.child = true
		ent2.tamed = false
	end
})


mobs:register_egg("paleotest:Brachiosaurus_egg", S("Brachiosaurus Egg"), "paleotest_egg1_inv.png", 0)
