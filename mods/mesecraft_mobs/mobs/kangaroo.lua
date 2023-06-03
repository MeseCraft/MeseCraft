-- Kangaroo by FreeGamers.org
-- Originally from "Procoptodon" by ElCeejo (base mob, texture, and model).
mobs:register_mob("mesecraft_mobs:kangaroo", {
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
        view_range = 8,
        damage = 7,
	fear_height = 13,
	fall_speed = -8,
	fall_damage = 5,
	water_damage = 3,
	lava_damage = 5,
	light_damage = 0,
        suffocation = false,
        floats = 1,
	follow = {"default:bush_leaves"},
        reach = 3,
        owner_loyal = true,
	attack_type = "dogfight",
	pathfinding = 0,
	makes_footstep_sound = true,
	sounds = {
		random = "mesecraft_mobs_kangaroo",
	},
	drops = {
		{name = "mesecraft_mobs:meat", chance = 1, min = 6, max = 9},
		{name = "mesecraft_mobs:leather", chance = 1, min = 2, max = 3},
		{name = "mesecraft_mobs:bone", chance = 1, min = 1, max = 2},
	},
	visual = "mesh",
	visual_size = {x=6, y=6},
	collisionbox = {-0.5, -0.8, -0.5, 0.5, 0.4, 0.5},
	textures = {
		{"mesecraft_mobs_kangaroo.png"},
	},
	child_texture = {
		{"mesecraft_mobs_kangaroo_child.png"},
	},
	mesh = "mesecraft_mobs_kangaroo.b3d",
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
-- Make Kangaroo Poop.
        function(self, dtime)
                self.egg_timer = (self.egg_timer or 0) + dtime
                if self.egg_timer < 10 then
                       return
                end
                self.egg_timer = 0

                if self.child
                or math.random(1, 100) > 1 then
                        return
                end

                local pos = self.object:get_pos()

                minetest.add_item(pos, "mesecraft_mobs:poop_turd")

                minetest.sound_play("mesecraft_mobs_common_poop", {
                        pos = pos,
                        gain = 1.0,
                        max_hear_distance = 8,
                })
        end,
})

-- Spawn Egg
mobs:register_egg("mesecraft_mobs:kangaroo", "Kangaroo Spawn Egg", "default_dry_grass.png", 1)

-- Spawn Parameters, spawns in Savannah near dry grass or air during the day.
mobs:spawn_specific("mesecraft_mobs:kangaroo", {"default:dry_dirt_with_dry_grass"}, {"group:dry_grass"}, 7, 16, 240, 2000, 6, 1, 150, true)
