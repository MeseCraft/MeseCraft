-- simple LED marquee mod
-- by Vanessa Dannenberg

led_marquee = {}

local S
if minetest.get_modpath("intllib") then
	S = intllib.make_gettext_pair()
else
	S = function(s) return s end
end

local color_to_char = {
	"0",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"H",
	"I",
	"J",
	"K",
	"L",
	"M",
	"N",
	"O",
	"P",
	"Q",
	"R"
}

local char_to_color = {
	["0"] = 0,
	["1"] = 1,
	["2"] = 2,
	["3"] = 3,
	["4"] = 4,
	["5"] = 5,
	["6"] = 6,
	["7"] = 7,
	["8"] = 8,
	["9"] = 9,

	["A"] = 10,
	["B"] = 11,
	["C"] = 12,
	["D"] = 13,
	["E"] = 14,
	["F"] = 15,
	["G"] = 16,
	["H"] = 17,
	["I"] = 18,
	["J"] = 19,
	["K"] = 20,
	["L"] = 21,
	["M"] = 22,
	["N"] = 23,
	["O"] = 24,
	["P"] = 25,
	["Q"] = 26,
	["R"] = 27,

	["a"] = 10,
	["b"] = 11,
	["c"] = 12,
	["d"] = 13,
	["e"] = 14,
	["f"] = 15,
	["g"] = 16,
	["h"] = 17,
	["i"] = 18,
	["j"] = 19,
	["k"] = 20,
	["l"] = 21,
	["m"] = 22,
	["n"] = 23,
	["o"] = 24,
	["p"] = 25,
	["q"] = 26,
	["r"] = 27

}

-- the following functions based on the so-named ones in Jeija's digilines mod

local reset_meta = function(pos)
	minetest.get_meta(pos):set_string("formspec", "field[channel;Channel;${channel}]")
end

local on_digiline_receive_std = function(pos, node, channel, msg)
	local meta = minetest.get_meta(pos)
	local setchan = meta:get_string("channel")
	if setchan ~= channel then return end
	local num = tonumber(msg)
	if msg == "colon" or msg == "period" or msg == "off" or (num and (num >= 0 and num <= 9)) then
			minetest.swap_node(pos, { name = "led_marquee:marquee_"..msg, param2 = node.param2})
	end
end

-- convert Lua's idea of a UTF-8 char to ISO-8859-1

-- first char is non-break space, 0xA0
local iso_chars=" ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ"

local get_iso = function(c)
	local hb = string.byte(c,1) or 0
	local lb = string.byte(c,2) or 0
	local dec = lb+hb*256
	local char = dec - 49664
	if dec > 49855 then char = dec - 49856 end
	return char
end

local make_iso = function(s)
	local i = 1
	local s2 = ""
	while i <= string.len(s) do
		if string.byte(s,i) > 159 then
			s2 = s2..string.char(get_iso(string.sub(s, i, i+1)))
			i = i + 2
		else
			s2 = s2..string.sub(s, i, i)
			i = i + 1
		end
	end
	return s2
end

-- scrolling

led_marquee.set_timer = function(pos, timeout)
	local timer = minetest.get_node_timer(pos)
	timer:stop()
	if not timeout or timeout < 0.2 or timeout > 5 then return false end

	if timeout > 0 then
		local meta = minetest.get_meta(pos)
		meta:set_int("timeout", timeout)
		timer:start(timeout)
	end
end

led_marquee.scroll_text = function(pos, elapsed, skip)
	skip = skip or 1
	local meta = minetest.get_meta(pos)
	local msg = meta:get_string("last_msg")
	local channel = meta:get_string("channel")
	local index = meta:get_int("index")
	local color = meta:get_int("last_color")
	local colorchar = color_to_char[color+1]
	if not index or index < 1 then index = 1 end
	local len = string.len(msg)
	index = index + skip
	if index > len then index = 1 end

	-- search backward to find the most recent color code in the string
	local r = index
	while r > 0 and not string.match(string.sub(msg, r, r+1), "/[0-9A-Ra-r]") do
		r = r - 1
	end
	if r == 0 then r = 1 end
	if string.match(string.sub(msg, r, r+1), "/[0-9A-Ra-r]") then
		colorchar = string.sub(msg, r+1, r+1)
	end

	-- search forward to find the next printable symbol after the current index
	local f = index
	while f < len do
		if string.match(string.sub(msg, f-1, f), "/[0-9A-Ra-r]") then
			f = f + 2
		else
			break
		end
	end
	led_marquee.display_msg(pos, channel, "/"..colorchar..string.sub(msg, f)..string.rep(" ", skip + 1))

	meta:set_int("index", f)
	if not elapsed or elapsed < 0.2 then return false end
	return true
end

-- the nodes:

local fdir_to_right = {
	{  0, -1 },
	{  0, -1 },
	{  0, -1 },
	{  0,  1 },
	{  1,  0 },
	{ -1,  0 },
}

local cbox = {
	type = "wallmounted",
	wall_top = { -8/16, 7/16, -8/16, 8/16, 8/16, 8/16 },
	wall_bottom = { -8/16, -8/16, -8/16, 8/16, -7/16, 8/16 },
	wall_side = { -8/16, -8/16, -8/16, -7/16, 8/16, 8/16 }
}

led_marquee.decode_color = function(msg)

end

led_marquee.display_msg = function(pos, channel, msg)
	msg = string.sub(msg, 1, 6144).." "
	if string.sub(msg,1,1) == string.char(255) then -- treat it as incoming UTF-8
		msg = make_iso(string.sub(msg, 2, 6144))
	end

	local master_fdir = minetest.get_node(pos).param2 % 8
	local master_meta = minetest.get_meta(pos)
	local last_color = master_meta:get_int("last_color")
	local pos2 = table.copy(pos)
	if not last_color or last_color < 0 or last_color > 27 then
		last_color = 0
		master_meta:set_int("last_color", 0)
	end
	local i = 1
	local len = string.len(msg)
	local wrapped = nil
	while i <= len do
		local node = minetest.get_node(pos2)
		local fdir = node.param2 % 8
		local meta = minetest.get_meta(pos2)
		local setchan = nil
		if meta then setchan = meta:get_string("channel") end
		local asc = string.byte(msg, i, i)
		if not string.match(node.name, "led_marquee:char_") then
			if not wrapped then
				pos2.x = pos.x
				pos2.y = pos2.y-1
				pos2.z = pos.z
				wrapped = true
			else
				break
			end
		elseif string.match(node.name, "led_marquee:char_")
			and fdir ~= master_fdir or (setchan ~= nil and setchan ~= "" and setchan ~= channel) then
			break
		elseif asc == 10 then
			pos2.x = pos.x
			pos2.y = pos2.y-1
			pos2.z = pos.z
			i = i + 1
			wrapped = nil
		elseif asc == 29 then
			local c = string.byte(msg, i+1, i+1) or 0
			local r = string.byte(msg, i+2, i+2) or 0
			pos2.x = pos.x + (fdir_to_right[fdir+1][1])*c
			pos2.y = pos.y - r
			pos2.z = pos.z + (fdir_to_right[fdir+1][2])*c
			i = i + 3
			wrapped = nil
		elseif asc == 30 then -- translate to slash for printing
			minetest.swap_node(pos2, { name = "led_marquee:char_47", param2 = master_fdir + (last_color*8)})
			pos2.x = pos2.x + fdir_to_right[fdir+1][1]
			pos2.z = pos2.z + fdir_to_right[fdir+1][2]
			i = i + 1
		elseif asc == 47 then -- slash
			local ccode = string.sub(msg, i+1, i+1)
			if ccode then
				if char_to_color[ccode] then
					last_color = char_to_color[ccode]
					i = i + 2
				else
					minetest.swap_node(pos2, { name = "led_marquee:char_47", param2 = master_fdir + (last_color*8)})
					pos2.x = pos2.x + fdir_to_right[fdir+1][1]
					pos2.z = pos2.z + fdir_to_right[fdir+1][2]
					i = i + 1
				end
			end
			master_meta:set_int("last_color", last_color)
			wrapped = nil
		elseif asc > 30 and asc < 256 then
			minetest.swap_node(pos2, { name = "led_marquee:char_"..asc, param2 = master_fdir + (last_color*8)})
			pos2.x = pos2.x + fdir_to_right[fdir+1][1]
			pos2.z = pos2.z + fdir_to_right[fdir+1][2]
			i = i + 1
			wrapped = nil
		else
			i = i + 1
		end
	end
end

local on_digiline_receive_string = function(pos, node, channel, msg)
	local meta = minetest.get_meta(pos)
	local setchan = meta:get_string("channel")
	local last_color = meta:get_int("last_color")
	if not last_color or last_color < 0 or last_color > 27 then
		last_color = 0
		meta:set_int("last_color", 0)
	end
	local fdir = node.param2 % 8

	if setchan ~= channel then return end
	if msg and msg ~= "" and type(msg) == "string" then
		if string.len(msg) > 1 then
			if msg == "clear" then
				led_marquee.set_timer(pos, 0)
				msg = string.rep(" ", 2048)
				meta:set_string("last_msg", msg)
				led_marquee.display_msg(pos, channel, msg)
				meta:set_int("index", 1)
			elseif msg == "allon" then
				led_marquee.set_timer(pos, 0)
				msg = string.rep(string.char(144), 2048)
				meta:set_string("last_msg", msg)
				led_marquee.display_msg(pos, channel, msg)
				meta:set_int("index", 1)
			elseif msg == "start_scroll" then
				local timeout = meta:get_int("timeout")
				led_marquee.set_timer(pos, timeout)
			elseif msg == "stop_scroll" then
				led_marquee.set_timer(pos, 0)
				return
			elseif string.sub(msg, 1, 12) == "scroll_speed" then
				local timeout = tonumber(string.sub(msg, 13))
				led_marquee.set_timer(pos, timeout)
			elseif string.sub(msg, 1, 11) == "scroll_step" then
				local skip = tonumber(string.sub(msg, 12))
				led_marquee.scroll_text(pos, nil, skip)
			elseif msg == "get" then -- get the master panel's displayed char as ASCII numerical value
				digilines.receptor_send(pos, digiline.rules.default, channel, tonumber(string.match(minetest.get_node(pos).name,"led_marquee:char_(.+)"))) -- wonderfully horrible string manipulaiton
			elseif msg == "getstr" then -- get the last stored message
				digilines.receptor_send(pos, digiline.rules.default, channel, meta:get_string("last_msg"))
			elseif msg == "getindex" then -- get the scroll index
				digilines.receptor_send(pos, digiline.rules.default, channel, meta:get_int("index"))
			else
				msg = string.gsub(msg, "//", string.char(30))
				led_marquee.set_timer(pos, 0)
				local last_msg = meta:get_string("last_msg")
				meta:set_string("last_msg", msg)
				led_marquee.display_msg(pos, channel, msg)
				if last_msg ~= msg then
					meta:set_int("index", 1)
				end
			end
		else
			local asc = string.byte(msg)
			if asc > 29 and asc < 256 then
				minetest.swap_node(pos, { name = "led_marquee:char_"..asc, param2 = fdir + (last_color*8)})
				meta:set_string("last_msg", tostring(msg))
				meta:set_int("index", 1)
			end
		end
	elseif msg and type(msg) == "number" then
		meta:set_string("last_msg", tostring(msg))
		led_marquee.display_msg(pos, channel, tostring(msg))
		meta:set_int("index", 1)
	end
end

-- the nodes!

for i = 31, 255 do
	local groups = { cracky = 2, not_in_creative_inventory = 1}
	local light = LIGHT_MAX-2
	local description = S("LED marquee panel ("..i..")")
	local leds = "led_marquee_char_"..i..".png^[mask:led_marquee_leds_on.png"

	if i == 31 then
		leds ={
			name = "led_marquee_char_31.png^[mask:led_marquee_leds_on_cursor.png",
			animation = {type = "vertical_frames", aspect_w = 32, aspect_h = 32, length = 0.75}
		}
	end

	local wimage

	if i == 32 then
		groups = {cracky = 2}
		light = nil
		description = S("LED marquee panel")
		wimage = "led_marquee_leds_off.png^(led_marquee_char_155.png^[multiply:red)"
	end

	minetest.register_node("led_marquee:char_"..i, {
		description = description,
		drawtype = "mesh",
		mesh = "led_marquee.obj",
		tiles = {
			{ name = "led_marquee_base.png", color = "white" },
			{ name = "led_marquee_leds_off.png", color = "white" }
		},
		overlay_tiles = { "", leds },
		inventory_image = wimage,
		wield_image = wimage,
		palette="led_marquee_palette.png",
		use_texture_alpha = true,
		groups = groups,
		paramtype = "light",
		paramtype2 = "colorwallmounted",
		light_source = light,
		selection_box = cbox,
		node_box = cbox,
		on_construct = function(pos)
			reset_meta(pos)
		end,
		on_receive_fields = function(pos, formname, fields, sender)
			local name = sender:get_player_name()
			if minetest.is_protected(pos, name) and not minetest.check_player_privs(name, {protection_bypass=true}) then
				minetest.record_protection_violation(pos, name)
				return
			end
			if (fields.channel) then
				minetest.get_meta(pos):set_string("channel", fields.channel)
			end
		end,
		digiline = {
			receptor = {},
			effector = {
				action = on_digiline_receive_string,
			},
		},
		drop = "led_marquee:char_32",
		on_timer = led_marquee.scroll_text
	})
end

-- crafts

minetest.register_craft({
	output = "led_marquee:char_32 6",
	recipe = {
		{ "default:glass", "default:glass", "default:glass" },
		{ "mesecons_lamp:lamp_off", "mesecons_lamp:lamp_off", "mesecons_lamp:lamp_off" },
		{ "group:wood", "mesecons_microcontroller:microcontroller0000", "group:wood" }
	},
})

