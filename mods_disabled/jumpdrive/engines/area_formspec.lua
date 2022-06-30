local has_technic = minetest.get_modpath("technic")

local inv_offset = 0
if has_technic then
	inv_offset = 1.25
end

jumpdrive.update_area_formspec = function(meta, pos)
	local formspec =
		"size[8," .. 9.3+inv_offset .. ";]" ..

		"field[0.3,0.5;8,1;area_number;Area;" .. meta:get_int("area_number") .. "]" ..

		"button_exit[0,1;2,1;jump;Jump]" ..
		"button_exit[2,1;2,1;show;Show]" ..
		"button_exit[4,1;2,1;save;Save]" ..
		"button[6,1;2,1;reset;Reset]" ..

		"button[0,2;4,1;write_book;Write to book]" ..
		"button[4,2;4,1;read_book;Read from book]" ..

		-- main inventory for fuel and books
		"list[context;main;0,3.25;8,1;]" ..

		-- player inventory
		"list[current_player;main;0,".. 4.5+inv_offset .. ";8,4;]" ..

		-- digiline channel
		"field[4.3," .. 9.02+inv_offset ..";3.2,1;digiline_channel;Digiline channel;" ..
		(meta:get_string("channel") or "") .. "]" ..
		"button_exit[7," .. 8.7+inv_offset .. ";1,1;set_digiline_channel;Set]" ..

		-- listring stuff
		"listring[context;main]" ..
		"listring[current_player;main]"

	if has_technic then
		formspec = formspec ..
			-- technic upgrades
			"label[3,4.7;Upgrades]" ..
			"list[context;upgrade;4,4.5;4,1;]"
	end

	meta:set_string("formspec", formspec)
end
