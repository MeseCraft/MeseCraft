
local S = mobs.intllib

-- Procoptodon by ElCeejo

mobs:register_mob("paleotest:procoptodon", {
	type = "animal",
	hp_min = 28,
	hp_max = 28,
	armor = 140,
	passive = false,
	walk_velocity = 2.5,
	run_velocity = 4,
        walk_chance = 10,
        jump = true,
        jump_height = 4,
        stepheight = 2,
        runaway = false,
        pushable = true,
        view_range = 5,
        knock_back = 1,
        damage = 7,
	fear_height = 13,
	fall_speed = -8,
	fall_damage = 5,
	water_damage = 0,
	lava_damage = 3,
	light_damage = 0,
        suffocation = false,
        floats = 1,
	follow = {"default:bush_leaves"},
        reach = 4,
        owner_loyal = true,
	attack_type = "dogfight",
	pathfinding = 0,
	makes_footstep_sound = true,
	sounds = {
		random = "paleotest_procoptodon",
	},
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 6, max = 9},
	},
	visual = "mesh",
	visual_size = {x=9, y=9},
	collisionbox = {-0.5, -1.2, -0.5, 0.5, 0.4, 0.5},
	textures = {
		{"paleotest_procoptodon1.png"},
		{"paleotest_procoptodon2.png"},
	},
	child_texture = {
		{"paleotest_procoptodon3.png"},
	},
	mesh = "paleotest_procoptodon.b3d",
	animation = {
		speed_normal = 40,
		speed_sprint = 85,
		stand_start = 50,
		stand_end = 140,
		walk_start = 1,
		walk_end = 40,
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
	name = "paleotest:procoptodon",
	nodes = "default:dirt_with_dry_grass",
	neighbors = "group:dry_grass",
	min_light = 14,
	interval = 60,
	chance = 8000, -- 15000
	min_height = 0,
	max_height = 200,
	day_toggle = true,
})

end

mobs:register_egg("paleotest:procoptodon", S("Procoptodon"), "default_dry_grass.png", 1)

minetest.register_craftitem("paleotest:Procoptodon_baby", {
	description = "Procoptodon Embryonic Sac",
	inventory_image = "paleotest_embryo.png",
	wield_image = "paleotest_embryo.png",
	stack_max = 1,
	on_place = function(itemstack, placer, pointed_thing)
		local pos1=minetest.get_pointed_thing_position(pointed_thing, true)
		pos1.y=pos1.y+1.5
		core.after(0.1, function()
		mob = minetest.add_entity(pos1, "paleotest:procoptodon")
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
