
local function unhash_pos(hash)
		local pos = {}
		local list = string.split(hash, ':')
		pos.x = tonumber(list[1])
		pos.y = tonumber(list[2])
		pos.z = tonumber(list[3])
		return pos
end

local function hash_pos(pos)
		return math.floor(pos.x + 0.5) .. ':' ..
				math.floor(pos.y + 0.5) .. ':' ..
				math.floor(pos.z + 0.5)
end

jumpdrive.telemosaic_compat = function(source_pos, target_pos)

	-- delegate to compat
	minetest.log("action", "[jumpdrive] Trying to rewire telemosaic @ " ..
			target_pos.x .. "/" .. target_pos.y .. "/" .. target_pos.z)

	local local_meta = minetest.get_meta(target_pos)
	local local_hash = local_meta:get_string('telemosaic:dest')

	if local_hash ~= nil and local_hash ~= '' then
		local local_pos = unhash_pos(local_hash)

		minetest.load_area(local_pos)
		local node = minetest.get_node(local_pos)

		if node.name == "telemosaic:beacon" then
			local remote_hash = minetest.get_meta(local_pos):get_string('telemosaic:dest')

			if remote_hash == hash_pos(source_pos) then
				-- remote beacon points to this beacon, update link
				local remote_pos = unhash_pos(remote_hash)
				local remote_meta = minetest.get_meta(remote_pos)

				minetest.log("action", "[jumpdrive] rewiring telemosaic at " .. minetest.pos_to_string(remote_pos) ..
						" to " .. minetest.pos_to_string(target_pos))

				remote_meta:set_string("telemosaic:dest", hash_pos(target_pos))
			end
		end
	end
end
