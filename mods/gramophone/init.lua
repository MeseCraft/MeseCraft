-- Gramophone mod by Zorman2000
-- Compatible with Minetest 0.4.14 and later
--
-- Similar to a Minecraft jukebox, but better :)
-- Includes API for registering music discs and music players.
-- Also, includes a disc shelf (caution: not lightweight in any sense!)

local path = minetest.get_modpath("gramophone")

dofile(path .. "/api.lua")
dofile(path .. "/nodes.lua")
dofile(path .. "/shelf.lua")
dofile(path .. "/default_music.lua")
dofile(path .. "/christmas_music.lua")
