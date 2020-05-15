-- Interval between movement checks (in seconds).
local INTERVAL = 5

-- Minimum distance to move to register as not AFK (in blocks).
local MINDIST = 0.2

-- If player does not move within this time, 'sit' player (in seconds).
local TIMEOUT = 300 -- 5 minutes

local time_afk = {}
local last_pos = {}
local chat_afk = {}
local chat_noafk = {}

local function check_moved()

	for _, p in ipairs(minetest.get_connected_players()) do
		local plname = p:get_player_name()
		local pos = p:getpos()
		local sit = false

		if chat_noafk[plname] == nil then
			chat_afk[plname] = false
			chat_noafk[plname] = true
		end

		if last_pos[plname] then
			local d = vector.distance(last_pos[plname], pos)
			-- print("Player: "..plname..", Dist: "..d)

			if d < MINDIST then
				time_afk[plname] = (time_afk[plname] or 0) + INTERVAL

				if time_afk[plname] >= TIMEOUT then

					default.player_attached[plname] = true
					default.player_set_animation(p, "sit")
					sit = true
	
					chat_noafk[plname] = false

					if chat_afk[plname] == false then
						minetest.chat_send_all("* "..plname.." is AFK.")
						chat_afk[plname] = true
					end

				end

			else
				time_afk[plname] = 0
			end
		end

		if not sit then

			last_pos[plname] = pos
			default.player_attached[plname] = false
			default.player_set_animation(p, "stand")
	
			chat_afk[plname] = false

			if chat_noafk[plname] == false then
				minetest.chat_send_all("* "..plname.." came back from AFK.")
				chat_noafk[plname] = true
			end
		end

		if p:get_hp() == 0 and sit then
			default.player_set_animation(p, "lay")
		end
	end


	minetest.after(INTERVAL, check_moved)
end

minetest.after(INTERVAL, check_moved)

minetest.register_on_leaveplayer(function(player)
	local plname = player:get_player_name()
	time_afk[plname] = nil
	last_pos[plname] = nil
	chat_afk[plname] = nil
	chat_noafk[plname] = nil
end)
