if not regional_weather.settings.pedology
or not minetest.get_modpath("pedology")
then return end

climate_api.register_abm({
	label			= "wetten or dry pedology nodes",
	nodenames = { "group:sucky" },
	neighbors = { "air" },
	interval	= 25,
	chance		= 30,
	catch_up	= false,

	conditions	= {
		min_height		= regional_weather.settings.min_height,
		max_height		= regional_weather.settings.max_height,
		min_heat			= 25,
		daylight			= 15,
		indoors				= false,
	},

	action = function (pos, node, env)
		local wetness = minetest.get_item_group(node.name, "wet") or 0
		if wetness < 2 and env.humidity > 55 then
			pedology.wetten(pos)
		elseif wetness > 0 and wetness < 3 and env.humidity < 40 then
			pedology.dry(pos)
		end
	end
})