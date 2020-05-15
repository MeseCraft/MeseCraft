--[[
Minetest Mod Storage Drawers - A Mod adding storage drawers

Copyright (C) 2017-2019 Linus Jahn <lnj@kaidan.im>

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

-- Load support for intllib.
local MP = core.get_modpath(core.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

core.register_entity("drawers:visual", {
	initial_properties = {
		hp_max = 1,
		physical = false,
		collide_with_objects = false,
		collisionbox = {-0.4374, -0.4374, 0,  0.4374, 0.4374, 0}, -- for param2 0, 2
		visual = "upright_sprite", -- "wielditem" for items without inv img?
		visual_size = {x = 0.6, y = 0.6},
		textures = {"blank.png"},
		spritediv = {x = 1, y = 1},
		initial_sprite_basepos = {x = 0, y = 0},
		is_visible = true,
	},

	get_staticdata = function(self)
		return core.serialize({
			drawer_posx = self.drawer_pos.x,
			drawer_posy = self.drawer_pos.y,
			drawer_posz = self.drawer_pos.z,
			texture = self.texture,
			drawerType = self.drawerType,
			visualId = self.visualId
		})
	end,

	on_activate = function(self, staticdata, dtime_s)
		-- Restore data
		local data = core.deserialize(staticdata)
		if data then
			self.drawer_pos = {
				x = data.drawer_posx,
				y = data.drawer_posy,
				z = data.drawer_posz,
			}
			self.texture = data.texture
			self.drawerType = data.drawerType or 1
			self.visualId = data.visualId or ""

			-- backwards compatibility
			if self.texture == "drawers_empty.png" then
				self.texture = "blank.png"
			end
		else
			self.drawer_pos = drawers.last_drawer_pos
			self.texture = drawers.last_texture or "blank.png"
			self.visualId = drawers.last_visual_id
			self.drawerType = drawers.last_drawer_type
		end

		local node = minetest.get_node(self.object:get_pos())
		if not node.name:match("^drawers:") then
			self.object:remove()
			return
		end

		-- add self to public drawer visuals
		-- this is needed because there is no other way to get this class
		-- only the underlying LuaEntitySAO
		-- PLEASE contact me, if this is wrong
		local vId = self.visualId
		if vId == "" then vId = 1 end
		local posstr = core.serialize(self.drawer_pos)
		if not drawers.drawer_visuals[posstr] then
			drawers.drawer_visuals[posstr] = {[vId] = self}
		else
			drawers.drawer_visuals[posstr][vId] = self
		end

		-- get meta
		self.meta = core.get_meta(self.drawer_pos)

		-- collisionbox
		local node = core.get_node(self.drawer_pos)
		local colbox
		if self.drawerType ~= 2 then
			if node.param2 == 1 or node.param2 == 3 then
				colbox = {0, -0.4374, -0.4374,  0, 0.4374, 0.4374}
			else
				colbox = {-0.4374, -0.4374, 0,  0.4374, 0.4374, 0} -- for param2 = 0 or 2
			end
			-- only half the size if it's a small drawer
			if self.drawerType > 1 then
				for i,j in pairs(colbox) do
					colbox[i] = j * 0.5
				end
			end
		else
			if node.param2 == 1 or node.param2 == 3 then
				colbox = {0, -0.2187, -0.4374,  0, 0.2187, 0.4374}
			else
				colbox = {-0.4374, -0.2187, 0,  0.4374, 0.2187, 0} -- for param2 = 0 or 2
			end
		end

		-- visual size
		local visual_size = {x = 0.6, y = 0.6}
		if self.drawerType >= 2 then
			visual_size = {x = 0.3, y = 0.3}
		end


		-- drawer values
		local vid = self.visualId
		self.count = self.meta:get_int("count"..vid)
		self.itemName = self.meta:get_string("name"..vid)
		self.maxCount = self.meta:get_int("max_count"..vid)
		self.itemStackMax = self.meta:get_int("base_stack_max"..vid)
		self.stackMaxFactor = self.meta:get_int("stack_max_factor"..vid)


		-- infotext
		local infotext = self.meta:get_string("entity_infotext"..vid) .. "\n\n\n\n\n"

		self.object:set_properties({
			collisionbox = colbox,
			infotext = infotext,
			textures = {self.texture},
			visual_size = visual_size
		})

		-- make entity undestroyable
		self.object:set_armor_groups({immortal = 1})
	end,

	on_rightclick = function(self, clicker)
		if core.is_protected(self.drawer_pos, clicker:get_player_name()) then
			core.record_protection_violation(self.drawer_pos, clicker:get_player_name())
			return
		end

		-- used to check if we need to play a sound in the end
		local inventoryChanged = false

		-- When the player uses the drawer with their bare hand all
		-- stacks from the inventory will be added to the drawer.
		if self.itemName ~= "" and
		   clicker:get_wielded_item():get_name() == "" and
		   not clicker:get_player_control().sneak then
			-- try to insert all items from inventory
			local i = 0
			local inv = clicker:get_inventory()

			while i < inv:get_size("main") do
				-- set current stack to leftover of insertion
				local leftover = self.try_insert_stack(
					self,
					inv:get_stack("main", i),
					true
				)

				-- check if something was added
				if leftover:get_count() < inv:get_stack("main", i):get_count() then
					inventoryChanged = true
				end

				-- set new stack
				inv:set_stack("main", i, leftover)
				i = i + 1
			end
		else
			-- try to insert wielded item only
			local leftover = self.try_insert_stack(
				self,
				clicker:get_wielded_item(),
				not clicker:get_player_control().sneak
			)

			-- check if something was added
			if clicker:get_wielded_item():get_count() > leftover:get_count() then
				inventoryChanged = true
			end
			-- set the leftover as new wielded item for the player
			clicker:set_wielded_item(leftover)
		end

		if inventoryChanged then
			self:play_interact_sound()
		end
	end,

	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		local node = minetest.get_node(self.object:get_pos())
		if not node.name:match("^drawers:") then
			self.object:remove()
			return
		end
		local add_stack = not puncher:get_player_control().sneak
		if core.is_protected(self.drawer_pos, puncher:get_player_name()) then
		   core.record_protection_violation(self.drawer_pos, puncher:get_player_name())
		   return
		end
		local inv = puncher:get_inventory()
		if inv == nil then
			return	
		end
		local spaceChecker = ItemStack(self.itemName)
		if add_stack then
			spaceChecker:set_count(spaceChecker:get_stack_max())
		end
		if not inv:room_for_item("main", spaceChecker) then
			return
		end

		stack = self:take_items(add_stack)
		if stack ~= nil then
			-- add removed stack to player's inventory
			inv:add_item("main", stack)

			-- play the interact sound
			self:play_interact_sound()
		end
	end,

	take_items = function(self, take_stack)
		local meta = core.get_meta(self.drawer_pos)

		if self.count <= 0 then
			return
		end

		local removeCount = 1
		if take_stack then
			removeCount = ItemStack(self.itemName):get_stack_max()
		end
		if removeCount > self.count then
			removeCount = self.count
		end

		local stack = ItemStack(self.itemName)
		stack:set_count(removeCount)

		-- update the drawer count
		self.count = self.count - removeCount

		self:updateInfotext()
		self:updateTexture()
		self:saveMetaData()

		-- return the stack that was removed from the drawer
		return stack
	end,

	try_insert_stack = function(self, itemstack, insert_stack)
		local stackCount = itemstack:get_count()
		local stackName = itemstack:get_name()

		-- if nothing to be added, return
		if stackCount <= 0 then return itemstack end
		-- if no itemstring, return
		if stackName == "" then return itemstack end

		-- only add one, if player holding sneak key
		if not insert_stack then
			stackCount = 1
		end

		-- if current itemstring is not empty
		if self.itemName ~= "" then
			-- check if same item
			if stackName ~= self.itemName then return itemstack end
		else -- is empty
			self.itemName = stackName
			self.count = 0

			-- get new stack max
			self.itemStackMax = ItemStack(self.itemName):get_stack_max()
			self.maxCount = self.itemStackMax * self.stackMaxFactor
		end

		-- Don't add items stackable only to 1
		if self.itemStackMax == 1 then
			self.itemName = ""
			return itemstack
		end

		-- set new counts:
		-- if new count is more than max_count
		if (self.count + stackCount) > self.maxCount then
			itemstack:set_count(self.count + stackCount - self.maxCount)
			self.count = self.maxCount
		else -- new count fits
			self.count = self.count + stackCount
			-- this is for only removing one
			itemstack:set_count(itemstack:get_count() - stackCount)
		end

		-- update infotext, texture
		self:updateInfotext()
		self:updateTexture()

		self:saveMetaData()

		if itemstack:get_count() == 0 then itemstack = ItemStack("") end
		return itemstack
	end,

	updateInfotext = function(self)
		local itemDescription = ""
		if core.registered_items[self.itemName] then
			itemDescription = core.registered_items[self.itemName].description
		end

		if self.count <= 0 then
			self.itemName = ""
			self.meta:set_string("name"..self.visualId, self.itemName)
			self.texture = "blank.png"
			itemDescription = S("Empty")
		end

		local infotext = drawers.gen_info_text(itemDescription,
			self.count, self.stackMaxFactor, self.itemStackMax)
		self.meta:set_string("entity_infotext"..self.visualId, infotext)

		self.object:set_properties({
			infotext = infotext .. "\n\n\n\n\n"
		})
	end,

	updateTexture = function(self)
		-- texture
		self.texture = drawers.get_inv_image(self.itemName)

		self.object:set_properties({
			textures = {self.texture}
		})
	end,

	dropStack = function(self, itemStack)
		-- print warning if dropping higher stack counts than allowed
		if itemStack:get_count() > itemStack:get_stack_max() then
			core.log("warning", "[drawers] Dropping item stack with higher count than allowed")
		end
		-- find a position containing air
		local dropPos = core.find_node_near(self.drawer_pos, 1, {"air"}, false)
		-- if no pos found then drop on the top of the drawer
		if not dropPos then
			dropPos = self.pos
			dropPos.y = dropPos.y + 1
		end
		-- drop the item stack
		core.item_drop(itemStack, nil, dropPos)
	end,

	dropItemOverload = function(self)
		-- drop stacks until there are no more items than allowed
		while self.count > self.maxCount do
			-- remove the overflow
			local removeCount = self.count - self.maxCount
			-- if this is too much for a single stack, only take the
			-- stack limit
			if removeCount > self.itemStackMax then
				removeCount = self.itemStackMax
			end
			-- remove this count from the drawer
			self.count = self.count - removeCount
			-- create a new item stack having the size of the remove
			-- count
			local stack = ItemStack(self.itemName)
			stack:set_count(removeCount)
			print(stack:to_string())
			-- drop the stack
			self:dropStack(stack)
		end
	end,

	setStackMaxFactor = function(self, stackMaxFactor)
		self.stackMaxFactor = stackMaxFactor
		self.maxCount = self.stackMaxFactor * self.itemStackMax

		-- will drop possible overflowing items
		self:dropItemOverload()
		self:updateInfotext()
		self:saveMetaData()
	end,

	play_interact_sound = function(self)
		core.sound_play("drawers_interact", {
			pos = self.object:get_pos(),
			max_hear_distance = 6,
			gain = 2.0
		})
	end,

	saveMetaData = function(self, meta)
		self.meta:set_int("count"..self.visualId, self.count)
		self.meta:set_string("name"..self.visualId, self.itemName)
		self.meta:set_int("max_count"..self.visualId, self.maxCount)
		self.meta:set_int("base_stack_max"..self.visualId, self.itemStackMax)
		self.meta:set_int("stack_max_factor"..self.visualId, self.stackMaxFactor)
	end
})

core.register_lbm({
	name = "drawers:restore_visual",
	nodenames = {"group:drawer"},
	run_at_every_load = true,
	action  = function(pos, node)
		local meta = core.get_meta(pos)
		-- create drawer upgrade inventory
		meta:get_inventory():set_size("upgrades", 5)
		-- set the formspec
		meta:set_string("formspec", drawers.drawer_formspec)

		-- count the drawer visuals
		local drawerType = core.registered_nodes[node.name].groups.drawer
		local foundVisuals = 0
		local objs = core.get_objects_inside_radius(pos, 0.54)
		if objs then
			for _, obj in pairs(objs) do
				if obj and obj:get_luaentity() and
						obj:get_luaentity().name == "drawers:visual" then
					foundVisuals = foundVisuals + 1
				end
			end
		end
		-- if all drawer visuals were found, return
		if foundVisuals == drawerType then
			return
		end

		-- not enough visuals found, remove existing and create new ones
		drawers.remove_visuals(pos)
		drawers.spawn_visuals(pos)
	end
})
