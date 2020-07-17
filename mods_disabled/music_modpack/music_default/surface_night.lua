local min_default = -31000
if minetest.get_modpath("music_dfcaverns") then
    min_default = -8
end

local ymax = minetest.settings:get("music_default_surface_ymax") or 31000
local ymin = minetest.settings:get("music_default_surface_ymin") or min_default

music.register_track({
    name = "anguish",
    length = 259,
    gain = 1,
    day = false,
    night = true,
    ymin = ymin,
    ymax = ymax,
})

music.register_track({
    name = "bittersweet",
    length = 202,
    gain = 1,
    day = false,
    night = true,
    ymin = ymin,
    ymax = ymax,
})

music.register_track({
    name = "heavy_heart",
    length = 296,
    gain = 1,
    day = false,
    night = true,
    ymin = ymin,
    ymax = ymax,
})

music.register_track({
    name = "magic_forest",
    length = 260,
    gain = 1,
    day = false,
    night = true,
    ymin = ymin,
    ymax = ymax,
})

music.register_track({
    name = "march_of_the_wind",
    length = 167,
    gain = 1,
    day = false,
    night = true,
    ymin = ymin,
    ymax = ymax,
})

music.register_track({
    name = "snowdrop",
    length = 278,
    gain = 1,
    day = false,
    night = true,
    ymin = ymin,
    ymax = ymax,
})

