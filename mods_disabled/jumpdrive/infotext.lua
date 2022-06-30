local has_technic = minetest.get_modpath("technic")

jumpdrive.update_infotext = function(meta, pos)
	local store = meta:get_int("powerstorage")
	local max_store = meta:get_int("max_powerstorage")

	if has_technic then
		local eu_input = meta:get_int("HV_EU_input")
		local demand = meta:get_int("HV_EU_demand")

		meta:set_string("infotext", "Power: " .. eu_input .. "/" .. demand .. " Store: " .. store .. "/" .. max_store)
	else
		meta:set_string("infotext", "Store: " .. store .. "/" .. max_store)
	end
end