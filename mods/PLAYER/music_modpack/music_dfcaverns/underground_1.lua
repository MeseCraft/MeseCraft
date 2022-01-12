local ymax = tonumber(minetest.settings:get("music_dfcaverns_underground1_ymax")) or -8
local ymin = tonumber(minetest.settings:get("music_dfcaverns_underground1_ymin")) or -800

music_api.register_track({
    name = "floating_cities",
    length = 184,
    gain = 1,
    day = true,
    night = true,
    ymin = ymin,
    ymax = ymax,
})

music_api.register_track({
    name = "infados",
    length = 223,
    gain = 1,
    day = true,
    night = true,
    ymin = ymin,
    ymax = ymax,
})

music_api.register_track({
    name = "morgana_rides",
    length = 246,
    gain = 1,
    day = true,
    night = true,
    ymin = ymin,
    ymax = ymax,
})

music_api.register_track({
    name = "thunderbird",
    length = 361,
    gain = 1,
    day = true,
    night = true,
    ymin = ymin,
    ymax = ymax,
})
