-- declare velocity for spider crawl function
local get_velocity = function(self)

	local v = self.object:get_velocity()

	return (v.x * v.x + v.z * v.z) ^ 0.5
end

--register spider mob
mobs:register_mob("mobs_creatures:spider", {
	type = "animal",
	passive = true,
	runaway = true,
	hp_min = 1,
	hp_max = 5,
    	armor = 200,
	collisionbox = {-0.08, -0.01, -0.1, 0.1, 0.17, 0.1},
	textures = {
                {"mobs_creatures_spider.png"},
                {"mobs_creatures_spider_2.png"},
        },
	visual_size = {x=0.5,y=0.5},
	visual = "mesh",
	mesh = "mobs_creatures_spider.b3d",
	makes_footstep_sound = false,
	view_range = 16,
	walk_velocity = 0.5,
	run_velocity = 1.5,
	damage = 1,
	water_damage = 5,
	lava_damage = 5,
	light_damage = 0,
	attack_type = "dogfight",
	animation = {
	        stand_speed = 10,
	        walk_speed = 25,
		run_speed = 50,
		stand_start = 20,
	        stand_end = 40,
		walk_start = 0,
	        walk_end = 20,
		run_start = 0,
	        run_end = 20,
	},
	jump = true,
	step = 1,
	-- custom function to make spiders climb vertical facings
	do_custom = function(self, dtime)

		-- quarter second timer
		self.spider_timer = (self.spider_timer or 0) + dtime
		if self.spider_timer < 0.25 then
			return
		end
		self.spider_timer = 0

		-- need to be stopped to go onwards
		if get_velocity(self) > 0.2 then
			self.disable_falling = false
			return
		end

		local pos = self.object:get_pos()
		local yaw = self.object:get_yaw()

		pos.y = pos.y + self.collisionbox[2] - 0.2

		local dir_x = -math.sin(yaw) * (self.collisionbox[4] + 0.5)
		local dir_z = math.cos(yaw) * (self.collisionbox[4] + 0.5)
		local nod = minetest.get_node_or_nil({
			x = pos.x + dir_x,
			y = pos.y + 0.5,
			z = pos.z + dir_z
		})

		-- get current velocity
		local v = self.object:get_velocity()

		-- can only climb solid facings
		if not nod or not minetest.registered_nodes[nod.name]
		or not minetest.registered_nodes[nod.name].walkable then
			self.disable_falling = nil
			v.y = 0
			self.object:set_velocity(v)
			return
		end

--print ("----", nod.name, self.disable_falling, dtime)

		-- turn off falling if attached to facing
		self.disable_falling = true

		-- move up facing
		v.y = self.jump_height
		mobs:set_animation(self, "jump")
		self.object:set_velocity(v)
	end
})
--API Template: mobs:spawn_specfic(name, nodes, neighbors, min_light, max_light, interval, chance, active_object_count, min_height, max_height, day_toggle, on_spawn)
mobs:spawn_specific("mobs_creatures:spider", { "group:cracky", "group:crumbly", "group:shovely", "group:pickaxey" }, {"air"}, 0, 7, 960, 2000, 1, -28000, 150)
mobs:register_egg("mobs_creatures:spider", "Spider Spawn Egg", "wool_black.png", 1)

