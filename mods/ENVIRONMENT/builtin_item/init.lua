-- Minetest: builtin/item_entity.lua

-- override ice to make slippery for 0.4.16
if not minetest.raycast then
	minetest.override_item("default:ice", {
		groups = {cracky = 3, puts_out_fire = 1, cools_lava = 1, slippery = 3}})
end


function core.spawn_item(pos, item)

	local stack = ItemStack(item)
	local obj = core.add_entity(pos, "__builtin:item")

	if obj then
		obj:get_luaentity():set_item(stack:to_string())
	end

	return obj
end


-- If item_entity_ttl is not set, enity will have default life time
-- Setting it to -1 disables the feature
local time_to_live = tonumber(core.settings:get("item_entity_ttl")) or 900
local gravity = tonumber(core.settings:get("movement_gravity")) or 9.81
local destroy_item = core.settings:get_bool("destroy_item") ~= false


-- localize some math functions
local abs = math.abs
local sqrt = math.sqrt


-- water flow functions by QwertyMine3, edited by TenPlus1 and Gustavo6046
local inv_roots = {[0] = 1}

local function to_unit_vector(dir_vector)

	local sum = dir_vector.x * dir_vector.x + dir_vector.z * dir_vector.z
	local invr_sum

	-- find inverse square root if possible
	if inv_roots[sum] ~= nil then
		invr_sum = inv_roots[sum]
	else
		-- not found, compute and save the inverse square root
		invr_sum = 1.0 / sqrt(sum)
		inv_roots[sum] = invr_sum
	end

	return {
		x = dir_vector.x * invr_sum,
		y = dir_vector.y,
		z = dir_vector.z * invr_sum
	}
end


local function node_ok(pos)

	local node = minetest.get_node_or_nil(pos)

	if node and minetest.registered_nodes[node.name] then
		return node
	end

	return minetest.registered_nodes["default:dirt"]
end


local function quick_flow_logic(node, pos_testing, direction)

	local node_testing = node_ok(pos_testing)
	local param2 = node.param2

	if not minetest.registered_nodes[node.name].groups.liquid then
		param2 = 0
	end

	if minetest.registered_nodes[node_testing.name].liquidtype ~= "flowing"
	and minetest.registered_nodes[node_testing.name].liquidtype ~= "source" then
		return 0
	end

	local param2_testing = node_testing.param2

	if param2_testing < param2 then

		if (param2 - param2_testing) > 6 then
			return -direction
		else
			return direction
		end

	elseif param2_testing > param2 then

		if (param2_testing - param2) > 6 then
			return direction
		else
			return -direction
		end
	end

	return 0
end


local function quick_flow(pos, node)

	local x, z = 0.0, 0.0

	x = x + quick_flow_logic(node, {x = pos.x - 1, y = pos.y, z = pos.z},-1)
	x = x + quick_flow_logic(node, {x = pos.x + 1, y = pos.y, z = pos.z}, 1)
	z = z + quick_flow_logic(node, {x = pos.x, y = pos.y, z = pos.z - 1},-1)
	z = z + quick_flow_logic(node, {x = pos.x, y = pos.y, z = pos.z + 1}, 1)

	return to_unit_vector({x = x, y = 0, z = z})
end


-- particle effects for when item is destroyed
local function add_effects(pos)

	minetest.add_particlespawner({
		amount = 1,
		time = 0.25,
		minpos = pos,
		maxpos = pos,
		minvel = {x = -1, y = 2, z = -1},
		maxvel = {x = 1, y = 4, z = 1},
		minacc = {x = 0, y = 0, z = 0},
		maxacc = {x = 0, y = 0, z = 0},
		minexptime = 1,
		maxexptime = 3,
		minsize = 1,
		maxsize = 4,
		texture = "tnt_smoke.png",
	})
end

-- print vector, helpful when debugging
local function vec_print(head, vec)
	print(head, vec.x, vec.y, vec.z)
end


local water_force = tonumber(minetest.settings:get("builtin_item.waterflow_force") or 1.6)
local water_drag = tonumber(minetest.settings:get("builtin_item.waterflow_drag") or 0.8)
local dry_friction = tonumber(minetest.settings:get("builtin_item.friction_dry") or 2.5)
local air_drag = tonumber(minetest.settings:get("builtin_item.air_drag") or 0.4)
local items_collect_on_slippery = tonumber(
		minetest.settings:get("builtin_item.items_collect_on_slippery") or 1) ~= 0


core.register_entity(":__builtin:item", {

	initial_properties = {
		hp_max = 1,
		physical = true,
		collide_with_objects = false,
		collisionbox = {-0.3, -0.3, -0.3, 0.3, 0.3, 0.3},
		visual = "wielditem",
		visual_size = {x = 0.4, y = 0.4},
		textures = {""},
		spritediv = {x = 1, y = 1},
		initial_sprite_basepos = {x = 0, y = 0},
		is_visible = false,
		infotext = ""
	},

	itemstring = "",
	falling_state = true,
	slippery_state = false,
	waterflow_state = false,
	age = 0,

	accel = {x = 0, y = 0, z = 0},

	set_item = function(self, item)

		local stack = ItemStack(item or self.itemstring)

		self.itemstring = stack:to_string()

		if self.itemstring == "" then
			return
		end

		local itemname = stack:is_known() and stack:get_name() or "unknown"
		local max_count = stack:get_stack_max()
		local count = math.min(stack:get_count(), max_count)
		local size = 0.2 + 0.1 * (count / max_count) ^ (1 / 3)
		local col_height = size * 0.75
		local def = core.registered_nodes[itemname]
		local glow = def and def.light_source
		local c1, c2 = "",""

		if not(stack:get_count() == 1) then
			c1 = " x" .. tostring(stack:get_count())
			c2 = " " .. tostring(stack:get_count())
		end

		local name1 = stack:get_meta():get_string("description")
		local name

		if name1 == "" then
			name = core.registered_items[itemname].description
		else
			name = name1
		end

		-- small random size bias to counter Z-fighting
		local bias = math.random() * 1e-3

		self.object:set_properties({
			is_visible = true,
			visual = "wielditem",
			textures = {itemname},
			visual_size = {x = size + bias, y = size + bias, z = size + bias},
			collisionbox = {-size, -col_height, -size, size, col_height, size},
			selectionbox = {-size, -size, -size, size, size, size},
			automatic_rotate = 0.314 / size,
			wield_item = self.itemstring,
			glow = glow,
			infotext = name .. c1 .. "\n(" .. itemname .. c2 .. ")"
		})

	end,

	get_staticdata = function(self)

		local data = {
			itemstring = self.itemstring,
			age = self.age,
			dropped_by = self.dropped_by
		}

		return core.serialize(data)
	end,

	on_activate = function(self, staticdata, dtime_s)

		if string.sub(staticdata, 1, string.len("return")) == "return" then

			local data = core.deserialize(staticdata)

			if data and type(data) == "table" then
				self.itemstring = data.itemstring
				self.age = (data.age or 0) + dtime_s
				self.dropped_by = data.dropped_by
			end
		else
			self.itemstring = staticdata
		end

		self.object:set_armor_groups({immortal = 1})
		self:set_item()
	end,

	try_merge_with = function(self, own_stack, object, entity)

		if self.age == entity.age then
			return false -- Can not merge with itself
		end

		local stack = ItemStack(entity.itemstring)
		local name = stack:get_name()

		if own_stack:get_name() ~= name
		or own_stack:get_meta() ~= stack:get_meta()
		or own_stack:get_wear() ~= stack:get_wear()
		or own_stack:get_free_space() == 0 then
			return false -- Can not merge different or full stack
		end

		local count = own_stack:get_count()
		local total_count = stack:get_count() + count
		local max_count = stack:get_stack_max()

		if total_count > max_count then
			return false
		end

		-- Merge the remote stack into this one
		local pos = object:get_pos()

		pos.y = pos.y + ((total_count - count) / max_count) * 0.15

		self.object:move_to(pos)
		self.age = 0 -- Handle as new entity

		-- Merge velocities
		local vel_a = self.object:get_velocity()
		local vel_b = object:get_velocity()

		self.object:set_velocity({
			x = (vel_a.x + vel_b.x) / 2,
			y = (vel_a.y + vel_b.y) / 2,
			z = (vel_a.z + vel_b.z) / 2
		})

		-- Merge stacks
		own_stack:set_count(total_count)
		self:set_item(own_stack)

		entity.itemstring = ""
		object:remove()

		return true
	end,

	step_update_node_state = function(self, moveresult, dtime)

		local pos = self.object:get_pos()

		-- get nodes every 1/4 second
		self.timer = (self.timer or 0) + dtime

		if self.timer > 0.25 or not self.node_inside then

			self.node_inside = minetest.get_node_or_nil(pos)
			self.def_inside = self.node_inside
					and core.registered_nodes[self.node_inside.name]

			-- get ground node for collision
			self.node_under = nil
			self.falling_state = true

			if moveresult.touching_ground then

				for _, info in ipairs(moveresult.collisions) do

					if info.axis == "y" then

						self.node_under = core.get_node(info.node_pos)
						self.falling_state = false

						break
					end
				end
			end

			self.def_under = self.node_under
				and core.registered_nodes[self.node_under.name]

			self.timer = 0
		end
	end,

	step_node_inside_checks = function(self)

		local pos = self.object:get_pos()
		local node = self.node_inside
		local def = self.def_inside

		-- Delete in 'ignore' nodes
		if node and node.name == "ignore" then

			self.itemstring = ""
			self.object:remove()

			return true
		end

		-- item inside block, move to vacant space
		if def and (def.walkable == nil or def.walkable == true)
		and (def.collision_box == nil or def.collision_box.type == "regular")
		and (def.node_box == nil or def.node_box.type == "regular") then

			local npos = minetest.find_node_near(pos, 1, "air")

			if npos then
				self.object:move_to(npos)
			end

			self.node_inside = nil -- force get_node
		end

		-- destroy item when dropped into lava (if enabled)
		if destroy_item and def and def.groups and def.groups.lava then

			minetest.sound_play("builtin_item_lava", {
				pos = pos,
				max_hear_distance = 6,
				gain = 0.5
			})

			self.itemstring = ""
			self.object:remove()

			add_effects(pos)

			return true
		end

		return false
	end,

	step_check_slippery = function(self)

		-- don't check for slippery ground if we're not on
		-- any ground to begin with
		local node = self.node_under
		local def = self.def_under

		if self.falling_state or not node then
			self.slippery_state = false
			return
		end

		if node and def and def.walkable then

			local slippery = core.get_item_group(node.name, "slippery")

			self.slippery_state = slippery ~= 0
		end
	end,

	step_water_physics = function(self)

		local pos = self.object:get_pos()
		local vel = self.object:get_velocity()
		local node = self.node_inside
		local def = self.def_inside

		self.waterflow_state = def and def.liquidtype == "flowing"

		if self.waterflow_state then

			-- get flow velocity
			local flow_vel = quick_flow(pos, node)

			-- calculate flow force and drag
			local flow_force_x = flow_vel.x * water_force
			local flow_force_z = flow_vel.z * water_force

			local flow_drag_x = (flow_force_x - vel.x) * water_drag
			local flow_drag_z = (flow_force_z - vel.z) * water_drag

			-- apply water force and friction
			self.accel.x = self.accel.x + flow_force_x + flow_drag_x
			self.accel.z = self.accel.z + flow_force_z + flow_drag_z
		end
	end,

	step_air_drag_physics = function(self)

		local vel = self.object:get_velocity()

		-- apply air drag
		if self.falling_state or (self.slippery_state and not self.waterflow_state) then
			self.accel.x = self.accel.x - vel.x * air_drag
			self.accel.z = self.accel.z - vel.z * air_drag
		end
	end,

	step_gravity = function(self)

		if self.falling_state then
			self.accel.y = self.accel.y - gravity
		end
	end,

	step_ground_friction = function(self)

		-- don't apply ground friction when falling!
		if self.falling_state then
			return
		end

		local vel = self.object:get_velocity()

		if self.slippery_state then

			local node = self.node_under

			-- apply slip factor (tiny friction that depends on the actual block type)
			if (abs(vel.x) > 0.2 or abs(vel.z) > 0.2) then

				local slippery = core.get_item_group(node.name, "slippery")
				local slip_factor = 4.0 / (slippery + 4)

				self.accel.x = self.accel.x - vel.x * slip_factor
				self.accel.z = self.accel.z - vel.z * slip_factor
			end

		else
			self.accel.x = self.accel.x - vel.x * dry_friction
			self.accel.z = self.accel.z - vel.z * dry_friction
		end
	end,

	step_apply_forces = function(self)
		self.object:set_acceleration(self.accel)
	end,

	step_check_timeout = function(self, dtime)

		local pos = self.object:get_pos()

		self.age = self.age + dtime

		if time_to_live > 0 and self.age > time_to_live then

			self.itemstring = ""
			self.object:remove()

			add_effects(pos)

			return true
		end

		return false
	end,

	step_check_custom_step = function(self, dtime, moveresult)

		local pos = self.object:get_pos()

		-- do custom step function
		local name = ItemStack(self.itemstring):get_name() or ""
		local custom = core.registered_items[name]
			and core.registered_items[name].dropped_step

		if custom and custom(self, pos, dtime, moveresult) == false then
			return true -- skip further checks if false
		end

		return false
	end,

	step_try_collect = function(self)

		local self_pos = self.object:get_pos()

		-- Don't collect items if falling
		if self.falling_state then
			return
		end

		-- Check if we should collect items while sliding
		if self.slippery_state and not items_collect_on_slippery then
			return
		end

		-- Collect the items around to merge with
		local own_stack = ItemStack(self.itemstring)

		if own_stack:get_free_space() == 0 then
			return
		end

		local objects = core.get_objects_inside_radius(self_pos, 1.0)

		for _, obj in pairs(objects) do

			local entity = obj:get_luaentity()

			if entity and entity.name == "__builtin:item" and not entity.is_falling then

				if self:try_merge_with(own_stack, obj, entity) then

					-- item will be moved up due to try_merge_with
					self.falling_state = true

					own_stack = ItemStack(self.itemstring)

					if own_stack:get_free_space() == 0 then
						return
					end
				end
			end
		end
	end,

	on_step = function(self, dtime, moveresult)

		-- reset acceleration
		self.accel = {x = 0, y = 0, z = 0}

		-- check item timeout
		if self:step_check_timeout(dtime) then
			return -- deleted, stop here
		end

		-- check custom step function
		if self:step_check_custom_step(dtime, moveresult) then
			return -- overriden
		end

		-- do general checks
		self:step_update_node_state(moveresult, dtime)

		if self:step_node_inside_checks() then
			return -- destroyed
		end

		self:step_check_slippery()

		-- do physics checks, then apply
		self:step_water_physics()
		self:step_ground_friction()
		self:step_gravity()

		self:step_apply_forces()

		-- do item checks
		self:step_try_collect()
	end,

	on_punch = function(self, hitter)

		local inv = hitter:get_inventory()

		if inv and self.itemstring ~= "" then

			local left = inv:add_item("main", self.itemstring)

			if left and not left:is_empty() then
				self:set_item(left)
				return
			end
		end

		self.itemstring = ""
		self.object:remove()
	end,
})
