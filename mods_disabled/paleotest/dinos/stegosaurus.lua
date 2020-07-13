
local S = mobs.intllib

-- Sleeping and Awake animation sets

local animation_awake = {
		speed_normal = 18,
		speed_sprint = 30,
		stand_start = 50,
		stand_end = 120,
		walk_start = 1,
		walk_end = 40,
		punch_start = 130,
		punch_end = 140,
		punch_loop = false,
		}
local animation_sleep = {
                stand_speed = 5,
		speed_normal = 18,
		speed_sprint = 30,
		stand_start = 145,
		stand_end = 160,
		walk_start = 145,
		walk_end = 160,
		punch_loop = false,
		}

-- Stegosaurus by ElCeejo

mobs:register_mob("paleotest:stegosaurus", {
	type = "animal",
	hp_min = 48,
	hp_max = 48,
	armor = 110,
	passive = false,
	walk_velocity = 1.3,
	run_velocity = 2.5,
        walk_chance = 20,
        jump = false,
        jump_height = 1.1,
        stepheight = 1.1,
        runaway = false,
        pushable = false,
        view_range = 10,
        knock_back = 0,
        damage = 11,
	fear_height = 5,
	fall_speed = -8,
	fall_damage = 10,
	water_damage = 0,
	lava_damage = 3,
	light_damage = 0,
        suffocation = false,
        floats = 1,
	follow = {"default:leaves"},
        reach = 10,
        owner_loyal = false,
	attack_type = "dogfight",
	pathfinding = 0,
	makes_footstep_sound = true,
	sounds = {
		random = "paleotest_stegosaurus",
	},
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 13, max = 15},
	},
	visual = "mesh",
	visual_size = {x=17, y=17},
	collisionbox = {-1.2, -1.0, -1.2, 1.2, 1.8, 1.2},
	textures = {
		{"paleotest_stegosaurus1.png"},
		{"paleotest_stegosaurus2.png"},
	},
	child_texture = {
		{"paleotest_stegosaurus3.png"},
	},
	mesh = "paleotest_stegosaurus.b3d",
	animation = {
		speed_normal = 18,
		speed_sprint = 30,
		stand_start = 50,
		stand_end = 120,
		walk_start = 1,
		walk_end = 40,
		punch_start = 130,
		punch_end = 140,
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

        self.passive = false    
        self.view_range = 10
        self.walk_chance = 20
        self.jump = true
        self.animation = animation_awake
	mobs:set_animation(self, self.animation.current)
	elseif self.time_of_day > 0.0
	and self.time_of_day < 1.0 then

        self.passive = true     
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
	self.walk_velocity = 0.7
	self.run_velocity = 0.7
			return
		end
	end,
})

local wild_spawn = minetest.settings:get_bool("wild_spawning")

if wild_spawn then

mobs:spawn({
	name = "paleotest:stegosaurus",
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

mobs:register_egg("paleotest:stegosaurus", S("Stegosaurus"), "default_pine_tree_top.png", 1)

-- Stegosaurus Egg by ElCeejo

mobs:register_mob("paleotest:Stegosaurus_egg", {
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
		stand_end = 1,
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

		mob = minetest.add_entity(pos, "paleotest:stegosaurus")
                ent2 = mob:get_luaentity()
		self.object:remove()

		mob:set_properties({
			textures = ent2.child_texture[1],
			visual_size = {
				x = ent2.base_size.x / 5,
				y = ent2.base_size.y / 5
			},
			collisionbox = {
				ent2.base_colbox[1] / 5,
				ent2.base_colbox[2] / 5,
				ent2.base_colbox[3] / 5,
				ent2.base_colbox[4] / 5,
				ent2.base_colbox[5] / 5,
				ent2.base_colbox[6] / 5
			},
		})

		ent2.child = true
		ent2.tamed = false
	end
})


mobs:register_egg("paleotest:Stegosaurus_egg", S("Stegosaurus Egg"), "paleotest_egg1_inv.png", 0)
