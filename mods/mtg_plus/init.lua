mtg_plus = {}

local path = minetest.get_modpath(minetest.get_current_modname())

-- Trivial blocks (full definition included; almost all nodes are full cubes)
dofile(path.."/brickblocks.lua") -- Bricks and blocks

-- Non-trivial blocks (definition require API)
dofile(path.."/xpanes.lua") -- Panes (xpanes mod)
dofile(path.."/ladders.lua") -- Ladders

-- Support for other mods
dofile(path.."/awards.lua") -- Achievements for the awards mod
