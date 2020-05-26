
-- invoked from move.lua
jumpdrive.move_objects = function(source_center, source_pos1, source_pos2, delta_vector)

	local all_objects = minetest.get_objects_inside_radius(source_center, 20);
	for _,obj in ipairs(all_objects) do

		local objPos = obj:get_pos()

		local xMatch = objPos.x >= source_pos1.x and objPos.x <= source_pos2.x
		local yMatch = objPos.y >= source_pos1.y and objPos.y <= source_pos2.y
		local zMatch = objPos.z >= source_pos1.z and objPos.z <= source_pos2.z

		local isPlayer = obj:is_player()

		if xMatch and yMatch and zMatch and not isPlayer then
			minetest.log("action", "[jumpdrive] object:  @ " .. minetest.pos_to_string(objPos))

			-- coords in range
			local entity = obj:get_luaentity()

			if not entity then
				minetest.log("action", "[jumpdrive] moving object")
				obj:set_pos( vector.add(objPos, delta_vector) )

			elseif entity.name:find("^mobs_animal:") then
				minetest.log("action", "[jumpdrive] moving animal")
				obj:set_pos( vector.add(objPos, delta_vector) )

			elseif entity.name == "__builtin:item" then
				minetest.log("action", "[jumpdrive] moving dropped item")
				obj:set_pos( vector.add(objPos, delta_vector) )

			else
				minetest.log("action", "[jumpdrive] removing entity: " .. entity.name)
				obj:remove()

			end
		end
	end


end
