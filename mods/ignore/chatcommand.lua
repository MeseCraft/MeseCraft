--[[ 
Part of the ignore mod
Last Modification : 01/18/16 @ 9:03PM UTC+1
This file contains the ignore chatcommand
And also, the ignore_protection privilege
--]]

minetest.register_privilege("ignore_protection", {
	description = "Players with this privilege cannot be ignored",
	give_to_singleplayer = false,
	give_to_admin = true,	
})

minetest.register_chatcommand("ignore", {
	description = "Manage ignore list",
	params = "<add | del | show | init | check | <help> [<name>]",
	privs = {shout = true},
	func = function(name, param)
		if not ignore.get_list(name) then
			ignore.load(name)
		end

		if param == "" then
			return false, "Use '/help ignore' or '/ignore help' to show ignore's help"
		end

		local params = param:split(" ")
		local cmd = params[1]

		if cmd == "help" then
			return true, "Ignore's help : \n" ..
				"- /ignore help : Show this help\n" ..
				"- /ignore add name : Add name in your ignore list\n" ..
				"- /ignore del name : Remove name from your ignore list\n" ..
				"- /ignore show : Print your entire ignore list\n" ..
				"- /ignore init : Reset your ignore list\n" ..
				"- /ignore check name : Checks whether or not player 'name' is ignoring you"

		elseif cmd == "add" or cmd == "+" then
			if not params[2] then
				return false, "Ignore's add subcommand needs a parameter : the player's name"
			end

			local res, code = ignore.add(params[2], name)
			if res then
				ignore.queue.add({type = "save", target = name})
				return true, "Successfully added " .. params[2] .. " to your ignore list"
			elseif code == "dejavu" then
				return true, params[2] .. " is already in your ignore list"
			elseif code == "protected" then
				return true, params[2] .. " is protected. You cannot ignore them"
			end

		elseif cmd == "del" or cmd == "-" then
			if not params[2] then
				return false, "Ignore's del subcommand needs a parameter : the player's name"
			end

			local res = ignore.del(params[2], name)
			if res then
				ignore.queue.add({type = "save", target = name})
				return true, "Successfully removed " .. params[2] .. " from your ignore list"
			else
				return true, params[2] .. " is not in your ignore list"
			end

		elseif cmd == "show" then
			if not ignore.get_list(name) or table.getn(ignore.get_ignore_names(name)) == 0 then
				return true, "Your ignore list is currently empty"
			end

			local res = "Your ignore list :"
			for name, time in pairs(ignore.get_list(name)) do
				res = res .. "\n- " .. name .. " : ignored on " .. os.date("%m/%d/%Y at %r", time)
			end

			return true, res

		elseif cmd == "init" then
			ignore.init_list(name)
			ignore.queue.add({type = "save", target = name})
			return true, "Successfully reset your ignore list"

		elseif cmd == "check" then
			if not params[2] then
				return false, "Please provide a player's name"
			end

			local res, code = ignore.get_ignore(name, params[2])
			if res then
				return true, "Player " .. params[2] .. " is ignoring you"
			elseif not code then
				return true, "You are not on " .. params[2] .. "'s ignore list"
			else
				return true, "This player doesn't appear to have any ignore list"
			end

		else
			return false, "Unknown subcommand " .. cmd .. ". See '/help ignore' or '/ignore help' for help on this command"
		end
	end
})
