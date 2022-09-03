df_ambience = {}

local pplus = minetest.get_modpath("playerplus")
local S = minetest.get_translator(minetest.get_current_modname())

local modpath =  minetest.get_modpath(minetest.get_current_modname())

local radius = 6
local registered_sets = {}
local set_nodes = {}
local muted_players = {}

local ensure_set_node = function(node_name)
	for _, existing_node in pairs(set_nodes) do
		if node_name == existing_node then
			return
		end
	end
	table.insert(set_nodes, node_name)
end

df_ambience.add_set = function(def)
	assert(def)
	assert(def.sounds)
	if def.nodes then
		for _, node_name in pairs(def.nodes) do
			ensure_set_node(node_name)
		end
	end
	def.frequency = def.frequency or 0.05
	table.insert(registered_sets, def)
end

local timer = 0
local random = math.random

local get_player_data = function(player, name)
	-- get head level node at player position
	local pos = player:get_pos()
	if not pos then return end
	local prop = player:get_properties()
	local eyeh = prop.eye_height or 1.47 -- eye level with fallback
	
	pos.y = pos.y + eyeh
	local nod_head = pplus and name and playerplus[name]
			and playerplus[name].nod_head or minetest.get_node(pos).name
	pos.y = pos.y - eyeh

	-- get all set nodes around player
	local ps, cn = minetest.find_nodes_in_area(
		{x = pos.x - radius, y = pos.y - radius, z = pos.z - radius},
		{x = pos.x + radius, y = pos.y + radius, z = pos.z + radius}, set_nodes)
		
	return {
		pos = pos,
		head_node = nod_head,
		biome = df_caverns.get_biome(pos),
		totals = cn
	}
end

local check_nodes = function(totals, nodes)
	for _, node in pairs(nodes) do
		if (totals[node] or 0) > 1 then
			return true
		end
	end
	return false
end

-- selects sound set
local get_ambience = function(player, name)
	local player_data
	-- loop through sets in order and choose first that meets its conditions
	for _, set in ipairs(registered_sets) do
		if random() < set.frequency then
			local check_passed
			local sound_check = set.sound_check
			local set_nodes = set.nodes
			if sound_check or set_nodes then
				player_data = player_data or get_player_data(player, name)
			end
			if ((not set_nodes) or check_nodes(player_data.totals, set_nodes)) and
				((not sound_check) or sound_check(player_data)) then
				return set
			end
		end
	end
end

minetest.register_globalstep(function(dtime)
	-- one second timer
	timer = timer + dtime
	if timer < 1 then return end
	timer = 0

	local player_name
	local number
	local ambience

	-- loop through players
	for _, player in pairs(minetest.get_connected_players()) do
		player_name = player:get_player_name()
		if not muted_players[player_name] then
			local set = get_ambience(player, player_name)
			if set then
				-- choose random sound from set
				number = random(#set.sounds)
				ambience = set.sounds[number]

				-- play sound
				minetest.sound_play(ambience.name, {
					to_player = player_name,
					gain = ambience.gain or 0.3,
					pitch = ambience.pitch or 1.0,
				}, true)
			end
		end
	end
end)

minetest.register_chatcommand("mute_df_ambience", {
	params = "",
	description = S("Mutes or unmutes ambient sounds in deep caverns"),
	func = function(name, param)
		local message
		if muted_players[name] then
			message = S("Unmuted")
			muted_players[name] = nil
		else
			message = S("Muted, no new sounds will start playing once current sounds finish")
			muted_players[name] = true
		end
		return true, message
	end
})

dofile(modpath.."/soundsets.lua")