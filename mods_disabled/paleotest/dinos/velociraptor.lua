
local S = mobs.intllib

-- Sleeping and Awake animation sets

local animation_awake = {
		speed_normal = 30,
		speed_sprint = 60,
		stand_start = 50,
		stand_end = 110,
		walk_start = 1,
		walk_end = 40,
		punch_start = 125,
		punch_end = 145,
		punch_start = 125,
		punch_end = 135,
		sleep_start = 135,
		sleep_end = 160,
		punch_loop = false,
		}
local animation_sleep = {
                stand_speed = 5,
		speed_normal = 30,
		speed_sprint = 60,
		walk_start = 140,
		walk_end = 160,
		stand_start = 140,
		stand_end = 160,
		punch_loop = false,
		}

-- Velociraptor by ElCeejo

mobs:register_mob("paleotest:velociraptor", {
	type = "monster",
	hp_min = 16,
	hp_max = 16,
	armor = 170,
	passive = false,
	walk_velocity = 3,
	run_velocity = 6,
        walk_chance = 20,
        jump = true,
        jump_height = 3,
        stepheight = 1.1,
        runaway = false,
        pushable = true,
        view_range = 10,
        knock_back = 1,
        damage = 4,
	fear_height = 12,
	fall_speed = -4,
	fall_damage = 5,
	water_damage = 0,
	lava_damage = 3,
	light_damage = 0,
        suffocation = false,
        floats = 1,
	owner = "",
	order = "follow",
	follow = {"mobs:meat_raw"},
        reach = 2,
        attack_chance = 20,
        attack_animals = true,
        attack_npcs = true,
        attack_players = true,
        owner_loyal = true,
        group_attack = true,
	attack_type = "dogfight",
	pathfinding = 1,
	makes_footstep_sound = true,
	sounds = {
		random = "paleotest_velociraptor",
	},
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 2, max = 4},
	},
	visual = "mesh",
	visual_size = {x=3.5, y=3.5},
	collisionbox = {-0.3, -0.5, -0.3, 0.3, 0.2, 0.3},
	textures = {
		{"paleotest_velociraptor1.png"},
		{"paleotest_velociraptor2.png"},
	},
	child_texture = {
		{"paleotest_velociraptor3.png"},
	},
	mesh = "paleotest_velociraptor.b3d",
	animation = {
                stand_speed = 5,
		speed_normal = 30,
		speed_sprint = 60,
		stand_start = 50,
		stand_end = 110,
		stand1_start = 140,
		stand1_end = 160,
		walk_start = 1,
		walk_end = 40,
		punch_start = 125,
		punch_end = 145,
		punch_start = 125,
		punch_end = 135,
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

-- Nocturnal mobs sleep at day and awake at night

	if self.time_of_day > 0.2
	and self.time_of_day < 0.8 then

        self.passive = true     
        self.view_range = 0
        self.walk_chance = 0
        self.jump = false
        self.animation = animation_sleep
        mobs:set_animation(self, self.animation.stand)
	elseif self.time_of_day > 0.0
	and self.time_of_day < 1.0 then

        self.passive = true  
        self.view_range = 10
        self.walk_chance = 20
        self.jump = true
        self.animation = animation_awake
        mobs:set_animation(self, self.animation.current)
                        return
		end

-- Baby mobs are passive, Tamed mobs will protect their owner

	if self.child == true then

	self.type = "animal"
	self.passive = true
        self.attack_animals = false
	self.walk_velocity = 0.4
	self.run_velocity = 0.4
			return
		end

	if self.tamed == true then

	self.type = "animal"
	self.passive = false
        self.attack_animals = true
        self.attack_monsters = true
        self.attack_players = true
        self.owner_loyal = true
			return
		end
	end,
})

local wild_spawn = minetest.settings:get_bool("wild_spawning")

if wild_spawn then

mobs:spawn({
	name = "paleotest:velociraptor",
	nodes = "default:desert_sand",
        neighbours = "default:dry_grass",
	min_light = 14,
	interval = 60,
	chance = 8000, -- 15000
	min_height = 0,
	max_height = 200,
	day_toggle = true,
})

end

mobs:register_egg("paleotest:velociraptor", S("Velociraptor"), "default_desert_sandstone_block.png", 1)

-- Velociraptor Egg by ElCeejo

mobs:register_mob("paleotest:Velociraptor_egg", {
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
		{"paleotest_egg3.png"},
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

		mob = minetest.add_entity(pos, "paleotest:velociraptor")
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


mobs:register_egg("paleotest:Velociraptor_egg", S("Velociraptor Egg"), "paleotest_egg3_inv.png", 0)
