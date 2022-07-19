local function table_empty(tab)
	for key in pairs(tab) do return false end
	return true
end

meseportals.save_data = function(table_pointer)
	local data = minetest.serialize( meseportals_network[table_pointer] )
	local path = minetest.get_worldpath().."/meseportals_"..table_pointer..".data"
	local file = io.open( path, "w" )
	if( file ) then
		file:write( data )
		file:close()
		return true
	else return nil
	end
end

meseportals.restore_data = function(table_pointer)
	
	local path = minetest.get_worldpath().."/meseportals_"..table_pointer..".data"
	local file = io.open( path, "r" )
	if( file ) then
		local data = file:read("*all")
		meseportals_network[table_pointer] = minetest.deserialize( data )
		file:close()
		if table_empty(meseportals_network[table_pointer]) then os.remove(path) end
	return true
	else return nil
	end
end

meseportals.load_players = function() 
	local path = minetest.get_worldpath().."/meseportals.players"
	local file = io.open( path, "r" )
	if( file ) then
		local data = file:read("*all")
		meseportals["registered_players"] = minetest.deserialize( data )
		file:close()
		if table_empty(meseportals["registered_players"]) then os.remove(path) end
	return true
	else return nil
	end
end

meseportals.save_players = function()
	if table_empty(meseportals["registered_players"]) then return end
	local data = minetest.serialize( meseportals["registered_players"] )
	local path = minetest.get_worldpath().."/meseportals.players"
	local file = io.open( path, "w" )
	if( file ) then
		file:write( data )
		file:close()
		return true
	else return nil
	end
end
-- load meseportalss network data
if meseportals.load_players() ~= nil then
	for __,tab in ipairs(meseportals["registered_players"]) do
		if meseportals.restore_data(tab["player_name"]) == nil  then
			--print ("[meseportals] Error loading data!")
			meseportals_network[tab["player_name"]] = {}
		end
	end
else
	print ("[meseportals] Error loading data! Creating new file.")
	meseportals["registered_players"]={}
	meseportals.save_players()
end

-- register_on_joinplayer
minetest.register_on_joinplayer(function(player)
	local player_name = player:get_player_name()
	local registered=nil
	for __,tab in ipairs(meseportals["registered_players"]) do
		if tab["player_name"] ==  player_name then registered = true break end
	end
	if registered == nil then
		local new={}
		new["player_name"]=player_name
		table.insert(meseportals["registered_players"],new)
		meseportals_network[player_name]={}
		meseportals.save_players()
		meseportals.save_data(player_name)
	end
	meseportals_gui["players"][player_name]={
		formspec = "",
		current_page = meseportals.default_page,
		own_portals ={},
		own_portals_count =0,
		public_portals ={},
		public_portals_count =0,
		current_index =0,
		temp_portal ={},
	}
end)


meseportals.unregisterPortal = function(pos)
	for _,tab in pairs(meseportals.registered_players) do
		local player_name=tab.player_name
		for __,portal in ipairs(meseportals_network[player_name]) do
			if portal["pos"].x==pos.x and portal["pos"].y==pos.y and portal["pos"].z==pos.z then
				table.remove(meseportals_network[player_name], __)
				if meseportals.save_data(player_name)==nil then
					print ("[meseportals] Couldnt update network file!")
				end
			end
		end
	end
end
	
meseportals.registerPortal = function(player_name,pos,dir)
	if meseportals.findPortal(pos) then
		 --An annoying glitch
		meseportals.unregisterPortal(pos)
	end
	
	if meseportals_network[player_name]==nil then
		meseportals_network[player_name]={}
	end
	local new_portal ={}
	new_portal["pos"]=pos
	new_portal["type"]="public"
	new_portal["description"]="Portal at (" ..new_portal["pos"].x .."," ..new_portal["pos"].y .."," ..new_portal["pos"].z ..")"
	new_portal["dir"]=dir
	new_portal["owner"]=player_name
	table.insert(meseportals_network[player_name],new_portal)
	if meseportals.save_data(player_name)==nil then
		print ("[meseportals] Couldnt update network file!")
	end
end

meseportals.findPortal = function(pos)
	if pos ~= nil then
		for _,tab in pairs(meseportals.registered_players) do
			local player_name=tab.player_name
			for _,portals in pairs(meseportals_network[player_name]) do
				if portals
				and vector.equals(portals.pos, pos) then
					return portals
				end
			end
		end
	end
	return nil
end

