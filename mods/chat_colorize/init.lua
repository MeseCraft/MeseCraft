local green = minetest.get_color_escape_sequence("#00ff00")
local white = minetest.get_color_escape_sequence("#ffffff")

minetest.register_on_chat_message(function(name, message)

	if not message then
		return
	end

	if not minetest.get_player_privs(name).shout then
		return true
	end

	local msg = message:lower()

	message = message:gsub("%s+", " ")
	minetest.chat_send_all("<" .. green .. name .. white .. "> " .. message)
	minetest.log("action", "<" .. name .. "> " .. message)

	return true
end)
