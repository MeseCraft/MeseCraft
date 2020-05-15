--[[
	Hidden Doors - Adds various wood, stone, etc. doors.
	Copyright © 2017, 2019 Hamlet <hamlatmesehub@riseup.net>,
	Napiophelios, Treer and contributors.

	Licensed under the EUPL, Version 1.2 or – as soon they will be
	approved by the European Commission – subsequent versions of the
	EUPL (the "Licence");
	You may not use this work except in compliance with the Licence.
	You may obtain a copy of the Licence at:

	https://joinup.ec.europa.eu/software/page/eupl
	https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863

	Unless required by applicable law or agreed to in writing,
	software distributed under the Licence is distributed on an
	"AS IS" basis,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
	implied.
	See the Licence for the specific language governing permissions
	and limitations under the Licence.

--]]


--
-- Global mod namespace
--

hidden_doors = {}


--
-- Variables
--

local s_ModPath = minetest.get_modpath(minetest.get_current_modname())


-- Used for localization, choose either built-in or intllib.

local S, NS = nil

if (minetest.get_modpath("intllib") == nil) then
	S = minetest.get_translator("hidden_doors")

else
	-- internationalization boilerplate
	S, NS = dofile(s_ModPath.."/intllib.lua")

end


local s_Description1 = S("Concealed ")
local s_Description2 = S(" Door")

-- 'painted' doors are not fully concealed,
-- they are wooden doors painted to blend in
local b_DoorsArePainted = minetest.settings:get_bool("hidden_doors_painted", false)

if b_DoorsArePainted then
	 s_Description1 = S("Painted ")
end

-- Hidden Doors' sounds
local f_HiddenDoorsVolume = tonumber(minetest.settings:get("hidden_doors_vol"))

if (f_HiddenDoorsVolume == nil) then
	f_HiddenDoorsVolume = 5.0
end

t_StoneDefault = default.node_sound_stone_defaults()
t_StoneOpen = {
	name = "hidden_doors_stone_door_open",
	gain = f_HiddenDoorsVolume
}
t_StoneClose = {
	name = "hidden_doors_stone_door_close",
	gain = f_HiddenDoorsVolume
}

t_WoodDefault = default.node_sound_wood_defaults()
s_WoodOpen = "doors_door_open"
s_WoodClose = "doors_door_close"

t_MetalDefault = default.node_sound_metal_defaults()
s_MetalOpen = "doors_steel_door_open"
s_MetalClose = "doors_steel_door_close"

t_GemDefault = default.node_sound_glass_defaults()
s_GemOpen = "doors_glass_door_open"
s_GemClose = "doors_glass_door_close"

-- Hidden door's base recipe item
s_RecipeItem1 = "doors:door_wood"

-- Hidden door's texture variables
local i_Resolution = 16 -- Default textures' resolution.
local i_NodeWidth = 0
local i_NodeHeight = 0
local s_ImageSize = ""

-- Composed texture's images' offsets.
local i_Y1 = 0	local i_X1 = 0
local i_Y2 = 0	local i_X2 = 0
local i_Y3 = 0	local i_X3 = 0
local i_Y4 = 0	local i_X4 = 0

local i_HiddenDoorsRes = tonumber(minetest.settings:get("i_HiddenDoorsRes"))

if (i_HiddenDoorsRes == nil) then
	i_HiddenDoorsRes = i_Resolution
end


if i_HiddenDoorsRes == 16 then

	-- Item's inventory texture dimensions
	i_InventoryWidth = i_Resolution * 2
	i_InventoryHeight = i_Resolution * 2
	s_InventorySize = i_InventoryWidth .. "x" .. i_InventoryHeight

	-- Node's texture dimensions
	i_NodeWidth = (i_Resolution * 2) + 6
	i_NodeHeight = (i_Resolution * 2)
	s_ImageSize = i_NodeWidth .. "x" .. i_NodeHeight

	-- Composed texture's dimensions
	i_Y1 = i_Resolution	i_X1 = 8
	i_Y2 = 6			i_X2 = 6
	i_Y3 = i_Resolution	i_X3 = i_Resolution
	i_Y4 = i_Resolution	i_X4 = 22


elseif i_HiddenDoorsRes == 32 then

	-- Item's inventory texture dimensions
	i_InventoryWidth = (i_Resolution * 4)
	i_InventoryHeight = (i_Resolution * 4)
	s_InventorySize = i_InventoryWidth .. "x" .. i_InventoryHeight

	-- Node's texture dimensions
	i_NodeWidth = ((i_Resolution * 2) + 6) * 2
	i_NodeHeight = (i_Resolution * 4)
	s_ImageSize = i_NodeWidth .. "x" .. i_NodeHeight

	-- Composed texture's dimensions
	i_Y1 = 32					i_X1 = 16
	i_Y2 = 12					i_X2 = 12
	i_Y3 = (i_Resolution * 2)	i_X3 = (i_Resolution * 2)
	i_Y4 = (i_Resolution * 2)	i_X4 = 44


elseif i_HiddenDoorsRes == 64 then

	-- Item's inventory texture dimensions
	i_InventoryWidth = (i_Resolution * 8)
	i_InventoryHeight = (i_Resolution * 8)
	s_InventorySize = i_InventoryWidth .. "x" .. i_InventoryHeight

	-- Node's texture dimensions
	i_NodeWidth = ((i_Resolution * 2) + 6) * 4
	i_NodeHeight = (i_Resolution * 8)
	s_ImageSize = i_NodeWidth .. "x" .. i_NodeHeight

	-- Composed texture's dimensions
	i_Y1 = 64					i_X1 = 32
	i_Y2 = 24					i_X2 = 24
	i_Y3 = (i_Resolution * 4)	i_X3 = (i_Resolution * 4)
	i_Y4 = (i_Resolution * 4)	i_X4 = 88


elseif i_HiddenDoorsRes == 128 then

	-- Item's inventory texture dimensions
	i_InventoryWidth = (i_Resolution * 16)
	i_InventoryHeight = (i_Resolution * 16)
	s_InventorySize = i_InventoryWidth .. "x" .. i_InventoryHeight

	-- Node's texture dimensions dimensions
	i_NodeWidth = ((i_Resolution * 2) + 6) * 8
	i_NodeHeight = (i_Resolution * 16)
	s_ImageSize = i_NodeWidth .. "x" .. i_NodeHeight

	-- Composed texture's dimensions
	i_Y1 = 128					i_X1 = 64
	i_Y2 = 48					i_X2 = 48
	i_Y3 = (i_Resolution * 8)	i_X3 = (i_Resolution * 8)
	i_Y4 = (i_Resolution * 8)	i_X4 = 176


else

	-- If the setting is not valid then set it to 16px and use that resolution
	i_HiddenDoorsRes = i_Resolution
	minetest.settings:set("i_HiddenDoorsRes", i_HiddenDoorsRes)

	-- Item's inventory texture dimensions
	i_InventoryWidth = (i_Resolution * 2)
	i_InventoryHeight = (i_Resolution * 2)
	s_InventorySize = i_InventoryWidth .. "x" .. i_InventoryHeight

	-- Node's texture dimensions
	i_NodeWidth = (i_Resolution * 2) + 6
	i_NodeHeight = (i_Resolution * 2)
	s_ImageSize = i_NodeWidth .. "x" .. i_NodeHeight

	-- Composed texture's dimensions
	i_Y1 = i_Resolution		i_X1 = 8
	i_Y2 = 6				i_X2 = 6
	i_Y3 = i_Resolution		i_X3 = i_Resolution
	i_Y4 = i_Resolution		i_X4 = 22

end


hidden_doors.GetPaintedTextureSuffix = function(b_UseDefault16pxResolution)

	local s_TextureSuffix = ""
	local s_TextureSuffixIntentory = ""

	if (b_DoorsArePainted == true) then

		local i_PaintOpacity = 35
		local i_PaintOpacityInventory = (i_PaintOpacity + 15)

		if (b_UseDefault16pxResolution == true) then
			s_TextureSuffix =
				"^((hidden_doors_painted_overlay.png^[opacity:" ..
				i_PaintOpacity ..
				"^hidden_doors_hinges_overlay.png)^[resize:38x32)"
			s_TextureSuffixIntentory =
				":8,0=hidden_doors_painted_overlay.png\\^[opacity\\:" ..
				i_PaintOpacityInventory .. "\\^[resize\\:38x32"

		else
			s_TextureSuffix =
				"^((hidden_doors_painted_overlay.png^[opacity:" ..
				i_PaintOpacity ..
				"^hidden_doors_hinges_overlay.png)^[resize:" ..
				s_ImageSize .. ")"
			s_TextureSuffixIntentory =
				": " .. i_X1 ..
				",0=hidden_doors_painted_overlay.png\\^[opacity\\:" ..
				i_PaintOpacityInventory .. "\\^[resize\\:" .. s_ImageSize
		end
	end

	return s_TextureSuffix, s_TextureSuffixIntentory
end


hidden_doors.RegisterHiddenDoors = function(a_s_ModName, a_s_SubName,
	s_RecipeItem1, s_RecipeItem2, s_RecipeItem3, a_s_Description,
	a_t_Sounds, a_s_SoundOpen, a_s_SoundClose)

	local s_TextureName = a_s_ModName .. "_" .. a_s_SubName .. ".png"

	-- If the door uses textures from Darkage then use the default 16px res.
	-- Do the same for Moreblocks.
	if (a_s_ModName ~= "darkage") and (a_s_ModName ~= "moreblocks") then

		local s_NewTexture = "[combine:" .. s_ImageSize .. ": 0," ..
			"0=" .. s_TextureName .. ": 0," ..
			i_Y3 .. "=" .. s_TextureName .. ":" .. i_X2 .. "," ..
			"0=" .. s_TextureName .. ":" .. i_X2 .. "," ..
			i_Y3 .. "=" .. s_TextureName .. ":" .. i_X4 .. "," ..
			"0=" .. s_TextureName .. ":" .. i_X4 .. "," ..
			i_Y3 .. "=" .. s_TextureName

		local s_PaintedTextureSuffix, s_PaintedTextureSuffixInventory =
			hidden_doors.GetPaintedTextureSuffix(false)

		doors.register("hidden_door_" .. a_s_SubName, {
			description = s_Description1 .. a_s_Description .. s_Description2,

			tiles = {
				{
					name = "(" .. s_NewTexture ..
						"^[transformFX)^([combine:" .. s_ImageSize ..
						":" ..i_X3.. "," .. "0=" .. s_TextureName ..
						":" .. i_X3 .. "," .. i_Y3 .. "=" ..
						s_TextureName .. ")" .. s_PaintedTextureSuffix,

					backface_culling = true
				}
			},

			inventory_image = "[combine:" .. s_InventorySize .. ":" ..
				i_X1 .. "," .. "0=" .. s_TextureName .. ":" .. i_X1 ..
				"," .. i_Y1 .. "=" ..s_TextureName ..
				s_PaintedTextureSuffixInventory,

			groups = {cracky = 1, level = 2},
			sounds = a_t_Sounds,
			sound_open = a_s_SoundOpen,
			sound_close = a_s_SoundClose,

			recipe = {
				{
					s_RecipeItem1, s_RecipeItem2, s_RecipeItem3
				},
			}
		})


	else

		local s_NewTexture = "[combine:" .. "38x32" .. ": 0," ..
			"0=" .. s_TextureName .. ": 0," ..
			"16=" .. s_TextureName .. ": 6," ..
			"0=" .. s_TextureName .. ": 6," ..
			"16=" .. s_TextureName .. ": 22," ..
			"0=" .. s_TextureName .. ": 22," ..
			"16=" .. s_TextureName

		local s_PaintedTextureSuffix, s_PaintedTextureSuffixInventory =
			hidden_doors.GetPaintedTextureSuffix(true)

		doors.register("hidden_door_" .. a_s_SubName, {

			description = s_Description1 .. a_s_Description .. s_Description2,

			tiles = {
				{
					name = "(" .. s_NewTexture .. "^[transformFX)^([combine:"
					.. "38x32" .. ": 16," .. "0=" .. s_TextureName .. ": 16,"
					.. "16=" .. s_TextureName .. ")" .. s_PaintedTextureSuffix,

					backface_culling = true
				}
			},

			inventory_image = "[combine:" .. "32x32" .. ": 8," ..
				"0=" .. s_TextureName .. ": 8," .. "16=" .. s_TextureName ..
				s_PaintedTextureSuffixInventory,

			groups = {cracky = 1, level = 2},
			sounds = a_t_Sounds,
			sound_open = a_s_SoundOpen,
			sound_close = a_s_SoundClose,

			recipe = {
				{
					s_RecipeItem1,
					s_RecipeItem2,
					s_RecipeItem3
				},
			}
		})
	end
end


--
-- Minetest Game's based hidden doors
--

dofile(s_ModPath .. "/minetest_game.lua")


--
-- Compatible modules' based hidden doors
--

if minetest.get_modpath("darkage") then
	dofile(s_ModPath .. "/darkage.lua")
end

if minetest.get_modpath("moreblocks") then
	dofile(s_ModPath .. "/moreblocks.lua")
end
