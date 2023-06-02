-- WOLF MOB
--License for code WTFPL and otherwise stated in readmes
mobs:register_mob("mesecraft_mobs:wolf", {
	type = "animal",
	hp_min = 10,
	hp_max = 10,
	passive = false,
	group_attack = true,
	collisionbox = {-0.3, -0.01, -0.3, 0.3, 0.84, 0.3},
	visual = "mesh",
	mesh = "mesecraft_mobs_wolf.b3d",
	textures = {
		{"mesecraft_mobs_wolf.png"},
	},
	visual_size = {x=3, y=3},
	makes_footstep_sound = true,
	sounds = {
		random = "mesecraft_mobs_wolf_random",
		damage = "mesecraft_mobs_wolf_pain",
		death = "mesecraft_mobs_wolf_death",
		attack = "mesecraft_mobs_wolf_warcry",
		distance = 16,
	},
	pathfinding = 1,
	floats = 1,
	view_range = 16,
	walk_chance = 50,
	walk_velocity = 2,
	run_velocity = 3,
	stepheight = 1.1,
	damage = 4,
	reach = 2,
	attack_type = "dogfight",
	fear_height = 4,
	water_damage = 0,
	lava_damage = 4,
	light_damage = 0,
	follow = {"mesecraft_mobs:bone", "mesecraft_mobs:rotten_flesh", "group:food_meat", "group:food_meat_raw", "group:food_chicken", "group:food_chicken_raw", "group:food_fish", "group:food_fish_raw"},
	on_rightclick = function(self, clicker)
		-- Try to tame wolf (intentionally does NOT use mobs:feed_tame)
		local tool = clicker:get_wielded_item()

		local dog, ent
		if tool:get_name() == "mesecraft_mobs:bone" then

			if not minetest.settings:get_bool("creative_mode") then
				tool:take_item()
				clicker:set_wielded_item(tool)
			end
			-- 1/3 chance of getting tamed
			if PseudoRandom(os.time()*10):next(1, 3) == 1 then
				local yaw = self.object:get_yaw()
				dog = minetest.add_entity(self.object:get_pos(), "mesecraft_mobs:dog")
				dog:set_yaw(yaw)
				ent = dog:get_luaentity()
				ent.owner = clicker:get_player_name()
				self.object:remove()
			end
		end
	end,
	animation = {
		speed_normal = 50,		speed_run = 100,
		stand_start = 40,		stand_end = 45,
		walk_start = 0,		walk_end = 40,
		run_start = 0,		run_end = 40,
	},
	jump = true,
	attacks_monsters = true,
        -- Make the wolf poop.
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

-- DOG (TAMED WOLF)
mobs:register_mob("mesecraft_mobs:dog", {
        type = "animal",
        hp_min = 20,
        hp_max = 20,
        passive = true,
        group_attack = true,
        collisionbox = {-0.3, -0.01, -0.3, 0.3, 0.84, 0.3},
        visual = "mesh",
        mesh = "mesecraft_mobs_wolf.b3d",
	textures = {
		{"mesecraft_mobs_wolf_tame.png^(mesecraft_mobs_wolf_collar.png^[colorize:#0000BB:192)"},
        },
        visual_size = {x=3, y=3},
        makes_footstep_sound = true,
        sounds = {
                random = "mesecraft_mobs_wolf_random",
                damage = "mesecraft_mobs_wolf_pain",
                death = "mesecraft_mobs_wolf_death",
                attack = "mesecraft_mobs_wolf_warcry",
                distance = 16,
        },
        pathfinding = 1,
        floats = 1,
        view_range = 16,
        walk_chance = 50,
        walk_velocity = 2,
        run_velocity = 3,
        stepheight = 1.1,
        damage = 4,
        reach = 2,
        attack_type = "dogfight",
        fear_height = 4,
        water_damage = 0,
        lava_damage = 4,
        light_damage = 0,
        follow = {"mesecraft_mobs:bone", "mesecraft_mobs:rotten_flesh", "group:food_meat", "group:food_meat_raw", "group:food_chicken", "group:food_chicken_raw", "group:food_fish", "group:food_fish_raw"},
	owner_loyal = true,
        animation = {
                speed_normal = 50,              speed_run = 100,
                stand_start = 40,               stand_end = 45,
                walk_start = 0,         walk_end = 40,
                run_start = 0,          run_end = 40,
        },
        jump = true,
        attacks_monsters = true,
	on_rightclick = function(self, clicker)
	        local item = clicker:get_wielded_item()

	        if mobs:protect(self, clicker) then
	                return
	        elseif item:get_name() ~= "" and mobs:capture_mob(self, clicker, 0, 2, 80, false, nil) then
	                return
		elseif item:get_name() == "mesecraft_mobs:bone" then
	                -- Feed to increase health
	                local hp = self.health
	                local hp_add = 5
	                -- Use eatable group to determine health boost
	                local eatable = minetest.get_item_group(item, "eatable")
	                if eatable > 0 then
	                        hp_add = eatable
	                elseif item:get_name() == "mesecraft_mobs:rotten_flesh" or minetest.get_item_group(item:get_name(), "food_meat_raw") == 1 or minetest.get_item_group(item:get_name(), "food_meat") == 1 or minetest.get_item_group(item:get_name(), "food_chicken") == 1 or minetest.get_item_group(item:get_name(), "food_chicken_raw") == 1 or minetest.get_item_group(item:get_name(), "food_fish_raw") == 1 or minetest.get_item_group(item:get_name(), "food_fish") == 1 then
	                        hp_add = 4
	                else
	                        hp_add = 4
	                end
	                local new_hp = hp + hp_add
	                if new_hp > self.hp_max then
	                        new_hp = self.hp_max
	                end
	                if not minetest.settings:get_bool("creative_mode") then
	                        item:take_item()
	                        clicker:set_wielded_item(item)
	                end
	                self.health = new_hp
	                return
--	        elseif minetest.get_item_group(item:get_name(), "dye") == 1 then
--	                -- Dye (if possible)
--	                for group, _ in pairs(colors) do
--	                        -- Check if color is supported
--	                        if minetest.get_item_group(item:get_name(), group) == 1 then
--	                                -- Dye collar
--	                                local tex = get_dog_textures(group)
--	                                if tex then
--	                                        self.base_texture = tex
--	                                        self.object:set_properties({
--	                                                textures = self.base_texture
--	                                        })
--	                                        if not minetest.settings:get_bool("creative_mode") then
--	                                                item:take_item()
--	                                                clicker:set_wielded_item(item)
--	                                        end
--	                                        break
--	                                end
--	                        end
--	                end
		        else
	                -- Toggle sitting order

	                if not self.owner or self.owner == "" then
	                        -- Huh? This wolf has no owner? Let's fix this! This should never happen.
	                        self.owner = clicker:get_player_name()
	                end

	                if not self.order or self.order == "" or self.order == "sit" then
	                        self.order = "roam"
	                        self.walk_chance = 50
	                        self.jump = true
	                else
	                        -- TODO: Add sitting model
	                        self.order = "sit"
	                        self.walk_chance = 0
	                        self.jump = false
	                end
	        end
	end,
        -- Make the poopy puppy poop.
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

	-- follow function
	function(dist, teleport_check_interval)
	return function(self, dtime)
		-- No teleportation if no owner or if sitting
		if not self.owner or self.order == "sit" then
			return
		end
		if not teleport_check_interval then
			teleport_check_interval = 2
		end
		if not dist then
			dist = 8
		end
		if self._teleport_timer == nil then
			self._teleport_timer = teleport_check_interval
			return
		end
		self._teleport_timer = self._teleport_timer - dtime
		if self._teleport_timer <= 0 then
			self._teleport_timer = teleport_check_interval
			local mob_pos = self.object:get_pos()
			local owner = minetest.get_player_by_name(self.owner)
			if not owner then
				-- No owner found, no teleportation
				return
			end
			local owner_pos = owner:get_pos()
			local dist_from_owner = vector.distance(owner_pos, mob_pos)
			if dist_from_owner > dist then
				-- Check for nodes below air in a 5×1×5 area around the owner position
				local check_offsets = table.copy(offsets)
				-- Attempt to place mob near player. Must be placed on walkable node below a non-walkable one. Place inside that air node.
				while #check_offsets > 0 do
					local r = pr:next(1, #check_offsets)
					local telepos = vector.add(owner_pos, check_offsets[r])
					local telepos_below = {x=telepos.x, y=telepos.y-1, z=telepos.z}
					table.remove(check_offsets, r)
					-- Long story short, spawn on a platform
					if minetest.registered_nodes[minetest.get_node(telepos).name].walkable == false and
							minetest.registered_nodes[minetest.get_node(telepos_below).name].walkable == true then
						-- Correct position found! Let's teleport.
						self.object:set_pos(telepos)
						return
					end
				end
			end
		end
	end
end,

})

-- Collar colors for dog.
--local colors = {
--	["color_black"] = "#000000",
--	["color_blue"] = "#0000BB",
--	["color_brown"] = "#663300", -- brown
--	["color_cyan"] = "#01FFD8",
--	["color_dark_green"] = "#005B00",
--	["color_grey"] = "#C0C0C0",
--	["color_darkgrey"] = "#303030",
--	["color_green"] = "#00FF01",
--	["color_magenta"] = "#FF05BB", -- magenta
--	["color_orange"] = "#FF8401",
--	["color_pink"] = "#FF65B5", -- pink
--	["color_red"] = "#FF0000",
--	["color_violet"] = "#5000CC",
--	["color_white"] = "#FFFFFF",
--	["color_yellow"] = "#FFFF00",
--}
--local get_dog_textures = function(color)
--	if colors[color] then
--		return {"mesecraft_mobs_wolf_tame.png^(mesecraft_mobs_wolf_collar.png^[colorize:"..colors[color]..":192)"}
--	else
--		return nil
--	end
--end

-- Tamed wolf texture + red collar
--dog.textures = get_dog_textures("color_red")

-- Register Spawn Parameters
mobs:spawn_specific("mesecraft_mobs:wolf", {"default:dirt_with_grass", "default:dirt_with_rainforest_litter", "default:dirt", "default:dirt_with_snow", "default:snow", "default:snowblock", "ethereal:prairie_dirt"}, {"air"}, 1, 8, 240, 6000, 2, 3, 100)

-- Register Spawn Egg
mobs:register_egg("mesecraft_mobs:wolf", "Wolf Spawn Egg", "wool_white.png", 1)
