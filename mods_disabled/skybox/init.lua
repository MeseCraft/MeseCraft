
skybox = {
  list = {},

  -- map name -> bool
  ignore_players = {}
}

local MP = minetest.get_modpath("skybox")
dofile(MP.."/register.lua")
dofile(MP.."/defaults.lua")
dofile(MP.."/skybox.lua")
dofile(MP.."/compat.lua")
