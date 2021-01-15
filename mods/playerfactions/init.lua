-- Translation support
local S = minetest.get_translator("playerfactions")

minetest.register_privilege("playerfactions_admin", {description = S("Allow the use of all playerfactions commands"), give_to_singleplayer = false})

-- Data
factions = {}
-- This variable "version" can be used by other mods to check the compatibility of this mod
factions.version = 2

local facts = {}
local storage = minetest.get_mod_storage()
if storage:get_string("facts") ~= "" then
	facts = minetest.deserialize(storage:get_string("facts"))
end
-- Fix factions
for fname, fact in pairs(facts) do
	if fact.members == nil then
		fact.members = {}
	end
end

factions.mode_unique_faction = minetest.settings:get_bool("player_factions.mode_unique_faction", true)
factions.max_members_list = tonumber(minetest.settings:get("player_factions.max_members_list")) or 50



local function save_factions()
	storage:set_string("facts", minetest.serialize(facts))
end

local function table_copy(data)
	local copy = {}
	if type(data) == "table" then
		for k,v in pairs(data) do
			copy[k]=table_copy(v)
		end
		return copy
	else
		return data
	end
end


-- Data manipulation
function factions.get_facts()
	return table_copy(facts)
end

function factions.player_is_in_faction(fname, player_name)
	if not minetest.player_exists(player_name) or facts[fname] == nil then
		return false
	end
	return facts[fname].members[player_name]
end

function factions.get_player_faction(name)
	if not minetest.player_exists(name) then
		return false
	end
	minetest.log("warning", "Function factions.get_player_faction() is deprecated in favor of factions.get_player_factions(). Please check updates of mods depending on playerfactions.")
	for fname, fact in pairs(facts) do
		if fact.members[name] then
			return fname
		end
	end
	return nil
end

function factions.get_player_factions(name)
	if not minetest.player_exists(name) then
		return false
	end
	local player_factions = nil
	for fname, fact in pairs(facts) do
		if fact.members[name] then
			if not player_factions then
				player_factions = {}
			end
			table.insert(player_factions, fname)
		end
	end
	return player_factions
end

function factions.get_owned_factions(name)
	local own_factions = nil
	for fname, fact in pairs(facts) do
		if fact.owner == name then
			if not own_factions then
				own_factions = {}
			end
			table.insert(own_factions, fname)
		end
	end
	return own_factions
end

function factions.get_administered_factions(name)
	local adm_factions = nil
	for fname, fact in pairs(facts) do
		if minetest.get_player_privs(name).playerfactions_admin or fact.owner == name then
			if not adm_factions then
				adm_factions = {}
			end
			table.insert(adm_factions, fname)
		end
	end
	return adm_factions
end

function factions.get_owner(fname)
	if facts[fname] == nil then
		return false
	end
	return facts[fname].owner
end

function factions.chown(fname, owner)
	if facts[fname] == nil then
		return false
	end
	facts[fname].owner = owner
	save_factions()
	return true
end

function factions.register_faction(fname, founder, pw)
	if facts[fname] ~= nil then
		return false
	end
	facts[fname] = {
		name = fname,
		owner = founder,
		password = pw,
		members = {[founder] = true}
	}
	save_factions()
	return true
end

function factions.disband_faction(fname)
	if facts[fname] == nil then
		return false
	end
	facts[fname] = nil
	save_factions()
	return true
end

function factions.get_password(fname)
	if facts[fname] == nil then
		return false
	end
	return facts[fname].password
end

function factions.set_password(fname, password)
	if facts[fname] == nil then
		return false
	end
	facts[fname].password = password
	save_factions()
	return true
end

function factions.join_faction(fname, player)
	if facts[fname] == nil or not minetest.player_exists(player) then
		return false
	end
	facts[fname].members[player] = true
	save_factions()
	return true
end

function factions.leave_faction(fname, player_name)
	if facts[fname] == nil or not minetest.player_exists(player_name) then
		return false
	end
	facts[fname].members[player_name] = nil
	save_factions()
	return true
end

-- Chat commands
local function handle_command(name, param)
	local params = {}
	for p in string.gmatch(param, "[^%s]+") do
		table.insert(params, p)
	end
	if params == nil then
		minetest.chat_send_player(name, S("Unknown subcommand. Run '/help factions' for help."))
	end
	local action = params[1]
	if action == "create" then
		local faction_name = params[2]
		local password = params[3]
		if factions.mode_unique_faction and factions.get_player_faction(name) ~= nil then
			minetest.chat_send_player(name, S("You are already in a faction."))
		elseif faction_name == nil then
			minetest.chat_send_player(name, S("Missing faction name."))
		elseif password == nil then
			minetest.chat_send_player(name, S("Missing password."))
		elseif facts[faction_name] ~= nil then
			minetest.chat_send_player(name, S("That faction already exists."))
		else
			factions.register_faction(faction_name, name, password)
			minetest.chat_send_player(name, S("Registered @1.", faction_name))
			return true
		end
	elseif action == "disband" then
		local password = nil
		local faction_name = nil
		local own_factions = factions.get_administered_factions(name)
		local number_factions = #own_factions
		if number_factions == 0 then
			minetest.chat_send_player(name, S("You are the owner of no faction."))
			return false
		elseif #params == 1 then
			minetest.chat_send_player(name, S("Missing password."))
			return false
		elseif #params == 2 and number_factions == 1 then
			password = params[2]
			faction_name = own_factions[1]
		elseif #params >= 3 then
			faction_name = params[3]
			password = params[2]
		end
		if password == nil then
			minetest.chat_send_player(name, S("Missing password."))
		elseif faction_name == nil then
			minetest.chat_send_player(name, S("You are the owner of many factions, you have to choose one of them: @1.", table.concat(own_factions, ", ")))
		elseif not facts[faction_name] then
			minetest.chat_send_player(name, S("This faction doesn't exists."))
		elseif name ~= factions.get_owner(faction_name) and not minetest.get_player_privs(name).playerfactions_admin then
			minetest.chat_send_player(name, S("Permission denied: You are not the owner of this faction, and don't have the playerfactions_admin privilege."))
		elseif password ~= factions.get_password(faction_name) then
			minetest.chat_send_player(name, S("Permission denied: Wrong password."))
		else
			factions.disband_faction(faction_name)
			minetest.chat_send_player(name, S("Disbanded @1.", faction_name))
			return true
		end
	elseif action == "list" then
		local faction_list = {}
		for k, f in pairs(facts) do
			table.insert(faction_list, k)
		end
		if #faction_list ~= 0 then
			minetest.chat_send_player(name, S("Factions (@1): @2.", #faction_list, table.concat(faction_list, ", ")))
		else
			minetest.chat_send_player(name, S("There are no factions yet."))
		end
		return true
	elseif action == "info" then
		local faction_name = params[2]
		if faction_name == nil then
			local player_factions = factions.get_player_factions(name) or {}
			if #player_factions == 1 then
				faction_name = player_factions[1]
			elseif #player_factions == 0 then
				minetest.chat_send_player(name, S("You are not a member of a faction."))
			else
				minetest.chat_send_player(name, S("You are in many factions, you have to choose one of them: @1.", table.concat(player_factions, ", ")))
				return false
			end
		elseif facts[faction_name] == nil then
			minetest.chat_send_player(name, S("This faction doesn't exists."))
		else
			local fmembers = ""
			if table.getn(facts[faction_name].members) > factions.max_members_list then
				fmembers = S("The faction has more than @1 members, the members list can't be shown.", factions.max_members_list)
			else
				for play,_ in pairs(facts[faction_name].members) do
					if fmembers == "" then
						fmembers = play
					else
						fmembers = fmembers..", "..play
					end
				end
			end
			minetest.chat_send_player(name, S("Name: @1\nOwner: @2\nMembers: @3", faction_name, factions.get_owner(faction_name), fmembers))
			if factions.get_owner(faction_name) == name or minetest.get_player_privs(name).playerfactions_admin then
				minetest.chat_send_player(name, S("Password: @1", factions.get_password(faction_name)))
			end
		end
	elseif action == "player_info" then
		local player_name = params[2]
		local player_factions = factions.get_player_factions(player_name)
		if not player_factions then
			minetest.chat_send_player(name, S("This player doesn't exists or is in no faction"))
			return false
		else
			local str_owner = ""
			local str_member = ""
			for _,v in ipairs(player_factions) do
				if str_member == "" then
					str_member = str_member..v
				else
					str_member = str_member..", "..v
				end
			end
			minetest.chat_send_player(name, "@1 is in the following factions: @2.", player_name, str_member, str_owner)
			local owned_factions = factions.get_owned_factions(player_name)
			if not owned_factions then
				minetest.chat_send_player(name, S("This player is the owner of no faction."))
			else
				for _,v in ipairs(owned_factions) do
					if str_owner == "" then
						str_owner = str_owner..v
					else
						str_owner = str_owner..", "..v
					end
				end
				minetest.chat_send_player(name, S("This player is the owner of the following factions: @1.", str_owner))
			end
			if minetest.get_player_privs(player_name).playerfactions_admin then
				minetest.chat_send_player(name, S("@1 has the playerfactions_admin privilege so they can admin every faction.", player_name))
			end
		end
	elseif action == "join" then
		local faction_name = params[2]
		local password = params[3]
		if factions.get_player_faction(name) ~= nil and factions.mode_unique_faction then
			minetest.chat_send_player(name, S("You are already in a faction."))
		elseif facts[faction_name] == nil then
			minetest.chat_send_player(name, S("The faction @1 doesn't exist.", faction_name))
		elseif factions.get_password(faction_name) ~= password then
			minetest.chat_send_player(name, S("Permission denied: Wrong password."))
		else
			if factions.join_faction(faction_name, name) then
				minetest.chat_send_player(name, S("Joined @1.", faction_name))
				return true
			else
				minetest.chat_send_player(name, S("Error on joining."))
				return false
			end
		end
	elseif action == "leave" then
		local player_factions = factions.get_player_factions(name)
		local number_factions = table.getn(player_factions)
		local faction_name = nil
		if number_factions == 0 then
			minetest.chat_send_player(name, S("You are not in a faction."))
			return false
		elseif #params == 1 then
		 	if number_factions == 1 then
				faction_name = player_factions[1]
			else
				minetest.chat_send_player(name, S("You are in many factions, you have to choose one of them: @1.", table.concat(player_factions, ", ")))
				return false
			end
		elseif #params >= 1 and facts[params[2]] ~= nil then
			faction_name = params[2]
		end
		if faction_name == nil then
			minetest.chat_send_player(name, S("The given faction doesn't exists."))
		elseif factions.get_owner(faction_name) == name then
			minetest.chat_send_player(name, S("You cannot leave your own faction, change owner or disband it."))
		else
			if factions.leave_faction(faction_name, name) then
				minetest.chat_send_player(name, S("Left @1.", faction_name))
				return true
			else
				minetest.chat_send_player(name, S("Error on leaving faction."))
				return false
			end
		end
	elseif action == "kick" then
		local target = nil
		local faction_name = nil
		local own_factions = factions.get_administered_factions(name)
		local number_factions = table.getn(own_factions)
		if number_factions == 0 then
			minetest.chat_send_player(name, S("You are the owner of no faction, you can't use this command."))
			return false
		elseif #params == 2 and number_factions == 1 then
			target = params[2]
			faction_name = own_factions[1]
		elseif #params >= 3 then
			faction_name = params[3]
			target = params[2]
		end
		if faction_name == nil then
			minetest.chat_send_player(name, S("You are the owner of many factions, you have to choose one of them: @1.", table.concat(own_factions, ", ")))
		elseif target == nil then
			minetest.chat_send_player(name, S("Missing player name."))
		elseif factions.get_owner(faction_name) ~= name and not minetest.get_player_privs(name).playerfactions_admin then
			minetest.chat_send_player(name, S("Permission denied: You are not the owner of this faction, and don't have the playerfactions_admin privilege."))
		elseif not facts[faction_name].members[target] then
			minetest.chat_send_player(name, S("This player is not in the specified faction."))
		elseif target == factions.get_owner(faction_name) then
			minetest.chat_send_player(name, S("You cannot kick the owner of a faction, use '/factions chown <player> [faction]' to change the ownership."))
		else
			if factions.leave_faction(faction_name, target) then
				minetest.chat_send_player(name, S("Kicked @1 from faction.", target))
				return true
			else
				minetest.chat_send_player(name, S("Error kicking @1 from faction.", target))
				return false
			end
		end
	elseif action == "passwd" then
		local password = nil
		local faction_name = nil
		local own_factions = factions.get_administered_factions(name)
		local number_factions = table.getn(own_factions)
		if #params == 1 then
			minetest.chat_send_player(name, S("Missing password."))
			return false
		elseif number_factions == 0 then
			minetest.chat_send_player(name, S("You are the owner of no faction, you can't use this command."))
			return false
		elseif #params == 2 and number_factions == 1 then
			password = params[2]
			faction_name = own_factions[1]
		elseif #params >= 3 then
			faction_name = params[3]
			password = params[2]
		end
		if faction_name == nil then
			minetest.chat_send_player(name, S("You are the owner of many factions, you have to choose one of them: @1.", table.concat(own_factions, ", ")))
		elseif password == nil then
			minetest.chat_send_player(name, S("Missing password."))
		elseif factions.get_owner(faction_name) ~= name and not minetest.get_player_privs(name).playerfactions_admin then
			minetest.chat_send_player(name, S("Permission denied: You are not the owner of this faction, and don't have the playerfactions_admin privilege."))
		else
			if factions.set_password(faction_name, password) then
				minetest.chat_send_player(name, S("Password has been updated."))
				return true
			else
				minetest.chat_send_player(name, S("Failed to change password."))
				return false
			end
		end
	elseif action == "chown" then
		local own_factions = factions.get_administered_factions(name)
		local number_factions = table.getn(own_factions)
		local faction_name = nil
		local target = nil
		local password = nil
		if #params < 3 then
			if params[2] ~= nil and minetest.player_exists(params[2]) then
				minetest.chat_send_player(name, S("Missing password."))
				return false
			else
				minetest.chat_send_player(name, S("Missing player name."))
				return false
			end
		elseif number_factions == 0 then
			minetest.chat_send_player(name, S("You are the owner of no faction, you can't use this command."))
			return false
		elseif number_factions == 1 and #params == 3 then
			faction_name = own_factions[1]
			target = params[2]
			password = params[3]
		elseif #params >= 4 then
			faction_name = params[4]
			target = params[2]
			password = params[3]
		end
		if faction_name == nil then
			minetest.chat_send_player(name, S("You are the owner of many factions, you have to choose one of them: @1.", table.concat(own_factions, ", ")))
		elseif target == nil then
			minetest.chat_send_player(name, S("Missing player name."))
		elseif password == nil then
			minetest.chat_send_player(name, S("Missing password."))
		elseif name ~= factions.get_owner(faction_name) and not minetest.get_player_privs(name).playerfactions_admin then
			minetest.chat_send_player(name, S("Permission denied: You are not the owner of this faction, and don't have the playerfactions_admin privilege."))
		elseif not facts[faction_name].members[target] then
			minetest.chat_send_player(name, S("@1 isn't in your faction.", target))
		elseif password ~= factions.get_password(faction_name) then
			minetest.chat_send_player(name, S("Permission denied: Wrong password."))
		else
			if factions.chown(faction_name, target) then
				minetest.chat_send_player(name, S("Ownership has been transferred to @1.", target))
				return true
			else
				minetest.chat_send_player(name, S("Failed to transfer ownership."))
				return false
			end
		end
	elseif action == "invite" then
		if not minetest.get_player_privs(name).playerfactions_admin then
			minetest.chat_send_player(name, S("Permission denied: You can't use this command, playerfactions_admin priv is needed."))
		else
			local target = params[2]
			local faction_name = params[3]
			if facts[faction_name] == nil then
				minetest.chat_send_player(name, S("The faction @1 doesn't exist.", faction_name))
			elseif not minetest.player_exists(target) then
				minetest.chat_send_player(name, S("The player doesn't exist."))
			elseif factions.mode_unique_faction and factions.get_player_faction(target) ~= nil then
				minetest.chat_send_player(name, S("The player is already in the faction \"@1\".",factions.get_player_faction(target)))
			else
				if factions.join_faction(faction_name, target) then
					minetest.chat_send_player(name, S("@1 is now a member of the faction @2.", target, faction_name))
					return true
				else
					minetest.chat_send_player(name, S("Error on adding @1 into @2.", target, faction_name))
					return true
				end
			end
		end
	else
		minetest.chat_send_player(name, S("Unknown subcommand. Run '/help factions' for help."))
	end
	return false
end

minetest.register_chatcommand("factions", {
	params = "create <faction> <password>: "..S("Create a new faction").."\n"
	.."list: "..S("List available factions").."\n"
	.."info <faction>: "..S("See information on a faction").."\n"
	.."player_info <player>: "..S("See information on a player").."\n"
	.."join <faction> <password>: "..S("Join an existing faction").."\n"
	.."leave [faction]: "..S("Leave your faction").."\n"
	.."kick <player> [faction]: "..S("Kick someone from your faction or from the given faction").."\n"
	.."disband <password> [faction]: "..S("Disband your faction or the given faction").."\n"
	.."passwd <password> [faction]: "..S("Change your faction's password or the password of the given faction").."\n"
	.."chown <player> [faction]: "..S("Transfer ownership of your faction").."\n"
	.."invite <player> <faction>: "..S("Add player to a faction, you need playerfactions_admin privs").."\n",

	description = "",
	privs = {},
	func = handle_command
})
