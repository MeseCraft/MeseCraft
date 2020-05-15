-- Parameters
snowdrift = {}
snowdrift.upperLimit = 130

local PRECTIM = 20 -- Time scale for precipitation variation, in minutes
local PRECTHR = 0.35 -- Precipitation noise threshold, -1 to 1:
					-- -1 = precipitation all the time
					-- 0 = precipitation half the time
					-- 1 = no precipitation
local DROPLPOS = 1024 -- Raindrop light-tested positions per cycle
					-- Maximum number of raindrops spawned per 0.5s
local RAINGAIN = 1.0 -- Rain sound volume
local NISVAL = 8 -- Overcast sky RGB value at night (brightness)
local DASVAL = 128 -- Overcast sky RGB value in daytime (brightness)
local DROPRAD = 32 -- Radius in which drops are created
local spawner_density = 3 -- Square root of the number of particle spawners to be created. 
-- Higher numbers = finer light detection, but more network usage

local np_prec = {
	offset = 0,
	scale = 1,
	spread = {x = PRECTIM, y = PRECTIM, z = PRECTIM},
	seed = 813,
	octaves = 1,
	persist = 0,
	lacunarity = 2.0,
	flags = "defaults"
}

-- These 2 must match biome heat and humidity noise parameters for a world

local np_temp = {
	offset = 50,
	scale = 50,
	spread = {x = 1000, y = 1000, z = 1000},
	seed = 5349,
	octaves = 3,
	persist = 0.5,
	lacunarity = 2.0,
	flags = "defaults"
}

local np_humid = {
	offset = 50,
	scale = 50,
	spread = {x = 1000, y = 1000, z = 1000},
	seed = 842,
	octaves = 3,
	persist = 0.5,
	lacunarity = 2.0,
	flags = "defaults"
}

-- End parameters


-- Stuff
local SDSQUARED = spawner_density*spawner_density
local SRANGE = DROPRAD/spawner_density
local difsval = DASVAL - NISVAL
local grad = 14 / 95
local yint = 1496 / 95
local alt_chill = 20 / 90

-- Initialise noise objects to nil

local nobj_temp = nil
local nobj_humid = nil
local nobj_prec = nil


-- Globalstep function

local handles = {}
local volumes = {}
local timer = 0


snowdrift.get_precip = function(pos)
	if not pos then return "none" end
	pos = {x=math.floor(pos.x+0.5),y=math.floor(pos.y+0.5),z=math.floor(pos.z+0.5)}
	nobj_temp = nobj_temp or minetest.get_perlin(np_temp)
	nobj_humid = nobj_humid or minetest.get_perlin(np_humid)
	nobj_prec = nobj_prec or minetest.get_perlin(np_prec)

	local nval_temp = nobj_temp:get2d({x = pos.x, y = pos.z}) - pos.y*alt_chill
	local nval_humid = nobj_humid:get2d({x = pos.x, y = pos.z})
	local nval_prec = nobj_prec:get2d({x = (os.clock() / 60)%30000, y = 0})
	
	
	local freeze = (nval_temp) < 28
	local precip = nval_prec > PRECTHR and
		nval_humid - grad * nval_temp > yint
		
	return (precip and (freeze and "snow" or "rain") or "none")
end

minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 2.5 then
		return
	end

	timer = 0

	for _, player in ipairs(minetest.get_connected_players()) do
		local player_name = player:get_player_name()
		local pos = player:get_pos()
		if not pos then return end
		local ppos = {x=math.floor(pos.x+0.5),y=math.floor(pos.y+0.5),z=math.floor(pos.z+0.5)}
		-- Point just above player, for rounding weirdness that happens at negative y coordinates.
		local pposy = ppos.y
		local dlight = minetest.get_node_light(ppos, 0.5)
		if not dlight then return end -- Light is sometimes nil. Why? Don't ask me.
		-- PROBLEMATIC SKYLIT CODE, CANNOT RUN ARTHIMETIC ON NIL VALUES
		local skylit
		local toptest = (minetest.get_node_light(pos, 0.5)) or 4
		local bottomtest = (minetest.get_node_light(pos, 0)) or 1
		skylit = toptest - bottomtest
		-- LETS TRY TO FIX IT

		if (pposy < snowdrift.upperLimit) then
			
			local pposx = ppos.x
			local pposz = ppos.z
			local ppos = {x = pposx, y = pposy, z = pposz}

			nobj_temp = nobj_temp or minetest.get_perlin(np_temp)
			nobj_humid = nobj_humid or minetest.get_perlin(np_humid)
			nobj_prec = nobj_prec or minetest.get_perlin(np_prec)

			local nval_temp = nobj_temp:get2d({x = pposx, y = pposz}) - pos.y*alt_chill
			 --altitude chill factor in mg_valleys
			local nval_humid = nobj_humid:get2d({x = pposx, y = pposz})
			local nval_prec = nobj_prec:get2d({x = (os.clock() / 60)%30000, y = 0})

			-- Biome system: Frozen biomes below heat 35,
			-- deserts below line 14 * t - 95 * h = -1496
			-- h = (14 * t + 1496) / 95
			-- h = 14/95 * t + 1496/95
			-- where 14/95 is gradient and 1496/95 is y intersection
			-- h - 14/95 t = 1496/95 y intersection
			-- so area above line is
			-- h - 14/95 t > 1496/95
			local freeze = nval_temp < 28
			-- minetest.chat_send_all(nval_temp)
			local precip = nval_prec > PRECTHR and
				nval_humid - grad * nval_temp > yint
			
			local prec_abs = nval_prec + 1
			local thr_scale = math.max(1 - PRECTHR, 0.05) -- Don't divide by zero
			local thr_abs = PRECTHR + 1
			local rainfall = (prec_abs - thr_abs) / thr_scale
			-- How heavily is it raining (on a scale from 0 to 1 over the bounds we've set)?
			rainfall =  math.max(rainfall, 0.05) --If we passed the threshhold, at least rain a little 
			
			-- UNoccasionally reset player sky
			-- if math.random() < 0.1 then
			
			if pposy > -60 and precip then -- Below -60 is dark sky, don't grey the sky here.
				-- Set overcast sky
				local sval
				local time = minetest.get_timeofday()
				if time >= 0.5 then
					time = 1 - time
				end
				-- Sky brightness transitions:
				-- First transition (24000 -) 4500, (1 -) 0.1875
				-- Last transition (24000 -) 5750, (1 -) 0.2396
				if time <= 0.1875 then
					sval = NISVAL
				elseif time >= 0.2396 then
					sval = DASVAL
				else
					sval = math.floor(NISVAL +
						((time - 0.1875) / 0.0521) * difsval)
				end
				-- Set sky to overcast bluish-grey
				player:set_sky({r = sval, g = sval, b = math.floor(sval*1.2), a = 255},
					"plain", {}, false)
			else
				-- Reset sky to normal
				player:set_sky({}, "regular", {}, true)
			end
			--end

			if (skylit == 0) or freeze or not precip then -- Snow, no weather, or cold = STOP
--			if (pposy < -25) or freeze or not precip then -- Snow, no weather, or cold = STOP
				if handles[player_name] then
					-- Stop sound if playing
					minetest.sound_stop(handles[player_name])
					handles[player_name] = nil
					volumes[player_name] = nil
				end
			else
				local vol = RAINGAIN * --Fade out sound as player goes out of open sky.
					(skylit/15)^2 *
					rainfall
				if handles[player_name] then
					if volumes[player_name] ~= vol then
						minetest.sound_fade(handles[player_name], (vol - volumes[player_name])/2, vol)
						volumes[player_name] = vol
					end
				else
					-- Start sound if not playing
					local handle = minetest.sound_play(
						"snowdrift_rain",
						{
							to_player = player_name,
							gain = vol, -- Fade as we get out of skylit area
							loop = true,
						}
					)
					handles[player_name] = handle
					volumes[player_name] = vol
				end
			end
			local node = minetest.get_node({x=ppos.x,y=math.floor(pos.y+1.9),z=ppos.z})
			if node and minetest.registered_nodes[node.name] then --Don't show particles when underwater.
				if minetest.registered_nodes[node.name].liquidtype ~= "none" then
					return
				end
			end
			
			-- Rainfall
			local lposx, lposz, spawny, spawnx, spawnz, spos, weather
			local ndrops = math.ceil((DROPLPOS/16)*rainfall)
			for lpos = 1, SDSQUARED do
				lposx = pposx - DROPRAD + ((math.floor(lpos/spawner_density) + 0.5) * 2 * SRANGE)
				lposz = pposz - DROPRAD + (((lpos % spawner_density) + 0.5) * 2 * SRANGE)
				
				spos = {x = lposx, y = pposy + 10, z = lposz}
				-- minetest.set_node(spos, {name="default:glass"})
				weather = snowdrift.get_precip(spos)
				if minetest.get_node_light(spos, 0.5) == 15 then
					if weather == "rain" then
						minetest.add_particlespawner({
							amount = ndrops * 8,  -- multiply the number of raindrops because they are not on the screen as long as snow.
							time = 5,
							minpos = {x=spos.x-SRANGE,y=spos.y,z=spos.z-SRANGE},
							maxpos = {x=spos.x+SRANGE,y=spos.y,z=spos.z+SRANGE},
							minvel = {x = 0.0, y = -20.0, z = 0.0},
							maxvel = {x = 0.0, y = -18.0, z = 0.0},
							minacc = {x = 0, y = 0, z = 0},
							maxacc = {x = 0, y = 0, z = 0},
							minexptime = 2,
							maxexptime = 2,
							minsize = 2.8,
							maxsize = 2.8,
							collisiondetection = true,
							collision_removal = true,
							vertical = true,
							texture = "snowdrift_raindrop.png",
							playername = player_name
						})
					elseif weather == "snow" then
						minetest.add_particlespawner({
							amount = ndrops,
							time = 5,
							minpos = {x=spos.x-SRANGE,y=spos.y,z=spos.z-SRANGE},
							maxpos = {x=spos.x+SRANGE,y=spos.y,z=spos.z+SRANGE},
							minvel = {x = -0.5, y = -2.5, z = -0.5},
							maxvel = {x = 0.5, y = -2.0, z = 0.5},
							minacc = {x = 0, y = 0, z = 0},
							maxacc = {x = 0, y = 0, z = 0},
							minexptime = 24,
							maxexptime = 24,
							minsize = 1,
							maxsize = 1,
							collisiondetection = true,
							collision_removal = true,
							vertical = false,
							texture = "snowdrift_snowflake" ..
								math.random(1, 12) .. ".png",
							playername = player_name
						})
					end
				end
			end
			
		elseif handles[player_name] then
			-- Stop sound when player goes above y limit
			minetest.sound_stop(handles[player_name])
			handles[player_name] = nil
			volumes[player_name] = nil
		end
	end
end)
if minetest.settings:get_bool("snowdrift.enable_abms") then
	dofile(minetest.get_modpath("snowdrift").."/abms.lua")
end

-- Stop sound and remove player handle on leaveplayer

minetest.register_on_leaveplayer(function(player)
	local player_name = player:get_player_name()
	if handles[player_name] then
		minetest.sound_stop(handles[player_name])
		handles[player_name] = nil
		volumes[player_name] = nil
	end
end)
