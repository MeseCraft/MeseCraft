minetest.register_globalstep(function(dtime)
	for _, player in pairs(minetest.get_connected_players()) do
		player:set_bone_position("Head", vector.new(0, 6.75, 0), vector.new(-math.deg(player:get_look_vertical()), 0, 0))
	end
end)
