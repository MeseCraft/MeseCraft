
local S = mobs.intllib

-- Smilodon by ElCeejo

mobs:register_mob("paleotest:smilodon", {
	type = "monster",
	hp_min = 27,
	hp_max = 27,
	armor = 150,
	passive = false,
	walk_velocity = 1,
	run_velocity = 3,
        walk_chance = 15,
        jump = true,
        jump_height = 2,
        stepheight = 1.1,
        runaway = false,
        pushable = true,
        view_range = 5,
        knock_back = 1,
        damage = 9,
	fear_height = 8,
	fall_speed = -8,
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
        group_attack = false,
	attack_type = "dogfight",
	pathfinding = 1,
	makes_footstep_sound = true,
	sounds = {
		random = "paleotest_smilodon",
	},
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 2, max = 4},
	},
	visual = "mesh",
	visual_size = {x=9, y=9},
	collisionbox = {-0.5, -0.9, -0.5, 0.5, 0.4, 0.5},
	textures = {
		{"paleotest_smilodon1.png"},
		{"paleotest_smilodon2.png"},
	},
	child_texture = {
		{"paleotest_smilodon3.png"},
	},
	mesh = "paleotest_smilodon.b3d",
	animation = {
		speed_normal = 18,
		speed_sprint = 20,
		speed_punch = 5,
		stand_start = 50,
		stand_end = 120, -- 20
		walk_start = 1,
		walk_end = 40,
		punch_start = 130,
		punch_end = 145,
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

-- Baby mobs are passive, Tamed mobs will protect their owner

	if self.child == true then

	self.type = "animal"
	self.passive = true
        self.attack_animals = false
	self.walk_velocity = 0.7
	self.run_velocity = 0.7
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
	name = "paleotest:smilodon",
	nodes = "default:snowblock",
	min_light = 14,
	interval = 60,
	chance = 8000, -- 15000
	min_height = 0,
	max_height = 200,
	day_toggle = true,
})

end

mobs:register_egg("paleotest:smilodon", S("Smilodon"), "farming_straw.png", 1)

-- Smilodon Cub by ElCeejo

minetest.register_craftitem("paleotest:Smilodon_baby", {
	description = "Smilodon Embryonic Sac",
	inventory_image = "paleotest_embryo.png",
	wield_image = "paleotest_embryo.png",
	stack_max = 1,
	on_place = function(itemstack, placer, pointed_thing)
		local pos1=minetest.get_pointed_thing_position(pointed_thing, true)
		pos1.y=pos1.y+1.5
		core.after(0.1, function()
		mob = minetest.add_entity(pos1, "paleotest:smilodon")
                ent2 = mob:get_luaentity()

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
		end)
		itemstack:take_item()
		return itemstack
	end,
})
