local goblin_enabled = minetest.settings:get_bool("commoditymarket_enable_goblin_market")
local under_enabled = minetest.settings:get_bool("commoditymarket_enable_under_market")
local goblin_prob = tonumber(minetest.settings:get("commoditymarket_goblin_market_dungeon_prob")) or 0.25
local under_prob = tonumber(minetest.settings:get("commoditymarket_under_market_dungeon_prob")) or 0.1

local goblin_max = tonumber(minetest.settings:get("commoditymarket_goblin_market_dungeon_max")) or 100
local goblin_min = tonumber(minetest.settings:get("commoditymarket_goblin_market_dungeon_min")) or -400
local under_max = tonumber(minetest.settings:get("commoditymarket_under_market_dungeon_max")) or -500
local under_min = tonumber(minetest.settings:get("commoditymarket_under_market_dungeon_min")) or -31000

local bad_goblin_range = goblin_min >= goblin_max
local bad_under_range = under_min >= under_max

if bad_goblin_range then
	minetest.log("error", "[commoditymarket] Goblin market dungeon generation range has a higher minimum y than maximum y")
end
if bad_under_range then
	minetest.log("error", "[commoditymarket] Undermarket dungeon generation range has a higher minimum y than maximum y")
end

local gen_goblin = goblin_enabled and goblin_prob > 0 and not bad_goblin_range
local gen_under = under_enabled and under_prob > 0 and not bad_under_range

if not (gen_goblin or gen_under) then
	return
end


-------------------------------------------------------
-- The following is shamelessly copied from dungeon_loot and tweaked for placing markets instead of chests
--Licensed under the MIT License (MIT) Copyright (C) 2017 sfan5

minetest.set_gen_notify({dungeon = true, temple = true})

local function noise3d_integer(noise, pos)
	return math.abs(math.floor(noise:get_3d(pos) * 0x7fffffff))
end

local is_wall = function(node)
	return node.name ~= "air" and node.name ~= "ignore"
end

local function find_walls(cpos)
	local dirs = {{x=1, z=0}, {x=-1, z=0}, {x=0, z=1}, {x=0, z=-1}}
	local get_node = minetest.get_node

	local ret = {}
	local mindist = {x=0, z=0}
	local min = function(a, b) return a ~= 0 and math.min(a, b) or b end
	for _, dir in ipairs(dirs) do
		for i = 1, 9 do -- 9 = max room size / 2
			local pos = vector.add(cpos, {x=dir.x*i, y=0, z=dir.z*i})

			-- continue in that direction until we find a wall-like node
			local node = get_node(pos)
			if is_wall(node) then
				local front_below = vector.subtract(pos, {x=dir.x, y=1, z=dir.z})
				local above = vector.add(pos, {x=0, y=1, z=0})

				-- check that it:
				--- is at least 2 nodes high (not a staircase)
				--- has a floor
				if is_wall(get_node(front_below)) and is_wall(get_node(above)) then
					pos = vector.subtract(pos, {x=dir.x, y=0, z=dir.z}) -- move goblin markets one node away from the wall
					table.insert(ret, {pos = pos, facing = {x=-dir.x, y=0, z=-dir.z}})
					if dir.z == 0 then
						mindist.x = min(mindist.x, i-1)
					else
						mindist.z = min(mindist.z, i-1)
					end
				end
				-- abort even if it wasn't a wall cause something is in the way
				break
			end
		end
	end

	return {
		walls = ret,
		size = {x=mindist.x*2, z=mindist.z*2},
		cpos = cpos,
	}
end

minetest.register_on_generated(function(minp, maxp, blockseed)
	local min_y = minp.y
	local max_y = maxp.y

	local gen_goblin_range = gen_goblin and not (min_y > goblin_max or max_y < goblin_min)
	local gen_under_range = gen_under and not (min_y > under_max or max_y < under_min)
	
	if not (gen_goblin_range or gen_under_range) then
		-- out of both ranges
		return
	end

	local gennotify = minetest.get_mapgen_object("gennotify")
	local poslist = gennotify["dungeon"] or {}
	for _, entry in ipairs(gennotify["temple"] or {}) do
		table.insert(poslist, entry)
	end
	if #poslist == 0 then return end

	local noise = minetest.get_perlin(151994, 4, 0.5, 1)
	local rand = PcgRandom(noise3d_integer(noise, poslist[1]))

	local rooms = {}
	-- process at most 8 rooms to keep runtime of this predictable
	local num_process = math.min(#poslist, 8)
	for i = 1, num_process do
		local room = find_walls(poslist[i])
		-- skip small rooms and everything that doesn't at least have 3 walls
		if math.min(room.size.x, room.size.z) >= 4 and #room.walls >= 3 then
			table.insert(rooms, room)
		end
	end
	if #rooms == 0 then return end

	if gen_under_range and rand:next(0, 2147483647)/2147483647 < under_prob then
		-- choose a random room
		local room = rooms[rand:next(1, #rooms)]
		local under_loc = room.cpos
	
		-- put undermarkets in the center of the room
		if minetest.get_node(under_loc).name == "air"
			and is_wall(vector.subtract(under_loc, {x=0, y=1, z=0})) then
			minetest.add_node(under_loc, {name="commoditymarket:under_market"})
		end
	end

	if gen_goblin_range and rand:next(0, 2147483647)/2147483647 < goblin_prob then
		-- choose a random room
		local room = rooms[rand:next(1, #rooms)]
		
		-- choose place somewhere in front of any of the walls
		local wall = room.walls[rand:next(1, #room.walls)]
		local v, vi -- vector / axis that runs alongside the wall
		if wall.facing.x ~= 0 then
			v, vi = {x=0, y=0, z=1}, "z"
		else
			v, vi = {x=1, y=0, z=0}, "x"
		end
		local marketpos = vector.add(wall.pos, wall.facing)
		local off = rand:next(-room.size[vi]/2 + 1, room.size[vi]/2 - 1)
		marketpos = vector.add(marketpos, vector.multiply(v, off))
	
		if minetest.get_node(marketpos).name == "air" then
			-- make it face inwards to the room
			local facedir = minetest.dir_to_facedir(vector.multiply(wall.facing, -1))
			minetest.add_node(marketpos, {name = "commoditymarket:goblin_market", param2 = facedir})
		end
	end
end)