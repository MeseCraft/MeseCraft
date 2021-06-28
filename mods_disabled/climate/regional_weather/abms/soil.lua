if not regional_weather.settings.soil then return end
if not minetest.get_modpath("farming") then return end

if farming ~= nil and farming.mod == "redo" then
	climate_api.register_abm({
		label			= "wetten soil at high humidity",
		nodenames = { "farming:soil" },
		interval	= 8,
		chance		= 2,
		catch_up	= false,

		 conditions	= {
			 min_height		= regional_weather.settings.min_height,
			 max_height		= regional_weather.settings.max_height,
			 min_humidity	= 55,
			 min_heat			= 30,
			 daylight			= 15,
			 indoors			= false
		 },

	   action = function (pos, node, env)
			 minetest.set_node(pos, { name = "farming:soil_wet" })
		 end
	})

else
	climate_api.register_abm({
		label			= "wetten fields at high humidity",
		nodenames = { "group:field" },
		interval	= 8,
		chance		= 2,
		catch_up	= false,

		 conditions	= {
			 min_height		= regional_weather.settings.min_height,
			 max_height		= regional_weather.settings.max_height,
			 min_humidity	= 55,
			 min_heat			= 30,
			 daylight			= 15,
			 indoors			= false
		 },

	   action = function (pos, node, env)
			 local node_def = minetest.registered_nodes[node.name] or nil
			 local wet_soil = node_def.soil.wet or nil
			 if wet_soil == nil then return end
			 minetest.set_node(pos, { name = wet_soil })
		 end
	})
end