-- Geomoria mapgen.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2017
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)
-- Modified as part of the MeseCraft project


local DEBUG
local max_depth = 31000
local geomoria_depth = geomoria_mod.geomoria_depth
local math_random = math.random


local ground_nodes = {}
local ground_nodes_names = {
  'default:desert_stone',
  'default:dirt',
  'default:dirt_with_dry_grass',
  'default:dirt_with_grass',
  'default:dirt_with_snow',
  'default:sand',
  'default:sandstone',
  'default:stone',
}
for _, i in pairs(ground_nodes_names) do
  ground_nodes[minetest.get_content_id(i)] = true
end


local constructors = {}     -- content_id,constructor pairs
-- This table caches name,content_id pairs the first time they're seen
-- also populates constructors table
local node = setmetatable({}, {
  __index = function(t, k)
    if not (t and k and type(t) == 'table') then
      return
    end

    local cid = minetest.get_content_id(k)
    local con = minetest.registered_nodes[k].on_construct
    t[k] = cid
    if con and type(con) == "function" then constructors[cid] = con end

    return cid
  end
})


local data = {}
local p2data = {}


-- wrap data table with getter/setter
-- intercept and record any nodes that need constructors called later
local constructor_queue = {}
local raw_data = {}
local data_intercept = {
  __index = function(t,k)
    return raw_data[k]
  end,
  __newindex = function(t,k,v)
    if constructors[v] then
      constructor_queue[k] = v
      end
    raw_data[k]=v
    return v
  end
}
setmetatable(data, data_intercept)

-- Runs constructors of any nodes built using the voxelmanip
local run_constructors = function(queue, area)
  for k,v in pairs(queue) do
    if data[k] == v then  -- make sure the node hasn't been changed since k,v went in the queue
      local pos = area:position(k)
      constructors[v](pos)
    end
  end
end


local fissure_noise_map, damage_noise_map
local fissure_noise, damage_noise = {}, {}


local function generate(p_minp, p_maxp, seed)
  if not (p_minp and p_maxp and seed) then
    return
  end

  local minp, maxp = p_minp, p_maxp
  local avg = (minp.y + maxp.y) / 2
  local csize = vector.add(vector.subtract(maxp, minp), 1)

  local exit_stair = (minp.z % (csize.z * 10)) < csize.z and (minp.x % (csize.x * 10)) < csize.x
  if avg < (geomoria_depth - 1) * 80 - 32 or (not exit_stair and avg > geomoria_depth * 80 - 32) then
    return
  end

  local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
  if not (vm and emin and emax) then
    return
  end

  vm:get_data(raw_data)
  p2data = vm:get_param2_data()
  local heightmap
  local area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})

  if exit_stair and minp.y < 200 and avg > geomoria_depth * 80 - 32 then
    heightmap = minetest.get_mapgen_object("heightmap")

    -- Correct heightmap.
    --if maxp.y < -300 or minp.y > 300 then
    --  for i = 1, #heightmap do
    --    heightmap[i] = (maxp.y < 0) and max_depth or - max_depth
    --  end
    --else
    --  local index = 0
    --  for z = minp.z, maxp.z do
    --    for x = minp.x, maxp.x do
    --      index = index + 1

    --      local height = heightmap[index]
    --      if height and height < maxp.y - 1 and height > minp.y then
    --        --nop
    --      else
    --        height = - max_depth
    --        local ivm2 = area:index(x, maxp.y + 8, z)
    --        for y = maxp.y + 8, minp.y - 8, -1 do
    --          if ground_nodes[data[ivm2]] then
    --            height = (y < maxp.y + 8) and y or max_depth
    --            break
    --          end
    --          ivm2 = ivm2 - area.ystride
    --        end
    --        heightmap[index] = height
    --      end
    --    end
    --  end
    --end
  end

  if geomoria_mod.add_fissures then
    if not (damage_noise_map and fissure_noise_map) then
      damage_noise_map = minetest.get_perlin_map({offset = 0, scale = 0.5, seed = -6827, spread = {x = 200, y = 200, z = 200}, octaves = 3, persist = 0.8, lacunarity = 2}, csize)
      fissure_noise_map = minetest.get_perlin_map({offset = 0, scale = 1, seed = -8402, spread = {x = 8, y = 64, z = 8}, octaves = 3, persist = 0.5, lacunarity = 2}, csize)

      if not (damage_noise_map and fissure_noise_map) then
        return
      end
    end

    damage_noise = damage_noise_map:get_2d_map_flat({x=minp.x, y=minp.z}, damage_noise)
    fissure_noise = fissure_noise_map:get_3d_map_flat(minp, fissure_noise)
  else
    heightmap = minetest.get_mapgen_object("heightmap")
    damage_noise = heightmap
    fissure_noise = heightmap
    -- damage_noise = heightmap:get_2d_map_flat({x=minp.x, y=minp.z}, damage_noise)
    -- fissure_noise = heightmap:get_3d_map_flat(minp, fissure_noise)

	end

  local write, wetness = geomoria_mod.geomorph(minp, maxp, data, p2data, area, node, heightmap)

  if not write then
    return
  end

  if not wetness then
    wetness = 0
  end

  if not DEBUG and fissure_noise then
    local index = 1
    local index2 = 1
    for z = minp.z, maxp.z do
      for y = minp.y, maxp.y do
        local ivm = area:index(minp.x, y, z)
        local taper = 0
        --local taper = math.abs(30 - (y - minp.y)) / 50 - 0.7
        local dy = y - minp.y
        if dy < 20 then
          taper = (20 - dy) / 40
        elseif dy > 59 then
          taper = (dy - 59) / 40
        end

        for x = minp.x, maxp.x do
		  local damage
		  if fissure_noise and damage_noise then
            damage = (fissure_noise[index] - damage_noise[index2 + x - minp.x] - taper)
		  else
		    damage = geomoria_mod.damage_level
		  end
          if damage > geomoria_mod.damage_level then
            if data[ivm] ~= node['default:water_source'] and data[ivm] ~= node['default:water_source'] then
			  --ShadMOrdre 20180821
              --data[ivm] = node['air']
            end
          elseif (data[ivm] == node['default:stone'] or data[ivm] == node['default:stone_block']) and damage > geomoria_mod.damage_level - 0.5 then
            if (wetness > 0 and math_random(2) == 1) or (wetness == 0 and math_random(10) == 1) then
              if minetest.registered_items['fun_caves:glowing_fungal_stone'] and math_random(4) == 1 then
			    --ShadMOrdre 20180821
                --data[ivm] = node['fun_caves:glowing_fungal_stone']
              else
                data[ivm] = node['default:mossycobble']
              end
            else
              data[ivm] = node['default:cobble']
            end
          end

          ivm = ivm + 1
          index = index + 1
        end
      end
      index2 = index2 + csize.x
    end
  end

  if write then

    vm:set_data(raw_data)
    vm:set_param2_data(p2data)

    if DEBUG then
      vm:set_lighting({day = 14, night = 14})
    else
      vm:set_lighting({day = 0, night = 0}, minp, maxp)
      vm:calc_lighting()
    end
    vm:update_liquids()
    vm:write_to_map()

	run_constructors(constructor_queue, area)
	constructor_queue = {}
  end
end


if geomoria_mod.path then
  dofile(geomoria_mod.path .. "/geomorph.lua")
end


local function pgenerate(...)
  local status, err = pcall(generate, ...)
  --local status, err = true
  --generate(...)
  if not status then
    print('Geomoria: Could not generate terrain:')
    print(dump(err))
    collectgarbage("collect")
  end
end


minetest.register_on_generated(pgenerate)
