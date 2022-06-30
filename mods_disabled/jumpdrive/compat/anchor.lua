-- stolen from technic / anchor.lua

local function compute_forceload_positions(pos, meta)
	local radius = meta:get_int("radius")
	local minpos = vector.subtract(pos, vector.new(radius, radius, radius))
	local maxpos = vector.add(pos, vector.new(radius, radius, radius))
	local minbpos = {}
	local maxbpos = {}
	for _, coord in ipairs({"x","y","z"}) do
		minbpos[coord] = math.floor(minpos[coord] / 16) * 16
		maxbpos[coord] = math.floor(maxpos[coord] / 16) * 16
	end
	local flposes = {}
	for x = minbpos.x, maxbpos.x, 16 do
		for y = minbpos.y, maxbpos.y, 16 do
			for z = minbpos.z, maxbpos.z, 16 do
				table.insert(flposes, vector.new(x, y, z))
			end
		end
	end
	return flposes
end

local function currently_forceloaded_positions(meta)
	local ser = meta:get_string("forceloaded")
	return ser == "" and {} or minetest.deserialize(ser)
end

local function forceload_off(meta)
	local flposes = currently_forceloaded_positions(meta)
	meta:set_string("forceloaded", "")
	for _, p in ipairs(flposes) do
		minetest.forceload_free_block(p)
	end
end

local function forceload_on(pos, meta)
	local want_flposes = compute_forceload_positions(pos, meta)
	local have_flposes = {}
	for _, p in ipairs(want_flposes) do
		if minetest.forceload_block(p) then
			table.insert(have_flposes, p)
		end
	end
	meta:set_string("forceloaded", #have_flposes == 0 and "" or minetest.serialize(have_flposes))
end

jumpdrive.anchor_compat = function(from, to)
	local to_meta = minetest.get_meta(to)
	local from_meta = minetest.get_meta(from)

	if from_meta:get_int("enabled") ~= 0 then
		-- anchor enabled
		forceload_off(from_meta)
		forceload_on(to, to_meta)
	end
end
