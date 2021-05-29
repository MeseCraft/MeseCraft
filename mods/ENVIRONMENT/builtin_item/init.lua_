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


-- water flow functions by QwertyMine3, edited by TenPlus1
local inv_roots = {
	[0] = 1
}

local function to_unit_vector(dir_vector)

	local sum = dir_vector.x * dir_vector.x + dir_vector.z * dir_vector.z
	local invr_sum = 0

	-- find inverse square root if possible
	if inv_roots[sum] ~= nil then
		invr_sum = inv_roots[sum]
	else
		-- not found, compute and save the inverse square root
		invr_sum = 1.0 / math.sqrt(sum)
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


-- reciprocal of the length of an unit square's diagonal
local DIAG_WEIGHT = 2 / math.sqrt(2)

local function quick_flow(pos, node)

	local x, z = 0.0, 0.0

	x = x + quick_flow_logic(node, {x = pos.x - 1, y = pos.y, z = pos.z},-1)
	x = x + quick_flow_logic(node, {x = pos.x + 1, y = pos.y, z = pos.z}, 1)
	z = z + quick_flow_logic(node, {x = pos.x, y = pos.y, z = pos.z - 1},-1)
	z = z + quick_flow_logic(node, {x = pos.x, y = pos.y, z = pos.z + 1}, 1)

	return to_unit_vector({x = x, y = 0, z = z})
end
-- END water flow functions


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


local water_force = 0.8
local water_friction = 0.8
local dry_friction = 2.5

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
		infotext = "",
	},

	itemstring = "",
	moving_state = true,
	slippery_state = false,
	age = 0,

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
			c1 = " x"..tostring(stack:get_count())
			c2 = " "..tostring(stack:get_count())
		end

		local name1 = stack:get_meta():get_string("description")
		local name

		if name1 == "" then
			name = core.registered_items[itemname].description
		else
			name = name1
		end

		self.object:set_properties({
			is_visible = true,
			visual = "wielditem",
			textures = {itemname},
			visual_size = {x = size, y = size},
			collisionbox = {-size, -col_height, -size, size, col_height, size},
			selectionbox = {-size, -size, -size, size, size, size},
			automatic_rotate = 0.314 / size,
			wield_item = self.itemstring,
			glow = glow,
			infotext = name .. c1 .. "\n(" .. itemname .. c2 .. ")"
		})

	end,

	get_staticdata = function(self)

		return core.serialize({
			itemstring = self.itemstring,
			age = self.age,
			dropped_by = self.dropped_by
		})
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
		self.object:set_velocity({x = 0, y = 2, z = 0})
		self.object:set_acceleration({x = 0, y = -gravity, z = 0})
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

		own_stack:set_count(total_count)
		self:set_item(own_stack)

		entity.itemstring = ""
		object:remove()

		return true
	end,

	on_step = function(self, dtime, moveresult)

		local pos = self.object:get_pos()

		self.age = self.age + dtime

		if time_to_live > 0 and self.age > time_to_live then

			self.itemstring = ""
			self.object:remove()

			add_effects(pos)

			return
		end

		-- get nodes every 1/4 second
		self.timer = (self.timer or 0) + dtime

		if self.timer > 0.25 or not self.node_inside then

			self.node_inside = minetest.get_node_or_nil(pos)
			self.def_inside = self.node_inside
					and core.registered_nodes[self.node_inside.name]

			-- get ground node for collision
			self.node_under = nil

			if moveresult.touching_ground then

				for _, info in ipairs(moveresult.collisions) do

					if info.axis == "y" then

						self.node_under = core.get_node(info.node_pos)

						break
					end
				end
			end

			self.def_under = self.node_under
					and core.registered_nodes[self.node_under.name]

			self.timer = 0
		end

		local node = self.node_inside

		-- Delete in 'ignore' nodes
		if node and node.name == "ignore" then

			self.itemstring = ""
			self.object:remove()

			return
		end

		-- do custom step function
		local name = ItemStack(self.itemstring):get_name() or ""
		local custom = core.registered_items[name]
			and core.registered_items[name].dropped_step

		if custom and custom(self, pos, dtime) == false then
			return -- skip further checks if false
		end

		local vel = self.object:get_velocity()
		local def = self.def_inside
		local is_slippery = false
		local is_moving = (def and not def.walkable) or
			vel.x ~= 0 or vel.y ~= 0 or vel.z ~= 0

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

			return
		end

		-- water flowing
		if def and def.liquidtype == "flowing" then

			-- force applies on acceleration over time, thus multiply
			local force = water_force * dtime
			-- friction applies on velocity over time,     thus exponentiate
			local friction = (1.0 + water_friction) ^ dtime

			-- get flow velocity and current vel/acc state
			local vec = quick_flow(pos, node)
			local a = self.object:get_acceleration()

			self.object:set_acceleration({
				x = a.x + vec.x * force,
				y = a.y,
				z = a.z + vec.z * force
			})

			-- apply friction to prevent items going too fast, and also to make
			-- water flow override previous horizontal momentum more quickly

			local v = self.object:get_velocity()

			-- adjust friction for going against the current
			local v_horz = { x = v.x, y = 0, z = v.z }
			local v_dir = to_unit_vector(v_horz)
			local flow_dot = v_dir.x * vec.x + v_dir.y * vec.y

			-- also maps flow_dot from [-1,0] to [0.5,2.5]
			friction = 1.0 + ((friction - 1.0) * (flow_dot + 1.5))

			self.object:set_velocity({
				x = v.x / friction,
				y = v.y / friction,
				z = v.z / friction
			})

			return
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

			return
		end

		-- Switch locals to node under
		node = self.node_under
		def = self.def_under


		-- Slippery node check
		if def and def.walkable then

			local slippery = core.get_item_group(node.name, "slippery")

			is_slippery = slippery ~= 0

			if is_slippery and (math.abs(vel.x) > 0.2 or math.abs(vel.z) > 0.2) then

				-- Horizontal deceleration
				local slip_factor = 4.0 / (slippery + 4)

				self.object:set_acceleration({
					x = -vel.x * slip_factor,
					y = 0,
					z = -vel.z * slip_factor
				})

			elseif vel.y == 0 then
				is_moving = false
			end
		end

		if self.moving_state == is_moving
		and self.slippery_state == is_slippery then
			return -- No further updates until moving state changes
		end

		self.moving_state = is_moving
		self.slippery_state = is_slippery

		local a_curr = self.object:get_acceleration()
		local v_curr = self.object:get_velocity()

		if is_moving then

			self.object:set_acceleration({
				x = a_curr.x,
				y = a_curr.y - gravity,
				z = a_curr.z
			})
		else
			self.object:set_acceleration({x = 0, y = 0, z = 0})

			-- preserve *some* velocity so items don't get stuck on the very ledges
			-- of nodes once they move just enough to leave the hitbox of flowing water
			self.object:set_velocity({
				x = v_curr.x / dry_friction,
				y = v_curr.y / dry_friction,
				z = v_curr.z / dry_friction
			})
		end

		--Only collect items if not moving
		if is_moving then
			return
		end

		-- Collect the items around to merge with
		local own_stack = ItemStack(self.itemstring)

		if own_stack:get_free_space() == 0 then
			return
		end

		local objects = core.get_objects_inside_radius(pos, 1.0)

		for k, obj in pairs(objects) do

			local entity = obj:get_luaentity()

			if entity and entity.name == "__builtin:item" then

				if self:try_merge_with(own_stack, obj, entity) then

					own_stack = ItemStack(self.itemstring)

					if own_stack:get_free_space() == 0 then
						return
					end
				end
			end
		end
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
