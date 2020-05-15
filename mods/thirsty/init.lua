--[[

Thirsty mod [thirsty]
==========================

A mod that adds a "thirst" mechanic, similar to hunger.

Copyright (C) 2015 Ben Deutsch <ben@bendeutsch.de>

License
-------

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301
USA

Terminology: "Thirst" vs. "hydration"
-------------------------------------

"Thirst" is the absence of "hydration" (a term suggested by
everamzah on the Minetest forums, thanks!). The overall mechanic
is still called "thirst", but the visible bar is that of
"hydration", filled with "hydro points".

]]

-- the main module variable
thirsty = {

    -- Configuration variables
    config = {
        -- configuration in thirsty.default.conf
    },

    -- the players' values
    players = {
        --[[
        name = {
            last_pos = '-10:3',
            time_in_pos = 0.0,
            pending_dmg = 0.0,
            thirst_factor = 1.0,
        }
        ]]
    },

    -- water fountains
    fountains = {
        --[[
        x:y:z = {
            pos = { x=x, y=y, z=z },
            level = 4,
            time_until_check = 20,
            -- something about times
        }
        ]]
    },

    -- general settings
    time_next_tick = 0.0,
}
local M = thirsty

dofile(minetest.get_modpath('thirsty')..'/configuration.lua')
local C = M.config

dofile(minetest.get_modpath('thirsty')..'/persistent_player_attributes.lua')
local PPA = M.persistent_player_attributes

thirsty.time_next_tick = thirsty.config.tick_time

dofile(minetest.get_modpath('thirsty')..'/hud.lua')
dofile(minetest.get_modpath('thirsty')..'/functions.lua')

minetest.register_on_joinplayer(thirsty.on_joinplayer)
minetest.register_on_dieplayer(thirsty.on_dieplayer)
minetest.register_globalstep(thirsty.main_loop)

dofile(minetest.get_modpath('thirsty')..'/components.lua')

