local ymax = tonumber(minetest.settings:get("music_dfcaverns_underground3_ymax")) or -1400
local ymin = tonumber(minetest.settings:get("music_dfcaverns_underground3_ymin")) or -31000

music_api.register_track({
    name = "crypto",
    length = 204,
    gain = 1,
    day = true,
    night = true,
    ymin = ymin,
    ymax = ymax,
})

music_api.register_track({
    name = "immersed",
    length = 244,
    gain = 1,
    day = true,
    night = true,
    ymin = ymin,
    ymax = ymax,
})

music_api.register_track({
    name = "lightless_dawn",
    length = 379,
    gain = 1,
    day = true,
    night = true,
    ymin = ymin,
    ymax = ymax,
})

music_api.register_track({
    name = "myst_on_the_moor",
    length = 229,
    gain = 1,
    day = true,
    night = true,
    ymin = ymin,
    ymax = ymax,
})

music_api.register_track({
    name = "shores_of_avalon",
    length = 236,
    gain = 1,
    day = true,
    night = true,
    ymin = ymin,
    ymax = ymax,
})
