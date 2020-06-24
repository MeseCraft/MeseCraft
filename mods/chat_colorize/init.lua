local green = minetest.get_color_escape_sequence("#00ff00")
local white = minetest.get_color_escape_sequence("#ffffff")

minetest.register_on_chat_message(function(name, message)

	-- If there is no message part then we do nothing and exit the function.
	if not message then
		return
	end

	-- If the player does not have permissions for "shout" then we do nothing and exit the function.
	if not minetest.get_player_privs(name).shout then
		return true
	end

	-- Use gsub function to do something?
	message = message:gsub("%s+", " ")
	-- Format the message with color and send it to the chat.
	minetest.chat_send_all("<" .. green .. name .. white .. "> " .. message)
	-- Add the message to the server log as well.
	minetest.log("action", "<" .. name .. "> " .. message)
	-- Exit the function
	return true
end)
