-- Track a player's wielded item
wielded_light.register_player_lightstep(function (player)
	local name = player:get_player_name()
	local inv = minetest.get_inventory({type = "detached", name = name.."_armor"})
	for i = 1, 6 do
		local stack = inv:get_stack("armor", i)
		wielded_light.track_user_entity(player, "armor"..i, stack:get_name())
	end
end)
