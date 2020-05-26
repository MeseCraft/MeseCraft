--[[

	Minetest Ethereal Mod

	Created by ChinChow

	Updated by TenPlus1

]]

 -- DO NOT change settings below, use the settings.conf file instead
ethereal = {

	version = "1.27",
	leaftype = 0, -- 0 for 2D plantlike, 1 for 3D allfaces
	leafwalk = false, -- true for walkable leaves, false to fall through
	cavedirt = true, -- caves chop through dirt when true
	torchdrop = true, -- torches drop when touching water
	papyruswalk = true, -- papyrus can be walked on
	lilywalk = true, -- waterlilies can be walked on
	xcraft = true, -- allow cheat crafts for cobble->gravel->dirt->sand, ice->snow, dry dirt->desert sand
	glacier   = 1, -- Ice glaciers with snow
	bamboo    = 1, -- Bamboo with sprouts
	mesa      = 1, -- Mesa red and orange clay with giant redwood
	alpine    = 1, -- Snowy grass
	healing   = 1, -- Snowy peaks with healing trees
	snowy     = 1, -- Cold grass with pine trees and snow spots
	frost     = 1, -- Blue dirt with blue/pink frost trees
	grassy    = 1, -- Green grass with flowers and trees
	caves     = 1, -- Desert stone ares with huge caverns underneath
	grayness  = 1, -- Grey grass with willow trees
	grassytwo = 1, -- Sparse trees with old trees and flowers
	prairie   = 1, -- Flowery grass with many plants and flowers
	jumble    = 1, -- Green grass with trees and jungle grass
	junglee   = 1, -- Jungle grass with tall jungle trees
	desert    = 1, -- Desert sand with cactus
	grove     = 1, -- Banana groves and ferns
	mushroom  = 1, -- Purple grass with giant mushrooms
	sandstone = 1, -- Sandstone with smaller cactus
	quicksand = 1, -- Quicksand banks
	plains    = 1, -- Dry dirt with scorched trees
	savanna   = 1, -- Dry yellow grass with acacia tree's
	fiery     = 1, -- Red grass with lava craters
	sandclay  = 1, -- Sand areas with clay underneath
	swamp     = 1, -- Swamp areas with vines on tree's, mushrooms, lilly's and clay sand
	sealife   = 1, -- Enable coral and seaweed
	reefs     = 1, -- Enable new 0.4.15 coral reefs in default
	sakura    = 1, -- Enable sakura biome with trees
	tundra    = 1, -- Enable tuntra biome with permafrost
}

local path = minetest.get_modpath("ethereal")

-- Load new settings if found
local input = io.open(path.."/settings.conf", "r")
if input then
	dofile(path .. "/settings.conf")
	input:close()
	input = nil
end

-- Intllib
local S
if minetest.global_exists("intllib") then
	if intllib.make_gettext_pair then
		-- New method using gettext.
		S = intllib.make_gettext_pair()
	else
		-- Old method using text files.
		S = intllib.Getter()
	end
else
	S = function(s) return s end
end
ethereal.intllib = S

-- Falling node function
ethereal.check_falling = minetest.check_for_falling or nodeupdate

-- creative check
local creative_mode_cache = minetest.settings:get_bool("creative_mode")
function ethereal.check_creative(name)
	return creative_mode_cache or minetest.check_player_privs(name, {creative = true})
end

dofile(path .. "/plantlife.lua")
dofile(path .. "/mushroom.lua")
dofile(path .. "/onion.lua")
dofile(path .. "/crystal.lua")
dofile(path .. "/water.lua")
dofile(path .. "/dirt.lua")
dofile(path .. "/food.lua")
dofile(path .. "/wood.lua")
dofile(path .. "/leaves.lua")
dofile(path .. "/sapling.lua")
dofile(path .. "/strawberry.lua")
dofile(path .. "/fishing.lua")
dofile(path .. "/extra.lua")
dofile(path .. "/sealife.lua")
dofile(path .. "/fences.lua")
dofile(path .. "/gates.lua")
dofile(path .. "/mapgen.lua")
dofile(path .. "/compatibility.lua")
dofile(path .. "/stairs.lua")
dofile(path .. "/lucky_block.lua")

-- Set bonemeal aliases
if minetest.get_modpath("bonemeal") then
	minetest.register_alias("ethereal:bone", "bonemeal:bone")
	minetest.register_alias("ethereal:bonemeal", "bonemeal:bonemeal")
else -- or return to where it came from
	minetest.register_alias("ethereal:bone", "default:dirt")
	minetest.register_alias("ethereal:bonemeal", "default:dirt")
end

if minetest.get_modpath("xanadu") then
	dofile(path .. "/plantpack.lua")
end

print (S("[MOD] Ethereal loaded"))
