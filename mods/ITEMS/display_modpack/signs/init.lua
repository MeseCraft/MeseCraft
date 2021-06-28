--[[
    signs mod for Minetest - Various signs with text displayed on
    (c) Pierre-Yves Rollo

    This file is part of signs.

    signs is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    signs is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with signs.  If not, see <http://www.gnu.org/licenses/>.
--]]

signs = {}
signs.name = minetest.get_current_modname()
signs.path = minetest.get_modpath(signs.name)

-- Load support for intllib.
local S, NS = dofile(signs.path.."/intllib.lua")
signs.intllib = S

dofile(signs.path.."/common.lua")
dofile(signs.path.."/nodes.lua")
dofile(signs.path.."/crafts.lua")
dofile(signs.path.."/compatibility.lua")




