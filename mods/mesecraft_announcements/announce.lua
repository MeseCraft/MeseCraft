-- This module has been forked from the original "annouce" mod by adminicos.
-- https://forum.minetest.net/viewtopic.php?t=16823

local config = dofile(minetest.get_modpath("mesecraft_announcements") .. "/config.lua")
local announcement_index = 1

--- Parses colors, will return a string  --- https://forum.minetest.net/viewtopic.php?f=47&t=17200
local function color(msg)

	-- Split message from the character '&'
	local messageParts = string.split("f" .. msg, "&")
	
	-- The message to be returned
	local coloredMsg = ""

	-- Color list, See reference at http://ess.khhq.net/mc/ (Only the colors)
	local colors = {
        ["4"] = "#be0000",
        ["c"] = "#fe3f3f",
        ["6"] = "#d9a334",
        ["e"] = "#fefe3f",
        ["2"] = "#00be00",
        ["a"] = "#3ffe3f",
        ["b"] = "#3ffefe",
        ["3"] = "#00bebe",
        ["1"] = "#0000be",
        ["9"] = "#3f3ffe",
        ["d"] = "#fe3ffe",
        ["5"] = "#be00be",
        ["7"] = "#bebebe",
        ["8"] = "#3f3f3f",
        ["f"] = "#ffffff",
        ["0"] = "#000000"
    }

    local foundColor = false
    for count, part in ipairs(messageParts) do -- For each part of the message (splitted in the first line of the function)
        for color, value in pairs(colors) do -- For each color we know
            if part:sub(1, 1) == color then -- If the first character of part is a color
                coloredMsg = coloredMsg .. minetest.colorize(value, part:sub(2)) -- Colorize and append the part into the new message
                foundColor = true -- Let the following code know we already appended this part
                break -- Exit out of the loop
            end
        end

        if not foundColor then
            coloredMsg = coloredMsg .. part
        end -- Append this part if it isn't appended before
        foundColor = false -- Reset the flag, so other colors can set it again
    end

    return coloredMsg
end

local function loop()
    local announcement = config.announcements[announcement_index]

    announcement_index = announcement_index + 1
    if announcement_index > #config.announcements then
        announcement_index = 1
    end

    minetest.chat_send_all(color(announcement))
    minetest.after(config.delay, loop)
end

minetest.after(config.delay, loop)
