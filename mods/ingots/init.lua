--[[
	Ingots - allows the placemant of ingots in the world
	Copyright (C) 2018  Skamiz Kazzarch

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
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
]]--

ingots = {}

local conf = dofile(minetest.get_modpath("ingots").."/conf.lua")
dofile(minetest.get_modpath("ingots").."/api.lua")

--Here you can make individual choices per ingot on which varian will be used.
--To disable the ability of an ingot to be placed just comment out it's registration line.

if minetest.get_modpath("default") then
		ingots.register_ingots("default:copper_ingot", "ingot_copper.png", conf.is_big)
		ingots.register_ingots("default:tin_ingot", "ingot_tin.png", conf.is_big)
		ingots.register_ingots("default:bronze_ingot", "ingot_bronze.png", conf.is_big)
		ingots.register_ingots("default:steel_ingot", "ingot_steel.png", conf.is_big)
		ingots.register_ingots("default:gold_ingot", "ingot_gold.png", conf.is_big)
end

if minetest.get_modpath("moreores") then
		ingots.register_ingots("moreores:silver_ingot", "ingot_silver.png", conf.is_big)
		ingots.register_ingots("moreores:mithril_ingot", "ingot_mithril.png", conf.is_big)
		if not minetest.registered_items["default:tin_ingot"] then
			ingots.register_ingots("moreores:tin_ingot", "ingot_tin.png", conf.is_big)
		end
end

if minetest.get_modpath("technic") then
		ingots.register_ingots("technic:stainless_steel_ingot", "ingot_stainless_steel.png", conf.is_big)
		ingots.register_ingots("technic:carbon_steel_ingot", "ingot_carbon_steel.png", conf.is_big)
		ingots.register_ingots("technic:mixed_metal_ingot", "ingot_mixed_metal.png", conf.is_big)
		ingots.register_ingots("technic:brass_ingot", "ingot_brass.png", conf.is_big)
		ingots.register_ingots("technic:lead_ingot", "ingot_lead.png", conf.is_big)
		ingots.register_ingots("technic:zinc_ingot", "ingot_zinc.png", conf.is_big)
		ingots.register_ingots("technic:chromium_ingot", "ingot_chromium.png", conf.is_big)
		ingots.register_ingots("technic:cast_iron_ingot", "ingot_cast_iron.png", conf.is_big)
end

if minetest.get_modpath("rainbow_ore") then
		ingots.register_ingots("rainbow_ore:rainbow_ore_ingot", "ingot_rainbow_ore.png", conf.is_big)
end
