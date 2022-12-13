-- warn about outdated Minetest versions
assert(minetest.add_particlespawner, "[Climate API] This mod requires a more current version of Minetest")

-- initialize global API interfaces
climate_api = {}
climate_mod = {}

-- set mod path for file imports
local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

-- retrieve boolean value from mod config
local function get_setting_bool(name, default)
	local value = minetest.settings:get_bool("climate_api_" .. name)
	if type(value) == "nil" then value = default end
	return minetest.is_yes(value)
end

-- retrive numeric value from mod config
local function get_setting_number(name, default)
	local value = minetest.settings:get("climate_api_" .. name)
	if type(value) == "nil" then value = default end
	return tonumber(value)
end

-- load settings from config file
climate_mod.settings = {
	damage					= get_setting_bool("damage", true),
	raycast					= get_setting_bool("raycast", true),
	particles				= get_setting_bool("particles", true),
	skybox					= get_setting_bool("skybox", true),
	sound						= get_setting_bool("sound", true),
	hud_overlay			= get_setting_bool("hud_overlay", true),
	wind						= get_setting_bool("wind", true),
	seasons					= get_setting_bool("seasons", true),
	fahrenheit			= get_setting_bool("fahrenheit", false),
	block_updates		= get_setting_bool("block_updates", true),
	heat						= get_setting_number("heat_base", 0),
	humidity				= get_setting_number("humidity_base", 0),
	time_spread			= get_setting_number("time_spread", 1),
	particle_count	= get_setting_number("particle_count", 1),
	tick_speed			= get_setting_number("tick_speed", 1),
	volume					= get_setting_number("volume", 1),
	ceiling_checks	= get_setting_number("ceiling_checks", 10),
}

climate_mod.i18n = minetest.get_translator("climate_api")

-- initialize empty registers
climate_mod.weathers = {}
climate_mod.effects = {}
climate_mod.cycles = {}
climate_mod.global_environment = {}
climate_mod.global_influences = {}
climate_mod.influences = {}
climate_mod.current_weather = {}
climate_mod.current_effects = {}
climate_mod.forced_weather = {}
climate_mod.forced_enviroment = {}

-- handle persistent mod storage
climate_mod.state = dofile(modpath .. "/lib/datastorage.lua")

-- import core API
climate_api = dofile(modpath .. "/lib/api.lua")
climate_api.utility = dofile(modpath .. "/lib/api_utility.lua")
climate_api.skybox = dofile(modpath .. "/lib/skybox_merger.lua")
climate_api.player_physics = dofile(modpath .. "/lib/player_physics.lua")
climate_api.environment = dofile(modpath .. "/lib/environment.lua")
climate_mod.world = dofile(modpath .. "/lib/world.lua")
climate_mod.trigger = dofile(modpath .. "/lib/trigger.lua")

-- start event loop and register chat commands
dofile(modpath.."/lib/main.lua")
dofile(modpath.."/lib/commands.lua")

-- register environment influences
dofile(modpath .. "/lib/influences.lua")

-- import predefined environment effects
dofile(modpath .. "/ca_effects/damage.lua")
dofile(modpath .. "/ca_effects/hud_overlay.lua")
dofile(modpath .. "/ca_effects/particles.lua")
dofile(modpath .. "/ca_effects/skybox.lua")
dofile(modpath .. "/ca_effects/sound.lua")
