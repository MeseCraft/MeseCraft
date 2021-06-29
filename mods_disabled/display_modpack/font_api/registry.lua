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

font_api.registered_fonts = {}
font_api.registered_fonts_number = 0

-- Local variables
------------------

local default_font = false

-- Local functions
------------------

-- Gets a default (settings or fist font)
local function get_default_font()
	-- First call
	if default_font == false then
		default_font = nil

		-- First, try with settings
		local settings_font = minetest.settings:get("default_font")

		if settings_font ~= nil and settings_font ~= "" then
			default_font = font_api.registered_fonts[settings_font]

			if default_font == nil then
				minetest.log("warning", "Default font in settings (\""..
				             settings_font.."\") is not registered.")
			end
		end

		-- If failed, choose first font without default = false
		if default_font == nil then
			for _, font in pairs(font_api.registered_fonts) do
				if font.default then
					default_font = font
					break
				end
			end
		end

		-- If failed, chose first font
		if default_font == nil then
			for _, font in pairs(font_api.registered_fonts) do
				default_font = font
				break
			end
		end

		-- Error, no font registered
		if default_font == nil then
			minetest.log("error",
			             "No font registred, unable to choose a default font.")
		end
	end

	return default_font
end

--- Returns font object to be used according to font_name
-- @param font_name: Name of the font
-- @return Font object if font found (or default font)

function font_api.get_font(font_name)
	local font = font_api.registered_fonts[font_name]

	if font == nil then
		local message

		if font_name == nil then
			message = "No font given"
		else
			message = "Font \""..font_name.."\" unregistered"
		end

		font = get_default_font()

		if font ~= nil then
			minetest.log("info", message..", using font \""..font.name.."\".")
		end
	end

	return font
end

-- API functions
----------------

--- Returns de default font name
-- @return Default font name

function font_api.get_default_font_name()
	return get_default_font().name
end

--- Register a new font
-- Textures corresponding to the font should be named after following patern :
-- font_<name>_<code>.png
-- <name> : name of the font
-- <code> : 4 digit hexadecimal unicode of the char
-- @param font_name Name of the font to register
-- If registering different sizes of the same font, add size in the font name
-- (e.g. times_10, times_12...).
-- @param def font definition. A associative array with following keys :
-- @key default True (by default) if this font may be used as default font
-- @key height (mandatory) Height in pixels of all font textures
-- @key widths (mandatory) Array of character widths in pixels, indexed by
-- UTF codepoints
-- @key margintop (optional) Margin (in texture pixels) added on top of each
-- char texture.
-- @key marginbottom (optional) dded at bottom of each char texture.
-- @key linespacing (optional) Spacing (in texture pixels) between each lines.
-- margintop, marginbottom and linespacing can be negative numbers (default 0)
-- and are to be used to adjust various font styles to each other.

-- TODO: Add something to remove common accent if not defined in font

function font_api.register_font(font_name, font_def)

	if font_api.registered_fonts[font_name] ~= nil then
		minetest.log("error", "Font \""..font_name.."\" already registered.")
		return
	end

	local font = font_api.Font:new(font_def)

	if font == nil then
		minetest.log("error", "Unable to register font \""..font_name.."\".")
		return
	end

	font.name = font_name
	font_api.registered_fonts[font_name] = font
	font_api.registered_fonts_number = font_api.registered_fonts_number + 1

	-- Force to choose again default font
	-- (allows use of fonts registered after start)
	default_font = false

	minetest.log("action", "New font registered in font_api: "..font_name..".")
end
