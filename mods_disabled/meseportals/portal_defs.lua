function meseportals.swap_portal_node(pos,name,dir)
	local node = core.get_node(pos)
	local meta = core.get_meta(pos)
	meta:set_string("dont_destroy","true")
	local meta0 = meta:to_table()
	node.name = name
	node.param2=dir
	core.set_node(pos,{name=name, param2=dir})
	meta:from_table(meta0)
	meta:set_string("dont_destroy","false")
end

minetest.register_node("meseportals:portal_collider",{
	drawtype = "airlike",
	on_blast = function() end,
	drop = "",
	groups = {not_in_creative_inventory=1,immovable=2},
	sunlight_propagates = true,
	can_dig = false,
	paramtype = "light",
	selection_box = {
	type = "fixed",
	fixed={0.0,0.0,0.0,0.0,0.0,0.0}},
})


function placeportalCollider(pos, pos1, player)
	local placed = false
	if minetest.check_player_privs(player, {protection_bypass=true}) or not minetest.is_protected(pos, player:get_player_name()) then
		if minetest.registered_nodes[minetest.get_node(pos).name] then
			if minetest.get_node(pos).name == "air" or minetest.registered_nodes[minetest.get_node(pos).name].buildable_to then
				core.set_node(pos,{name="meseportals:portal_collider"})
				local meta = minetest.get_meta(pos)
				meta:set_string("portal", minetest.pos_to_string(pos1))
				placed = true
			end
		end
	end
	return placed
end

local function placeportal(player,pos)
	if minetest.check_player_privs(player, {msp_unlimited=true}) or meseportals.maxPlayerPortals > #meseportals_network[player:get_player_name()] then
		local dir = minetest.dir_to_facedir(player:get_look_dir())
		local pos1 = vector.new(pos)
		local hadRoom = true
		if dir == 1
		or dir == 3 then
			pos1.z=pos1.z+2
			hadRoom = hadRoom and placeportalCollider(pos1, pos, player)
			pos1.y=pos1.y+1
			hadRoom = hadRoom and placeportalCollider(pos1, pos, player)
			pos1.y=pos1.y+1
			hadRoom = hadRoom and placeportalCollider(pos1, pos, player)
			pos1.y=pos1.y+1
			hadRoom = hadRoom and placeportalCollider(pos1, pos, player)
			pos1.z=pos1.z-1
			hadRoom = hadRoom and placeportalCollider(pos1, pos, player)
			pos1.z=pos1.z-1
			hadRoom = hadRoom and placeportalCollider(pos1, pos, player)
			pos1.z=pos1.z-1
			hadRoom = hadRoom and placeportalCollider(pos1, pos, player)
			pos1.z=pos1.z-1
			hadRoom = hadRoom and placeportalCollider(pos1, pos, player)
			pos1.y=pos1.y-1
			hadRoom = hadRoom and placeportalCollider(pos1, pos, player)
			pos1.y=pos1.y-1
			hadRoom = hadRoom and placeportalCollider(pos1, pos, player)
			pos1.y=pos1.y-1
			hadRoom = hadRoom and placeportalCollider(pos1, pos, player)
			pos1.y=pos1.y-1
			placeportalCollider(pos1, pos, player)
			pos1.z=pos1.z+1
			placeportalCollider(pos1, pos, player)
			pos1.z=pos1.z+1
			placeportalCollider(pos1, pos, player)
			pos1.z=pos1.z+1
			placeportalCollider(pos1, pos, player)
			pos1.z=pos1.z+1
			placeportalCollider(pos1, pos, player)
		else
			pos1.x=pos1.x+2
			hadRoom = hadRoom and placeportalCollider(pos1, pos, player)
			pos1.y=pos1.y+1
			hadRoom = hadRoom and placeportalCollider(pos1, pos, player)
			pos1.y=pos1.y+1
			hadRoom = hadRoom and placeportalCollider(pos1, pos, player)
			pos1.y=pos1.y+1
			hadRoom = hadRoom and placeportalCollider(pos1, pos, player)
			pos1.x=pos1.x-1
			hadRoom = hadRoom and placeportalCollider(pos1, pos, player)
			pos1.x=pos1.x-1
			hadRoom = hadRoom and placeportalCollider(pos1, pos, player)
			pos1.x=pos1.x-1
			hadRoom = hadRoom and placeportalCollider(pos1, pos, player)
			pos1.x=pos1.x-1
			hadRoom = hadRoom and placeportalCollider(pos1, pos, player)
			pos1.y=pos1.y-1
			hadRoom = hadRoom and placeportalCollider(pos1, pos, player)
			pos1.y=pos1.y-1
			hadRoom = hadRoom and placeportalCollider(pos1, pos, player)
			pos1.y=pos1.y-1
			hadRoom = hadRoom and placeportalCollider(pos1, pos, player)
			pos1.y=pos1.y-1
			placeportalCollider(pos1, pos, player)
			pos1.x=pos1.x+1
			placeportalCollider(pos1, pos, player)
			pos1.x=pos1.x+1
			placeportalCollider(pos1, pos, player)
			pos1.x=pos1.x+1
			placeportalCollider(pos1, pos, player)
			pos1.x=pos1.x+1
			placeportalCollider(pos1, pos, player)
		end
		if hadRoom then
			meseportals.swap_portal_node(pos,"meseportals:portalnode_off",dir)
			local player_name = player:get_player_name()
			meseportals.registerPortal(player_name, pos, dir)
			return true
		else
			minetest.remove_node(pos)
			minetest.chat_send_player(player:get_player_name(), "Not enough room!")
		end
	else
		minetest.chat_send_player(player:get_player_name(), "You have reached the maximum allowed number of portals!")
		core.remove_node(pos)
	end
end

function meseportals.activatePortal(pos)
	local portal = meseportals.findPortal(pos)
	if meseportals.findPortal(pos) then
		portal["updateme"] = true
		meseportals.save_data(portal["owner"])
	end
end

function meseportals.deactivatePortal(pos)
	local portal = meseportals.findPortal(pos)
	if portal then
		portal["destination"] = nil
		portal["destination_description"] = nil
		portal["destination_dir"] = nil
		portal["updateme"] = true
		meseportals.save_data(portal["owner"])
	end
end



local function removeportal(pos)
	if (meseportals.findPortal(pos) ~= nil) then
		local meta = core.get_meta(pos)
		if meta:get_string("dont_destroy") == "true" then
			-- when swapping it
			return
		end
		if meseportals.findPortal(pos)["destination"] then
			meseportals.deactivatePortal(meseportals.findPortal(pos)["destination"])
		end
		meseportals.unregisterPortal(pos)
	end
end

local msp_selection_box = {
	type = "fixed",
	fixed={{-2.5,-1.5,-0.2,2.5,3.5,0.2},},
}

local msp_groups = {cracky=2,not_in_creative_inventory=1,immovable=2}
local msp_groups1 = {cracky=2,immovabl=2}


local old_pttfp = minetest.pointed_thing_to_face_pos
minetest.pointed_thing_to_face_pos = function(placer, pointed_thing) 
	if pointed_thing and placer and pointed_thing.above and pointed_thing.under then
		if pointed_thing.under.x == pointed_thing.above.x and pointed_thing.under.y == pointed_thing.above.y and pointed_thing.under.z == pointed_thing.above.z then
			return placer:get_pos()
		else
			return old_pttfp(placer, pointed_thing)
		end
	else
		return vector.new(0,0,0)
	end
end

minetest.register_node("meseportals:portalnode_on",{
	tiles = {
		--{name = "gray.png"},
		--{
		--name = "puddle_animated.png",
		--animation = {
		--	type = "vertical_frames",
		--	aspect_w = 16,
		--	aspect_h = 16,
		--	length = 2.0,
		--	},
		--},
		{name = "meseportal_vortex.png",--Portal
		animation = {
			type = "vertical_frames",
			},
		},
		{name = "meseportal_mese_on.png", --Buttons
		animation = {
			type = "vertical_frames",
			},
		},
		{name = "meseportal_mese_on.png", --Cables
		animation = {
			type = "vertical_frames",
			},
		},
		{name = "meseportal_mese_on.png", --Coil
		animation = {
			type = "vertical_frames",
			},
		},
		{name = "meseportal_frame.png"}, --Frame
	},
	drawtype = "mesh",
	mesh = "meseportal.obj",
	visual_scale = 5.0,
	groups = msp_groups,
	drop = "meseportals:portalnode_off",
	paramtype2 = "facedir",
	paramtype = "light",
	light_source = 5,
	selection_box = msp_selection_box,
	walkable = false,
	on_destruct = removeportal,
	on_rightclick=meseportals.portalFormspecHandler,
})

minetest.register_node("meseportals:portalnode_off",{
	description = "Mese Portal (Sneak+Place = Buried)",
	inventory_image = "meseportal.png",
	wield_image = "meseportal.png",
	tiles = {
		{name = "meseportal_null.png"},
		{name = "meseportal_mese_off.png"},
		{name = "meseportal_mese_off.png"},
		{name = "meseportal_mese_off.png"},
		{name = "meseportal_frame.png"},
	},
	groups = msp_groups1,
	paramtype2 = "facedir",
	paramtype = "light",
	drawtype = "mesh",
	drop = "meseportals:portalnode_off",
	mesh = "meseportal.obj",
	visual_scale = 5.0,
	selection_box = msp_selection_box,
	walkable = false,
	on_destruct = removeportal,
	on_place = function(itemstack, placer, pointed_thing)
		
		local pos = pointed_thing.above
		if minetest.registered_nodes[minetest.get_node(pointed_thing.under).name] then
			if minetest.registered_nodes[minetest.get_node(pointed_thing.under).name].on_rightclick and not placer:get_player_control().sneak then
				return minetest.registered_nodes[minetest.get_node(pointed_thing.under).name].on_rightclick(pointed_thing.under, minetest.get_node(pointed_thing.under), placer, itemstack, pointed_thing)
			end
			if minetest.registered_nodes[minetest.get_node(pointed_thing.under).name].buildable_to then
				pos = pointed_thing.under
			end
		end
		if minetest.check_player_privs(placer, {protection_bypass=true}) or not minetest.is_protected(pos, placer:get_player_name()) then
			minetest.item_place(itemstack, placer, pointed_thing, minetest.dir_to_facedir(placer:get_look_dir()))
			local node = minetest.get_node(pos)
			local meta = minetest.get_meta(pos)
			if placer:get_player_control().sneak then
				minetest.set_node(pos, node)
			else
				minetest.remove_node(pos)
				pos.y = pos.y + 1
				minetest.set_node(pos, node)
			end
			if placeportal(placer,pos) then
				return itemstack
			else
				return nil
			end
		end
	end,
	on_rightclick=meseportals.portalFormspecHandler,
})

local old_protected = minetest.is_protected

local basecheck = { --f = face (x or z axis)
	{x=0, z=0, f=0},
	{x=1, z=0, f=1},
	{x=2, z=0, f=1},
	{x=-1, z=0, f=1},
	{x=-2, z=0, f=1},
	{x=0, z=1, f=2},
	{x=0, z=2, f=2},
	{x=0, z=-1, f=2},
	{x=0, z=-2, f=2},
}
minetest.is_protected = function(pos, player, ...) --Protect the bottom of the portal
	if not pos then return end
	local pos1 = vector.new(pos.x, pos.y + 1, pos.z) --Allocate
	local portal
	for _,pos2 in pairs(basecheck) do
		pos1.x = pos.x + pos2.x
		pos1.z = pos.z + pos2.z
		portal = meseportals.findPortal(pos1)
		if portal then
			if pos2.f == 0 then return true end --Right under
			if (pos2.f == 1) == (portal.dir == 0 or portal.dir == 2) then --Adjacent, XNOR with facedir
				return true
			end
		end
	end
	portal = meseportals.findPortal(pos)
	if portal and not minetest.check_player_privs(player, {msp_admin=true}) then 
		if portal.owner ~= player then
			minetest.chat_send_player(player, "This portal belongs to " ..portal["owner"] .."!")
			return true
		end
		if portal.admin_lock then
			minetest.chat_send_player(player, "This portal has been locked by an admin.")
			return true
		end
	end
	
	return old_protected(pos, player, ...)
end

local usePortalController = function(pos, clicker)
	if meseportals.findPortal(pos) then
		meseportals.portalFormspecHandler(pos, nil, clicker, nil)
	else
		minetest.chat_send_player(clicker:get_player_name(), "The linked portal was moved or destroyed. Link this controller to a new portal.")
	end
end

minetest.register_node("meseportals:linked_portal_controller", {
	description = "Linked Portal Controller",
	inventory_image = "meseportal_controller_inventory.png",
	wield_image = "meseportal_controller_inventory.png",
	tiles = {{name = "meseportal_controller.png"}},
	drawtype = "mesh",
	paramtype = "light",
	paramtype2 = "facedir",
	mesh = "meseportal_controller.obj",
	drop = "meseportals:unlinked_portal_controller",
	groups = {cracky=3,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
	stack_max = 1,
	walkable = true,
	light_source = 5,
	selection_box = {
		type = "fixed",
		fixed={{-0.425,-0.325,0.5,0.45,0.325,0.425},},
	},
	collision_box = {
		type = "fixed",
		fixed={{-0.425,-0.325,0.5,0.45,0.325,0.425},},
	},
	on_place = function(itemstack, placer, pointed_thing)
		if minetest.check_player_privs(placer, {protection_bypass=true}) or not minetest.is_protected(pointed_thing.above, placer:get_player_name()) then
			local rightClicked = minetest.get_node(pointed_thing.under).name
			if not placer:get_player_control().sneak then
				if rightClicked == "meseportals:portalnode_on" or rightClicked == "meseportals:portalnode_off" then
					local portal = meseportals.findPortal(pointed_thing.under)
					if portal then
						if portal["type"] == "public" or placer:get_player_name() == portal["owner"] or minetest.check_player_privs(placer, {msp_admin=true}) or not meseportals.allowPrivatePortals then
							minetest.chat_send_player(placer:get_player_name(), "Controller linked to "..portal["description"])
							itemstack:get_meta():set_string("portal", minetest.pos_to_string(pointed_thing.under))
							itemstack:get_meta():set_string("description", "Linked Portal Controller ["..portal["description"].."]")
							return itemstack
						else
							minetest.chat_send_player(placer:get_player_name(), portal["owner"] .." has set this portal to private.")
						end
					else
						minetest.chat_send_player(placer:get_player_name(), "This portal is broken.")
					end
				elseif minetest.registered_nodes[rightClicked] and minetest.registered_nodes[rightClicked].on_rightclick then
					return minetest.registered_nodes[rightClicked].on_rightclick(pointed_thing.under, minetest.get_node(pointed_thing.under), placer, itemstack, pointed_thing)
				end
			end
			local p
			if minetest.registered_nodes[minetest.get_node(pointed_thing.under).name] and minetest.registered_nodes[minetest.get_node(pointed_thing.under).name].buildable_to then
				p = pointed_thing.under
			else
				p = pointed_thing.above
			end
			local portalID = itemstack:get_meta():get_string("portal")
			minetest.item_place(itemstack, placer, pointed_thing, minetest.dir_to_facedir(placer:get_look_dir()))
			local meta = minetest.get_meta(p)
			meta:set_string("portal", portalID)
			return itemstack
		end
	end,
	on_use = function(itemstack, user)
		local pos1 = minetest.string_to_pos(itemstack:get_meta():get_string("portal"))
		usePortalController(pos1, user)
	end,
	on_rightclick = function(pos, node, clicker)
		local pos1 = minetest.string_to_pos(minetest.get_meta(pos):get_string("portal"))
		usePortalController(pos1, clicker)
	end
})

minetest.register_node("meseportals:unlinked_portal_controller", {
	description = "Unlinked Portal Controller",
	inventory_image = "meseportal_controller_inventory_unlinked.png",
	wield_image = "meseportal_controller_inventory_unlinked.png",
	tiles = {{name = "meseportal_controller_unlinked.png"}},
	drawtype = "mesh",
	paramtype = "light",
	paramtype2 = "facedir",
	mesh = "meseportal_controller.obj",
	drop = "meseportals:unlinked_portal_controller",
	groups = {cracky=3,oddly_breakable_by_hand=2},
	walkable = true,
	selection_box = {
		type = "fixed",
		fixed={{-0.425,-0.325,0.5,0.45,0.325,0.425},},
	},
	collision_box = {
		type = "fixed",
		fixed={{-0.425,-0.325,0.5,0.45,0.325,0.425},},
	},
	on_place = function(itemstack, placer, pointed_thing)
		local rightClicked = minetest.get_node(pointed_thing.under).name
		if not placer:get_player_control().sneak then
			if rightClicked == "meseportals:portalnode_on" or rightClicked == "meseportals:portalnode_off" then
				local portal = meseportals.findPortal(pointed_thing.under)
				if portal then
					if portal["type"] == "public" or placer:get_player_name() == portal["owner"] or minetest.check_player_privs(placer, {msp_admin=true}) then
						minetest.chat_send_player(placer:get_player_name(), "Controller linked to "..portal["description"])
						itemstack:set_name("meseportals:linked_portal_controller")
						itemstack:get_meta():set_string("portal", minetest.pos_to_string(pointed_thing.under))
						itemstack:get_meta():set_string("description", "Linked Portal Controller ["..portal["description"].."]")
						return itemstack
					else
						minetest.chat_send_player(placer:get_player_name(), portal["owner"] .." has set this portal to private.")
						return
					end
				else
					minetest.chat_send_player(placer:get_player_name(), "This portal is broken.")
				end
			elseif minetest.registered_nodes[rightClicked] and minetest.registered_nodes[rightClicked].on_rightclick then
				return minetest.registered_nodes[rightClicked].on_rightclick(pointed_thing.under, minetest.get_node(pointed_thing.under), placer, itemstack, pointed_thing)
			end
		end
		return minetest.item_place(itemstack, placer, pointed_thing, minetest.dir_to_facedir(placer:get_look_dir()))
	end,
	on_use = function(_, user)
		minetest.chat_send_player(user:get_player_name(), "This controller is not linked. Link this controller to a portal by right-clicking the portal.")
	end,
	on_rightclick = function(_, __, user)
		minetest.chat_send_player(user:get_player_name(), "This controller is not linked. Link this controller to a portal by right-clicking the portal.")
	end,
})

minetest.register_craftitem("meseportals:portal_segment", {
	description = "Encased Mesenetic Field Coil",
	inventory_image = "meseportal_portal_part.png",
	wield_image = "meseportal_portal_part.png",
})

minetest.register_craftitem("meseportals:tesseract_crystal", {
	description = "Tesseract Crystal",
	inventory_image = "meseportal_tesseract.png",
	wield_image = "meseportal_tesseract.png",
})