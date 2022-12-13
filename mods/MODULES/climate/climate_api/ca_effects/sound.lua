--[[
# Sound Loop Effect
Use this effect to loop an ambient sound effect
Expects a table as the parameter containing the following values:
- ``name <string>``: Name of the played sound effect (without .ogg file ending)
- ``gain <number>`` (optional): Volume of the sound (defaults to 1.0)
- ``pitch <number>`` (optional): Pitch of the sound (defaults to 1.0)
]]

if not climate_mod.settings.sound then return end

local EFFECT_NAME = "climate_api:sound"
local FADE_DURATION = climate_api.LONG_CYCLE

local modpath = minetest.get_modpath(minetest.get_current_modname())
local soundloop = dofile(modpath .. "/lib/soundloop.lua")

local function start_sound(pname, sound)
	return soundloop.play(pname, sound, FADE_DURATION)
end

local function stop_sound(pname, sound)
	return soundloop.stop(pname, sound, FADE_DURATION)
end

local function start_effect(player_data)
	for playername, data in pairs(player_data) do
		for weather, value in pairs(data) do
			start_sound(playername, value)
		end
	end
end

local function handle_effect(player_data, prev_data)
	for playername, data in pairs(player_data) do
		for weather, value in pairs(data) do
			if prev_data[playername][weather] == nil then
				start_sound(playername, value)
			end
		end
	end

	for playername, data in pairs(prev_data) do
		for weather, value in pairs(data) do
			if player_data[playername][weather] == nil then
				stop_sound(playername, value)
			end
		end
	end
end

local function stop_effect(prev_data)
	for playername, data in pairs(prev_data) do
		for weather, value in pairs(data) do
			stop_sound(playername, value)
		end
	end
end

climate_api.register_effect(EFFECT_NAME, start_effect, "start")
climate_api.register_effect(EFFECT_NAME, handle_effect, "tick")
climate_api.register_effect(EFFECT_NAME, stop_effect, "stop")
