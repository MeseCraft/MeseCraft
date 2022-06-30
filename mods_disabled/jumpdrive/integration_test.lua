
minetest.log("warning", "[TEST] integration-test enabled!")

local function execute_move(callback)
	local source_pos1 = { x=0, y=0, z=0 }
	local source_pos2 = { x=5, y=5, z=5 }
	local target_pos1 = { x=10, y=10, z=10 }
	local target_pos2 = { x=15, y=15, z=15 }

	minetest.get_voxel_manip(source_pos1, source_pos1)
	local src_node = minetest.get_node(source_pos1)

	areas:add("dummy", "landscape", source_pos1, source_pos2)
	areas:save()

	assert(not minetest.is_protected(source_pos1, "dummy"))
	assert(minetest.is_protected(source_pos1, "dummy2"))

	jumpdrive.move(source_pos1, source_pos2, target_pos1, target_pos2)

	assert(not minetest.is_protected(source_pos1, "dummy"))
	assert(not minetest.is_protected(source_pos1, "dummy2"))

	assert(not minetest.is_protected(target_pos1, "dummy"))
	assert(minetest.is_protected(target_pos1, "dummy2"))

	minetest.get_voxel_manip(target_pos1, target_pos1)
	local target_node = minetest.get_node(target_pos1)

	if target_node.name ~= src_node.name then
		error("moved node name does not match")
	end

	if target_node.param2 ~= src_node.param2 then
		error("moved param2 does not match")
	end

	callback()
end

local function execute_mapgen(callback)
	local pos1 = { x=-50, y=-10, z=-50 }
	local pos2 = { x=50, y=50, z=50 }
	minetest.emerge_area(pos1, pos2, callback)
end

local function execute_test(callback)
	execute_mapgen(function(blockpos, action, calls_remaining)
		minetest.log("action", "Emerged: " .. minetest.pos_to_string(blockpos))
		if calls_remaining > 0 then
			return
		end

		jumpdrive.mapgen.reset()
		execute_move(function()
			callback()
		end)
	end)
end

minetest.register_on_mods_loaded(function()
	minetest.after(1, function()
		execute_test(function()
			local data = minetest.write_json({ success = true }, true);
			local file = io.open(minetest.get_worldpath().."/integration_test.json", "w" );
			if file then
				file:write(data)
				file:close()
			end

			file = io.open(minetest.get_worldpath().."/registered_nodes.txt", "w" );
			if file then
				for name in pairs(minetest.registered_nodes) do
					file:write(name .. '\n')
				end
				file:close()
			end

			minetest.log("warning", "[TEST] integration tests done!")
			minetest.request_shutdown("success")
		end)
	end)
end)
