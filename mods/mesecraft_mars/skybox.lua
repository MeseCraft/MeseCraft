local has_skybox_mod = minetest.get_modpath("skybox")
local min_y = mesecraft_mars.y_start
local cave_end_y = mesecraft_mars.y_start + (mesecraft_mars.y_height * 0.97)
local max_y = mesecraft_mars.y_start + mesecraft_mars.y_skybox_height

if has_skybox_mod then
	skybox.register({
		-- http://www.custommapmakers.org/skyboxes.php
		name = "mars",
		miny = cave_end_y,
		maxy = max_y,
		always_day = false,
	        gravity = .37,
		clouds = {
			thickness=64,
			color={r=124, g=124, b=124},
			ambient={r=0, g=0, b=0, a=255},
			density=0.3,
			height=mesecraft_mars.y_start + mesecraft_mars.y_skybox_height - 800,
			speed={y=-2,x=-2}
			},
		sky_type = "plain",
		sky_color = {r=244, g=189, b=114}
	})
	skybox.register({
		name = "mars_cave",
		miny = min_y,
		maxy = cave_end_y,
	        gravity = .37,
		sky_type = "plain",
		always_night = true,
		sky_color = {r=0, g=0, b=0}
	})
end
