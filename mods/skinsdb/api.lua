-- get current skin
local storage = minetest.get_mod_storage()

function skins.get_player_skin(player)
	if player:get_attribute("skinsdb:skin_key") then
		storage:set_string(player:get_player_name(), player:get_attribute("skinsdb:skin_key"))
		player:set_attribute("skinsdb:skin_key", nil)
	end
	local skin = storage:get_string(player:get_player_name())
	return skins.get(skin) or skins.get(skins.default)
end

-- Assign skin to player
function skins.assign_player_skin(player, skin)
	local skin_obj
	if type(skin) == "string" then
		skin_obj = skins.get(skin)
	else
		skin_obj = skin
	end

	if not skin_obj then
		return false
	end

	if skin_obj:is_applicable_for_player(player:get_player_name()) then
		local skin_key = skin_obj:get_key()
		if skin_key == skins.default then
			skin_key = ""
		end
		storage:set_string(player:get_player_name(), skin_key)
	else
		return false
	end
	return true
end

-- update visuals
function skins.update_player_skin(player)
	if skins.armor_loaded then
		-- all needed is wrapped and implemented in 3d_armor mod
		armor:set_player_armor(player)
	else
		-- do updates manually without 3d_armor
		skins.get_player_skin(player):apply_skin_to_player(player)
		if minetest.global_exists("sfinv") and sfinv.enabled then
			sfinv.set_player_inventory_formspec(player)
		end
	end
end

-- Assign and update - should be used on selection externally
function skins.set_player_skin(player, skin)
	local success = skins.assign_player_skin(player, skin)
	if success then
		skins.get_player_skin(player):set_skin(player)
		skins.update_player_skin(player)
	end
	return success
end

-- Check Skin format (code stohlen from stu's multiskin)
function skins.get_skin_format(file)
	file:seek("set", 1)
	if file:read(3) == "PNG" then
		file:seek("set", 16)
		local ws = file:read(4)
		local hs = file:read(4)
		local w = ws:sub(3, 3):byte() * 256 + ws:sub(4, 4):byte()
		local h = hs:sub(3, 3):byte() * 256 + hs:sub(4, 4):byte()
		if w >= 64 then
			if w == h then
				return "1.8"
			elseif w == h * 2 then
				return "1.0"
			end
		end
	end
end
