local state = minetest.get_mod_storage()

if not state:contains("heat_random") then
	state:from_table({
		heat_random = 1,
		humidity_random = 1,
		humidity_base = 50,
		wind_x = 0.5,
		wind_z = 0.5
	})
end

return state