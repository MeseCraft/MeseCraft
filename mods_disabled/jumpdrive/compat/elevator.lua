

jumpdrive.elevator_compat = function(pos1, pos2)

	-- find potential elevators
	local elevator_motors = minetest.find_nodes_in_area(pos1, pos2, "elevator:motor")

	for _,pos in ipairs(elevator_motors) do
		-- delegate to compat

		local def = minetest.registered_nodes["elevator:motor"]
		minetest.log("action", "[jumpdrive] Restoring elevator @ " .. pos.x .. "/" .. pos.y .. "/" .. pos.z)

		-- function(pos, placer, itemstack)
		def.after_place_node(pos, nil, nil)
	end

end
