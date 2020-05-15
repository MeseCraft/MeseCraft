
-- submodule
otherworlds.asteroids = {}

-- Approximate realm limits.
local XMIN = -33000
local XMAX = 33000
local ZMIN = -33000
local ZMAX = 33000

local ASCOT = 1.0 -- Large asteroid / comet nucleus noise threshold.
local SASCOT = 1.0 -- Small asteroid / comet nucleus noise threshold.
local STOT = 0.125 -- Asteroid stone threshold.
local COBT = 0.05 -- Asteroid cobble threshold.
local GRAT = 0.02 -- Asteroid gravel threshold.
local ICET = 0.05 -- Comet ice threshold.
local ATMOT = -0.01 -- Comet atmosphere threshold.
local FISTS = 0.01 -- Fissure noise threshold at surface. Controls size of fissures and amount / size of fissure entrances.
local FISEXP = 0.3 -- Fissure expansion rate under surface.
local ORECHA = 3*3*3 -- Ore 1/x chance per stone node.
local CPCHU = 0 -- Maximum craters per chunk.
local CRMIN = 5 -- Crater radius minimum, radius includes dust and obsidian layers.
local CRRAN = 8 -- Crater radius range.


-- Note: for fewer large objects: increase the 'spread' numbers in 'np_large' noise parameters. For fewer small objects do the same in 'np_small'. Then tune size with 'ASCOT'.

-- 3D Perlin noise 1 for large structures
local np_large = {
	offset = 0,
	scale = 1,
	spread = {x=256, y=128, z=256},
	seed = -83928935,
	octaves = 5,
	persist = 0.6
}

-- 3D Perlin noise 3 for fissures
local np_fissure = {
	offset = 0,
	scale = 1,
	spread = {x=64, y=64, z=64},
	seed = -188881,
	octaves = 4,
	persist = 0.5
}

-- 3D Perlin noise 4 for small structures
local np_small = {
	offset = 0,
	scale = 1,
	spread = {x=128, y=64, z=128},
	seed = 1000760700090,
	octaves = 4,
	persist = 0.6
}

-- 3D Perlin noise 5 for ore selection
local np_ores = {
	offset = 0,
	scale = 1,
	spread = {x=128, y=128, z=128},
	seed = -70242,
	octaves = 1,
	persist = 0.5
}

-- 3D Perlin noise 6 for comet atmosphere
local np_latmos = {
	offset = 0,
	scale = 1,
	spread = {x=256, y=128, z=256},
	seed = -83928935,
	octaves = 3,
	persist = 0.6
}

-- 3D Perlin noise 7 for small comet atmosphere
local np_satmos = {
	offset = 0,
	scale = 1,
	spread = {x=128, y=64, z=128},
	seed = 1000760700090,
	octaves = 2,
	persist = 0.6
}


-- On dignode function. Atmosphere flows into a dug hole.
minetest.register_on_dignode(function(pos, oldnode, digger)
	if minetest.find_node_near(pos, 1, {"vacuum:vacuum"}) then
		minetest.set_node(pos, {name = "vacuum:vacuum"})
	end
end)

-- Generate on_generated function based on parameters
function otherworlds.asteroids.create_on_generated(ymin, ymax, content_ids)
	local YMIN = ymin
	local YMAX = ymax

	local c_air = content_ids.c_air
	local c_stone = content_ids.c_stone
	local c_cobble = content_ids.c_cobble
	local c_gravel = content_ids.c_gravel
	local c_dust = content_ids.c_dust
	local c_ironore = content_ids.c_ironore
	local c_copperore = content_ids.c_copperore
	local c_goldore = content_ids.c_goldore
	local c_diamondore = content_ids.c_diamondore
	local c_meseore = content_ids.c_meseore
	local c_waterice = content_ids.c_waterice
	local c_atmos = content_ids.c_atmos
	local c_snowblock = content_ids.c_snowblock
	local c_obsidian = content_ids.c_obsidian

	-- return the function closed over the upvalues we want
	return function(minp, maxp, seed)
		if minp.x < XMIN or maxp.x > XMAX
		or minp.y < YMIN or maxp.y > YMAX
		or minp.z < ZMIN or maxp.z > ZMAX then
			return
		end
		-- local t1 = os.clock()
		local x1 = maxp.x
		local y1 = maxp.y
		local z1 = maxp.z
		local x0 = minp.x
		local y0 = minp.y
		local z0 = minp.z
		--print ("[asteroid] chunk ("..x0.." "..y0.." "..z0..")")
		local sidelen = x1 - x0 + 1 -- chunk side length
		--local vplanarea = sidelen ^ 2 -- vertical plane area, used if calculating noise index from x y z
		local chulens = {x=sidelen, y=sidelen, z=sidelen}
		local minpos = {x=x0, y=y0, z=z0}

		local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
		local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
		local data = vm:get_data()

		local nvals1 = minetest.get_perlin_map(np_large, chulens):get3dMap_flat(minpos)
		local nvals3 = minetest.get_perlin_map(np_fissure, chulens):get3dMap_flat(minpos)
		local nvals4 = minetest.get_perlin_map(np_small, chulens):get3dMap_flat(minpos)
		local nvals5 = minetest.get_perlin_map(np_ores, chulens):get3dMap_flat(minpos)
		local nvals6 = minetest.get_perlin_map(np_latmos, chulens):get3dMap_flat(minpos)
		local nvals7 = minetest.get_perlin_map(np_satmos, chulens):get3dMap_flat(minpos)

		local ni = 1
		for z = z0, z1 do -- for each vertical plane do
		for y = y0, y1 do -- for each horizontal row do
		local vi = area:index(x0, y, z) -- LVM index for first node in x row
		for x = x0, x1 do -- for each node do
			local noise1abs = math.abs(nvals1[ni]) 
			local noise4abs = math.abs(nvals4[ni]) 
			local comet = false
			if nvals6[ni] < -(ASCOT + ATMOT) or (nvals7[ni] < -(SASCOT + ATMOT) and nvals1[ni] < ASCOT) then 
				comet = true -- comet biome
			end
			if noise1abs > ASCOT or noise4abs > SASCOT then -- if below surface then
				local noise1dep = noise1abs - ASCOT -- noise1dep zero at surface, positive beneath
				if math.abs(nvals3[ni]) > FISTS + noise1dep * FISEXP then -- if no fissure then
					local noise4dep = noise4abs - SASCOT -- noise4dep zero at surface, positive beneath
					if not comet or (comet and (noise1dep > math.random() + ICET or noise4dep > math.random() + ICET)) then
						-- asteroid or asteroid materials in comet
						if noise1dep >= STOT or noise4dep >= STOT then
							-- stone/ores
							if math.random(ORECHA) == 2 then
								if nvals5[ni] > 0.6 then
									data[vi] = c_goldore
								elseif nvals5[ni] < -0.6 then
									data[vi] = c_diamondore
								elseif nvals5[ni] > 0.2 then
									data[vi] = c_meseore
								elseif nvals5[ni] < -0.2 then
									data[vi] = c_copperore
								else
									data[vi] = c_ironore
								end
							else
								data[vi] = c_stone
							end
						elseif noise1dep >= COBT or noise4dep >= COBT then
							data[vi] = c_cobble
						elseif noise1dep >= GRAT or noise4dep >= GRAT then
							data[vi] = c_gravel
						else
							data[vi] = c_dust
						end
					else -- comet materials
						if noise1dep >= ICET or noise4dep >= ICET then
							data[vi] = c_waterice
						else
							data[vi] = c_snowblock
						end
					end
				elseif comet then -- fissures, if comet then add comet atmosphere
					data[vi] = c_atmos
				end
			elseif comet then -- if comet atmosphere then
				data[vi] = c_atmos
			end
			ni = ni + 1
			vi = vi + 1
		end
		end
		end
		-- craters
		for ci = 1, CPCHU do -- iterate
			local cr = CRMIN + math.floor(math.random() ^ 2 * CRRAN) -- exponential radius
			local cx = math.random(minp.x + cr, maxp.x - cr) -- centre x
			local cz = math.random(minp.z + cr, maxp.z - cr) -- centre z
			local comet = false
			local surfy = false
			for y = y1, y0 + cr, -1 do
				local vi = area:index(cx, y, cz) -- LVM index for node
				local nodeid = data[vi]
				if nodeid == c_dust
				or nodeid == c_gravel
				or nodeid == c_cobble then
					surfy = y
					break
				elseif nodename == c_snowblock
				or nodename == c_waterice then
					comet = true
					surfy = y
					break
				end
			end
			if surfy and y1 - surfy > 8 then -- if surface found and 8 node space above impact node then
				for x = cx - cr, cx + cr do -- for each plane do
					for z = cz - cr, cz + cr do -- for each column do
						for y = surfy - cr, surfy + cr do -- for each node do
							local vi = area:index(x, y, z) -- LVM index for node
							local nr = ((x - cx) ^ 2 + (y - surfy) ^ 2 + (z - cz) ^ 2) ^ 0.5
							if nr <= cr - 2 then
								if comet then
									data[vi] = c_atmos
								else
									data[vi] = c_air
								end
							elseif nr <= cr - 1 then
								local nodeid = data[vi]
								if nodeid == c_gravel
								or nodeid == c_cobble
								or nodeid == c_stone
								or nodeid == c_diamondore
								or nodeid == c_goldore
								or nodeid == c_meseore
								or nodeid == c_copperore
								or nodeid == c_ironore then
									data[vi] = c_dust
								end
							elseif nr <= cr then
								local nodeid = data[vi]
								if nodeid == c_cobble
								or nodeid == c_stone then
									data[vi] = c_obsidian -- obsidian buried under dust
								end
							end
						end
					end
				end
			end
		end
		vm:set_data(data)
		vm:set_lighting({day=0, night=0})
		vm:calc_lighting()
		vm:write_to_map(data)
		-- local chugent = math.ceil((os.clock() - t1) * 1000)
		--print ("[asteroid] time "..chugent.." ms")
		data = nil
	end
end
