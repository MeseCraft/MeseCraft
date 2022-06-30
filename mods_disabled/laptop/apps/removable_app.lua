laptop.register_app("removable", {
	app_name = "Removable Storage",
	app_icon = "laptop_removable.png",
	app_info = "Interface with Removable Media",
	formspec_func = function(app, mtos)
		local formspec = 
				"list[nodemeta:"..mtos.pos.x..','..mtos.pos.y..','..mtos.pos.z..";main;0,0.3;1,1;]" ..
				"list[current_player;main;0,4.85;8,1;]" ..
				"list[current_player;main;0,6.08;8,3;8]" ..
				"listring[nodemeta:"..mtos.pos.x..','..mtos.pos.y..','..mtos.pos.z..";main]" ..
				"listring[current_player;main]"..
				"background[0,0.3;8,1;".. mtos.theme.contrast_background .. ']'

		mtos.bdev.removable_disk = nil -- force reading
		local idata = mtos.bdev:get_removable_disk()
		if idata.stack then
			-- change label
			formspec = formspec .. "field[2,0.65;4,1;label;;"..idata.label.."]"..
					mtos.theme:get_button('5.7,0.5;1.5,0.7', 'minor', 'set_label', 'Rename', 'Rename the '..idata.def.description)..
					mtos.theme:get_label('0,1.5', idata.def.description)..
					mtos.theme:get_label('0,2', "Format: "..idata.os_format)..
			-- buttons
					mtos.theme:get_button('0,3;1.5,0.7', 'minor', 'format_wipe', 'wipe', 'Wipe all data from disk')..
					mtos.theme:get_button('0,4;1.5,0.7', 'minor', 'format_data', 'data', 'Format disk to store data')
			if idata.def.groups.laptop_removable_usb then
				formspec = formspec .. mtos.theme:get_button('2,3;1.5,0.7', 'minor', 'format_backup', 'backup', 'Store backup to disk')
			end
			if idata.os_format == "backup" then
				formspec = formspec .. mtos.theme:get_button('2,4;1.5,0.7', 'minor', 'restore', 'restore', 'Restore from backup disk')
			end

			-- format CS-BOS
			if idata.def.groups.laptop_removable_floppy then
				formspec = formspec .. mtos.theme:get_button('4,3;1.5,0.7', 'minor', 'format_csbos', 'CS-BOS', 'Format disk to boot CS-BOS ')
			end
		end
		return formspec
	end,

	receive_fields_func = function(app, mtos, sender, fields)
		local idata = mtos.bdev:get_removable_disk()
		if idata.stack then
			if fields.set_label then
				idata.label = fields.label
			elseif fields.format_wipe then
				idata:format_disk()
			elseif fields.format_data then
				idata:format_disk("data", "Data "..idata.def.description)
			elseif fields.format_backup then
				idata:format_disk("backup", "Backup of "..mtos.hwdef.description.." from "..os.date('%x'))
				idata.meta:set_string("backup_data", mtos.meta:get_string('laptop_appdata'))
			elseif fields.format_csbos then
				idata:format_disk("boot", "CS-BOS Boot Disk")
			elseif fields.restore then
				mtos.meta:set_string('laptop_appdata', idata.meta:get_string("backup_data"))
				mtos.bdev = laptop.get_bdev_handler(mtos)
				mtos:power_on() --reboot
			end
		end
		laptop.mtos_cache:sync_and_free(mtos)
	end,
})
