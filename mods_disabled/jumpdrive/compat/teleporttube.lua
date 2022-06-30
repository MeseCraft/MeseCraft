

if not pipeworks.tptube then
	minetest.log("warning", "[jumpdrive] pipeworks teleport patch not applied, tp-tubes don't work as expected!")
end


-- https://gitlab.com/VanessaE/pipeworks/blob/master/teleport_tube.lua
jumpdrive.teleporttube_compat = function(from, to)
	if not pipeworks.tptube then
		-- only works with the patch from "./patches/pipeworks.patch"
		return
	end

	local from_hash = pipeworks.tptube.hash(from)
	local to_hash = pipeworks.tptube.hash(to)

	-- swap data
	local db = pipeworks.tptube.get_db()
	local data = db[from_hash]

	if not data then
		minetest.log("warning", "[jumpdrive] no tp-tube data found at hash: " ..
			from_hash .. " / pos: " .. minetest.pos_to_string(from))
		return
	end

	minetest.log("action", "[jumpdrive] moving tp-tube data from " ..
		from_hash .. " to " .. to_hash .. " at pos: " .. minetest.pos_to_string(from))

	data.x = to.x
	data.y = to.y
	data.z = to.z

	db[from_hash] = nil
	db[to_hash] = data

end

jumpdrive.teleporttube_compat_commit = function()
	if not pipeworks.tptube then
		-- only works with the patch from "./patches/pipeworks.patch"
		return
	end

	pipeworks.tptube.save_tube_db()
end
