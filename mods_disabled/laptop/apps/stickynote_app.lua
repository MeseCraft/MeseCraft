local store_area = 'stickynote:files'

laptop.register_app("stickynote", {
	app_name = "Notepad",
	app_icon = "laptop_notes_pad.png",
	app_info = "Write Text Documents",
	formspec_func = function(app, mtos)
		local data = mtos.bdev:get_app_storage('system', 'stickynote')
		data.files = data.files or {}
		data.text = data.text or ""

		if data.selected_disk_name and data.selected_file_name then
			app.app_info = app.app_info..' - Open File: '..data.selected_disk_name..' / '..data.selected_file_name
		end

		-- cache sorted files list
		if not data.fileslist_sorted then
			data.fileslist_sorted = {}
			for filename,_ in pairs(data.files) do
				table.insert(data.fileslist_sorted, filename)
			end
			table.sort(data.fileslist_sorted)
		end

		local formspec = "background[0,1.35;15.2,8.35;"..mtos.theme.contrast_background.."]"..
				"textarea[0.35,1.35;15.08,9.5;text;;"..minetest.formspec_escape(data.text).."]"..
				mtos.theme:get_button('0,0.5;1.5,0.8', 'minor', 'clear', 'New', 'New file')..
				mtos.theme:get_button('2,0.5;1.5,0.8', 'minor', 'load', 'Load', 'Load file')..
				mtos.theme:get_button('4,0.5;1.5,0.8', 'minor', 'save', 'Save', 'Save file')..
				mtos.theme:get_button('8,0.5;1.5,0.8', 'minor', 'print', 'Print', 'Print file')
		return formspec
	end,
	receive_fields_func = function(app, mtos, sender, fields)
		local data = mtos.bdev:get_app_storage('system', 'stickynote')
		if fields.text then
			data.text = fields.text
		end

		if fields.load then
			mtos:select_file_dialog({
					mode = 'open',
					allowed_disks = {'hdd', 'removable'},
					selected_disk_name = data.selected_disk_name,
					selected_file_name = data.selected_file_name,
					store_name = store_area,
					prefix = 'open_',
			})
		elseif fields.open_selected_disk and fields.open_selected_file then
			data.selected_disk_name = fields.open_selected_disk
			data.selected_file_name = fields.open_selected_file
			local store = mtos.bdev:get_app_storage(data.selected_disk_name, store_area)
			if store then
				data.text = store[data.selected_file_name].content
			end
		elseif fields.save then
			mtos:select_file_dialog({
					mode = 'save',
					allowed_disks = {'hdd', 'removable'},
					selected_disk_name = data.selected_disk_name,
					selected_file_name = data.selected_file_name,
					store_name = store_area,
					prefix = 'save_',
			})
		elseif fields.save_selected_disk and fields.save_selected_file then
			data.selected_disk_name = fields.save_selected_disk
			data.selected_file_name = fields.save_selected_file
			local store = mtos.bdev:get_app_storage(data.selected_disk_name, store_area)
			if store then
				store[data.selected_file_name] = { content = data.text, ctime = os.time(), owner = sender:get_player_name() }
			end
		elseif fields.clear then
			data.selected_disk_name = nil
			data.selected_file_name = nil
			data.text = ""
		elseif fields.print then
			mtos:print_file_dialog({
				label = data.selected_file_name,
				text = data.text,
			})
		end
	end
})
