-- COW FROM MOBS_MC, SIMPLIFIED BY FREEGAMERS.ORG
mobs:register_mob("mesecraft_mobs:cow", {
	type = "animal",
	hp_min = 10,
	hp_max = 10,
	collisionbox = {-0.45, -0.01, -0.45, 0.45, 1.39, 0.45},
	visual = "mesh",
	mesh = "mesecraft_mobs_cow.b3d",
	textures = { {
		"mesecraft_mobs_cow.png",
		"transparent_pixel.png",
	}, },
	visual_size = {x=2.8, y=2.8},
	makes_footstep_sound = true,
	walk_velocity = 1,
	drops = {
		{name = "mesecraft_mobs:meat", chance = 1, min = 1, max = 3,},
		{name = "mesecraft_mobs:leather",chance = 1,min = 0,max = 2,},
	},
	water_damage = 1,
	lava_damage = 5,
	light_damage = 0,
	runaway = true,
	sounds = {
		random = "mesecraft_mobs_cow_random",
		death = "mesecraft_mobs_cow_damage",
		damage = "mesecraft_mobs_cow_damage",
		jump = "mesecraft_mobs_cow_jump",
		distance = 16,
	},
	animation = {
		stand_speed = 25, walk_speed = 25, run_speed = 50,
		stand_start = 0,		stand_end = 0,
		walk_start = 0,		walk_end = 40,
		run_start = 0,		run_end = 40,
	},
	follow = "farming:wheat",
        replace_rate = 10,
        replace_what = {
                {"group:grass", "air", 0},
                {"default:dirt_with_grass", "default:dirt", -1}
        },
        on_rightclick = function(self, clicker)

                -- feed or tame
                if mobs:feed_tame(self, clicker, 8, true, true) then

                        -- if fed 7x wheat or grass then cow can be milked again
                        if self.food and self.food > 6 then
                                self.gotten = false
                        end

                        return
                end

                if mobs:protect(self, clicker) then return end
                if mobs:capture_mob(self, clicker, 0, 5, 60, false, nil) then return end

                local tool = clicker:get_wielded_item()
                local name = clicker:get_player_name()

                -- milk cow with empty bucket
                if tool:get_name() == "mesecraft_bucket:bucket_empty" then

                        --if self.gotten == true
                        if self.child == true then
                                return
                        end

                        if self.gotten == true then
                                minetest.chat_send_player(name,
                                        "Cow already milked!")
                                return
                        end

                        local inv = clicker:get_inventory()

                        tool:take_item()
                        clicker:set_wielded_item(tool)
		-- Add bucket of milk and play a sound effect
                        if inv:room_for_item("main", {name = "mesecraft_mobs:milk_bucket"}) then
		                local pos = self.object:get_pos()
                                clicker:get_inventory():add_item("main", "mesecraft_mobs:milk_bucket")
                                minetest.sound_play("mesecraft_mobs_cow_milk", {
                                pos = pos,
                                gain = 1.0,
                                max_hear_distance = 8,
                                })
                        else
                                local pos = self.object:get_pos()
                                pos.y = pos.y + 0.5
                                minetest.add_item(pos, {name = "mesecraft_mobs:milk_bucket"})
		                minetest.sound_play("mesecraft_mobs_cow_milk", {
                	        pos = pos,
                        	gain = 1.0,
	                        max_hear_distance = 8,
        		        })

                        end

                        self.gotten = true -- milked
			return
		end
	end,
	follow = "farming:wheat",
	view_range = 10,
	fear_height = 2,
        on_replace = function(self, pos, oldnode, newnode)

                self.food = (self.food or 0) + 1

                -- if cow replaces 8x grass then it can be milked again
                if self.food >= 8 then
                        self.food = 0
                        self.gotten = false
                end
        end,
	-- Make the cow poop.
        do_custom = function(self, dtime)
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
-- Register Cow Spawn Parameters
mobs:spawn_specific("mesecraft_mobs:cow", {"default:dirt", "default:dirt_with_grass", "ethereal:prairie_dirt", "ethereal:mushroom_dirt"}, {"air"}, 9, 15, 120, 5000, 4, 0, 200)

-- Register Cow Spawn Egg
mobs:register_egg("mesecraft_mobs:cow", "Cow Spawn Egg", "wool_brown.png", 1)
