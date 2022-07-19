local reportFormspecViolation = function(submitter_name, violation)
	local path = minetest.get_worldpath().."/meseportals_incidents.log"
	local file = io.open( path, "r" )
	local data = ""
	if( file ) then
		data = file:read("*all")
		file:close()
	end
	data = data.."<"..os.date().."> "..submitter_name.." "..violation.."\n"
	file = io.open( path, "w" )
	if( file ) then
		file:write( data )
		file:close()
	end
end
local getCleanText = function(submitter_name, scan_text)
	if scan_text ~= nil then
		if string.find(scan_text, ";") or 
		string.find(scan_text, "%[") or 
		string.find(scan_text, "%]") or 
		string.find(scan_text, "\\") then
			reportFormspecViolation(submitter_name, "sent dirty string of length "..string.len(scan_text)..": "..scan_text)
			--Call me paranoid. The length bit is so that someone can't get away with causing their report to line-break, and fabricating a fake report on the next line, essentially framing another player as well as themself.
			return ""
		else
			return scan_text
		end
	else
		return nil
	end
end


meseportals.searchportals = function(pos, player_name, isAdmin)
	meseportals_gui["players"][player_name]["own_portals"]={}
	meseportals_gui["players"][player_name]["public_portals"]={}
	local own_portals_count=0
	local public_portals_count=0
	
	for __,portal in ipairs(meseportals_network[player_name]) do
		if portal["pos"].x==pos.x and portal["pos"].y==pos.y and portal["pos"].z==pos.z then
			--current_portal=portals
		else
			own_portals_count=own_portals_count+1
			if string.find(portal["description"], meseportals_gui["players"][player_name]["query"]) then
				table.insert(meseportals_gui["players"][player_name]["own_portals"],portal)
			end
		end
	end

	-- get all public portals
	for __,tab in ipairs(meseportals["registered_players"]) do
		local temp=tab["player_name"]
		for __,portal in ipairs(meseportals_network[temp]) do
			if string.find(portal["description"], meseportals_gui["players"][player_name]["query"]) then
				if portal["type"]=="public" or portal["owner"] == player_name or isAdmin or not meseportals.allowPrivatePortals then
					if portal["pos"].x==pos.x and portal["pos"].y==pos.y and portal["pos"].z==pos.z then
						--current_portal=portals
					else
						public_portals_count=public_portals_count+1
						table.insert(meseportals_gui["players"][player_name]["public_portals"],portal)
					end
				end
			end
		end
	end
	meseportals_gui["players"][player_name]["own_portals_count"]=own_portals_count
	meseportals_gui["players"][player_name]["public_portals_count"]=public_portals_count

end

-- Mods can override this to restict portal connections.
-- Admins ignore this.
meseportals.can_connect = function(src_portal, dest_portal)
	return dest_portal["destination"] == nil, "Destination portal is busy."
end

--show formspec to player
meseportals.portalFormspecHandler = function(pos, _, clicker, _)
	if (meseportals.findPortal(pos) ~= nil) then
		local player_name = clicker:get_player_name()
		local isAdmin = minetest.check_player_privs(clicker, {msp_admin=true})
		local owner=meseportals.findPortal(pos)["owner"]
		if meseportals.findPortal(pos)["type"] == "private" and player_name ~= owner and meseportals.allowPrivatePortals and not isAdmin then 
			minetest.chat_send_player(clicker:get_player_name(), meseportals.findPortal(pos)["owner"] .." has set this portal to private.")
			return 
		else
			local current_portal=meseportals.findPortal(pos)
			meseportals_gui["players"][player_name]["query"]=""
			meseportals.searchportals(pos, player_name, isAdmin)

			-- print(dump(meseportals_gui["players"][player_name]["public_portals"]))
			if current_portal == nil then
				print ("Portal not registered in network! Please remove it and place once again.")
				return nil
			end
			meseportals_gui["players"][player_name]["current_index"]=0
			meseportals_gui["players"][player_name]["temp_portal"]["owner"]=current_portal.owner
			meseportals_gui["players"][player_name]["temp_portal"]["type"]=current_portal["type"]
			meseportals_gui["players"][player_name]["temp_portal"]["description"]=current_portal["description"]
			meseportals_gui["players"][player_name]["temp_portal"]["pos"]={}
			meseportals_gui["players"][player_name]["temp_portal"]["pos"] = vector.new(pos)
			if current_portal["destination"] then
				meseportals_gui["players"][player_name]["temp_portal"]["destination_description"]=current_portal["destination_description"]
				meseportals_gui["players"][player_name]["temp_portal"]["destination_dir"]=current_portal["destination_dir"]
				meseportals_gui["players"][player_name]["temp_portal"]["destination"]={}
				meseportals_gui["players"][player_name]["temp_portal"]["destination"].x=current_portal["destination"].x
				meseportals_gui["players"][player_name]["temp_portal"]["destination"].y=current_portal["destination"].y
				meseportals_gui["players"][player_name]["temp_portal"]["destination"].z=current_portal["destination"].z
			else
				meseportals_gui["players"][player_name]["temp_portal"]["destination"]=nil
			end
			meseportals_gui["players"][player_name]["dest_type"]="all"
			local formspec=meseportals.get_formspec(player_name,"main")
			meseportals_gui["players"][player_name]["formspec"]=formspec
			if formspec ~=nil then minetest.show_formspec(player_name, "meseportals_main", formspec) end
		end
	else
		minetest.chat_send_player(clicker:get_player_name(), "This portal is broken.")
	end
end

-- get_formspec
meseportals.get_formspec = function(player_name,page)
	if player_name==nil then return nil end
	meseportals_gui["players"][player_name]["current_page"]=page
	local temp_portal=meseportals_gui["players"][player_name]["temp_portal"]
	local isAdmin = minetest.check_player_privs(player_name, {msp_admin=true})
	local formspec = "size[14,9.8]"
	--background
	formspec = formspec .."background[-0.19,-0.25;14.38,10.6;meseportal_ui_form_bg.png]"
	formspec = formspec.."label[0,0.0;Mese Portal ("
	if meseportals.allowPrivatePortals then
		formspec=formspec..temp_portal["owner"]
	end
	formspec = formspec..")]"
	formspec = formspec.."label[0,.5;Position: ("..temp_portal["pos"].x..","..temp_portal["pos"].y..","..temp_portal["pos"].z..")]"
	if player_name == temp_portal["owner"] or isAdmin or not meseportals.allowPrivatePortals then
		if meseportals.allowPrivatePortals then
			formspec = formspec.."image_button[3.5,.6;.6,.6;meseportal_toggle_icon.png;toggle_type;]"
			formspec = formspec.."label[4,.5;Type: "..temp_portal["type"].."]"
		end
		formspec = formspec.."image_button[6.5,.6;.6,.6;meseportal_pencil_icon.png;edit_desc;]"
	end
	formspec = formspec.."label[0,1.1;Destination: ]"
	if temp_portal["destination"] then
		if meseportals.findPortal(temp_portal["destination"]) then
			if isAdmin or meseportals.findPortal(temp_portal["destination"])["type"] ~= "private" or player_name == meseportals.findPortal(temp_portal["destination"])["owner"] or not meseportals.allowPrivatePortals then
				formspec = formspec.."label[2.5,1.1;"..temp_portal["destination_description"].." ("..temp_portal["destination"].x..","..temp_portal["destination"].y..","..temp_portal["destination"].z..") "
				if isAdmin then
					formspec = formspec.."("..meseportals.findPortal(temp_portal["destination"])["type"]..")"
				end
				formspec = formspec.."]"
			else
				formspec = formspec.."label[2.5,1.1;Private Portal]"
			end
		else
			formspec = formspec.."label[2.5,1.1;Invalid Destination]"
		end
		formspec = formspec.."image_button[2,1.2;.6,.6;meseportal_cancel_icon.png;remove_dest;]"
	else
	formspec = formspec.."label[2,1.1;Not connected]"
	end
	formspec = formspec.."label[0,1.7;Aviable destinations:]"
	formspec = formspec.."image_button[3.5,1.8;.6,.6;meseportal_toggle_icon.png;toggle_dest_type;]"
	formspec = formspec.."label[4,1.7;Filter: "..meseportals_gui["players"][player_name]["dest_type"].."]"
	
	formspec = formspec.."image_button[12.6,1.375;.8,.8;meseportal_ui_search_icon.png;update_search_query;]"
	formspec = formspec.."field[9.5,1.6;3.5,1;search_box;Search...;"..meseportals_gui["players"][player_name]["query"].."]"
	
	
	if page=="main" then
		if player_name == temp_portal["owner"]or isAdmin or not meseportals.allowPrivatePortals then
			formspec = formspec.."image_button[6.5,.6;.6,.6;meseportal_pencil_icon.png;edit_desc;]"
		end
		formspec = formspec.."label[7,.5;Description: "..temp_portal["description"].."]"
	end
	if page=="edit_desc" then
		if player_name == temp_portal["owner"]or isAdmin or not meseportals.allowPrivatePortals then
			formspec = formspec.."image_button[6.5,.6;.6,.6;meseportal_ok_icon.png;save_desc;]"
		end
		formspec = formspec.."field[7.3,.7;5,1;desc_box;Edit portal description:;"..temp_portal["description"].."]"
	end
	
	local list_index=meseportals_gui["players"][player_name]["current_index"]
	local page=math.ceil(list_index / 24)
	local pagemax
	if meseportals_gui["players"][player_name]["dest_type"] == "own" then
		pagemax = math.ceil((meseportals_gui["players"][player_name]["own_portals_count"] / 24))
		local x,y
		for y=0,7,1 do
		for x=0,2,1 do
			local portal_temp=meseportals_gui["players"][player_name]["own_portals"][list_index+1]
			if portal_temp then
				formspec = formspec.."image_button["..(x*4.5)..","..(2.5+y*.87)..";.6,.6;meseportal.png;list_button"..list_index..";]"
				formspec = formspec.."label["..(x*4.5+.5)..","..(2.3+y*.87)..";"
				if portal_temp["destination"] ~= nil then
					formspec = formspec.."<A> "
				end
				formspec = formspec.."("..portal_temp["pos"].x..","..portal_temp["pos"].y..","..portal_temp["pos"].z..") "..portal_temp["type"].."]"
				formspec = formspec.."label["..(x*4.5+.5)..","..(2.7+y*.87)..";"..portal_temp["description"].."]"
			end
			list_index=list_index+1
		end
		end
	else
		pagemax = math.ceil(meseportals_gui["players"][player_name]["public_portals_count"] / 24)
		local x,y
		for y=0,7,1 do
		for x=0,2,1 do
			local portal_temp=meseportals_gui["players"][player_name]["public_portals"][list_index+1]
			if portal_temp then
				formspec = formspec.."image_button["..(x*4.5)..","..(2.5+y*.87)..";.6,.6;meseportal.png;list_button"..list_index..";]"
				formspec = formspec.."label["..(x*4.5+.5)..","..(2.3+y*.87)..";"
				if portal_temp["destination"] ~= nil then
					formspec = formspec.."<A> "
				end
				formspec=formspec.."("..portal_temp["pos"].x..","..portal_temp["pos"].y..","..portal_temp["pos"].z..") "..portal_temp["owner"].."]"
				formspec = formspec.."label["..(x*4.5+.5)..","..(2.7+y*.87)..";"..portal_temp["description"]
				if isAdmin then
					formspec = formspec.." ("..portal_temp["type"]..")"
				end
				formspec = formspec.."]"
			end
			list_index=list_index+1
		end
		end
	end
	formspec=formspec.."label[7.5,1.7;Page: "..((pagemax > 0) and (page + 1) or 0).." of "..pagemax.."]"
	formspec = formspec.."image_button[6.5,1.8;.6,.6;meseportal_left_icon.png;page_left;]"
	formspec = formspec.."image_button[6.9,1.8;.6,.6;meseportal_right_icon.png;page_right;]"
	if isAdmin then formspec = formspec.."image_button_exit[5.1,9.3;.8,.8;meseportal_adminlock.png;lock_and_save;]" end
	formspec = formspec.."image_button_exit[6.1,9.3;.8,.8;meseportal_ok_icon.png;save_changes;]"
	formspec = formspec.."image_button_exit[7.1,9.3;.8,.8;meseportal_cancel_icon.png;discard_changes;]"
	return formspec
end

-- register_on_player_receive_fields
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "meseportals_main" then return end
	local player_name = player:get_player_name()
	local isAdmin = minetest.check_player_privs(player, {msp_admin=true})
	local temp_portal=meseportals_gui["players"][player_name]["temp_portal"]
	if not temp_portal then return end
	local current_portal=meseportals.findPortal(meseportals_gui["players"][player_name]["temp_portal"]["pos"])
	local formspec
	if current_portal then
		if (player_name ~= current_portal["owner"] and temp_portal["type"] == "private" and not isAdmin) and meseportals.allowPrivatePortals then
			reportFormspecViolation(player_name, "accessed someone else's private portal!")
			return
		end
		if player_name == current_portal["owner"] or isAdmin or not meseportals.allowPrivatePortals then
			if fields.toggle_type then
				if temp_portal["type"] == "private" then
					temp_portal["type"] = "public"
				else
					temp_portal["type"] = "private" 
				end
				meseportals_gui["players"][player_name]["current_index"]=0
				formspec= meseportals.get_formspec(player_name,"main")
				meseportals_gui["players"][player_name]["formspec"] = formspec
				minetest.show_formspec(player_name, "meseportals_main", formspec)
				minetest.sound_play("click", {to_player=player_name, gain = 0.5})
				return
			end
			if fields.edit_desc then
				formspec= meseportals.get_formspec(player_name,"edit_desc")
				meseportals_gui["players"][player_name]["formspec"]=formspec
				minetest.show_formspec(player_name, "meseportals_main", formspec)
				minetest.sound_play("click", {to_player=player_name, gain = 0.5})
				return
			end

			if fields.save_desc then
				temp_portal["description"]=getCleanText(player_name, fields.desc_box)
				formspec= meseportals.get_formspec(player_name,"main")
				meseportals_gui["players"][player_name]["formspec"]=formspec
				minetest.show_formspec(player_name, "meseportals_main", formspec)
				minetest.sound_play("click", {to_player=player_name, gain = 0.5})
				return
			end
		else
			if fields.toggle_type then
				reportFormspecViolation(player_name, "attempted to change type of someone else's portal!")
			end
			
			if fields.edit_desc then
				reportFormspecViolation(player_name, "attempted to edit description of someone else's portal!")
			end
			
			if fields.save_desc then
				reportFormspecViolation(player_name, "attempted to change description of someone else's portal!")
			end
		end
		if fields.toggle_dest_type then
			if meseportals_gui["players"][player_name]["dest_type"] == "own" then
				meseportals_gui["players"][player_name]["dest_type"] = "all"
			else meseportals_gui["players"][player_name]["dest_type"] = "own" end
			meseportals_gui["players"][player_name]["current_index"] = 0
			formspec = meseportals.get_formspec(player_name,"main")
			meseportals_gui["players"][player_name]["formspec"] = formspec
			minetest.show_formspec(player_name, "meseportals_main", formspec)
			minetest.sound_play("click", {to_player=player_name, gain = 0.5})
			return
		end
		if fields.update_search_query then
			meseportals_gui["players"][player_name]["query"] = getCleanText(player_name, fields.search_box)
			meseportals.searchportals(current_portal["pos"], player_name, isAdmin)
			formspec = meseportals.get_formspec(player_name,"main")
			meseportals_gui["players"][player_name]["formspec"] = formspec
			minetest.show_formspec(player_name, "meseportals_main", formspec)
			minetest.sound_play("click", {to_player=player_name, gain = 0.5})
		end
		-- page controls
		local start=math.floor(meseportals_gui["players"][player_name]["current_index"]/24 +1 )
		local start_i=start
		local pagemax
		if meseportals_gui["players"][player_name]["dest_type"] == "own" then
			pagemax = math.ceil((meseportals_gui["players"][player_name]["own_portals_count"]) / 24)
		else
			pagemax = math.ceil((meseportals_gui["players"][player_name]["public_portals_count"]) / 24)
		end
		if pagemax == 0 then pagemax = 1 end
		if fields.page_left then
			minetest.sound_play("paperflip2", {to_player=player_name, gain = 1.0})
			start_i = start_i - 1
			if start_i < 1 then	start_i = 1	end
			if not (start_i	== start) then
				meseportals_gui["players"][player_name]["current_index"] = (start_i-1)*24
				formspec = meseportals.get_formspec(player_name,"main")
				meseportals_gui["players"][player_name]["formspec"] = formspec
				minetest.show_formspec(player_name, "meseportals_main", formspec)
			end
		end
		if fields.page_right then
			minetest.sound_play("paperflip2", {to_player=player_name, gain = 1.0})
			start_i = start_i + 1
			if start_i > pagemax then start_i =  pagemax end
			if not (start_i	== start) then
				meseportals_gui["players"][player_name]["current_index"] = (start_i-1)*24
				formspec = meseportals.get_formspec(player_name,"main")
				meseportals_gui["players"][player_name]["formspec"] = formspec
				minetest.show_formspec(player_name, "meseportals_main", formspec)
			end
		end
		
		

		if fields.discard_changes then
			minetest.sound_play("click", {to_player=player_name, gain = 0.5})
		end
		
		if current_portal.admin_lock and not isAdmin then
			minetest.chat_send_player(player_name, "This portal has been locked by an admin.")
			return
		end
		
		
		if fields.remove_dest then
			minetest.sound_play("click", {to_player=player_name, gain = 0.5})
			temp_portal["destination"]=nil
			temp_portal["destination_description"]=nil
			formspec = meseportals.get_formspec(player_name,"main")
			meseportals_gui["players"][player_name]["formspec"] = formspec
			minetest.show_formspec(player_name, "meseportals_main", formspec)
		end

		if fields.save_changes or fields.lock_and_save then
			minetest.sound_play("click", {to_player=player_name, gain = 0.5})
			if player_name == current_portal["owner"] or isAdmin or not meseportals.allowPrivatePortals then
				if fields.desc_box ~= nil then
					temp_portal["description"]=getCleanText(player_name, fields.desc_box) 
				end
				current_portal["type"]=temp_portal["type"]
				current_portal["description"]=temp_portal["description"]
			end
			if temp_portal["destination"] then
				local dest_portal = meseportals.findPortal(temp_portal["destination"])
				if dest_portal then
					if isAdmin then 
						current_portal.admin_lock = fields.lock_and_save 
						dest_portal.admin_lock = fields.lock_and_save 
						
					elseif fields.lock_and_save then
						reportFormspecViolation(player_name, "attempted to admin-lock a portal while missing msp_admin privilege!")
					end
					if dest_portal["type"] ~= "private" or dest_portal["owner"] == player_name or isAdmin then
						if current_portal["destination"] ~= nil then
							current_portal["destination_deactivate"] = vector.new(current_portal["destination"])
						end
						current_portal["destination"]={}
						current_portal["destination"]=vector.new(temp_portal["destination"])
						current_portal["destination_description"]=temp_portal["destination_description"]
						current_portal["destination_dir"]=temp_portal["destination_dir"]
					else
						reportFormspecViolation(player_name, "attempted to connect to private portal at "..minetest.pos_to_string(dest_portal.pos).." from "..minetest.pos_to_string(current_portal.pos))
					end
				else
					minetest.chat_send_player(player_name, "The destination portal seems to have vanished while you were in the menu...")
				end
			else
				if current_portal["destination"] ~= nil then
					current_portal["destination_deactivate"] = vector.new(current_portal["destination"])
					meseportals.deactivatePortal(current_portal.pos)
				end
			end
		
			if current_portal["destination_deactivate"] ~= nil then
				if not temp_portal["destination"] then 
					current_portal.admin_lock = nil
				end
				if meseportals.findPortal(current_portal["destination_deactivate"]) then
					meseportals.findPortal(current_portal["destination_deactivate"]).admin_lock = nil
					meseportals.deactivatePortal (current_portal["destination_deactivate"])
					current_portal["destination_deactivate"] = nil
				end
			end
			
			if meseportals.findPortal(current_portal["destination"]) then
				local dest_portal = meseportals.findPortal(current_portal["destination"])
				local can_connect, fail_reason = meseportals.can_connect(table.copy(current_portal), table.copy(dest_portal))
				if can_connect or isAdmin then
					dest_portal.admin_lock = current_portal.admin_lock 
					-- Connecting to a portal, its locked state becomes the same as this portal.
					if dest_portal["destination"] then --Admin can interrupt any existing connection
						meseportals.deactivatePortal(dest_portal["destination"])
					end
					meseportals.activatePortal (current_portal.pos)
					dest_portal["destination"] = current_portal["pos"]
					dest_portal["destination_description"] = current_portal["description"]
					dest_portal["destination_dir"] = current_portal["dir"]
					meseportals.activatePortal (dest_portal.pos)
					current_portal["time"] = meseportals.close_after
				else
					if fail_reason then
						minetest.chat_send_player(player_name, "Connection failed: " .. fail_reason)
					else
						minetest.chat_send_player(player_name, "Connection failed.")
					end
					
					meseportals.deactivatePortal (current_portal["pos"])
				end
			else
				meseportals.deactivatePortal (current_portal["pos"])
			end
			
			if meseportals.save_data(current_portal["owner"])==nil then
				print ("[meseportals] Couldnt update network file!")
			end
		end

		local list_index=meseportals_gui["players"][player_name]["current_index"]
		local i
		for i=0,23,1 do
			local button="list_button"..i+list_index
			if fields[button] then
				minetest.sound_play("click", {to_player=player_name, gain = 1.0})
				local portal=meseportals_gui["players"][player_name]["temp_portal"]
				local dest_portal
				if meseportals_gui["players"][player_name]["dest_type"] == "own" then
					dest_portal=meseportals_gui["players"][player_name]["own_portals"][list_index+i+1]
				else
					dest_portal=meseportals_gui["players"][player_name]["public_portals"][list_index+i+1]
				end
				portal["destination"]=vector.new(dest_portal["pos"])
				portal["destination_description"]=dest_portal["description"]
				portal["destination_dir"]=dest_portal["dir"]
				formspec = meseportals.get_formspec(player_name,"main")
				meseportals_gui["players"][player_name]["formspec"] = formspec
				minetest.show_formspec(player_name, "meseportals_main", formspec)
			end
		end
	end
end)
