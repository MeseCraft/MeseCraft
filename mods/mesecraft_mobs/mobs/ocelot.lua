-- Simplified by FreeGamers.org
--License for code WTFPL and otherwise stated in readmes
--################### OCELOT AND CAT from mc_mobs--###################

local pr = PseudoRandom(os.time()*12)

-- Returns true if the item is food (taming) for the cat/ocelot
local is_food = function(itemstring)
	for f=1, #mobs_mc.follow.ocelot do
		if itemstring == mobs_mc.follow.ocelot[f] then
			return true
		elseif string.sub(itemstring, 1, 6) == "group:" and minetest.get_item_group(itemstring, string.sub(itemstring, 7, -1)) ~= 0 then
			return true
		end
	end
	return false
end

-- Ocelot
local ocelot = {
	type = "animal",
	hp_min = 10,
	hp_max = 10,
	collisionbox = {-0.3, -0.01, -0.3, 0.3, 0.69, 0.3},
	visual = "mesh",
	mesh = "mesecraft_mobs_cat.b3d",
	textures = {"mesecraft_mobs_cat_ocelot.png"},
	visual_size = {x=2.0, y=2.0},
	makes_footstep_sound = true,
	walk_chance = 70,
	walk_velocity = 1,
	run_velocity = 3,
	floats = 1,
	runaway = true,
        runaway_from = {"player"},
	water_damage = 0,
	lava_damage = 4,
	light_damage = 0,
	fall_damage = 0,
	fear_height = 4,
	sounds = {
		random = "mesecraft_mobs_ocelot_random",
		damage = "mesecraft_mobs_ocelot_pain",
		distance = 16,
	},
	animation = {
		speed_normal = 25,		speed_run = 50,
		stand_start = 0,		stand_end = 0,
		walk_start = 0,		walk_end = 40,
		run_start = 0,		run_end = 40,
	},
	follow = {"mesecraft_mobs:milk_bucket", "mesecraft_mobs:milk_glass", "mesecraft_mobs:chicken_raw", "mesecraft_mobs:chicken_cooked", "mesecraft_mobs:cod_raw", "mesecraft_mobs:cod_cooked", "mesecraft_mobs:clownfish_raw", "mesecraft_mobs:clownfish_cooked", "mesecraft_mobs:rabbit_raw", "mesecraft_mobs:rabbit_cooked", "mesecraft_mobs:salmon_raw", "mesecraft_mobs:salmon_cooked",},
	view_range = 12,
	passive = true,
	attack_type = "dogfight",
	pathfinding = 1,
	damage = 2,
	reach = 1,
	attack_animals = true,
	specific_attack = { "mesecraft_mobs:chicken" },
-- FROM WOLF	
	on_rightclick = function(self, clicker)
		-- Can't tame a kitten. Sorry.
		if self.child then return end
		-- Try to tame ocelot (intentionally does NOT use mobs:feed_tame)
		local item = clicker:get_wielded_item()
		if item:get_name() == "mesecraft_mobs:rotten_flesh" or minetest.get_item_group(item:get_name(), "food_meat_raw") == 1 or minetest.get_item_group(item:get_name(), "food_meat") == 1 or minetest.get_item_group(item:get_name(), "food_chicken") == 1 or minetest.get_item_group(item:get_name(), "food_chicken_raw") == 1 or minetest.get_item_group(item:get_name(), "food_fish_raw") == 1 or minetest.get_item_group(item:get_name(), "food_fish") == 1 or minetest.get_item_group(item:get_name(), "food_milk") == 1 or minetest.get_item_group(item:get_name(), "food_milk_glass") == 1 then
		-- Don't take items in creative mode.		
			if not minetest.settings:get_bool("creative_mode") then
					item:take_item()
					clicker:set_wielded_item(item)
				end	
			-- 1/3 chance of getting tamed
			if pr:next(1, 3) == 1 then
				local yaw = self.object:get_yaw()
				local cat = minetest.add_entity(self.object:get_pos(), "mesecraft_mobs:cat")
				cat:set_yaw(yaw)
				local ent = cat:get_luaentity()
				ent.owner = clicker:get_player_name()
				ent.tamed = true
				self.object:remove()
				return
			end
		end
	end,
}

mobs:register_mob("mesecraft_mobs:ocelot", ocelot)

-- Cat
local cat = table.copy(ocelot)
cat.textures = {{"mesecraft_mobs_cat_black.png"}, {"mesecraft_mobs_cat_red.png"}, {"mesecraft_mobs_cat_siamese.png"}}
cat.owner = ""
cat.order = "roam" -- "sit" or "roam"
cat.owner_loyal = true
cat.tamed = true
cat.runaway = false
-- Automatically teleport cat to owner
cat.do_custom = function(dist, teleport_check_interval)
		return function(self, dtime)
		-- No teleportation if no owner or if sitting
		if not self.owner or self.order == "sit" then
			return
		end
		if not teleport_check_interval then
			teleport_check_interval = 4
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
end
cat.on_rightclick = function(self, clicker)
	-- restore health when fed.
        local item = clicker:get_wielded_item()
	if item:get_name() == "mesecraft_mobs:rotten_flesh" or minetest.get_item_group(item:get_name(), "food_meat_raw") == 1 or minetest.get_item_group(item:get_name(), "food_meat") == 1 or minetest.get_item_group(item:get_name(), "food_chicken") == 1 or minetest.get_item_group(item:get_name(), "food_chicken_raw") == 1 or minetest.get_item_group(item:get_name(), "food_fish_raw") == 1 or minetest.get_item_group(item:get_name(), "food_fish") == 1 or minetest.get_item_group(item:get_name(), "food_milk") == 1 or minetest.get_item_group(item:get_name(), "food_milk_glass") == 1 then
                local hp = self.health
                local hp_add = 5
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
	end
	if mobs:feed_tame(self, clicker, 1, true, false) then return end
	if mobs:capture_mob(self, clicker, 0, 60, 5, false, nil) then return end
	if mobs:protect(self, clicker) then return end
	-- if its a kitten do nothing.
	if self.child then return end

	-- Toggle sitting order

	if not self.owner or self.owner == "" then
		-- Huh? This cat has no owner? Let's fix this! This should never happen.
		self.owner = clicker:get_player_name()
	end

	if not self.order or self.order == "" or self.order == "sit" then
		self.order = "roam"
		self.walk_chance = default_walk_chance
		self.jump = true
	else
		-- “Sit!”
		-- TODO: Add sitting model
		self.order = "sit"
		self.walk_chance = 0
		self.jump = false
	end

end

mobs:register_mob("mesecraft_mobs:cat", cat)

-- Spawn ocelot
mobs:spawn({
	name = "mesecraft_mobs:ocelot",
	nodes = {"default:dirt_with_rainforest_litter", "default:jungleleaves", "default:junglewood"},
	neighbors = {"air"},
	light_max = 20,
	light_min = 0,
	chance = 2500,
	active_object_count = 2,
	min_height = 1,
	max_height = 5,
	on_spawn = function(self, pos)
		-- 1/7 chance to spawn 2 ocelot kittens
		if pr:next(1,7) == 1 then
			-- Turn object into a child
			local make_child = function(object)
				local ent = object:get_luaentity()
				object:set_properties({
					visual_size = { x = ent.base_size.x/2, y = ent.base_size.y/2 },
					collisionbox = {
						ent.base_colbox[1]/2,
						ent.base_colbox[2]/2,
						ent.base_colbox[3]/2,
						ent.base_colbox[4]/2,
						ent.base_colbox[5]/2,
						ent.base_colbox[6]/2,
					}
				})
				ent.child = true
			end

			-- Possible spawn offsets, two of these will get selected
			local k = 0.7
			local offsets = {
				{ x=k, y=0, z=0 },
				{ x=-k, y=0, z=0 },
				{ x=0, y=0, z=k },
				{ x=0, y=0, z=-k },
				{ x=k, y=0, z=k },
				{ x=k, y=0, z=-k },
				{ x=-k, y=0, z=k },
				{ x=-k, y=0, z=-k },
			}
			for i=1, 2 do
				local o = pr:next(1, #offsets)
				local offset = offsets[o]
				local child_pos = vector.add(pos, offsets[o])
				table.remove(offsets, o)
				make_child(minetest.add_entity(child_pos, "mesecraft_mobs:ocelot"))
			end
		end
	end,
})

-- spawn eggs
-- FIXME: The spawn icon shows a cat texture, not an ocelot texture
mobs:register_egg("mesecraft_mobs:ocelot", "Ocelot Spawn Egg", "wool_orange.png", 1)
mobs:register_egg("mesecraft_mobs:cat", "Cat Spawn Egg", "wool_orange.png", 1)
