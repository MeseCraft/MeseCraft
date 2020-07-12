--[[
Part of the ignore mod
Last Modification: 01/18/16 @ 9:01PM UTC+1
This file contains the ignore callback
--]]

function ignore.callback(sender, message)

	-- 1) The engine's job
	-- Invalid command handler (which should be in the builtin btw)
	if message == "/" then
		minetest.chat_send_player(sender, "-!- Empty command")
		return true
	end
	local cmd, _ = message:match("^/([^ ]+) *(.*)")
	if cmd and not core.chatcommands[cmd] then
		minetest.chat_send_player(sender, "-!- Invalid command: " .. cmd)
		return true
	elseif not minetest.check_player_privs(sender, {shout = true}) then
		minetest.chat_send_player(sender, "-!- You don't have permission to shout.")
		return true
	end

	-- Normal log handler
	minetest.log("action", ("CHAT: <%s> %s"):format(sender, message))

	-- Execute other callbacks (remember we don't want to block them)
	-- First, identify our range in the callback table
	local index = 0
	for i, func in pairs(core.registered_on_chat_messages) do
		if func == ignore.callback then
			index = i
			break
		end
	end

	for i = index+1, table.getn(core.registered_on_chat_messages) do
		if (not minetest.global_exists("chatdam") or core.registered_on_chat_messages[i] ~= chatdam.floodcontrol) then
			local ret = core.registered_on_chat_messages[i](sender, message)
			if ret then
				-- If other mods decide to block callbacks that's their choice
				break
			end
		end
	end


	-- Finally, send and sort according to ignores
	for k, ref in pairs(minetest.get_connected_players()) do
		local receiver = ref:get_player_name()
		local vtable = minetest.get_version().string:split('-')[1]:split('.')
		if (receiver ~= sender or (tonumber(vtable[1]) > 0 or tonumber(vtable[2]) > 4 or tonumber(vtable[3]) >= 15)) and not ignore.get_ignore(sender, receiver) then
			-- Small note :
			-- In VERSION < 0.4.16, a client would see their own message in chat before the server acknowledged them, so the server wouldn't send it to them, and we didn't either
			-- In VERSION >= 0.4.16, a client would receive the server packet indicating a chat message before showing even the player's own message : we need to send them
			minetest.chat_send_player(receiver, ("<%s> %s"):format(sender, message))
		end
	end	

	return true -- Tell the engine we did its job
end

minetest.register_on_chat_message(ignore.callback)

-- Override on /me
local old_me_callback = core.chatcommands["me"].func
core.chatcommands["me"].func = function(name, param)
	for _, p in pairs(minetest.get_connected_players()) do
		if not ignore.get_ignore(name, p:get_player_name()) then
			minetest.chat_send_player(p:get_player_name(), ("* %s %s"):format(name, param))
		end
	end
end
