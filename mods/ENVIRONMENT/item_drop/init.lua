local load_time_start = minetest.get_us_time()

-- Functions which can be overridden by mods
item_drop = {
	-- This function is executed before picking up an item or making it fly to
	-- the player. If it does not return true, the item is ignored.
	-- It is also executed before collecting the item after it flew to
	-- the player and did not reach him/her for magnet_time seconds.
	can_pickup = function(entity, player)
		if entity.item_drop_picked then
			-- Ignore items where picking has already failed
			return false
		end
		return true
	end,

	-- before_collect and after_collect are executed before and after an item
	-- is collected by a player
	before_collect = function(entity, pos, player)
	end,
	after_collect = function(entity, pos, player)
		entity.item_drop_picked = true
	end,
}

local function legacy_setting_getbool(name_new, name_old, default)
	local v = minetest.settings:get_bool(name_new)
	if v == nil then
		v = minetest.settings:get_bool(name_new)
	end
	if default then
		return v ~= false
	end
	return v
end

local function legacy_setting_getnumber(name_new, name_old, default)
	return tonumber(minetest.settings:get(name_new))
		or tonumber(minetest.settings:get(name_old))
		or default
end

if legacy_setting_getbool("item_drop.enable_item_pickup",
		"enable_item_pickup", true) then
	local pickup_gain = legacy_setting_getnumber("item_drop.pickup_sound_gain",
		"item_pickup_gain", 0.2)
	local pickup_particle =
		minetest.settings:get_bool("item_drop.pickup_particle", true)
	local pickup_radius = legacy_setting_getnumber("item_drop.pickup_radius",
		"item_pickup_radius", 0.75)
	local magnet_radius = tonumber(
		minetest.settings:get("item_drop.magnet_radius")) or -1
	local magnet_time = tonumber(
		minetest.settings:get("item_drop.magnet_time")) or 5.0
	local pickup_age = tonumber(
		minetest.settings:get("item_drop.pickup_age")) or 0.5
	local key_triggered = legacy_setting_getbool("item_drop.enable_pickup_key",
		"enable_item_pickup_key", true)
	local key_invert = minetest.settings:get_bool(
		"item_drop.pickup_keyinvert") ~= false
	local keytype
	if key_triggered then
		keytype = minetest.settings:get("item_drop.pickup_keytype") or
		minetest.settings:get("item_pickup_keytype") or "Use"
		-- disable pickup age if picking is explicitly enabled by the player
		if not key_invert then
			pickup_age = math.min(pickup_age, 0)
		end
	end
	local mouse_pickup = minetest.settings:get_bool(
		"item_drop.mouse_pickup") ~= false
	if not mouse_pickup then
		minetest.registered_entities["__builtin:item"].pointable = false
	end

	local magnet_mode = magnet_radius > pickup_radius
	local zero_velocity_mode = pickup_age == -1
	if magnet_mode
	and zero_velocity_mode then
		error"zero velocity mode can't be used together with magnet mode"
	end

	-- tells whether an inventorycube should be shown as pickup_particle or not
	-- for known drawtypes
	local inventorycube_drawtypes = {
		normal = true,
		allfaces = true,
		allfaces_optional = true,
		glasslike = true,
		glasslike_framed = true,
		glasslike_framed_optional = true,
		liquid = true,
		flowingliquid = true,
	}

	-- adds the item to the inventory and removes the object
	local function collect_item(ent, pos, player)
		item_drop.before_collect(ent, pos, player)
		minetest.sound_play("item_drop_pickup", {
			pos = pos,
			gain = pickup_gain,
		})
		if pickup_particle then
			local item = minetest.registered_nodes[
				ent.itemstring:gsub("(.*)%s.*$", "%1")]
			local image = ""
			if item and item.tiles and item.tiles[1] then
				if inventorycube_drawtypes[item.drawtype] then
					local tiles = item.tiles

					local top = tiles[1]
					if type(top) == "table" then
						top = top.name
					end
					local left = tiles[3] or top
					if type(left) == "table" then
						left = left.name
					end
					local right = tiles[5] or left
					if type(right) == "table" then
						right = right.name
					end

					image = minetest.inventorycube(top, left, right)
				else
					image = item.inventory_image or item.tiles[1]
				end
				minetest.add_particle({
					pos = {x = pos.x, y = pos.y + 1.5, z = pos.z},
					velocity = {x = 0, y = 1, z = 0},
					acceleration = {x = 0, y = -4, z = 0},
					expirationtime = 0.2,
					size = 3,--math.random() + 0.5,
					vertical = false,
					texture = image,
				})
			end
		end
		ent:on_punch(player)
		item_drop.after_collect(ent, pos, player)
	end

	-- opt_get_ent gets the object's luaentity if it can be collected
	local opt_get_ent
	if zero_velocity_mode then
		function opt_get_ent(object)
			if object:is_player()
			or not vector.equals(object:get_velocity(), {x=0, y=0, z=0}) then
				return
			end
			local ent = object:get_luaentity()
			if not ent
			or ent.name ~= "__builtin:item"
			or ent.itemstring == "" then
				return
			end
			return ent
		end
	else
		function opt_get_ent(object)
			if object:is_player() then
				return
			end
			local ent = object:get_luaentity()
			if not ent
			or ent.name ~= "__builtin:item"
			or (ent.dropped_by and ent.age < pickup_age)
			or ent.itemstring == "" then
				return
			end
			return ent
		end
	end

	local afterflight
	if magnet_mode then
		-- take item or reset velocity after flying a second
		function afterflight(object, inv, player)
			-- TODO: test what happens if player left the game
			local ent = opt_get_ent(object)
			if not ent then
				return
			end
			local item = ItemStack(ent.itemstring)
			if inv
			and inv:room_for_item("main", item)
			and item_drop.can_pickup(ent, player) then
				collect_item(ent, object:get_pos(), player)
			else
				-- the acceleration will be reset by the object's on_step
				object:set_velocity({x=0,y=0,z=0})
				ent.is_magnet_item = false
			end
		end

		-- disable velocity and acceleration changes of items flying to players
		minetest.after(0, function()
			local ObjectRef
			local blocked_methods = {"set_acceleration", "set_velocity",
				"setacceleration", "setvelocity"}
			local itemdef = minetest.registered_entities["__builtin:item"]
			local old_on_step = itemdef.on_step
			local function do_nothing() end
			function itemdef.on_step(self, dtime)
				if not self.is_magnet_item then
					return old_on_step(self, dtime)
				end
				ObjectRef = ObjectRef or getmetatable(self.object)
				local old_funcs = {}
				for i = 1, #blocked_methods do
					local method = blocked_methods[i]
					old_funcs[method] = ObjectRef[method]
					ObjectRef[method] = do_nothing
				end
				old_on_step(self, dtime)
				for i = 1, #blocked_methods do
					local method = blocked_methods[i]
					ObjectRef[method] = old_funcs[method]
				end
			end
		end)
	end

	-- set keytype to the key name if possible
	if keytype == "Use" then
		keytype = "aux1"
	elseif keytype == "Sneak" then
		keytype = "sneak"
	elseif keytype == "LeftAndRight" then -- LeftAndRight combination
		keytype = 0
	elseif keytype == "SneakAndRMB" then -- SneakAndRMB combination
		keytype = 1
	end


	-- tests if the player has the keys pressed to enable item picking
	local function has_keys_pressed(player)
		if not key_triggered then
			return true
		end

		local control = player:get_player_control()
		local keys_pressed
		if keytype == 0 then -- LeftAndRight combination
			keys_pressed = control.left and control.right
		elseif keytype == 1 then -- SneakAndRMB combination
			keys_pressed = control.sneak and control.RMB
		else
			keys_pressed = control[keytype]
		end

		return keys_pressed ~= key_invert
	end

	-- called for each player to possibly collect an item, returns true if so
	local function pickupfunc(player)
		if not has_keys_pressed(player)
		or not minetest.get_player_privs(player:get_player_name()).interact
		or player:get_hp() <= 0 then
			return
		end

		local pos = player:get_pos()
		pos.y = pos.y+0.5
		local inv

		local objectlist = minetest.get_objects_inside_radius(pos,
			magnet_mode and magnet_radius or pickup_radius)
		for i = 1,#objectlist do
			local object = objectlist[i]
			local ent = opt_get_ent(object)
			if ent
			and item_drop.can_pickup(ent, player) then
				if not inv then
					inv = player:get_inventory()
					if not inv then
						minetest.log("error", "[item_drop] Couldn't " ..
							"get inventory")
						return
					end
				end
				local item = ItemStack(ent.itemstring)
				if inv:room_for_item("main", item) then
					local flying_item
					local pos2
					if magnet_mode then
						pos2 = object:get_pos()
						flying_item = vector.distance(pos, pos2) > pickup_radius
					end
					if not flying_item then
						-- The item is near enough to pick it
						collect_item(ent, pos, player)
						-- Collect one item at a time to avoid the loud pop
						return true
					end
					-- The item is not too far a way but near enough to be
					-- magnetised, make it fly to the player
					local vel = vector.multiply(vector.subtract(pos, pos2), 3)
					vel.y = vel.y + 0.6
					object:set_velocity(vel)
					if not ent.is_magnet_item then
						ent.object:set_acceleration({x=0, y=0, z=0})
						ent.is_magnet_item = true

						minetest.after(magnet_time, afterflight,
							object, inv, player)
					end
				end
			end
		end
	end

	local function pickup_step()
		local got_item
		local players = minetest.get_connected_players()
		for i = 1,#players do
			got_item = got_item or pickupfunc(players[i])
		end
		-- lower step if takeable item(s) were found
		local time
		if got_item then
			time = 0.02
		else
			time = 0.2
		end
		minetest.after(time, pickup_step)
	end
	minetest.after(3.0, pickup_step)
end

if legacy_setting_getbool("item_drop.enable_item_drop", "enable_item_drop", true)
and not minetest.settings:get_bool("creative_mode") then
	-- Workaround to test if an item metadata (ItemStackMetaRef) is empty
	local function itemmeta_is_empty(meta)
		local t = meta:to_table()
		for k, v in pairs(t) do
			if k ~= "fields" then
				return false
			end
			assert(type(v) == "table")
			if next(v) ~= nil then
				return false
			end
		end
		return true
	end

	-- Tests if the item has special information such as metadata
	local function can_split_item(item)
		return item:get_wear() == 0 and itemmeta_is_empty(item:get_meta())
	end

	local function spawn_items(pos, items_to_spawn)
		for i = 1,#items_to_spawn do
			local obj = minetest.add_item(pos, items_to_spawn[i])
			if not obj then
				error("Couldn't spawn item " .. name .. ", drops: "
					.. dump(drops))
			end

			local vel = obj:get_velocity()
			local x = math.random(-5, 4)
			if x >= 0 then
				x = x+1
			end
			vel.x = 1 / x
			local z = math.random(-5, 4)
			if z >= 0 then
				z = z+1
			end
			vel.z = 1 / z
			obj:set_velocity(vel)
		end
	end

	function minetest.handle_node_drops(pos, drops)
		for i = 1,#drops do
			local item = drops[i]
			if type(item) == "string" then
				-- The string is not necessarily only the item name,
				-- so always convert it to ItemStack
				item = ItemStack(item)
			end
			local count = item:get_count()
			local name = item:get_name()

			-- Sometimes nothing should be dropped
			if name == ""
			or not minetest.registered_items[name] then
				count = 0
			end

			if count > 0 then
				-- Split items if possible
				local items_to_spawn = {item}
				if can_split_item(item) then
					for i = 1,count do
						items_to_spawn[i] = name
					end
				end

				spawn_items(pos, items_to_spawn)
			end
		end
	end
end


local time = (minetest.get_us_time() - load_time_start) / 1000000
local msg = "[item_drop] loaded after ca. " .. time .. " seconds."
if time > 0.01 then
	print(msg)
else
	minetest.log("info", msg)
end
