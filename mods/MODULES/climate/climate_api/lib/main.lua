local GSCYCLE			=  0.03	* climate_mod.settings.tick_speed	-- only process event loop after this amount of time
local WORLD_CYCLE = 30.00	* climate_mod.settings.tick_speed	-- only update global environment influences after this amount of time

local function is_connected(playername)
	local connected = minetest.get_connected_players()
	for _, player in ipairs(connected) do
		local name = player:get_player_name()
		if playername == name then return true end
	end
	return false
end

local gs_timer = 0
local world_timer = 0
minetest.register_globalstep(function(dtime)
	gs_timer = gs_timer + dtime
	world_timer = world_timer + dtime

	if gs_timer + dtime < GSCYCLE then return else gs_timer = 0 end

	if world_timer >= WORLD_CYCLE then
		world_timer = 0
		climate_mod.world.update_status(minetest.get_gametime())
		climate_mod.global_environment = climate_mod.trigger.get_global_environment()
	end


	local previous_effects = table.copy(climate_mod.current_effects)
	-- skip weather changes for offline players
	for effect, data in pairs(previous_effects) do
		for playername, _ in pairs(data) do
			if not is_connected(playername) then
				previous_effects[effect][playername] = nil
			end
		end
	end

	local current_effects = climate_mod.trigger.get_active_effects()

	for name, effect in pairs(climate_mod.effects) do
		local cycle = climate_mod.cycles[name].timespan * climate_mod.settings.tick_speed
		if cycle < climate_mod.cycles[name].timer + dtime then
			climate_mod.cycles[name].timer = 0
			climate_mod.current_effects[name] = current_effects[name]
			climate_mod.trigger.call_handlers(name, current_effects[name], previous_effects[name])
		else
			climate_mod.cycles[name].timer = climate_mod.cycles[name].timer + dtime
		end
	end
end)