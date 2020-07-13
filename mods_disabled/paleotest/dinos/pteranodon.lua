
local S = mobs.intllib

-- Walking and Flying animation sets

local animation_fly = {
		speed_normal = 10,
		speed_sprint = 20,
		stand_start = 50,
		stand_end = 90,
		walk_start = 1,
		walk_end = 40,
		}
local animation_land = {
		speed_normal = 10,
		speed_sprint = 20,
		stand_start = 125,
		stand_end = 165,
		walk_start = 100,
		walk_end = 120,
		}

-- Pteranodon by ElCeejo

mobs:register_mob("paleotest:pteranodon", {
	type = "animal",
	hp_min = 16,
	hp_max = 16,
	armor = 180,
	passive = true,
	walk_velocity = 1,
	run_velocity = 3,
        walk_chance = 50,
        jump = false,
        jump_height = 1.1,
        stepheight = 1.1,
        fly = true,
        fly_in = "air",
        runaway = true,
        pushable = false,
        view_range = 13,
        knock_back = 0,
        damage = 3,
	fear_height = 0,
	fall_speed = -8,
	fall_damage = 0,
	water_damage = 3,
	lava_damage = 3,
	light_damage = 0,
        suffocation = false,
        floats = 1,
        reach = 1,
        attack_chance = 0,
        attack_animals = false,
        attack_npcs = false,
        attack_players = false,
        owner_loyal = false,
        group_attack = false,
	attack_type = "dogfight",
	pathfinding = 1,
	makes_footstep_sound = true,
	sounds = {
		random = "paleotest_pteranodon",
	},
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 3, max = 5},
	},
	visual = "mesh",
	visual_size = {x=10, y=10},
	collisionbox = {-0.3, -0.5, -0.3, 0.3, 0.2, 0.3},
	textures = {
		{"paleotest_pteranodon1.png"},
		{"paleotest_pteranodon2.png"},
	},
	child_texture = {
		{"paleotest_pteranodon3.png"},
	},
	mesh = "paleotest_pteranodon.b3d",
	animation = {
		speed_normal = 10,
		speed_sprint = 20,
		stand_start = 50,
		stand_end = 90,
		walk_start = 1,
		walk_end = 40,
	},

	do_custom = function(self)

-- Fliers will ocassionally land

        local floor = math.floor
        local pos = self.object:get_pos()


	if math.random(1, 500) == 1 then

        self.fly = false
        self.fly2 = false
        self.disable_falling = false
	self.fall_speed = -8
        self.animation = animation_land
                       return
		end
 
        if math.random(1, 250) == 1
        and self.fly == false then

        self.fly2 = true
	self.disable_falling = true
        self.animation = animation_fly
                        return
		end

-- Force to fly after landing


        if self.fly2 == true then

	local p = self.object:get_pos()
	local s = self.object:get_pos()
	local p1 = s
	local me_y = floor(p1.y)
	local p2 = p
	local p_y = floor(p2.y + 1)
	local v = self.object:get_velocity()

	if self:flight_check() then

		if me_y < p_y then

			self.object:set_velocity({
				x = v.x,
				y = 0.1 * self.walk_velocity,
				z = v.z
			})

		elseif me_y > p_y then

			self.object:set_velocity({
				x = v.x,
				y = -1 * self.walk_velocity,
				z = v.z
			})
		end
	else
		if me_y < p_y then

		self.object:set_velocity({
			        x = v.x,
				y = 0.01,
				z = v.z
			})

		elseif me_y > p_y then

			self.object:set_velocity({
				x = v.x,
				y = -0.01,
				z = v.z
			})
		end

		if v.y > 0 then

			self.object:set_acceleration({
				x = 0,
				y = 0,
				z = 0
			})
                        return
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
		end
	end
end,
})

local wild_spawn = minetest.settings:get_bool("wild_spawning")

if wild_spawn then

mobs:spawn({
	name = "paleotest:pteranodon",
	nodes = "default:water_source",
	min_light = 14,
	interval = 60,
	chance = 8000, -- 15000
	min_height = 0,
	max_height = 200,
	day_toggle = true,
})

end

mobs:register_egg("paleotest:pteranodon", S("Pteranodon"), "default_water.png", 1)

-- Pteranodon Egg by ElCeejo

mobs:register_mob("paleotest:Pteranodon_egg", {
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

		self.egg_timer = (self.egg_timer or 120) + dtime
		if self.egg_timer < 120 then
			return
		end
		self.egg_timer = 120

		if self.child
		or math.random(1, 100) > 1 then
			return
		end

		local pos = self.object:get_pos()

		mob = minetest.add_entity(pos, "paleotest:pteranodon")
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


mobs:register_egg("paleotest:Pteranodon_egg", S("Pteranodon Egg"), "paleotest_egg1_inv.png", 0)
