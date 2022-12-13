
local speed = player_monoids.speed

minetest.register_privilege("monoid_master", {
	description = "Allows testing of player monoids.",
	give_to_singleplayer = false,
	give_to_admin = true,
})

local function test(player)
	local ch_id = speed:add_change(player, 10)
	local p_name = player:get_player_name()

	minetest.chat_send_player(p_name, "Your speed is: " .. speed:value(player))

	minetest.after(3, function()
		speed:del_change(player, ch_id)
		minetest.chat_send_player(p_name, "Your speed is: " .. speed:value(player))
	end)
end

minetest.register_chatcommand("test_monoids", {
	description = "Runs a test on monoids",
	privs = { monoid_master = true },
	func = function(p_name)
		test(minetest.get_player_by_name(p_name))
	end,
})
