if not regional_weather.settings.fire then return end
if not minetest.get_modpath("fire") then return end

climate_api.register_abm({
	label			= "extinguish fire at high humidity",
	nodenames = { "fire:basic_flame" },
	neighbors	= { "air" },
	interval	= 10,
	chance		= 2,
	catch_up	= false,

	 conditions	= {
		 min_height		= regional_weather.settings.min_height,
		 max_height		= regional_weather.settings.max_height,
		 min_humidity	= 55,
		 max_heat			= 85,
		 daylight			= 15,
		 indoors			= false
	 },

	 action = function (pos, node, env)
		 minetest.set_node(pos, { name = "air" })
	 end
})