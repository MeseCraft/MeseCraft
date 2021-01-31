--[[

	Minetest Ethereal Mod

	Created by ChinChow

	Updated by TenPlus1

]]

 -- DO NOT change settings below, use the settings.conf file instead
ethereal = {

	version = "1.28",
	leaftype = minetest.settings:get('ethereal.leaftype') or 0,
	leafwalk = minetest.settings:get_bool('ethereal.leafwalk', false),
	cavedirt = minetest.settings:get_bool('ethereal.cavedirt', true),
	torchdrop = minetest.settings:get_bool('ethereal.torchdrop', true),
	papyruswalk = minetest.settings:get_bool('ethereal.papyruswalk', true),
	lilywalk = minetest.settings:get_bool('ethereal.lilywalk', true),
	xcraft = minetest.settings:get_bool('ethereal.xcraft', true),

	glacier = minetest.settings:get('ethereal.glacier') or 1,
	bamboo = minetest.settings:get('ethereal.bamboo') or 1,
	mesa = minetest.settings:get('ethereal.mesa') or 1,
	alpine = minetest.settings:get('ethereal.alpine') or 1,
	healing = minetest.settings:get('ethereal.healing') or 1,
	snowy = minetest.settings:get('ethereal.snowy') or 1,
	frost = minetest.settings:get('ethereal.frost') or 1,
	grassy = minetest.settings:get('ethereal.grassy') or 1,
	caves = minetest.settings:get('ethereal.caves') or 1,
	grayness = minetest.settings:get('ethereal.grayness') or 1,
	grassytwo = minetest.settings:get('ethereal.grassytwo') or 1,
	prairie = minetest.settings:get('ethereal.prairie') or 1,
	jumble = minetest.settings:get('ethereal.jumble') or 1,
	junglee = minetest.settings:get('ethereal.junglee') or 1,
	desert = minetest.settings:get('ethereal.desert') or 1,
	grove = minetest.settings:get('ethereal.grove') or 1,
	mushroom = minetest.settings:get('ethereal.mushroom') or 1,
	sandstone = minetest.settings:get('ethereal.sandstone') or 1,
	quicksand = minetest.settings:get('ethereal.quicksand') or 1,
	plains = minetest.settings:get('ethereal.plains') or 1,
	savanna = minetest.settings:get('ethereal.savanna') or 1,
	fiery = minetest.settings:get('ethereal.fiery') or 1,
	sandclay = minetest.settings:get('ethereal.sandclay') or 1,
	swamp = minetest.settings:get('ethereal.swamp') or 1,
	sealife = minetest.settings:get('ethereal.sealife') or 1,
	reefs = minetest.settings:get('ethereal.reefs') or 1,
	sakura = minetest.settings:get('ethereal.sakura') or 1,
	tundra = minetest.settings:get('ethereal.tundra') or 1,
	mediterranean = minetest.settings:get('ethereal.mediterranean') or 1
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
if minetest.get_translator then
	S = minetest.get_translator("ethereal")
elseif minetest.global_exists("intllib") then
	if intllib.make_gettext_pair then
		S = intllib.make_gettext_pair()
	else
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
dofile(path .. "/biomes.lua")
dofile(path .. "/ores.lua")
dofile(path .. "/schems.lua")
dofile(path .. "/decor.lua")
dofile(path .. "/compatibility.lua")
dofile(path .. "/stairs.lua")

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
