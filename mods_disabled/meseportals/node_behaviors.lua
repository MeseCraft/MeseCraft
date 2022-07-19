
minetest.register_abm({
	nodenames = {"meseportals:portal_collider"},
	interval = 1,
	chance = 1,
	action = function(pos) 
		local portalpos = minetest.string_to_pos(minetest.get_meta(pos):get_string("portal"))
		if portalpos then
			local nodeName = minetest.get_node(portalpos).name
			if nodeName ~= "ignore" then --If the portal is on the edge of the loaded world, wait to update
				if nodeName ~= "meseportals:portalnode_on" and nodeName ~= "meseportals:portalnode_off" then
					minetest.remove_node(pos)
				end
			end
		end
	end
})


minetest.register_abm({
	nodenames = {"meseportals:portalnode_on", "meseportals:portalnode_off"},
	interval = 1,
	chance = 1,
	action = function(pos)
		local current_portal = meseportals.findPortal(pos)
		if not current_portal then
			minetest.remove_node(pos)
			return
		end
		
	end
})


minetest.register_globalstep(function(dtime)
	local meta, infotext, pos1, pos, dir, dir1, hdiff, dest_portal
	for _, skip in pairs(meseportals_network) do
		for __, portal in pairs(skip) do
			if portal then
				pos = portal["pos"]
				if portal["time"] and not portal["admin_lock"] then -- Close portals automatically after a while
					if portal["time"] > 0 then
						portal["time"] = portal["time"] - dtime
					else
						portal["time"] = nil
						if portal["destination"] then
							meseportals.deactivatePortal(portal["destination"])
						end
						meseportals.deactivatePortal(pos)
					end
				end
				
				if minetest.get_node_or_nil(pos) then  -- Do the complicated stuff only if the portal is loaded
					if minetest.get_node(pos).name ~= "meseportals:portalnode_off" 
						and minetest.get_node(pos).name ~= "meseportals:portalnode_on"
					then --Portal broke
						if portal["destination"] then
							meseportals.deactivatePortal(portal["destination"])
						end
						meseportals.unregisterPortal(pos)
					elseif portal["updateme"] then -- Node needs to update
						if portal["destination"] == nil then
							if minetest.get_node(pos).name ~= "meseportals:portalnode_off" then
								minetest.sound_play("meseportal_close", {pos = pos, gain=0.6, max_hear_distance = 40})
							end
							meseportals.swap_portal_node(pos,"meseportals:portalnode_off",portal["dir"])
						else
							meseportals.swap_portal_node(pos,"meseportals:portalnode_on",portal["dir"])
							minetest.sound_play("meseportal_open", {pos = pos, gain=0.6, max_hear_distance = 40})
						end
						portal["updateme"] = false
						meseportals.save_data(portal["owner"])
						meta = minetest.get_meta(pos)
						if portal["type"]=="private" and meseportals.allowPrivatePortals then 
							infotext="Private Portal"
						else
							infotext=(portal["description"])
							if meseportals.allowPrivatePortals then 
								infotext=infotext.." ("..portal["owner"].."'s Public Portal)"
							end
							dest_portal = meseportals.findPortal(portal["destination"])
							if dest_portal then
								if dest_portal["type"] == "public" or not meseportals.allowPrivatePortals then
									infotext=infotext.."\nDestination: " ..portal["destination_description"] .." ("..portal["destination"].x..","..portal["destination"].y..","..portal["destination"].z..") "
								else
									infotext=infotext.."\nDestination: Private Portal"
								end
							end
						end
						if portal.admin_lock then
							infotext=infotext.."\nAdmin connection (Can not be closed)"
						end
						meta:set_string("infotext",infotext)
					end
			
					--Teleport players
					dest_portal=meseportals.findPortal(portal["destination"])
					if dest_portal then
						pos1 = vector.new(dest_portal["pos"])
						dir = portal.dir
						dir1 = portal.destination_dir
						for _,object in pairs(core.get_objects_inside_radius({x = pos.x, y = pos.y, z = pos.z}, 2)) do
							hdiff = nil
							if dir == 1
							or dir == 3 then
								if math.floor(object:get_pos().x + 0.5) == pos.x then
									hdiff = (object:get_pos().z - pos.z)
								end
							else
								if math.floor(object:get_pos().z + 0.5) == pos.z then
									hdiff = (object:get_pos().x - pos.x)
								end
							end
							if hdiff then
								pos1.y = pos1.y + (object:get_pos().y - pos.y) + 0.2
								local dest_angle = ((dir1 - 2) * -90) 
						
								dest_angle = ((object:get_look_horizontal() or object:get_yaw()) + math.pi) + ((dir1 - dir) * -(math.pi/2))
						
								if dir == 1 or dir == 2 then
									hdiff = -hdiff
								end
								--hdiff = -1
								if dir1 == 0 then --ALL CORRECT
									pos1.z = pos1.z-1.25
									pos1.x = pos1.x - hdiff
								elseif dir1 == 1 then
									pos1.x = pos1.x-1.25
									pos1.z = pos1.z + hdiff
								elseif dir1 == 2 then
									pos1.z=pos1.z+1.25
									pos1.x = pos1.x + hdiff
								elseif dir1 == 3 then
									pos1.x = pos1.x+1.25
									pos1.z = pos1.z - hdiff
								end
								local vel = object:get_velocity() or object:get_player_velocity()
								vel.x = -vel.x
								local magnitude = math.sqrt((vel.x*vel.x) + (vel.z*vel.z))
								if math.abs(vel.z) < 0.01 then
									vel.z = 0.01
								end
								local direction = math.atan(vel.x/vel.z)
								-- Direction of velocity plus the change in look direction
								if vel.z < 0 then
									direction = direction + math.pi
								end
								direction = direction + math.pi + ((dir1 - dir) * -(math.pi/2))
								vel.x = magnitude * -math.sin(direction)
								vel.z = magnitude * math.cos(direction)
								local moved = false
								if object:is_player() then
									object:set_pos(pos1)
									if vector.equals(vector.round(object:get_pos()), vector.round(pos1)) then moved = true end
								elseif object:get_properties().physical == true then
									object:set_pos(pos1)
									moved = true
								end
								if moved then
									if object:is_player() then
										--player:set_player_velocity(vel) -- TODO: Bother the devs more about this
										object:set_look_horizontal(dest_angle)
										minetest.sound_play("meseportal_warp", {to_player=object:get_player_name(), gain=0.6, max_hear_distance=15})
									else
										object:set_velocity(vel)
										object:set_yaw(dest_angle)
									end
									minetest.sound_play("meseportal_warp", {pos = pos, gain=0.6, max_hear_distance=15})
									minetest.sound_play("meseportal_warp", {pos = pos1, gain=0.6, max_hear_distance=15})
								end
							end
						end
					else 
						if portal["destination"] then --Destination portal broke/vanished
							meseportals.deactivatePortal(pos)
						end
					end
				end
			end
		end
	end
end)