--MCmobs v0.4
--maikerumine
--made for MC like Survival game
--License for code WTFPL and otherwise stated in readmes

local path = minetest.get_modpath("mobs_mc")

if not minetest.get_modpath("mobs_mc_gameconfig") then
	mobs_mc = {}
end

-- For utility functions
mobs_mc.tools = {}

-- This function checks if the item ID has been overwritten and returns true if it is unchanged
if minetest.get_modpath("mobs_mc_gameconfig") and mobs_mc.override and mobs_mc.override.items then
	mobs_mc.is_item_variable_overridden = function(id)
		return mobs_mc.override.items[id] == nil
	end
else
	-- No items are overwritten, so always return true
	mobs_mc.is_item_variable_overridden = function(id)
		return true
	end
end

--MOB ITEMS SELECTOR SWITCH
dofile(path .. "/0_gameconfig.lua")
-- Shared functions
dofile(path .. "/3_shared.lua")

--Animals
--dofile(path .. "/bat.lua") -- Mesh and animation by toby109tt  / https://github.com/22i
--dofile(path .. "/rabbit.lua") -- Mesh and animation byExeterDad
--dofile(path .. "/chicken.lua") -- Mesh and animation by Pavel_S
--dofile(path .. "/cow+mooshroom.lua") -- Mesh by Morn76 Animation by Pavel_S
dofile(path .. "/ocelot.lua") --  Mesh and animation by toby109tt  / https://github.com/22i
--dofile(path .. "/parrot.lua") --  Mesh and animation by toby109tt  / https://github.com/22i
--dofile(path .. "/pig.lua") -- Mesh and animation by Pavel_S
--dofile(path .. "/polar_bear.lua") --  Mesh and animation by toby109tt  / https://github.com/22i
--dofile(path .. "/wolf.lua") -- KrupnoPavel

--Monsters
--dofile(path .. "/silverfish.lua") -- maikerumine Mesh and animation by toby109tt  / https://github.com/22i

--NOTES:
--
--[[
COLISIONBOX in minetest press f5 to see where you are looking at then put these wool collor nodes on the ground in direction of north/east/west... to make colisionbox editing easier
#1west-pink/#2down/#3south-blue/#4east-red/#5up/#6north-yelow
{-1, -0.5, -1, 1, 3, 1}, Right, Bottom, Back, Left, Top, Front
--]]
--
--

if minetest.settings:get_bool("log_mods") then
	minetest.log("action", "[MOD] Mobs Redo 'MC' loaded")
end
