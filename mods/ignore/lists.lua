-- Part of the ignore mod
-- Last Modification : 01/18/16 @ 9:00PM UTC+1
-- This file contains all methods/namespaces for loading/saving/managing lists
--

ignore.lists = {}
ignore.lists.data  = {}

function ignore.get_list(name)
	return ignore.lists.data[name]
end

function ignore.get_ignore_names(name)
	if not ignore.lists.data[name] then
		return {}
	end

	local tab = {}
	for n, _ in pairs(ignore.lists.data[name]) do
		table.insert(tab, n)
	end
	return tab
end

function ignore.set_list(name, list)
	ignore.lists.data[name] = list
	minetest.log("action", "[Ignore] Set list of player " .. name)
	return true
end

function ignore.del_list(name)
	ignore.lists.data[name] = nil
	minetest.log("action", "[Ignore] Deleted list of player " .. name)
	return true
end

function ignore.init_list(name)
	ignore.lists.data[name] = {}
	minetest.log("action", "[Ignore] Init on list for player " .. name)
	return true
end

function ignore.get_ignore(ignored, name)
	if not ignore.lists.data[name] then
		local res, code = ignore.load(name)
		if not res and code then
			return false, code
		else
			return ignore.get_ignore(ignored, name)
		end
	end

	return ignore.lists.data[name][ignored]
end

function ignore.add(ignored, name)
	if not ignore.lists.data[name] then
		ignore.init_list(name)
		return ignore.add(ignored, name)
		-- ^ Crooked
	end

	if ignore.get_ignore(ignored, name) then
		minetest.log("action", "[Ignore] Will not add " .. ignored .. " in list of player " .. name .. " : already present")
		return false, "dejavu"
	elseif minetest.get_player_privs(ignored).ignore_protection then
		minetest.log("action", "[Ignore] Will not add " .. ignored .. " in list of player " .. name .. " : player protected")
		return false, "protected"
	end

	ignore.lists.data[name][ignored] = os.time()
	minetest.log("action", "[Ignore] Adding " .. ignored .. " in " .. name .. "'s list")

	return true
end

function ignore.del(ignored, name)
	if not ignore.lists.data[name] then
		minetest.log("action", "[Ignore] Will not remove " .. ignored .. " from " .. name .. "'s list : no ignore list")
		return false, "nolist"
	end

	local status = ignore.get_ignore(ignored, name)
	if not status then
		minetest.log("action", "[Ignore] Couldn't remove " .. ignored .. " from " .. name .. "'s list : not currently ignored")
		return false, "notignored"
	else
		minetest.log("action", "[Ignore] Successfully removed " .. ignored .. " from " .. name .. "'s list")
		ignore.lists.data[name][ignored] = nil
		return true
	end
end

function ignore.save(name)
	if not ignore.lists.data[name] then
		minetest.log("action", "[Ignore] Saving list of " .. name .. " : inexistant list")
		ignore.init_list(name)
	end

	local f, err = io.open(ignore.config.save_dir .. "/" .. name, 'w')
	if not f then
		minetest.log("error", "[Ignore] Failed to save " .. name .. "'s list : " .. err)
		return false, err
	end

	for ignored, timestamp in pairs(ignore.lists.data[name]) do
		f:write(("%s %s\n"):format(ignored, timestamp))
	end
	f:close()

	minetest.log("action", "[Ignore] Ignore list saved for " .. name)
	return true
end

function ignore.load(name)
	ignore.init_list(name)

	local f, err = io.open(ignore.config.save_dir .. "/" .. name)
	if not f then
		minetest.log("error", "[Ignore] Failed to load " .. name .. "'s list : " .. err)
		return false, err
	end

	for line in f:lines() do
		local ignored, timestamp
		ignored = line:split(" ")[1]
		timestamp = line:split(" ")[2]

		if not ignored or not timestamp then
			f:close()
			minetest.log("error", "[Ignore] Error reading " .. name .. "'s list : corrupted file")
			minetest.chat_send_player(name, "Error: Your file might be corrupted")
			return false, line
		end
		ignore.lists.data[name][ignored] = timestamp
	end

	minetest.log("action", "Successfully logged " .. name .. "'s file")
	f:close()
	return true
end
