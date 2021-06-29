--[[
    digiterms mod for Minetest - Digiline monitors using Display API / Font API
    (c) Pierre-Yves Rollo

    This file is part of digiterms.

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

digiterms = {}
digiterms.name = minetest.get_current_modname()
digiterms.path = minetest.get_modpath(digiterms.name)
digiterms.font = "mozart"

display_api.register_display_entity("digiterms:screen")

dofile(digiterms.path.."/font_mozart.lua")
dofile(digiterms.path.."/functions.lua")
dofile(digiterms.path.."/nodes.lua")
dofile(digiterms.path.."/crafts.lua")

if minetest.get_modpath("scifi_nodes") then
  print ('[digiterms] scifi_nodes mod present, adding some more nodes')
  dofile(digiterms.path.."/scifi_nodes.lua")
  dofile(digiterms.path.."/scifi_crafts.lua")
end
