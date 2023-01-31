local mod_name = minetest.get_current_modname()

-- Node replacements that emit light
-- Sets of lighting_node={ node=original_node, level=light_level }
local lighting_nodes = {}

-- The nodes that can be replaced with lighting nodes
-- Sets of original_node={ [1]=lighting_node_1, [2]=lighting_node_2, ... }
local lightable_nodes = {}

-- Prefixes used for each node so we can avoid overlap
-- Pairs of prefix=original_node
local lighting_prefixes = {}

-- node_name=true pairs of lightable nodes that are liquids and can flood some light sources
local lightable_liquids = {}

-- How often will the positions of lights be recalculated
local update_interval = 0.3

-- How long until a previously lit node should be updated - reduces flicker
local removal_delay = update_interval * 0.5

-- How often will a node attempt to check itself for deletion
local cleanup_interval = update_interval * 3

-- How far in the future will the position be projected based on the velocity
local velocity_projection = update_interval * 1

-- How many light levels should an item held in the hand be reduced by, compared to the placed node
-- does not apply to manually registered light levels
local level_delta = 2

-- item=light_level pairs of registered wielded lights
local shiny_items = {}

-- List of custom callbacks for each update step
local update_callbacks = {}
local update_player_callbacks = {}

-- position={id=light_level} sets of known about light sources and their levels by position
local active_lights = {}

--[[ Sets of entities being tracked, in the form:
entity_id = {
	obj = entity,
	items = {
		category_id..entity_id = {
			level = light_level,
			item? = item_name
		}
	},
	update = true | false,
	pos? = position_vector,
	offset? = offset_vector,
}
]]
local tracked_entities = {}

-- position=true pairs of positions that need to be recaculated this update step
local light_recalcs = {}

--[[
	Using 2-digit hex codes for categories
	Starts at 00, ends at FF
	This makes it easier extract `uid` from `cat_id..uid` by slicing off 2 characters
	The category ID must be of a fixed length (2 characters)
]]
local cat_id = 0
local cat_codes = {}
local function get_light_category_id(cat)
	-- If the category id does not already exist generate a new  one
	if not cat_codes[cat] then
		if cat_id >= 256 then
			error("Wielded item category limit exceeded, maximum 256 wield categories")
		end
		local code = string.format("%02x", cat_id)
		cat_id = cat_id+1
		cat_codes[cat] = code
	end
	-- If the category id does exist, return it
	return cat_codes[cat]
end

-- Log an error coming from this mod
local function error_log(message, ...)
	minetest.log("error", "[Wielded Light] " .. (message:format(...)))
end

-- Is a node lightable and a liquid capable of flooding some light sources
local function is_lightable_liquid(pos)
	local node = minetest.get_node_or_nil(pos)
	if not node then return end
	return lightable_liquids[node.name]
end

-- Check if an entity instance still exists in the world
local function is_entity_valid(entity)
	return entity and (entity.obj:is_player() or (entity.obj:get_luaentity() and entity.obj:get_luaentity().name) or false)
end

-- Check whether a node was registered by the wield_light mod
local function is_wieldlight_node(pos_vec)
	local name = string.sub(minetest.get_node(pos_vec).name, 1, #mod_name)
	return name == mod_name
end

-- Get the projected position of an entity based on its velocity, rounded to the nearest block
local function entity_pos(obj, offset)
	local velocity = obj:get_velocity()
	return wielded_light.get_light_position(
		vector.round(
			vector.add(
				vector.add(
					offset or { x=0, y=0, z=0 },
					obj:get_pos()
				),
				vector.multiply(
					velocity or { x=0, y=0, z=0 },
					velocity_projection
				)
			)
		)
	)
end

-- Add light to active light list and mark position for update
local function add_light(pos, id, light_level)
	if not active_lights[pos] then
		active_lights[pos] = {}
	end
	if active_lights[pos][id] ~= light_level then
		-- minetest.log("error", "add "..id.." "..pos.." "..tostring(light_level))
		active_lights[pos][id] = light_level
		light_recalcs[pos] = true
	end
end

-- Remove light from active light list and mark position for update
local function remove_light(pos, id)
	if not active_lights[pos] then return end
	-- minetest.log("error", "rem "..id.." "..pos)
	active_lights[pos][id] = nil
	minetest.after(removal_delay, function ()
		light_recalcs[pos] = true
	end)
end

-- Track an entity's position and update its light, will be called on every update step
local function update_entity(entity)
	local pos = entity_pos(entity.obj, entity.offset)
	local pos_str = pos and minetest.pos_to_string(pos)

	-- If the position has changed, remove the old light and mark the entity for update
	if entity.pos and pos_str ~= entity.pos then
		entity.update = true
		for id,_ in pairs(entity.items) do
			remove_light(entity.pos, id)
		end
	end

	-- Update the recorded position
	entity.pos = pos_str

	-- If the position is still loaded, pump the timer up so it doesn't get removed
	if pos then
		-- If the entity is marked for an update, add the light in the position if it emits light
		if entity.update then
			for id, item in pairs(entity.items) do
				if item.level > 0 and not (item.floodable and is_lightable_liquid(pos)) then
					add_light(pos_str, id, item.level)
				else
					remove_light(pos_str, id)
				end
			end
		end
	end
	if active_lights[pos_str] then
		if is_wieldlight_node(pos) then
			minetest.get_node_timer(pos):start(cleanup_interval)
		end
	end
	entity.update = false
end


-- Save the original nodes timer if it has one
local function save_timer(pos_vec)
	local timer = minetest.get_node_timer(pos_vec)
	if timer:is_started() then
		local meta = minetest.get_meta(pos_vec)
		meta:set_float("saved_timer_timeout", timer:get_timeout())
		meta:set_float("saved_timer_elapsed", timer:get_elapsed())
	end
end

-- Restore the original nodes timer if it had one
local function restore_timer(pos_vec)
	local meta = minetest.get_meta(pos_vec)
	local timeout = meta:get_float("saved_timer_timeout")
	if timeout > 0 then
		local elapsed = meta:get_float("saved_timer_elapsed")
		local timer = minetest.get_node_timer(pos_vec)
		timer:set(timeout, elapsed)
		meta:set_string("saved_timer_timeout","")
		meta:set_string("saved_timer_elapsed","")
	end
end

-- Replace a lighting node with its original counterpart
local function reset_lighting_node(pos)
	local existing_node = minetest.get_node(pos)
	local lighting_node = wielded_light.get_lighting_node(existing_node.name)
	if not lighting_node then
		return
	end
	minetest.swap_node(pos, { name = lighting_node.node,param2 = existing_node.param2 })
	restore_timer(pos)
end

-- Will be run once the node timer expires
local function cleanup_timer_callback(pos, elapsed)
	local pos_str = minetest.pos_to_string(pos)
	local lights = active_lights[pos_str]
	-- If no active lights for this position, remove itself
	if not lights then
		reset_lighting_node(pos)
	else
	-- Clean up any tracked entities for this position that no longer exist
		for id,_ in pairs(lights) do
			local uid = string.sub(id,3)
			local entity = tracked_entities[uid]
			if not is_entity_valid(entity) then
				remove_light(pos_str, id)
			end
		end
		minetest.get_node_timer(pos):start(cleanup_interval)
	end
end


-- Recalculate the total light level for a given position and update the light level there
local function recalc_light(pos)
	-- If not in active lights list we can't do anything
	if not active_lights[pos] then return end

	-- Calculate the light level of the node
	local any_light = false
	local max_light = 0
	for id, light_level in pairs(active_lights[pos]) do
		any_light = true
		if light_level > max_light then
			max_light = light_level
		end
	end

	-- Convert the position back to a vector
	local pos_vec = minetest.string_to_pos(pos)

	-- If no items in this position, delete it from the list and remove any light node
	if not any_light then
		active_lights[pos] = nil
		reset_lighting_node(pos_vec)
		return
	end

	-- If no light in this position remove any light node
	if max_light == 0 then
		reset_lighting_node(pos_vec)
		return
	end

	-- Limit the light level
	max_light = math.min(max_light, minetest.LIGHT_MAX)

	-- Get the current light level in this position
	local existing_node = minetest.get_node(pos_vec)
	local name = existing_node.name
	local old_value = wielded_light.level_of_lighting_node(name) or 0

	-- If the light level has changed, set the coresponding light node and initiate the cleanup timer
	if old_value ~= max_light then
		local node_name
		if lightable_nodes[name] then
			node_name = name
		elseif lighting_nodes[name] then
			node_name = lighting_nodes[name].node
		end
		if node_name then
			if not is_wieldlight_node(pos_vec) then
				save_timer(pos_vec)
			end

			minetest.swap_node(pos_vec, {
				name = lightable_nodes[node_name][max_light],
				param2 = existing_node.param2
			})
			minetest.get_node_timer(pos_vec):start(cleanup_interval)
		else
			active_lights[pos] = nil
		end
	end
end

local timer = 0
-- Will be run on every global step
local function global_timer_callback(dtime)
	-- Only run once per update interval, global step will be called much more often than that
	timer = timer + dtime;
	if timer < update_interval then
		return
	end
	timer = 0

	-- Run all custom player callbacks for each player
	local connected_players = minetest.get_connected_players()
	for _,callback in pairs(update_player_callbacks) do
		for _, player in pairs(connected_players) do
			callback(player)
		end
	end

	-- Run all custom callbacks
	for _,callback in pairs(update_callbacks) do
		callback()
	end

	-- Look at each tracked entity and update its position
	for uid, entity in pairs(tracked_entities) do
		if is_entity_valid(entity) then
			update_entity(entity)
		else
			-- If the entity no longer exists, stop tracking it
			tracked_entities[uid] = nil
		end
	end

	-- Recalculate light levels
	for pos,_ in pairs(light_recalcs) do
		recalc_light(pos)
	end
	light_recalcs = {}
end

--- Shining API ---
wielded_light = {}

-- Registers a callback to be called every time the update interval is passed
function wielded_light.register_lightstep(callback)
	table.insert(update_callbacks, callback)
end

-- Registers a callback to be called for each player every time the update interval is passed
function wielded_light.register_player_lightstep(callback)
	table.insert(update_player_callbacks, callback)
end

-- Returns the node name for a given light level
function wielded_light.lighting_node_of_level(light_level, prefix)
	return mod_name..":"..(prefix or "")..light_level
end

-- Gets the light level for a given node name, inverse of lighting_node_of_level
function wielded_light.level_of_lighting_node(node_name)
	local lighting_node = wielded_light.get_lighting_node(node_name)
	if lighting_node then
		return lighting_node.level
	end
end

-- Check if a node name is one of the wielded light nodes
function wielded_light.get_lighting_node(node_name)
	return lighting_nodes[node_name]
end

-- Register any node as lightable, register all light level variations for it
function wielded_light.register_lightable_node(node_name, property_overrides, custom_prefix)
	-- Node name must be string
	if type(node_name) ~= "string" then
		error_log("You must provide a node name to be registered as lightable, '%s' given.", type(node_name))
		return
	end

	-- Node must already be registered
	local original_definition = minetest.registered_nodes[node_name]
	if not original_definition then
		error_log("The node '%s' cannot be registered as lightable because it does not exist.", node_name)
		return
	end

	-- Decide the prefix for the lighting node
	local prefix = custom_prefix or node_name:gsub(":", "_", 1, true) .. "_"
	if lighting_prefixes[prefix] then
		error_log("The lighting prefix '%s' cannot be used for '%s' as it is already used for '%s'.", prefix, node_name, lighting_prefixes[prefix])
		return
	end
	lighting_prefixes[prefix] = node_name

	-- Default for property overrides
	if not property_overrides then property_overrides = {} end

	-- Copy the node definition and provide required settings for a lighting node
	local new_definition = table.copy(original_definition)
	new_definition.on_timer = cleanup_timer_callback
	new_definition.paramtype = "light"
	new_definition.mod_origin = mod_name
	new_definition.groups = new_definition.groups or {}
	new_definition.groups.not_in_creative_inventory = 1
	-- Make sure original node is dropped if a lit node is dug
	if not new_definition.drop then
		new_definition.drop = node_name
	end

	-- Allow any properties to be overridden on registration
	for prop, val in pairs(property_overrides) do
		new_definition[prop] = val
	end

	-- If it's a liquid, we need to stop it flowing
	if new_definition.groups.liquid then
		new_definition.liquid_range = 0
		lightable_liquids[node_name] = true
	end

	-- Register the lighting nodes
	lightable_nodes[node_name] = {}
	for i=1, minetest.LIGHT_MAX do
		local lighting_node_name = wielded_light.lighting_node_of_level(i, prefix)

		-- Index for quick finding later
		lightable_nodes[node_name][i] = lighting_node_name
		lighting_nodes[lighting_node_name] = {
			node = node_name,
			level = i
		}

		-- Copy the base definition and apply the light level
		local level_definition = table.copy(new_definition)
		level_definition.light_source = i

		-- If it's a liquid, we need to stop it replacing itself with the original
		if level_definition.groups.liquid then
			level_definition.liquid_alternative_source = lighting_node_name
			level_definition.liquid_alternative_flowing = lighting_node_name
		end

		minetest.register_node(":"..lighting_node_name, level_definition)
	end
end

-- Check if node can have a wielded light node placed in it
function wielded_light.is_lightable_node(node_pos)
	local name = minetest.get_node(node_pos).name
	if lightable_nodes[name] then
		return true
	elseif wielded_light.get_lighting_node(name) then
		return true
	end
	return false
end

-- Gets the closest position to pos that's a lightable node
function wielded_light.get_light_position(pos)
	local around_vector = {
		{x=0, y=0, z=0},
		{x=0, y=1, z=0}, {x=0, y=-1, z=0},
		{x=1, y=0, z=0}, {x=-1, y=0, z=0},
		{x=0, y=0, z=1}, {x=0, y=0, z=-1},
	}
	for _, around in ipairs(around_vector) do
		local light_pos = vector.add(pos, around)
		if wielded_light.is_lightable_node(light_pos) then
			return light_pos
		end
	end
end

-- Gets the emitted light level of a given item name
function wielded_light.get_light_def(item_name)
	-- Invalid item? No light
	if not item_name or item_name == "" then
		return 0, false
	end

	-- If the item is cached return the cached level
	local cached_definition = shiny_items[item_name]
	if cached_definition then
		return cached_definition.level, cached_definition.floodable
	end

	-- Get the item definition
	local stack = ItemStack(item_name)
	local itemdef = stack:get_definition()

	-- If invalid, no light
	if not itemdef then
		return 0, false
	end

	-- Get the light level of an item from its definition
	-- Reduce the light level by level_delta - original functionality
	-- Limit between 0 and the max light level
	return math.min(math.max((itemdef.light_source or 0) - level_delta, 0), minetest.LIGHT_MAX), itemdef.floodable
end

-- Register an item as shining
function wielded_light.register_item_light(item_name, light_level, floodable)
	if shiny_items[item_name] then
		if light_level then
			shiny_items[item_name].level = light_level
		end
		if floodable ~= nil then
			shiny_items[item_name].floodable = floodable
		end
	else
		if floodable == nil then
			local stack = ItemStack(item_name)
			local itemdef = stack:get_definition()
			floodable = itemdef.floodable
		end
		shiny_items[item_name] = {
			level = light_level,
			floodable = floodable or false
		}
	end
end

-- Mark an item as floodable or not
function wielded_light.register_item_floodable(item_name, floodable)
	if floodable == nil then floodable = true end
	if shiny_items[item_name] then
		shiny_items[item_name].floodable = floodable
	else
		local calced_level = wielded_light.get_light_def(item_name)
		shiny_items[item_name] = {
			level = calced_level,
			floodable = floodable
		}
	end
end

-- Keep track of an item entity. Should be called once for an item
function wielded_light.track_item_entity(obj, cat, item)
	if not is_entity_valid({ obj=obj }) then return end

	local light_level, light_is_floodable = wielded_light.get_light_def(item)
	-- If the item does not emit light do not track it
	if light_level <= 0 then return end

	-- Generate the uid for the item and the id for the light category
	local uid = tostring(obj)
	local id = get_light_category_id(cat)..uid

	-- Create the main tracking object for this item instance if it does not already exist
	if not tracked_entities[uid] then
		tracked_entities[uid] = { obj=obj, items={}, update = true }
	end

	-- Create the item tracking object for this item + category
	tracked_entities[uid].items[id] = { level=light_level, floodable=light_is_floodable }

	-- Add the light in on creation so it's immediate
	local pos = entity_pos(obj)
	local pos_str = pos and minetest.pos_to_string(pos)
	if pos_str then
		if not (light_is_floodable and is_lightable_liquid(pos)) then
			add_light(pos_str, id, light_level)
		end
	end
	tracked_entities[uid].pos = pos_str
end

-- A player's light should appear near their head not their feet
local player_height_offset = { x=0, y=1, z=0 }

-- Keep track of a user / player entity. Should be called as often as the user updates
function wielded_light.track_user_entity(obj, cat, item)
	-- Generate the uid for the player and the id for the light category
	local uid = tostring(obj)
	local id = get_light_category_id(cat)..uid

	-- Create the main tracking object for this player instance if it does not already exist
	if not tracked_entities[uid] then
		tracked_entities[uid] = { obj=obj, items={}, offset = player_height_offset, update = true }
	end

	local tracked_entity = tracked_entities[uid]
	local tracked_item = tracked_entity.items[id]

	-- If the item being tracked for the player changes, update the item tracking object for this item + category
	if not tracked_item or tracked_item.item ~= item then
		local light_level, light_is_floodable = wielded_light.get_light_def(item)
		tracked_entity.items[id] = { level=light_level, item=item, floodable=light_is_floodable }
		tracked_entity.update = true
	end
end


-- Setup --

-- Wielded item shining globalstep
minetest.register_globalstep(global_timer_callback)

-- Dropped item on_step override
-- https://github.com/minetest/minetest/issues/6909
local builtin_item = minetest.registered_entities["__builtin:item"]
local item = {
	on_step = function(self, dtime, ...)
		builtin_item.on_step(self, dtime, ...)
		-- Register an item once for tracking
		-- If it's already being tracked, exit
		if self.wielded_light then return end
		self.wielded_light = true
		local stack = ItemStack(self.itemstring)
		local item_name = stack:get_name()
		wielded_light.track_item_entity(self.object, "item", item_name)
	end
}
setmetatable(item, {__index = builtin_item})
minetest.register_entity(":__builtin:item", item)

-- Track a player's wielded item
wielded_light.register_player_lightstep(function (player)
	wielded_light.track_user_entity(player, "wield", player:get_wielded_item():get_name())
end)

-- Register helper nodes
local water_name = "default:water_source"
if minetest.get_modpath("hades_core") then
	water_name = "hades_core:water_source"
end

wielded_light.register_lightable_node("air", nil, "")
wielded_light.register_lightable_node(water_name, nil, "water_")
wielded_light.register_lightable_node("default:river_water_source", nil, "river_water_")

---TEST
--wielded_light.register_item_light('default:dirt', 14)

--do mesecraft's nodes
dofile(minetest.get_modpath("wielded_light").."/mesecraft.lua")
