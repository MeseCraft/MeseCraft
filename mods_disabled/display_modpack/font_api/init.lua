--[[
	font_api mod for Minetest - Library creating textures with fonts and text
	(c) Pierre-Yves Rollo

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]

-- Global variables
-------------------

font_api = {}
font_api.name = minetest.get_current_modname()
font_api.path = minetest.get_modpath(font_api.name)

-- Inclusions
-------------

dofile(font_api.path.."/font.lua")
dofile(font_api.path.."/registry.lua")
dofile(font_api.path.."/fontform.lua")
if minetest.get_modpath("display_api") then
	dofile(font_api.path.."/display_api.lua")
end
dofile(font_api.path.."/deprecation.lua")
