local printer_range = 10

local function trigger_queue(mtos)
	-- Check print requirements
	if mtos.sysdata.selected_view ~= 'output' or
			mtos.sysdata.out_stack_save or
			not mtos.sysdata.paper_count or mtos.sysdata.paper_count == 0 or
			not mtos.sysdata.dye_count or mtos.sysdata.dye_count == 0 or
			not mtos.sysdata.print_queue or
			not mtos.sysdata.print_queue[1] then
		mtos.sysdata.print_progress = 0
		return false
	end

	-- timer done
	if mtos.sysdata.print_progress >= 5 then
		mtos.sysdata.print_progress = 0
		mtos.sysdata.paper_count = mtos.sysdata.paper_count - 1
		mtos.sysdata.dye_count = mtos.sysdata.dye_count - 0.1
		local idata = mtos.bdev:get_removable_disk()
		local stack = ItemStack("laptop:printed_paper")
		local print_data = mtos.sysdata.print_queue[1]
		stack:get_meta():from_table({ fields = print_data})
		table.remove(mtos.sysdata.print_queue, 1)
		idata:reload(stack)
		idata.label = print_data.title
	end

	local timer = minetest.get_node_timer(mtos.pos)
	if not timer:is_started() then
		timer:start(1)
	end
	return true
end

local function sync_stack_values(mtos)
	mtos.sysdata.paper_count = mtos.sysdata.paper_count or 0
	mtos.sysdata.dye_count = mtos.sysdata.dye_count or 0
	mtos.sysdata.print_progress = mtos.sysdata.print_progress or 0
	local idata = mtos.bdev:get_removable_disk()
	-- store old stack values
	if mtos.sysdata.selected_view == 'paper' then
		if idata.stack then
			mtos.sysdata.paper_count = idata.stack:get_count()
		else
			mtos.sysdata.paper_count = 0
		end
	elseif mtos.sysdata.selected_view == 'dye' then
		if idata.stack then
			mtos.sysdata.dye_count = mtos.sysdata.dye_count - math.floor(mtos.sysdata.dye_count) + idata.stack:get_count()
		else
			mtos.sysdata.dye_count = mtos.sysdata.dye_count - math.floor(mtos.sysdata.dye_count)
		end
	elseif mtos.sysdata.selected_view == 'output' then
		if idata.stack then
			mtos.sysdata.out_stack_save = idata.stack:to_string()
		else
			mtos.sysdata.out_stack_save  = nil
		end
	end
end

laptop.register_app("printer_launcher", {
	app_name = "Printer firmware",
	view = true, -- to be hidden in "usual" OS
	fullscreen = true,
	formspec_func = function(launcher_app, mtos)
		mtos.sysdata.print_queue = mtos.sysdata.print_queue or {}
		mtos.sysdata.selected_view = mtos.sysdata.selected_view or 'output'
		sync_stack_values(mtos)
		trigger_queue(mtos)
		-- inventory fields
		local formspec = "size[9,8]"..
				"list[current_player;main;0.3,3.85;8,1;]" ..
				"list[current_player;main;0.3,5.08;8,3;8]" ..
				"listring[nodemeta:"..mtos.pos.x..','..mtos.pos.y..','..mtos.pos.z..";main]" ..
				"listring[current_player;main]"..
				mtos.theme:get_label('0,0', mtos.hwdef.description, 'titlebar')
		local idata = mtos.bdev:get_removable_disk()

		-- queue
		formspec = formspec .. mtos.theme:get_tableoptions()..
				"tablecolumns[" ..
						"text;".. -- label
						"text;".. -- author
						"text]".. -- timestamp
				"table[0,0.5;5,2.42;printers;"
		for idx, file in ipairs(mtos.sysdata.print_queue) do
			if idx > 1 then
				formspec = formspec..','
			end
			formspec = formspec .. minetest.formspec_escape(file.title or "")..','..
					(file.author or "")..','..os.date("%c", file.timestamp)
		end
		formspec = formspec .. ";]"

		local out_button = 'minor'
		local paper_button = 'minor'
		local dye_button = 'minor'
		if mtos.sysdata.selected_view == 'paper' then
			paper_button = 'major'
			formspec = formspec .."background[6.2,0.8;2.5,0.7;"..mtos.theme.contrast_background..']'
		elseif mtos.sysdata.selected_view == 'dye' then
			dye_button = 'major'
			formspec = formspec .."background[6.2,1.5;2.5,0.7;"..mtos.theme.contrast_background..']'
		elseif mtos.sysdata.selected_view == 'output' then
			out_button = 'major'
			formspec = formspec .."background[6.2,2.2;2.5,0.7;"..mtos.theme.contrast_background..']'
		end

		formspec = formspec .."background[5.2,0.55;1.5,2.45;"..mtos.theme.contrast_background..']'..
				mtos.theme:get_label('5.3,0.8', 'Paper: '..mtos.sysdata.paper_count, 'contrast')..
				mtos.theme:get_label('5.3,1.3', 'Dye: '..mtos.sysdata.dye_count, 'contrast')..
				mtos.theme:get_button('6.8,0.8;1.5,0.7', paper_button, 'view_paper', 'Paper tray', 'Insert paper')..
				mtos.theme:get_button('6.8,1.5;1.5,0.7', dye_button, 'view_dye', 'Dye tray', 'Insert black dye')..
				mtos.theme:get_button('6.8,2.2;1.5,0.7', out_button, 'view_out', 'Output tray', 'Get printed paper')..
				"list[nodemeta:"..mtos.pos.x..','..mtos.pos.y..','..mtos.pos.z..";main;5.4,1.8;1,1;]"..
				mtos.theme:get_button('0.3,3;1.5,0.7', 'minor', 'reset', 'Reset', 'Reset printer queue')..
				mtos.theme:get_button('2,3;1.5,0.7', 'minor', 'delete', 'Delete', 'Delete job')..
				"background[3.7,3.1;"..(mtos.sysdata.print_progress)..",0.5;laptop_theme_red_back_button.png]"
		return formspec
	end,

	appwindow_formspec_func = function(launcher_app, app, mtos)
		local formspec = 'size[10,7]'
		return formspec
	end,

	allow_metadata_inventory_put = function(app, mtos, player, listname, index, stack)
		if mtos.sysdata.selected_view == 'output' then
			-- nothing
		elseif  mtos.sysdata.selected_view == 'paper' and stack:get_name() == 'default:paper' then
			return stack:get_stack_max()
		elseif mtos.sysdata.selected_view == 'dye' and stack:get_name() == 'dye:black' then
			return stack:get_stack_max()
		end
		return 0
	end,

	allow_metadata_inventory_take = function(app, mtos, player, listname, index, stack)
		-- removal allways possible
		return stack:get_count()
	end,

	receive_fields_func = function(app, mtos, sender, fields)
		sync_stack_values(mtos)
		local idata = mtos.bdev:get_removable_disk()
		if fields.view_out then
			mtos.sysdata.selected_view = 'output'
			idata.stack = ItemStack(mtos.sysdata.out_stack_save or "")
		elseif fields.view_paper then
			mtos.sysdata.selected_view = 'paper'
			idata.stack = ItemStack('default:paper')
			idata.stack:set_count(mtos.sysdata.paper_count)
		elseif fields.view_dye then
			mtos.sysdata.selected_view = 'dye'
			idata.stack = ItemStack('dye:black')
			idata.stack:set_count(math.floor(mtos.sysdata.dye_count))
		elseif fields.reset then
			mtos.sysdata.print_queue = {}
			mtos.sysdata.print_progress = 0
		elseif fields.delete then
			table.remove(mtos.sysdata.print_queue, 1)
			mtos.sysdata.print_progress = 0
		end
		idata:reload(idata.stack)
		trigger_queue(mtos)
	end,

	on_timer = function(app, mtos)
		mtos.sysdata.print_progress = mtos.sysdata.print_progress + 1
		return trigger_queue(mtos)
	end,
})



local function get_printer_info(pos)
	local hw_os = laptop.os_get(pos)
	local printer
	if hw_os then
		printer = {
				pos = pos,
				name = hw_os.hwdef.description,
				nodename = hw_os.node.name,
			}
		if not minetest.registered_items[hw_os.node.name].groups.laptop_printer then
			printer.status =  'off'
--			printer.status_color = '#FF0000'
		elseif not hw_os.sysram.current_app or hw_os.sysram.current_app == 'os:power_off' then
			printer.status =  'disabled'
--			printer.status_color = '#FF0000'
		else
			printer.status = 'online'
--			printer.status_color = '#00FF00'
		end
	end
	return printer
end

laptop.register_view("printer:app", {
	app_info = "Print file",
	formspec_func = function(app, mtos)
		local store = mtos.bdev:get_app_storage('ram', 'printer:app')
		local param = store.param
		local sysstore = mtos.bdev:get_app_storage('system', 'printer:app')
		sysstore.printers = sysstore.printers or {}

		local formspec = mtos.theme:get_label('0.5,1', "Selected Printer:")
		if sysstore.selected_printer then
			local printer = get_printer_info(sysstore.selected_printer.pos)
			if not printer then
				printer = sysstore.selected_printer
				printer.status = 'removed'
			else
				sysstore.selected_printer = printer
			end
			local status_color = mtos.theme["status_"..printer.status.."_textcolor"] or mtos.theme.textcolor
			formspec = formspec .. 'item_image[0.5,1.5;1,1;'..printer.nodename..']'..
					mtos.theme:get_label('1.5,1.7', minetest.formspec_escape(printer.name)..' '..
					minetest.pos_to_string(printer.pos)..' '.. minetest.colorize(status_color, printer.status))
		end

		formspec = formspec .. mtos.theme:get_tableoptions()..
				"tablecolumns[" ..
						"text;".. -- Printer name
						"text;".. -- Printer position
						"color;"..-- Status color
						"text]".. -- Printer status
				"table[0.5,2.5;6.5,4.2;printers;"
		if sysstore.printers[1] then
			local sel_idx = ""
			for idx, printer in ipairs(sysstore.printers) do
				if idx > 1 then
					formspec = formspec..','
				end
				local pos_string = minetest.pos_to_string(printer.pos)
				local status_color = mtos.theme["status_"..printer.status.."_textcolor"] or mtos.theme.textcolor
				formspec = formspec..minetest.formspec_escape(printer.name)..','..
						minetest.formspec_escape(minetest.pos_to_string(printer.pos))..','..
						status_color..','..printer.status
				if sysstore.selected_printer and vector.distance(printer.pos, sysstore.selected_printer.pos) == 0 then
					sel_idx = idx
				end
			end
			formspec = formspec .. ";"..sel_idx.."]"
		else
			formspec = formspec .. "No printer found :(]"
		end

		formspec = formspec .. mtos.theme:get_button('2.7,9;2,0.7', 'minor', 'scan', 'Search', 'Scan for printers')
		if sysstore.selected_printer and sysstore.selected_printer.status == 'online' then
			formspec = formspec .. mtos.theme:get_button('10,9;2,0.7', 'major', 'print', 'Print', 'Print file')
		end

		param.label = param.label or "<unnamed>"

		formspec = formspec .. mtos.theme:get_bgcolor_box("7.15,0.4;7.6,1","contrast")..
				mtos.theme:get_label('7.3,0.6','Heading:','contrast').."field[9.7,0.7;5,1;label;;"..minetest.formspec_escape(param.label or "").."]"..
				mtos.theme:get_label('9.7,1.7'," by "..(mtos.sysram.current_player or ""))..
				mtos.theme:get_tableoptions(false).."tablecolumns[text]table[7.15,2.5;7.6,6.0;preview_bg;]"..
				"textarea[7.5,2.5;7.5,7;;"..minetest.colorize(mtos.theme.table_textcolor, (minetest.formspec_escape(param.text) or ""))..";]"

		return formspec
	end,
	receive_fields_func = function(app, mtos, sender, fields)
		local store = mtos.bdev:get_app_storage('ram', 'printer:app')
		local param = store.param
		local sysstore = mtos.bdev:get_app_storage('system', 'printer:app')
		sysstore.printers = sysstore.printers or {}

		if fields.scan then
			sysstore.printers = {}
			local nodes = minetest.find_nodes_in_area({x = mtos.pos.x-printer_range, y= mtos.pos.y-printer_range, z = mtos.pos.z-printer_range},
					{x = mtos.pos.x+printer_range, y= mtos.pos.y+printer_range, z = mtos.pos.z+printer_range}, {"group:laptop_printer"})
			for _, pos in ipairs(nodes) do
				local printer = get_printer_info(pos)
				if printer then
					printer.printer_os = nil -- do not store whole OS
					table.insert(sysstore.printers, printer)
				end
			end
			table.sort(sysstore.printers, function(a,b) return vector.distance(a.pos, mtos.pos) < vector.distance(b.pos, mtos.pos) end)
		end

		if fields.printers then
			local event = minetest.explode_table_event(fields.printers)
			sysstore.selected_printer = sysstore.printers[event.row] or sysstore.selected_printer
		end

		if fields.label then
			param.label = fields.label
		end

		if fields.print and sysstore.selected_printer then
			local hw_os = laptop.os_get(sysstore.selected_printer.pos)
			if hw_os and minetest.registered_items[hw_os.node.name].groups.laptop_printer then
				hw_os.sysdata.print_queue = hw_os.sysdata.print_queue or {}
				sync_stack_values(hw_os)
				table.insert(hw_os.sysdata.print_queue, { title = param.label, text = param.text, author = param.author or sender:get_player_name(), timestamp = param.timestamp or os.time() })
				hw_os:set_app() --update page
				app:back_app()
			end
		end
	end,
})
