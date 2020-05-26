
jumpdrive.fleet.update_formspec = function(meta, pos)

	local button_line =
		"button_exit[0,1.5;2,1;jump;Jump]" ..
		"button_exit[2,1.5;2,1;show;Show]" ..
		"button_exit[4,1.5;2,1;save;Save]" ..
		"button[6,1.5;2,1;reset;Reset]"

	if meta:get_int("active") == 1 then
		local jump_index = meta:get_int("jump_index")
		local jump_list = minetest.deserialize( meta:get_string("jump_list") )

		meta:set_string("infotext", "Controller active: " .. jump_index .. "/" .. #jump_list)

		button_line = "button_exit[0,1.5;8,1;stop;Stop]"
	else
		meta:set_string("infotext", "Ready")
	end

	meta:set_string("formspec", "size[8,10;]" ..
		"field[0.3,0.5;2,1;x;X;" .. meta:get_int("x") .. "]" ..
		"field[3.3,0.5;2,1;y;Y;" .. meta:get_int("y") .. "]" ..
		"field[6.3,0.5;2,1;z;Z;" .. meta:get_int("z") .. "]" ..

		button_line ..

		"button[0,2.5;4,1;write_book;Write to book]" ..
		"button[4,2.5;4,1;read_book;Read from book]" ..

		"list[context;main;0,3.75;8,1;]" ..

		"list[current_player;main;0,5;8,4;]" ..

		"field[4.3,9.52;3.2,1;digiline_channel;Digiline channel;" .. (meta:get_string("channel") or "") .. "]" ..
		"button_exit[7,9.2;1,1;set_digiline_channel;Set]" ..

		-- listring stuff
		"listring[]")
end
