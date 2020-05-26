

jumpdrive.locator_compat = function(from, to)
	local meta = minetest.get_meta(to)
	locator.remove_beacon(from)
	locator.update_beacon(to, meta)
end

