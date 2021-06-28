--[[
    signs mod for Minetest - Various signs with text displayed on
    (c) Pierre-Yves Rollo

    This file is part of signs.

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

local S = signs.intllib
local F = function(...) return minetest.formspec_escape(S(...)) end

-- Generic callback for show_formspec displayed formspecs of "sign" mod

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local found, _, mod, node_name, pos = formname:find("^([%w_]+):([%w_]+)@([^:]+)")
	if found then
		if mod ~= 'signs' then return end

		local ndef = minetest.registered_nodes[mod..":"..node_name]

		if ndef and ndef.on_receive_fields then
			ndef.on_receive_fields(minetest.string_to_pos(pos), formname, fields, player)
		end
	end
end)
