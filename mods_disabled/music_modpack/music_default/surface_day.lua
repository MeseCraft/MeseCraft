local ymax = tonumber(minetest.settings:get("music_default_surface_ymax")) or 31000
local ymin = tonumber(minetest.settings:get("music_default_surface_ymin")) or -8

music.register_track({
    name = "almost_new",
    length = 202,
    gain = 1,
    day = true,
    night = false,
    ymin = ymin,
    ymax = ymax,
})

music.register_track({
    name = "ascending_the_vale",
    length = 247,
    gain = 1,
    day = true,
    night = false,
    ymin = ymin,
    ymax = ymax,
})

music.register_track({
    name = "disquiet",
    length = 185,
    gain = 1,
    day = true,
    night = false,
    ymin = ymin,
    ymax = ymax,
})

music.register_track({
    name = "silver_blue_light",
    length = 350,
    gain = 1,
    day = true,
    night = false,
    ymin = ymin,
    ymax = ymax,
})

music.register_track({
    name = "windswept",
    length = 208,
    gain = 1,
    day = true,
    night = false,
    ymin = ymin,
    ymax = ymax,
})
