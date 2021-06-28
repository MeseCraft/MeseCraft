--[[
    digiterms mod for Minetest - Digiline monitors using Display API / Font API
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

local player_contexts = {}

minetest.register_on_leaveplayer(function(player)
  player_contexts[player:get_player_name()] = nil
end)

function digiterms.get_player_context(name)
  player_contexts[name] = player_contexts[name] or {}
  return player_contexts[name]
end

local function get_lines(pos)
  local lines = {}
  local meta = minetest.get_meta(pos)
  local text = meta:get_string("display_text")
  local pos = 1
	repeat
		local found = text:find("\n", pos) or #text + 1
    lines[#lines+1] = text:sub(pos, found - 1)
		pos = found + 1
	until (pos > (#text + 1))
  return lines
end

local function set_lines(pos, lines)
  local meta = minetest.get_meta(pos)
  meta:set_string("display_text", table.concat(lines, "\n"))
end

local function push_line(lines, line, maxlines)
  for index = 1, (maxlines - 1) do
    lines[index] = lines[index + 1] or ""
  end
  lines[maxlines] = line
end

local function push_text(lines, text, maxlines, maxcolumns)
	local pos = 1
	local column = 0
	local start = 1
	while pos <= #text do
		local b = text:byte(pos)
		column = column + 1
		if b == 0x0A then
			push_line(lines, text:sub(start, pos - 1), maxlines)
			start = pos + 1
			column = 0
		end
		if column > maxcolumns then
			push_line(lines, text:sub(start, pos - 1), maxlines)
			start = pos
			column = 1
		end
		if b < 0x80 then pos = pos + 1
		elseif b >= 0xF0 then pos = pos + 4
		elseif b >= 0xE0 then	pos = pos + 3
		elseif b >= 0xC2 then	pos = pos + 2
	  else pos = pos + 1 end-- Invalid char
	end
	if pos - 1 >= start then
		push_line(lines, text:sub(start, pos - 1), maxlines)
	end
end

function digiterms.push_text_on_screen(pos, text)
  local def = minetest.registered_nodes[minetest.get_node(pos).name]
  if def.display_entities and def.display_entities["digiterms:screen"] then
    def = def.display_entities["digiterms:screen"]
    if def.lines and def.columns then
      local lines = get_lines(pos)
      push_text(lines, text, def.lines, def.columns)
      set_lines(pos, lines)
      display_api.update_entities(pos)
    else
      minetest.log("warning", "[digiterms] At "..minetest.pos_to_string(pos)
        ..", digiterms:screen entity should have 'lines' and 'columns' attribures.")
    end
  end
end

local node_def_defaults = {
	groups = { display_api = 1},
	on_place = display_api.on_place,
	on_destruct = display_api.on_destruct,
	on_rotate = display_api.on_rotate,
	on_punch = display_api.update_entities,
	on_construct = function(pos)
			minetest.get_meta(pos):set_string("formspec",
				"field[channel;Channel;${channel}]")
			display_api.on_construct(pos)
		end,
	on_receive_fields = function(pos, formname, fields, player)
			local name = player:get_player_name()
			if minetest.is_protected(pos, name) then
				minetest.record_protection_violation(pos, name)
				return
			end

			if (fields.channel) then
				minetest.get_meta(pos):set_string("channel", fields.channel)
			end
		end,
	digiline = {
		wire = { use_autoconnect = false },
		receptor = {},
		effector = {
			action = function(pos, _, channel, msg)
					if channel ~= minetest.get_meta(pos):get_string("channel") then
						return
					end

					if type(msg) ~= "string" then
						return
					end

					digiterms.push_text_on_screen(pos, msg)
				end,
		},
	},
}

function superpose_table(base, exceptions)
  local result = table.copy(base)
  for key, value in pairs(exceptions) do
		if type(value) == 'table' then
      result[key] = superpose_table(result[key] or {}, value)
    else
      result[key] = value
    end
  end
  return result
end

function digiterms.register_monitor(
  nodename, nodedef, nodedefon, nodedefoff)
  local ndef = superpose_table(node_def_defaults, nodedef)
  if nodedefon and nodedefoff then
    ndef.on_punch = function(pos, node)
      	display_api.on_destruct(pos)
      	local meta = minetest.get_meta(pos)
      	meta:set_string("display_text", nil)
      	minetest.swap_node(pos, {name = nodename..'_off',
      		param = node.param, param2 = node.param2 })
    	end
    minetest.register_node(nodename, superpose_table(ndef, nodedefon))

    -- Register the corresponding Off node
    if ndef.display_entities then
      ndef.display_entities["digiterms:screen"] = nil
    end
    ndef.drop = nodename
  	ndef.groups.not_in_creative_inventory = 1
    ndef.on_destruct = nil
  	ndef.on_punch = function(pos, node)
    		minetest.swap_node(pos, {name = nodename,  -- Stange but it works
    			param = node.param, param2 = node.param2 })
    		display_api.update_entities(pos)
      end
    minetest.register_node(nodename..'_off', superpose_table(ndef, nodedefoff))
  else
    minetest.register_node(nodename, ndef)
  end
end
