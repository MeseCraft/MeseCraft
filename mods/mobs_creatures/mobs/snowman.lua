--Snowman from mc_mobs by maikerumine
-- TODO make egg craftable?, make water freeze into ice? maybe change him to NPC nonpassive

local snow_trail_frequency = 0.5 -- Time in seconds for checking to add a new snow trail

local mobs_griefing = true

-- SNOWBALL ARROW FOR ATTACKS
mobs:register_arrow("mobs_creatures:snowmans_snowball", {
	visual = "sprite",
	visual_size = {x=.5, y=.5},
	textures = {"default_snowball.png"},
	velocity = 8,
	   hit_player = function(self, player)
	      player:punch(self.object, 1.0, {
		 full_punch_interval = 1.0,
		 damage_groups = {fleshy = 9},
	      }, nil)
	       minetest.sound_play({name = "default_snow_footstep", gain = 1.0}, {pos=player:getpos(), max_hear_distance = 8})
	   end,

	   hit_mob = function(self, player)
	      player:punch(self.object, 1.0, {
		 full_punch_interval = 1.0,
		 damage_groups = {fleshy = 9},
	      }, nil)
	   end,

	   hit_node = function(self, pos, node)
	       minetest.sound_play({name = "default_snow_footstep", gain = 1.0}, {pos=pos, max_hear_distance = 8})
	      self.object:remove()
	   end,
	})

mobs:register_mob("mobs_creatures:snowman", {
	type = "monster",
	hp_min = 20,
	hp_max = 20,
	pathfinding = 1,
	view_range = 12,
	light_damage = 1,
	fall_damage = 0,
	water_damage = 4,
	lava_damage = 20,
	attacks_monsters = true,
	collisionbox = {-0.35, -0.01, -0.35, 0.35, 1.89, 0.35},
	visual = "mesh",
	mesh = "mobs_creatures_snowman.b3d",
	textures = {
		{"mobs_creatures_snowman.png^transparent_pixel.png"},
	},
	drops = {
	{ name = "default:snow", chance = 1, min = 0, max = 4 },
	{ name = "farming:carrot", chance = 4, min = 1, max = 1 },
	{ name = "default:stick", chance = 2, min = 1, max = 2 },
	{ name = "default:coal_lump", chance = 4, min = 1, max = 4},
	},
	sounds = {
		        random = "default_snow_footstep",
		        war_cry = "default_snow_footstep",
			jump = "default_snow_footstep",
		        shoot_attack = "default_snow_footstep",
		        damage = "default_snow_footstep",
		        death = "default_snow_footstep",
	   },
	visual_size = {x=3, y=3},
	walk_velocity = 0.6,
	run_velocity = 2,
	jump = true,
	makes_footstep_sound = true,
	attack_type = "shoot",
	arrow = "mobs_creatures:snowmans_snowball",
	shoot_interval = 2,
	shoot_offset = 1,
	animation = {
		speed_normal = 25,
		speed_run = 50,
		stand_start = 20,
		stand_end = 40,
		walk_start = 0,
		walk_end = 20,
		run_start = 0,
		run_end = 20,
		die_start = 40,
		die_end = 50,
		die_loop = false,
	},
	blood_amount = 0,
	immune_to = {
		{"default:shovel_wood", 3}, -- shovels deal more damage to snowman.
		{"default:shovel_stone", 3},
		{"default:shovel_bronze", 4},
		{"default:shovel_steel", 4},
		{"default:shovel_mese", 5},
		{"default:shovel_diamond", 7},
	},
	do_custom = function(self, dtime)
		if not mobs_griefing then
			return
		end
		-- Leave a trail of top snow behind.
		-- This is done in do_custom instead of just using replace_what because with replace_what,
		-- the top snop may end up floating in the air.
		if not self._snowtimer then
			self._snowtimer = 0
			return
		end
		self._snowtimer = self._snowtimer + dtime
		if self.health > 0 and self._snowtimer > snow_trail_frequency then
			self._snowtimer = 0
			local pos = self.object:getpos()
			local below = {x=pos.x, y=pos.y-1, z=pos.z}
			local def = minetest.registered_nodes[minetest.get_node(pos).name]
			-- Node at snow golem's position must be replacable
			if def and def.buildable_to then
				-- Node below must be walkable
				-- and a full cube (this prevents oddities like top snow on top snow, lower slabs, etc.)
				local belowdef = minetest.registered_nodes[minetest.get_node(below).name]
				if belowdef and belowdef.walkable and (belowdef.node_box == nil or belowdef.node_box.type == "regular") then
					-- Place top snow
					minetest.set_node(pos, {name = mobs_mc.items.top_snow})
				end
			end
		end
	end,
	on_die = function(self, pos) -- on die, spawn a fire:permanent flame.
		        minetest.add_particlespawner({
			    amount = 100,
			    time = 0.1,
			    minpos = {x=pos.x-1, y=pos.y-1, z=pos.z-1},
			    maxpos = {x=pos.x+1, y=pos.y+1, z=pos.z+1},
			    minvel = {x=-0, y=-0, z=-0},
			    maxvel = {x=1, y=1, z=1},
			    minacc = {x=-0.5,y=5,z=-0.5},
			    maxacc = {x=0.5,y=5,z=0.5},
			    minexptime = 0.1,
			    maxexptime = 1,
			    minsize = 1,
			    maxsize = 3,
			    collisiondetection = false,
			    texture="default_snowball.png"
			})
		if minetest.get_node(pos).name == "air" then
		        minetest.set_node(pos, {name = "default:snow"})
		end
		self.object:remove()
	    end,
})
-- Spawn Parameters
mobs:spawn_specific("mobs_creatures:snowman", {"default:snow", "default:snowblock", "default:dirt_with_snow"},{"air"},0,7,240,4000,2,-10,200)

-- Spawn Egg
mobs:register_egg("mobs_creatures:snowman", "Snowman", "default_snow.png", 1)
