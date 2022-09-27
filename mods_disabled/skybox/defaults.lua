
local default_moon = { visible = true }
local default_sun = { visible = true, sunrise_visible = true }
local default_stars = { visible = true }

local default_clouds = {
    thickness=16,
    color={r=243, g=214, b=255, a=229},
    ambient={r=0, g=0, b=0, a=255},
    density=0.4,
    height=200,
    speed={y=-2,x=-1}
}

local default_sky = {
    clouds = true,
    type = "regular",
    sky_color = {
        day_sky = "#61b5f5",
        day_horizon = "#90d3f6",
        dawn_sky = "#b4bafa",
        dawn_horizon = "#bac1f0",
        night_sky = "#006bff",
        night_horizon = "#4090ff",
        indoors = "#646464",
        fog_tint_type = "default",
    }
}

function skybox.set_defaults(defaults)
    default_moon = defaults.moon or default_moon
    default_sun = defaults.sun or default_sun
    default_stars = defaults.stars or default_stars
    default_clouds = defaults.clouds or default_clouds
    default_sky = defaults.sky or default_sky
end

-- sets the default skybox for the player
function skybox.set_default_skybox(player)
	player:override_day_night_ratio(nil)

	-- https://github.com/minetest/minetest/blob/4a3728d828fa8896b49e80fdc68f5d7647bf45b7/src/skyparams.h#L75-L88
	player:set_sky(default_sky)
	player:set_moon(default_moon)
	player:set_sun(default_sun)
	player:set_stars(default_stars)
	player:set_clouds(default_clouds)

end