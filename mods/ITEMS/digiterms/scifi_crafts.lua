--[[
	digiterms mod for Minetest - Digilines monitors using Display API / Font API
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

local wire = 'digilines:wire_std_00000000'

minetest.register_craft({
  output = "digiterms:scifi_glassscreen",
  type = "shapeless",
  recipe = { "scifi_nodes:glassscreen", "digilines:wire_std_00000000" }
})

minetest.register_craft({
  output = "digiterms:scifi_widescreen",
  type = "shapeless",
  recipe = { "scifi_nodes:widescreen", "digilines:wire_std_00000000" }
})

minetest.register_craft({
  output = "digiterms:scifi_tallscreen",
  type = "shapeless",
  recipe = { "scifi_nodes:tallscreen", "digilines:wire_std_00000000" }
})

minetest.register_craft({
  output = "digiterms:scifi_keysmonitor",
  type = "shapeless",
  recipe = { "scifi_nodes:keysmonitor", "digilines:wire_std_00000000" }
})
