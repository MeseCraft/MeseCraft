local ymax = tonumber(minetest.settings:get("music_nether_ymax")) or -17000
local ymin = tonumber(minetest.settings:get("music_nether_ymin")) or -31000

music_api.register_track({
    name = "nether1",
    length = 185,
    gain = 1,
    day = true,
    night = true,
    ymin = ymin,
    ymax = ymax,
})

music_api.register_track({
    name = "nether2",
    length = 138,
    gain = 1,
    day = true,
    night = true,
    ymin = ymin,
    ymax = ymax,
})

music_api.register_track({
    name = "nether3",
    length = 177,
    gain = 1,
    day = true,
    night = true,
    ymin = ymin,
    ymax = ymax,
})

music_api.register_track({
    name = "nether4",
    length = 205,
    gain = 1,
    day = true,
    night = true,
    ymin = ymin,
    ymax = ymax,
})