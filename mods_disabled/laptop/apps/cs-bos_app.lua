local help_texts = {
	CLS = "                   Clears the screen.",
	CD = "                     Change disk. CD [HDD,FDD]",
	DATE = "                 Displays the current system date.",
	DIR = "                     Display directory of current disk. DIR [filename] brings up info for specified file or files if using wild card *.",
	DEL = "                   Delete a file. DEL [FILENAME]",
	HALT = "                  Shut down CS-BOS.",
	HELP = "                 Displays HELP menu. HELP [command] displays help on that command.",
	MEM = "                  Displays memory usage table.",
	EXIT = "                   Exit CS-BOS shell",
	REBOOT = "           Perform a soft reboot.",
	TEXTCOLOR = "   Change terminal text color. TEXTCOLOR [green, amber, or white]",
	SCROLLBACK = "Change terminal scrollback size. SCROLLBACK [##]",
	TIME = "                  Displays the current system time.",
	TIMEDATE = "        Displays the current system time and date.",
	VER = "                   Displays CS-BOS version.",
	FORMAT = "           View format information or Format Disk. FORMAT [/E] Erase disk, [/S] Create system (boot) disk, [/D] Create data disk",
	LABEL = "               Show/Set floppy label. LABEL [new_label]",
}

local function get_initial_message(mtos, data)
	data.outlines = {
		"BASIC OPERATING SYSTEM v"..mtos.os_attr.version_string,
		"(C)COPYRIGHT "..mtos.os_attr.releaseyear.." CARDIFF-SOFT",
		"128K RAM SYSTEM  77822 BYTES FREE",
	}
end


local function add_outline(data, line)
	table.insert(data.outlines, line)
	if #data.outlines > data.scrollback_size then
		for i = data.scrollback_size, #data.outlines do
			table.remove(data.outlines,1)
		end
	end
end


local function is_executable_app(mtos, app)
	if not mtos.sysdata then -- cannot executed withoud sysdata
		return false
	elseif app and not app.view and -- app given
			app.name ~= 'cs-bos_launcher' and -- No recursive calls
			mtos:is_app_compatible(app.name) then
		return true
	else
		return false
	end
end

local function numWithCommas(n)
  return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,"):gsub(",(%-?)$","%1"):reverse()
end


--- Simple VFS for BOS Operations
local simple_vfs_map = {}
-- Hard disk
simple_vfs_map.HDD = {
	id = 'HDD',
	dev = 'hdd',
	longname = 'DISK 0:HDD',
	check_inserted = function(disk, mtos)
		return mtos.bdev:is_hw_capability('hdd')
	end,
	get_full_name = function(disk, mtos)
		return disk.longname
	end,
	get_format = function(disk, mtos)
		return 'BOOT'
	end,
}
-- Floppy disk
simple_vfs_map.FDD = {
	id = 'FDD',
	dev = 'removable',
	longname = 'DISK 0:FDD',
	check_inserted = function(disk, mtos)
		local idata = mtos.bdev:get_removable_disk()
		if idata.stack and ( idata.os_format == 'data' or idata.os_format == 'boot') then
			return true
		end
	end,
	get_full_name = function(disk, mtos)
		local idata = mtos.bdev:get_removable_disk()
		return disk.longname..": "..idata.label
	end,
	get_format = function(disk, mtos)
		local idata = mtos.bdev:get_removable_disk()
		return idata.os_format
	end,
}
simple_vfs_map.REMOVABLE = simple_vfs_map.FDD


local simple_vfs = {}
-- Get the VFS disk object
function simple_vfs.get_disk(mtos, device)
	if not device then
		return
	end
	local disk = simple_vfs_map[device:upper()]
	local inserted
	if disk then
		inserted  = disk:check_inserted(mtos)
	end
	return disk, inserted
end


function simple_vfs.parse_path(input_line)
	local filename = input_line:gsub("^%s*(.-)%s*$", "%1") -- strip spaces
	local diskname
	if filename:sub(4,4) == ':' then
		diskname = filename:sub(1,3)
		filename = filename:sub(5)
	end
	return filename, diskname
end
--- End for Simple VFS for BOS Operations


local function initialize_data(data, sdata, mtos, sysos)
	if mtos.os_attr.tty_monochrome then
		data.tty = mtos.os_attr.tty_style
	else
		data.tty = sdata.tty or data.tty or mtos.os_attr.tty_style
		if not laptop.supported_textcolors[data.tty] then --compat hack
			data.tty = mtos.os_attr.tty_style
		end
	end

	data.scrollback_size = sdata.scrollback_size or data.scrollback_size or mtos.os_attr.min_scrollback_size
		-- Set initial message on new session
	if not data.outlines then
		get_initial_message(mtos, data)
	end

	if not data.current_disk then
		if sysos.booted_from == 'removable' then
			data.current_disk = 'FDD'
		else
			data.current_disk = 'HDD'
		end
	end
	data.inputfield = data.inputfield or ""
end


laptop.register_app("cs-bos_launcher", {
	app_name = "CS-BOS Prompt",
	app_info = "Command Line Interface",
	fullscreen = true,
	app_icon = "laptop_cs_bos.png",

	formspec_func = function(cs_bos, mtos)
		local data = mtos.bdev:get_app_storage('ram', 'cs_bos')
		local sysos = mtos.bdev:get_app_storage('ram', 'os')
		local sdata = mtos.bdev:get_app_storage('system', 'cs_bos') or {} -- handle temporary if no sysdata given

		-- no system found. In case of booted from removable, continue in live mode
		if not mtos.sysdata and sysos.booted_from ~= "removable" then
			local formspec = "size[10,7]background[10,7;0,0;laptop_launcher_insert_floppy.png;true]"..
					"listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"..
					"list[nodemeta:"..mtos.pos.x..','..mtos.pos.y..','..mtos.pos.z..";main;2.5,3;1,1;]" ..
					"list[current_player;main;0,6.5;8,1;]" ..
					"listring[nodemeta:"..mtos.pos.x..','..mtos.pos.y..','..mtos.pos.z..";main]" ..
					"listring[current_player;main]"

			local idata = mtos.bdev:get_removable_disk()
			if idata.stack then
				if idata.os_format ~= "boot" then
					formspec = formspec .. "label[0,1.7;Disk found but not formatted to boot]"
				end
			end
			return formspec
		end

		initialize_data(data, sdata, mtos, sysos)
		local tty = laptop.supported_textcolors[data.tty]
		local formspec =
				"size[15,10]background[15,10;0,0;laptop_theme_desktop_icon_label_button_black.png;true]"..
				"label[-0.15,9.9;"..minetest.colorize(tty,data.current_disk..">").."]"..
				"field[1.020,9.93;15.6,1;inputfield;;"..minetest.formspec_escape(data.inputfield).."]"..
				"tablecolumns[text]tableoptions[background=#000000;border=false;highlight=#000000;"..
				"color="..tty..";highlight_text="..tty.."]"..
				"table[-0.35,-0.35;15.57, 10.12;outlines;"
		for idx,line in ipairs(data.outlines) do
			if idx > 1 then
				formspec = formspec..','
			end
			formspec = formspec..minetest.formspec_escape(line)
		end
		formspec = formspec..";"..#data.outlines.."]".."field_close_on_enter[inputfield;false]"
		return formspec
	end,

	receive_fields_func = function(cs_bos, mtos, sender, fields)
		local data = mtos.bdev:get_app_storage('ram', 'cs_bos')
		local sysos = mtos.bdev:get_app_storage('ram', 'os')
		local sdata = mtos.bdev:get_app_storage('system', 'cs_bos') or {} -- handle temporary if no sysdata given
		initialize_data(data, sdata, mtos, sysos)

		if fields.inputfield then -- move received data to the formspec input field
			data.inputfield = fields.inputfield
		end

		if fields.key_enter then
			-- run the command
			local exec_all = data.inputfield:split(" ")
			local input_line = data.inputfield
			local exec_command = exec_all[1] --further parameters are 2++
			add_outline(data, "> "..data.inputfield)
			data.inputfield = ""
			if exec_command then
				exec_command = exec_command:upper()
			end
			if exec_command == nil then --empty line
			elseif mtos.os_attr.blacklist_commands[exec_command] then
				add_outline(data, '?ERROR NOT IMPLEMENTED')
			elseif exec_command == "HALT" then
				-- same code as in node_fw on punch to disable the OS
				if mtos.hwdef.next_node then
					local hwdef_next = laptop.node_config[mtos.hwdef.next_node]
					if hwdef_next.hw_state then
						mtos[hwdef_next.hw_state](mtos, mtos.hwdef.next_node)
					else
						mtos:swap_node(hwdef.next_node)
						mtos:save()
					end
				end
			elseif exec_command == "DEL" then
				local filename, diskname = simple_vfs.parse_path(input_line:sub(5))
				if filename then
					local disk, inserted = simple_vfs.get_disk(mtos, diskname or data.current_disk)
					if disk and inserted then
						local txtdata = mtos.bdev:get_app_storage(disk.dev, 'stickynote:files')
						if txtdata and txtdata[filename] then
							txtdata[filename] = nil
							add_outline(data, filename:upper()..' DELETED SUCCESSFULY')
						else
							add_outline(data, 'FILE NOT FOUND: '..filename)
						end
					end
				end
			elseif exec_command == "EXIT" then
				data.outlines = nil  -- reset screen
				mtos:set_app()  -- quit app (if in app mode)
			elseif exec_command == "REBOOT" then
				mtos:power_on()  -- reboots computer
			elseif exec_command == "EJECT" then
				local idata = mtos.bdev:get_removable_disk()
				local success = idata:eject()
				if success then
					add_outline(data, 'DISK EJECTED')
				else
					add_outline(data, 'NO DISK FOUND')
				end
			elseif is_executable_app(mtos, laptop.apps[exec_command:lower()]) then
				add_outline(data, 'LAUNCHED '..exec_command)
				mtos:set_app(exec_command:lower())
			elseif exec_command == "CD" then
				local disk, inserted = simple_vfs.get_disk(mtos, exec_all[2])
				if disk and inserted then
					data.current_disk = disk.id
					add_outline(data, "CURRENT DISK = "..disk:get_full_name(mtos))
				elseif disk then
					add_outline(data, 'NO DISK PRESENT: '..disk.longname)
				else
					add_outline(data, "?SYNTAX ERROR")
				end
			elseif exec_command == "DIR" then
				local searchstring, diskname = simple_vfs.parse_path(input_line:sub(5))
				local disk, inserted = simple_vfs.get_disk(mtos, diskname or data.current_disk)
				if disk and inserted then
					local txtdata = mtos.bdev:get_app_storage(disk.dev, 'stickynote:files')
					local message = "VIEWING CONTENTS OF "..disk:get_full_name(mtos)
					if searchstring and searchstring ~= '' then
						message = message .. ' FILTER STRING '..searchstring
					end
					add_outline(data, message)
					add_outline(data, "FORMAT: "..disk:get_format(mtos))
					add_outline(data, "")
					local file_found
					if sysos.booted_from == disk.dev then
						for k, v in pairs(laptop.apps) do
							if is_executable_app(mtos, v) then
								if not searchstring or searchstring == '' or k:upper():match('^'..searchstring:upper():gsub('*','.*')..'$' ) then
									add_outline(data, k:upper().."*    "..(v.app_info or ""))
									file_found = true
								end
							end
						end
					end
					for k, v in pairs(txtdata) do
						if not searchstring or searchstring == '' or k:match('^'..searchstring:gsub('*','.*')..'$' ) then
							add_outline(data, k.."      "..v.owner.."      "..os.date("%I:%M:%S %p, %A %B %d, %Y", v.ctime))
							file_found = true
						end
					end
					if not file_found then
						add_outline(data, 'NO FILES ON THIS DISK')
					end
				elseif disk then
					add_outline(data, 'NO DISK PRESENT: '..disk.longname)
				else
					add_outline(data, "?SYNTAX ERROR")
				end
			elseif exec_command == "TYPE" then
				local filename, diskname = simple_vfs.parse_path(input_line:sub(6))
				if filename then
					local disk, inserted = simple_vfs.get_disk(mtos, diskname or data.current_disk)
					if disk and inserted then
						local txtdata = mtos.bdev:get_app_storage(disk.dev, 'stickynote:files')
						if txtdata then
							local file = txtdata[filename]
							if file and file.content then
								for s in file.content:gmatch("[^\n]+") do
									add_outline(data, s)
								end
							else
								add_outline(data, 'FILE NOT FOUND: '..filename)
							end
						end
					elseif disk then
						add_outline(data, 'NO DISK PRESENT: '..disk.longname)
					else
						add_outline(data, "?SYNTAX ERROR")
					end
				else
					add_outline(data, '?SYNATX ERROR')
				end
			elseif exec_command == "CLS" then
				data.outlines = {}
			elseif exec_command == "TIME" then
				add_outline(data, os.date("%I:%M:%S %p"))
			elseif exec_command == "DATE" then
				add_outline(data, os.date("%A %B %d, %Y"))
			elseif exec_command == "TIMEDATE" then
				add_outline(data, os.date("%I:%M:%S %p, %A %B %d, %Y"))
			elseif exec_command == "VER" then
				add_outline(data, 'CARDIFF-SOFT BASIC OPERATING SYSTEM v'..mtos.os_attr.version_string)
			elseif exec_command == "MEM" then
				local convent = math.random(30,99)
				local upper = math.random(10,99)
				local xms = math.random(20000,99999)
				add_outline(data, 'Memory Type                 Total =            Used       +       Free')
				add_outline(data, '------------------------       -------------        -------------       -------------')
				add_outline(data, 'Conventional                        640                   '..convent..'                 '..(640-convent))
				add_outline(data, 'Upper                                    123                   '..upper..'                   '..(123-upper))
				add_outline(data, 'Reserved                                  0                     0                      0')
				add_outline(data, 'Extended (XMS)*         130,309           '..numWithCommas(xms)..'            '..numWithCommas(130309-xms))
				add_outline(data, '------------------------       -------------        -------------       -------------')
				add_outline(data, 'Total Memory                131,072            '..numWithCommas(convent+upper+xms)..'           '..numWithCommas(131072-(convent+upper+xms)))
			elseif exec_command == "TEXTCOLOR" then
				local textcolor = exec_all[2]
				if textcolor and laptop.supported_textcolors[textcolor:upper()] then
					sdata.tty = textcolor:upper()
					add_outline(data, 'SET TEXTCOLOR TO: '..sdata.tty)
				elseif textcolor then
					add_outline(data, '?SYNATX ERROR')
				else
					add_outline(data, 'TEXTCOLOR: '..data.tty)
				end
			elseif exec_command == "SCROLLBACK" then
				if exec_all[2] then
					local newsize = tonumber(exec_all[2])
					if newsize then
						if newsize >= mtos.os_attr.min_scrollback_size and newsize <= mtos.os_attr.max_scrollback_size then
							sdata.scrollback_size = newsize
							add_outline(data, 'SET SCROLLBACK TO: '..newsize)
						else
							add_outline(data, "?OUT OF RANGE")
						end
					else
						add_outline(data, "?SYNTAX ERROR")
					end
				else
					add_outline(data, "SCROLLBACK: "..data.scrollback_size)
					add_outline(data, "SUPPORTED: "..mtos.os_attr.min_scrollback_size.."-"..mtos.os_attr.max_scrollback_size)
				end
			elseif exec_command == "FORMAT" then
				local idata = mtos.bdev:get_removable_disk()
				if not idata.stack then
					add_outline(data, '?DISK NOT FOUND')
				else
					local fparam
					if exec_all[2] then
						fparam = exec_all[2]:upper()
					end
					local ftype, newlabel
					if fparam == "/E" then
						ftype = ""
						newlabel = ""
					elseif fparam == "/S" then
						ftype = "boot"
						newlabel = "CS-BOS Boot Disk"
					elseif fparam == "/D" then
						ftype = "data"
						newlabel = "Data "..idata.def.description
					end
					if not ftype and fparam then
						add_outline(data, "?SYNTAX ERROR")
					else
						if ftype then
							add_outline(data, 'FORMATTING '..idata.def.description)
							idata:format_disk(ftype, newlabel)
						else
							add_outline(data, 'MEDIA INFORMATION: '..idata.def.description)
						end
						add_outline(data, "FORMAT: "..idata.os_format)
						add_outline(data, "LABEL: "..idata.label)
					end
				end
			elseif exec_command == "LABEL" then
				local idata = mtos.bdev:get_removable_disk()
				if not idata.stack then
					add_outline(data, '?DISK NOT FOUND')
				else
					if exec_all[2] then
						idata.label = input_line:sub(6):gsub("^%s*(.-)%s*$", "%1")
					end
					add_outline(data, "LABEL: "..idata.label)
				end
			elseif exec_command == "HELP" then
				local help_command = exec_all[2]
				if not help_command then -- no argument, print all
					add_outline(data, 'These shell commands are defined internally.')
					add_outline(data, '')
					local help_sorted = {}
					for k, v in pairs(help_texts) do
						if not mtos.os_attr.blacklist_commands[k] then
							table.insert(help_sorted, k.."    "..v)
						end
					end
					table.sort(help_sorted)
					for _, kv in ipairs(help_sorted) do
						add_outline(data, kv)
					end
				else
					help_command = help_command:upper()
					local help_text
					if mtos.os_attr.blacklist_commands[help_command] then
						help_text = "?NOT IMPLEMENTED ERROR"
					else
						help_text = help_texts[help_command] or "?  NO HELP IS AVAILABLE FOR THAT TOPIC"
					end
					add_outline(data, help_command:upper().. "    "..help_text)
				end
			else
				add_outline(data, "?SYNTAX ERROR")
			end
			if data.outlines then
				add_outline(data, '')
			end
		end
	end,

appwindow_formspec_func = function(...)
	--re-use the default launcher theming
	return laptop.apps["launcher"].appwindow_formspec_func(...)
end,
})
