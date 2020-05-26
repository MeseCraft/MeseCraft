
jumpdrive.technic_run = function(pos, node)
	local meta = minetest.get_meta(pos)
	jumpdrive.migrate_engine_meta(pos, meta)

	local eu_input = meta:get_int("HV_EU_input")
	local store = meta:get_int("powerstorage")
	local power_requirement = meta:get_int("power_requirement")
	local max_store = meta:get_int("max_powerstorage")

	if store < max_store then
		-- charge
		meta:set_int("HV_EU_demand", power_requirement)
		store = store + eu_input
		meta:set_int("powerstorage", math.min(store, max_store))
	else
		-- charged
		meta:set_int("HV_EU_demand", 0)
	end

	jumpdrive.update_infotext(meta, pos)
end
