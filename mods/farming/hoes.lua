
local S = farming.intllib
local tr = minetest.get_modpath("toolranks")

-- Hoe registration function

farming.register_hoe = function(name, def)

	-- Check for : prefix (register new hoes in your mod's namespace)
	if name:sub(1,1) ~= ":" then
		name = ":" .. name
	end

	-- Check def table
	if def.description == nil then
		def.description = S("Hoe")
	end

	if def.inventory_image == nil then
		def.inventory_image = "unknown_item.png"
	end

	if def.max_uses == nil then
		def.max_uses = 30
	end

	-- add hoe group
	def.groups = def.groups or {}
	def.groups.hoe = 1

	-- Register the tool
	minetest.register_tool(name, {
		description = def.description,
		inventory_image = def.inventory_image,
		on_use = function(itemstack, user, pointed_thing)
			return farming.hoe_on_use(itemstack, user, pointed_thing, def.max_uses)
		end,
		groups = def.groups,
		sound = {breaks = "default_tool_breaks"},
	})

	-- Register its recipe
	if def.recipe then
		minetest.register_craft({
			output = name:sub(2),
			recipe = def.recipe
		})
	elseif def.material then
		minetest.register_craft({
			output = name:sub(2),
			recipe = {
				{def.material, def.material, ""},
				{"", "group:stick", ""},
				{"", "group:stick", ""}
			}
		})
	end
end

-- Turns dirt with group soil=1 into soil

function farming.hoe_on_use(itemstack, user, pointed_thing, uses)

	local pt = pointed_thing

	-- check if pointing at a node
	if not pt or pt.type ~= "node" then
		return
	end

	local under = minetest.get_node(pt.under)
	local upos = pointed_thing.under

	if minetest.is_protected(upos, user:get_player_name()) then
		minetest.record_protection_violation(upos, user:get_player_name())
		return
	end

	local p = {x = pt.under.x, y = pt.under.y + 1, z = pt.under.z}
	local above = minetest.get_node(p)

	-- return if any of the nodes is not registered
	if not minetest.registered_nodes[under.name]
	or not minetest.registered_nodes[above.name] then
		return
	end

	-- check if the node above the pointed thing is air
	if above.name ~= "air" then
		return
	end

	-- check if pointing at dirt
	if minetest.get_item_group(under.name, "soil") ~= 1 then
		return
	end

	-- turn the node into soil, wear out item and play sound
	minetest.set_node(pt.under, {name = "farming:soil"})

	minetest.sound_play("default_dig_crumbly", {pos = pt.under, gain = 0.5})

	local wear = 65535 / (uses -1)

	if farming.is_creative(user:get_player_name()) then
		if tr then
			wear = 1
		else
			wear = 0
		end
	end

	if tr then
		itemstack = toolranks.new_afteruse(itemstack, user, under, {wear = wear})
	else
		itemstack:add_wear(wear)
	end

	return itemstack
end

-- Define Hoes

farming.register_hoe(":farming:hoe_wood", {
	description = S("Wooden Hoe"),
	inventory_image = "farming_tool_woodhoe.png",
	max_uses = 30,
	material = "group:wood"
})

minetest.register_craft({
	type = "fuel",
	recipe = "farming:hoe_wood",
	burntime = 5,
})

farming.register_hoe(":farming:hoe_stone", {
	description = S("Stone Hoe"),
	inventory_image = "farming_tool_stonehoe.png",
	max_uses = 90,
	material = "group:stone"
})

farming.register_hoe(":farming:hoe_steel", {
	description = S("Steel Hoe"),
	inventory_image = "farming_tool_steelhoe.png",
	max_uses = 200,
	material = "default:steel_ingot"
})

farming.register_hoe(":farming:hoe_bronze", {
	description = S("Bronze Hoe"),
	inventory_image = "farming_tool_bronzehoe.png",
	max_uses = 500,
	groups = {not_in_creative_inventory = 1},
})

farming.register_hoe(":farming:hoe_mese", {
	description = S("Mese Hoe"),
	inventory_image = "farming_tool_mesehoe.png",
	max_uses = 350,
	groups = {not_in_creative_inventory = 1},
})

farming.register_hoe(":farming:hoe_diamond", {
	description = S("Diamond Hoe"),
	inventory_image = "farming_tool_diamondhoe.png",
	max_uses = 500,
	groups = {not_in_creative_inventory = 1},
})

-- Toolranks support
if tr then

minetest.override_item("farming:hoe_wood", {
	original_description = "Wood Hoe",
	description = toolranks.create_description("Wood Hoe")})

minetest.override_item("farming:hoe_stone", {
	original_description = "Stone Hoe",
	description = toolranks.create_description("Stone Hoe")})

minetest.override_item("farming:hoe_steel", {
	original_description = "Steel Hoe",
	description = toolranks.create_description("Steel Hoe")})

minetest.override_item("farming:hoe_bronze", {
	original_description = "Bronze Hoe",
	description = toolranks.create_description("Bronze Hoe")})

minetest.override_item("farming:hoe_mese", {
	original_description = "Mese Hoe",
	description = toolranks.create_description("Mese Hoe")})

minetest.override_item("farming:hoe_diamond", {
	original_description = "Diamond Hoe",
	description = toolranks.create_description("Diamond Hoe")})
end


-- hoe bomb function
local function hoe_area(pos, player)

	-- check for protection
	if minetest.is_protected(pos, player:get_player_name()) then
		minetest.record_protection_violation(pos, player:get_player_name())
		return
	end

	local r = 5 -- radius

	-- remove flora (grass, flowers etc.)
	local res = minetest.find_nodes_in_area(
		{x = pos.x - r, y = pos.y - 1, z = pos.z - r},
		{x = pos.x + r, y = pos.y + 2, z = pos.z + r},
		{"group:flora"})

	for n = 1, #res do
		minetest.swap_node(res[n], {name = "air"})
	end

	-- replace dirt with tilled soil
	res = nil
	res = minetest.find_nodes_in_area_under_air(
		{x = pos.x - r, y = pos.y - 1, z = pos.z - r},
		{x = pos.x + r, y = pos.y + 2, z = pos.z + r},
		{"group:soil"})

	for n = 1, #res do
		minetest.swap_node(res[n], {name = "farming:soil"})
	end
end


-- throwable hoe bomb
minetest.register_entity("farming:hoebomb_entity", {
	physical = true,
	visual = "sprite",
	visual_size = {x = 1.0, y = 1.0},
	textures = {"farming_hoe_bomb.png"},
	collisionbox = {0,0,0,0,0,0},
	lastpos = {},
	player = "",

	on_step = function(self, dtime)

		if not self.player then

			self.object:remove()

			return
		end

		local pos = self.object:get_pos()

		if self.lastpos.x ~= nil then

			local vel = self.object:getvelocity()

			-- only when potion hits something physical
			if vel.x == 0
			or vel.y == 0
			or vel.z == 0 then

				if self.player ~= "" then

					-- round up coords to fix glitching through doors
					self.lastpos = vector.round(self.lastpos)

					hoe_area(self.lastpos, self.player)
				end

				self.object:remove()

				return

			end
		end

		self.lastpos = pos
	end
})


-- actual throwing function
local function throw_potion(itemstack, player)

	local playerpos = player:get_pos()

	local obj = minetest.add_entity({
		x = playerpos.x,
		y = playerpos.y + 1.5,
		z = playerpos.z
	}, "farming:hoebomb_entity")

	local dir = player:get_look_dir()
	local velocity = 20

	obj:setvelocity({
		x = dir.x * velocity,
		y = dir.y * velocity,
		z = dir.z * velocity
	})

	obj:setacceleration({
		x = dir.x * -3,
		y = -9.5,
		z = dir.z * -3
	})

	obj:setyaw(player:get_look_yaw() + math.pi)
	obj:get_luaentity().player = player
end


-- hoe bomb item
minetest.register_craftitem("farming:hoe_bomb", {
	description = S("Hoe Bomb (use or throw on grassy areas to hoe land"),
	inventory_image = "farming_hoe_bomb.png",
	groups = {flammable = 2, not_in_creative_inventory = 1},
	on_use = function(itemstack, user, pointed_thing)

		if pointed_thing.type == "node" then
			hoe_area(pointed_thing.above, user)
		else
			throw_potion(itemstack, user)

			if not farming.is_creative(user:get_player_name()) then

				itemstack:take_item()

				return itemstack
			end
		end
	end,
})

	farming.register_hoe(":moreores:hoe_silver", {
		description = S("%s Hoe"):format(S("Silver")),
		inventory_image = "moreores_tool_silverhoe.png",
		max_uses = 300,
		material = "moreores:silver_ingot",
	})

	farming.register_hoe(":moreores:hoe_mithril", {
		description = S("%s Hoe"):format(S("Mithril")),
		inventory_image = "moreores_tool_mithrilhoe.png",
		max_uses = 1000,
		material = "moreores:mithril_ingot",
	})

	-- Toolranks support
	if tr then

		minetest.override_item("moreores:hoe_silver", {
			original_description = S("%s Hoe"):format(S("Silver")),
			description = toolranks.create_description("Silver Hoe")})

		minetest.override_item("moreores:hoe_mithril", {
			original_description = S("%s Hoe"):format(S("Mithril")),
			description = toolranks.create_description("Mithril Hoe")})
	end
