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

-- Fallback table
local fallbacks = dofile(font_api.path.."/fallbacks.lua")

-- Local functions
------------------

-- Returns number of UTF8 bytes of the first char of the string
local function get_char_bytes(str)
	local msb = str:byte(1)
	if msb ~= nil then
		if msb <  0x80 then return 1 end
		if msb >= 0xF0 then return 4 end
		if msb >= 0xE0 then	return 3 end
		if msb >= 0xC2 then	return 2 end
	end
end

-- Returns the unicode codepoint of the first char of the string
local function char_to_codepoint(str)
	local bytes = get_char_bytes(str)
	if bytes == 1 then
	    return str:byte(1)
	elseif bytes == 2 and str:byte(2) ~= nil then
		return (str:byte(1) - 0xC2) * 0x40
			+ str:byte(2)
	elseif bytes == 3 and str:byte(2) ~= nil and str:byte(3) ~= nil then
		return (str:byte(1) - 0xE0) * 0x1000
			+ str:byte(2) % 0x40 * 0x40
			+ str:byte(3) % 0x40
	elseif bytes == 4 and str:byte(2) ~= nil and str:byte(3) ~= nil
		and str:byte(4) ~= nil then -- Not tested
		return (str:byte(1) - 0xF0) * 0x40000
			+ str:byte(2) % 0x40 * 0x1000
			+ str:byte(3) % 0x40 * 0x40
			+ str:byte(4) % 0x40
	end
end

--------------------------------------------------------------------------------
--- Font class

local Font = {}
font_api.Font = Font

function Font:new(def)

	if type(def) ~= "table" then
		minetest.log("error",
			"[font_api] Font definition must be a table.")
		return nil
	end

	if def.height == nil or def.height <= 0 then
		minetest.log("error",
			"[font_api] Font definition must have a positive height.")
		return nil
	end

	if type(def.widths) ~= "table" then
		minetest.log("error",
			"[font_api] Font definition must have a widths array.")
		return nil
	end

	if def.widths[0] == nil then
		minetest.log("error",
			"[font_api] Font must have a char with codepoint 0 (=unknown char).")
		return nil
	end

	local font = table.copy(def)
	setmetatable(font, self)
	self.__index = self

	-- Check if fixedwidth
	for codepoint, width in pairs(font.widths) do
		font.fixedwidth = font.fixedwidth or width
		if width ~= font.fixedwidth then
			font.fixedwidth = nil
			break
		end
	end

	return font
end

--- Gets the next char of a text
-- @return Codepoint of first char,
-- @return Remaining string without this first char

function Font:get_next_char(text)
	local bytes = get_char_bytes(text)

	if bytes == nil then
		minetest.log("warning",
			"[font_api] Encountered a non UTF char, not displaying text.")
		return nil, ''
	end

	local codepoint = char_to_codepoint(text)

	if codepoint == nil then
		minetest.log("warning",
			"[font_api] Encountered a non UTF char, not displaying text.")
		return nil, ''
	end

	-- Fallback mechanism
	if self.widths[codepoint] == nil then
		local char = text:sub(1, bytes)

		if fallbacks[char] then
			return self:get_next_char(fallbacks[char]..text:sub(bytes+1))
		else
			return 0, text:sub(bytes+1) -- Ultimate fallback
		end
	else
		return codepoint, text:sub(bytes+1)
	end
end

--- Returns the width of a given char
-- @param char : codepoint of the char
-- @return Char width
function Font:get_char_width(codepoint)
	if self.fixedwidth then
		return self.fixedwidth
	elseif self.widths[codepoint] then
		return self.widths[codepoint]
	else
		return self.widths[0]
	end
end

--- Text height for multiline text including margins and line spacing
-- @param nb_of_lines : number of text lines (default 1)
-- @return Text height

function Font:get_height(nb_of_lines)
	if nb_of_lines == nil then nb_of_lines = 1 end

	if nb_of_lines > 0 then
		return
			(
				(self.height or 0) +
				(self.margintop or 0) +
				(self.marginbottom or 0)
			) * nb_of_lines +
			(self.linespacing or 0) * (nb_of_lines -1)
	else
		return nb_of_lines == 0 and 0 or nil
	end
end

--- Computes text width for a given text (ignores new lines)
-- @param line Line of text which the width will be computed.
-- @return Text width

function Font:get_width(line)
	local codepoint
	local width = 0
	line = line or ''

	while line ~= "" do
		codepoint, line = self:get_next_char(line)
		if codepoint == nil then return 0 end -- UTF Error
		width = width + self:get_char_width(codepoint)
	end

	return width
end

--- Legacy make_text_texture method (replaced by "render" - Dec 2018)

function Font:make_text_texture(text, texturew, textureh, maxlines,
		halign, valign, color)
		return self:render(text, texturew, textureh, {
			lines = maxlines,
			valign = valign,
			halign = halign,
			color = color
		})
end

--- Render text with the font in a view
-- @param text Text to be rendered
-- @param texturew Width (in pixels) of the texture (extra text will be truncated)
-- @param textureh Height (in pixels) of the texture (extra text will be truncated)
-- @param style Style of the rendering:
--		- lines: maximum number of text lines (if text is limited)
--		- halign: horizontal align ("left"/"center"/"right")
--		- valign: vertical align ("top"/"center"/"bottom")
--		- color: color of the text ("#rrggbb")
-- @return Texture string

function Font:render(text, texturew, textureh, style)
	local style = style or {}

	-- Split text into lines (and limit to style.lines # of lines)
	local lines = {}
	local pos = 1
	local found, line
	repeat
		found = string.find(text, "\n", pos) or (#text + 1)
		line = string.sub(text, pos, found - 1)
		lines[#lines + 1] = { text = line, width = self:get_width(line) }
		pos = found + 1
	until (style.lines and (#lines >= style.lines)) or (pos > (#text + 1))

	if not #lines then
		return ""
	end

	local x, y, codepoint
	local texture = ""
	local textheight = self:get_height(#lines)

	if style.valign == "top" then
		y = 0
	elseif style.valign == "bottom" then
		y = textureh - textheight
	else
		y = (textureh - textheight) / 2
	end

	y = y + (self.margintop or 0)

	for _, line in pairs(lines) do
		if style.halign == "left" then
			x = 0
		elseif style.halign == "right" then
			x = texturew - line.width
		else
			x = (texturew - line.width) / 2
		end

		while line.text ~= '' do
			codepoint, line.text = self:get_next_char(line.text)
			if codepoint == nil then return '' end -- UTF Error

			-- Add image only if it is visible (at least partly)
			if x + self.widths[codepoint] >= 0 and x <= texturew then
				texture = texture..
					string.format(":%d,%d=font_%s_%04x.png", x, y, self.name, codepoint)
			end
			x = x + self.widths[codepoint]
		end

		y = y + self:get_height() + (self.linespacing or 0)
	end
	texture = string.format("[combine:%dx%d", texturew, textureh)..texture
	if style.color then
		texture = texture.."^[colorize:"..style.color
	end
	return texture
end
