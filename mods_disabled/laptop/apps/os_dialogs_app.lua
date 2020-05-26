-- Tool to get data
local function get_file(key, value)
	if not value then
		return { name = key }
	elseif type(value) == 'string' then
		return { name = key, content = value }
	else
		return {
				name = key,
--				content = value.content or value,
				owner = value.owner,
				ctime = value.ctime,
			}
	end
end

laptop.register_view('os:power_off', {
	fullscreen = true,
})


laptop.register_view('os:select_file', {
	formspec_func = function(app, mtos)
		local param = mtos.bdev:get_app_storage('ram', 'os:select_file').param
		local allowed_disks = param.allowed_disks or { 'system' }
		local selected_disk
		if param.selected_disk_name then
			selected_disk = mtos.bdev:get_app_storage(param.selected_disk_name, param.store_name)
		end

		-- Get all available storage and check the storage_list
		local storage_list = {}
		for idx, disk in ipairs(allowed_disks) do
			local dev_exists = mtos.bdev:get_app_storage(disk, param.store_name)
			if dev_exists then
				if not selected_disk then
					selected_disk = dev_exists
					param.selected_disk_name = disk
				end
				table.insert(storage_list, disk)
			end
		end

		-- Get sorted files list
		param.files_list = {}
		if selected_disk then
			for key, value in pairs(selected_disk) do
				table.insert(param.files_list, get_file(key, value))
			end
		end
		table.sort(param.files_list, function(a,b) return a.name<b.name end)
		-- adjust tilte
		if param.mode == 'save' then
			param.message = 'Save file as'
			param.button_txt = 'Save'
		elseif param.mode == 'open' then
			param.message = 'Open file'
			param.button_txt = 'Open'
		else
			param.message = 'select file'
			param.button_txt = 'Select'
		end
		app.app_info = param.message

		-- available devices
		local formspec = mtos.theme:get_bgcolor_box('0,1.5;1.2,6', 'contrast')
		for idx, store in ipairs(storage_list) do
			local icon_pos = '0.2,'..(idx+0.8)
			if store == param.selected_disk_name then
				formspec = formspec .. mtos.theme:get_bgcolor_box('0.1,'..(idx+0.7)..';1,1', 'table_highlight')
			end
			if store == 'removable' then
				formspec = formspec .. 'item_image_button['..icon_pos..';1,1;'.. mtos.bdev:get_removable_disk().def.name..';disksel_removable;]'
			elseif store == 'hdd' then
				formspec = formspec .. 'item_image_button['..icon_pos..';1,1;'.. mtos.hwdef.nodename..';disksel_hdd;]'
			else
				formspec = formspec .. mtos.theme:get_button(icon_pos..';1,1', 'minor', 'disksel_'..store, store)
			end
		end
		formspec = formspec .. mtos.theme:get_button('0,7.7;1.4,1', 'minor', 'mount', 'Mount')

		-- Files table
		formspec = formspec .. mtos.theme:get_tableoptions().."tablecolumns[" ..
						"text;".. -- subject
						"text,padding=1.5;".. -- owner
						"text,padding=1.5,align=right]".. -- date
					"table[1.5,1.5;10.8,7.1;filesel;"
		local selected_idx = ""
		for idx, file in ipairs(param.files_list) do
			if idx > 1 then
				formspec = formspec..','
			end
			formspec = formspec..file.name..','..(file.owner or '')..','
			if file.ctime then
				formspec = formspec..os.date("%c", file.ctime)
			end
			if file.name == param.selected_file_name then
				selected_idx = idx
			end
		end
		formspec = formspec .. ";"..selected_idx.."]"

		-- Buttons
		if param.mode == 'save' then
			formspec = formspec .. mtos.theme:get_bgcolor_box('1.5,8.8;11,1.2', 'contrast')..
					mtos.theme:get_label("1.6,9.1", "File name:", "contrast").."field[3.2,9.3;5.5,0.8;filename;;"..(param.selected_file_name or "").."]"
		else
			formspec = formspec .. mtos.theme:get_label('1.5, 9.3', "Selected file: "..(param.selected_file_name or ""))
		end
		if param.selected_file_name and param.selected_file_name ~= "" and
				selected_disk and selected_disk[param.selected_file_name] then
			formspec = formspec .. mtos.theme:get_button('10.2,8.9;1.5,1', 'minor', 'delete', 'Delete')
			formspec = formspec .. mtos.theme:get_button('8.5,8.9;1.5,1', 'major', 'select', param.button_txt)
		elseif param.mode == 'save' then
			formspec = formspec .. mtos.theme:get_button('8.5,8.9;1.5,1', 'major', 'select', param.button_txt)
		end

		return formspec
	end,

-- Input processing
	receive_fields_func = function(app, mtos, sender, fields)
		local st = mtos.bdev:get_app_storage('ram', 'os:select_file')
		local param = st.param

		if fields.filename then
			param.selected_file_name = fields.filename
		end

		for field, value in pairs(fields) do
			if field:sub(1,7) == 'disksel' then
				param.selected_disk_name = field:sub(9,-1)
				break
			end
		end

		if fields.mount then
			mtos:set_app("removable")

		elseif fields.filesel then
			local event = minetest.explode_table_event(fields.filesel)
			if param.files_list[event.row] then
				param.selected_file_name = param.files_list[event.row].name
			end

		elseif fields.select and param.selected_file_name and param.selected_file_name ~= "" 
				and param.selected_disk_name and param.selected_disk_name ~= "" then
			param.prefix = param.prefix or ""
			local pass_fields = {
					[param.prefix..'selected_disk'] = param.selected_disk_name,
					[param.prefix..'selected_file'] = param.selected_file_name,
			}
			app:back_app(pass_fields, sender)
			st.param = nil
		elseif fields.delete and param.selected_disk_name and param.selected_file_name then
			local store = mtos.bdev:get_app_storage(param.selected_disk_name, param.store_name)
			if store then
				store[param.selected_file_name] = nil
			end
		end
	end
})
