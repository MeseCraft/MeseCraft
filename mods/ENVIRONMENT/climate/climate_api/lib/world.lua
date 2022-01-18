local world = {}
local BASE_TIME = 0.2 * climate_mod.settings.time_spread

local WIND_SPREAD = 600
local WIND_SCALE = 2
local HEAT_SPREAD = 400
local HEAT_SCALE = 0.3
local HUMIDITY_SPREAD = 150
local HUMIDITY_SCALE = 0.5
local HUMIDITY_BASE_SPREAD = 800
local HUMIDITY_BASE_SCALE = 40

local nobj_wind_x
local nobj_wind_z
local nobj_heat
local nobj_humidity
local nobj_humidity_base

local pn_wind_speed_x = {
	offset = 0,
	scale = WIND_SCALE,
	spread = {x = WIND_SPREAD, y = WIND_SPREAD, z = WIND_SPREAD},
	seed = 31441,
	octaves = 2,
	persist = 0.5,
	lacunarity = 2
}

local pn_wind_speed_z = {
	offset = 0,
	scale = WIND_SCALE,
	spread = {x = WIND_SPREAD, y = WIND_SPREAD, z = WIND_SPREAD},
	seed = 938402,
	octaves = 2,
	persist = 0.5,
	lacunarity = 2
}

local pn_heat = {
	offset = 1,
	scale = HEAT_SCALE,
	spread = {x = HEAT_SPREAD, y = HEAT_SPREAD, z = HEAT_SPREAD},
	seed = 235896,
	octaves = 2,
	persist = 0.5,
	lacunarity = 2
}

local pn_humidity = {
	offset = 0,
	scale = HUMIDITY_SCALE,
	spread = {x = HUMIDITY_SPREAD, y = HUMIDITY_SPREAD, z = HUMIDITY_SPREAD},
	seed = 8374061,
	octaves = 2,
	persist = 0.5,
	lacunarity = 2
}

local pn_humidity_base = {
	offset = 50,
	scale = HUMIDITY_BASE_SCALE,
	spread = {x = HUMIDITY_BASE_SPREAD, y = HUMIDITY_BASE_SPREAD, z = HUMIDITY_BASE_SPREAD},
	seed = 3803465,
	octaves = 2,
	persist = 0.5,
	lacunarity = 2
}

local function update_wind(timer)
	nobj_wind_x = nobj_wind_x or minetest.get_perlin(pn_wind_speed_x)
	nobj_wind_z = nobj_wind_z or minetest.get_perlin(pn_wind_speed_z)
	local n_wind_x = nobj_wind_x:get_2d({x = timer, y = 0})
	local n_wind_z = nobj_wind_z:get_2d({x = timer, y = 0})
	climate_mod.state:set_float("wind_x", n_wind_x)
	climate_mod.state:set_float("wind_z", n_wind_z)
end

local function update_heat(timer)
	nobj_heat = nobj_heat or minetest.get_perlin(pn_heat)
	local n_heat = nobj_heat:get_2d({x = timer, y = 0})
	climate_mod.state:set_float("heat_random", n_heat)
end

local function update_humidity(timer)
	nobj_humidity = nobj_humidity or minetest.get_perlin(pn_humidity)
	local n_humidity = nobj_humidity:get_2d({x = timer, y = 0})
	climate_mod.state:set_float("humidity_random", n_humidity)
	nobj_humidity_base = nobj_humidity_base or minetest.get_perlin(pn_humidity_base)
	local n_humidity_base = nobj_humidity_base:get_2d({x = timer, y = 0})
	climate_mod.state:set_float("humidity_base", n_humidity_base)
end

function world.update_status(timer)
	timer = math.floor(timer * BASE_TIME)
	update_wind(timer)
	update_heat(timer)
	update_humidity(timer)
end

return world