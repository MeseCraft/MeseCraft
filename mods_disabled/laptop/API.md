# Laptop Mod API

## Add new hardware nodes
`laptop.register_hardware(name, hwdef)`
- `name` - Item name (prefix) The created node names are name_variant
- `hwdef.description`  -  Computer item name
- `hwdef.infotext` - Text shown if node is pointed
- `hwdef.sequence` = { "variant_1_name", "variant_2_name", "variant_3_name" } On punch swaps sequence. the first variant is in creative inventory
- `hwdef.custom_launcher` - optional - custom launcher name
- `hwdef.os_version` - optional - Set OS version. ('1.10', '3.31' or '6.33') By default the latest version is used
- `hwdef.tty_style` - optional - override CS-BOS console textcolor
- `hwdef.tty_monochrome` - Old computer with monochrome CRT screen
- `hwdef.custom_theme` -  optional - custom initial theme name
- `hwdef.hw_capabilities` = { "hdd", "floppy", "usb", "net", "liveboot" } Table with hardware capabilities. Default is all, if nothing set
- `hwdef.node_defs` - A list for node definitions for each variant. with hw_state parameter for OS-initialization
```
  hwdef.node_defs = {
		variant_1_name = {
			hw_state =  "resume", "power_on" or "power_off", -- Hardware state
			--node 1 definiton
		},
		variant_2_name = {
			hw_state =  "resume", "power_on" or "power_off", -- Hardware state
			--node 2 definiton
		},
	}
```

- `laptop.os_get(pos)` - Get an OS object. Usefull in on_construct or on_punch to initialize or do anything with OS
  Needed in on_receive_fields to be able to call mtos:receive_fields(fields, sender) for interactive apps
- `laptop.after_place_node` / `laptop.after_dig_node` - (optional) can be used directly for node definition. Move laptop apps data to ItemStack if digged and restored back if placed again. So you can take along your laptop. Note: you need to set `stack_max = 1` because the data can be stored per stack only, not per item.


## Operating system object
`local mtos = laptop.os_get(pos)` - Get the Operating system object. Used internally, but usable for remote operations. mtos is passed to app methods as parameter

### Operating system methods
- `mtos:power_on(new_node_name)` - Free RAM, activate the launcher and if given swap node to new_node_name
- `mtos:resume(new_node_name)` - Restore the last running app after power_off. Means no free ram and no switch to launcher. Update formspec and if given swap node to new_node_name
- `mtos:power_off(new_node_name)` - Remove the formspec and if given swap node to new_node_name
- `mtos:swap_node(new_node_name)`- Swap the node only without any changes on OS
- `mtos:set_infotext(infotext)` - Set the mouseover infotext for laptop node
- `mtos:get_app(appname)`- Get the app instance
- `mtos:set_app(appname)` - Start/Enable/navigate to appname. If no appname given the launcher is called
- `mtos:get_theme(theme)`- Get theme data current or requested (theme parameter is optional)
- `mtos:set_theme(theme)`- Activate theme
- `mtos:get_os_attr()`- Get OS-version attributes (see mtos.os_attr)
- `mtos:save()` - Store all app-data to nodemeta. Called mostly internally so no explicit call necessary
- `mtos:pass_to_app(method, reshow, sender, ...)` - call custom "method" on app object. Used internally. Reshow means update formspec after update
- `mtos:select_file_dialog(param)` - call the select file dialog ('os:select_file')
```
		if fields.load then
			mtos:select_file_dialog({
					mode = 'open',  -- open/select or save mode
					allowed_disks = {'hdd', 'removable'}, -- disks shown in disk overview ('ram', 'hdd', 'removable', 'cloud' or 'system')
					selected_disk_name = data.selected_disk_name, -- Start selection on disk
					selected_file_name = data.selected_file_name, -- Start selection with file
					store_name = store_area, -- The storage_name used for fliles (Sample 'stickynote:files')
					prefix = 'open_', -- Prefix for return files
			})
		elseif fields.open_selected_disk and fields.open_selected_file then
			data.selected_disk_name = fields.open_selected_disk  -- Selected disk (prefix 'open_' is used)
			data.selected_file_name = fields.open_selected_file -- Selected file (prefix 'open_' is used)
```
- `mtos:print_file_dialog({ label= , text= })` - call the print file dialog ('printer:app')

### Operating system attributes
	`mtos.pos` - Computers position vector
	`mtos.node` = minetest.get_node(pos)
	`mtos.hwdef` = Merged hardware definition (Hardware + Hardware node attributes merged to 1 object)
	`mtos.meta` = Nade meta - mostly managed by block device framework
	`mtos.bdev` = Block device framework object
	`mtos.sysram` = System/OS ram partition, mtos.bdev:get_app_storage('ram', 'os')
	`mtos.sysdata` = System/OS data partition, mtos.bdev:get_app_storage('system', 'os')
	`mtos.theme` = Selected theme object
	`mtos.os_attr` = Hard-coded attributes for OS version
		`releaseyear`
		`version_string`
		`blacklist_commands`  CS-BOS interpreter
		`tty_style`           CS-BOS Console color. Supported GREEN, AMBER, WHITE
		`tty_monochrome`      CS-BOS Console is monochrome, no color change supported
		`min_scrollback_size` CS-BOS Buffer
		`max_scrollback_size` CS-BOS Buffer
		`custom_launcher`     Custom launcher for OS (can be overriden on node level)
		`custom_theme`        Custom theme for OS (can be overriden on node level)

## Apps
### Definition attributes
`laptop.register_app(internal_shortname, { definitiontable })` - add a new app or view
- `app_name` - App name shown in launcher. If not defined the app is just a view, not visible in launcher but can be activated. This way multi-screen apps are possible
- `app_icon` - Icon to be shown in launcher. If nothing given the default icon is used
- `app_info` - Short app info visible in launcher tooltip
- `os_min_version` - minimum version to be used (CS-BOS, optional)
- `os_max_version` - maximum version to be used (CS-BOS, optional)
- `fullscreen` - (boolean) Do not add app-background and window buttons
- `view` - (boolean) The definition is a view. That means the app/view is not visible in launcher
- `browser_page` - (boolean) This view is shown in browser app as available page
- `formspec_func(app, mtos)` - Function, should return the app formspec (mandatory) During definition the "app" and the "mtos" are available
- `appwindow_formspec_func(launcher_app, app, mtos)`- Only custom launcher app: App background / Window decorations and buttons
- `receive_fields_func(app, mtos, sender, fields)` Function for input processing. The "app" and the "mtos" are available inside the call
- `allow_metadata_inventory_put(app, mtos, player, listname, index, stack)` - Optional: custom actions on item put
- `allow_metadata_inventory_take(app, mtos, player, listname, index, stack)` - Optional: custom actions on item take
- `allow_metadata_inventory_move(app, mtos, player, from_list, from_index, to_list, to_index, count)`  - Optional: custom actions on item move
- `on_metadata_inventory_put(app, mtos, player, listname, index, stack)` - Optional: custom check on items put
- `on_metadata_inventory_take(app, mtos, player, listname, index, stack)` - Optional: custom check on items put
- `on_metadata_inventory_move(app, mtos, player, from_list, from_index, to_list, to_index, count)` - Optional: custom check on items put
- `on_timer(app, mtos, nil, elapsed) - Optional. The on-timer callback (no sender)

`laptop.register_view(internal_shortname, { definitiontable })` - add a new app or view
same as register_app, but the view flag is set. app_name and app_icon not necessary

### App Object
`local app = mtos:get_app(appname)` - Give the app object internal_shortname, connected to given mtos. Not necessary in formspec_func or receive_fields_func because given trough interface
- `app:back_app(fields, sender)` - Go back to previous app/view. Trough fields/sender additional data can be sent to the previous app trough receive_fields_func
- `app:exit_app()` - Delete call stack and return to launcher
- `app:get_timer()` - Get timer for this app (based on nodetimer)

## Themes
### Theme definition
`laptop.register_theme(name, definitiontable)` - add a new theme. All parameters optional, if missed, the default is used
The most colors are grouped by "prefixes". Each prefix means a specific content to be themed.
#### Theme suffixes
- background - A background texture
- button - A foreground texture, used on buttons
- bgcolor - Background RGB color, should be the same color as background texture
- textcolor - Foreground RGB color used for label text or button texts

#### Theme prefixes
- desktop - Main launcher
  - `desktop_background` Desktop background image
- desktop_icon - The App icon in main launcher
  - `desktop_icon_button` App button background in launcher
- desktop_icon_label The label under the app icon in main launcher (technically a button too)
  - `desktop_icon_label_button` Background texture for icon label text
  - `desktop_icon_label_textcolor` Icon label text color

- app - App decorations
  - `app_background` Apps background image, adds titlebar
- titlebar - The titlebar on app decorations
  - `titlebar_textcolor` Sets the color of text on app titlebar
- back - The back button on app decoration
  - `back_button` Back Button image
  - `back_textcolor` Back Button textclolor (for '<' character)
- exit - The exit button on app decoration
  - `exit_button` Exit button image
  - `exit_textcolor` Exit button textcolor (for 'X' character)
  - `exit_character` Sets the character that shows up in the close box, X is default

- major - Highlighted Button
  - `major_button` Major (highlighted) button image
  - `major_textcolor` Major (highlighted) button text color

- minor - not highlighted button
  - `minor_button` Minor button image
  - `minor_textcolor` Minor button text color

- contrast - dark background in contrast for not themeable elements
  - `contrast_background` dark background to place under white text elements that does not support textcolor
  - `contrast_bgcolor` dark background as RGB
  - `contrast_textcolor` some labels are placed on contrast background. This color is used to colorize them

- toolbar - Toolbar buttons
		`toolbar_button` Button unterlay
		`toolbar_textcolor` Toolbar buttons textcolor

- status_online - Used to show status information "online / green"
  - `status_online_textcolor` - Sets "online" text color for peripherals
- status_disabled - Used to show status information "disabled / yellow"
  - `status_disabled_textcolor` - Sets "disabled" text color for peripherals
- status_off - Used to show status information "off / red"
  - `status_off_textcolor =` - Sets "offline" text color for peripherals

- table - Colorize the table-like output
  - `table_bgcolor` - Table background color
  - `table_textcolor` - Table text color
- table_highlight - Colorize the selection in tables
  - `table_highlight_bgcolor` - Table highlighted background
  - `table_highlight_textcolor` - Table highlighted textcolor
- muted - muted color
  - `muted_textcolor` - Table textcolor muted

- monochrome - Optimized for monochrome output (old computers). Some elements will be colorized using this color
  - `monochrome_textcolor` - default is nil. if set to RGB, colorization is applied on some textures (like tetris shapes)

- url - Browser URL's for default background
	`url_textcolor`
	`url_button`

- url_dark - Browser URL's for dark background
	`url_dark_textcolor`
	`url_dark_button`

- url_bright - Browser URL's for white background
	`url_bright_textcolor`
	`url_bright_button`

- fallback - without prefix (obsolete)
  - `textcolor` Default text color for buttons and labels. Each "prefix" can have own textcolor, like major_textcolor and minor_textcolor for major/minor buttons or labels

- Other settings / without prefix
  - `taskbar_clock_position_and_size` Set where the clock is positioned and its size on the taskbar
  - `node_color` Palette number to set if the node is paramtype2 = "colorfacedir" (inactive)
  - `os_min_version` - minimum version to be used (CS-BOS, optional)
  - `os_max_version` - maximum version to be used (CS-BOS, optional)
  - `table_border` -  draw tables border (true or false)
  - `texture_replacements` - A table with texture replacements, defined as { ['orig_texture_name.png'] = 'themed_texture_name.png', }

### Theme methods
`function laptop.get_theme(theme_name)`
- `theme:get_button(area, prefix, code, text)` get a themed [prefix]_button in area 'x,y;w,h' with code and text
- `theme:get_image_button(area, prefix, code, image, text)` get a themed [prefix]_button in area 'x,y;w,h' with code an image and text. Text is colorized by [prefix]_textcolor or textcolor
- `theme:get_label(pos, text, color_prefix)` get a themed label text starting at pos 'x,y', colorize theme by color prefix (usually the button text colors)
- `theme:get_texture(image)` get replacement for texture image if set in theme or the image. Called internally from get_image_button()
- `theme:get_tableoptions(show_select_bar)` get themed tableoptions string before table[]. If show_select_bar is set to false, the highlight values are the same as non-highlight so no selection is visible
- `theme:get_bgcolor_box(area, prefix)` get plain box colorized by [prefix]_bgcolor or bgcolor

## Block devices / Data objects
`mtos.bdev = laptop.get_bdev_handler(mtos)`

### Low-Level methods
Can be used for non-data and/or system tasks. For usual data store please use the storage methods
- `bdev:get_ram_disk()` ram store - a table with all app-related storage partitions
- `bdev:get_hard_disk()` hdd store - a table with all app-related storage partitions, if hard disk capatibility exists
- `bdev:get_removable_disk()` removable data object (drive)
- `bdev:get_cloud_disk(storage_name)` - Get named cloud storage
- `bdev:sync()` - Write/store all opened and maybe changed data (cached)
- `bdev:sync_cloud()` - Write/store all opened and maybe changed data in cloud

### Storage methods
- `get_boot_disk()` - Check which device can be booted. possible return value is "hdd" or "removable"
- `get_app_storage(disk_type, storage_name)` - Get data storage table to be used in apps.
  - disk_type can be 'ram', 'hdd', 'removable', 'cloud' or 'system'. System is eather hdd or removable storage depending on booted device
  - store_name is usually the app name. 'os' is reserved for System related saves

### Low-level Removable data
`data = bdev:get_removable_disk()`
- `bdev.inv` - node inventory (the slot)
- `bdev.label` - Meda label. Item name by default
- `bdev.def` - Registered item definition (read-only)
- `bdev.stack` - The item stack
- `bdev.meta` - Stack metadata
- `bdev.os_format`- The format type: "none", "boot", "backup", "filesystem" (read-only)
- `bdev.rtype` - Removable type. "usb" or "floppy"
- `bdev.storage` - Data table used for app storage, if format is data compatible
- `bdev:reload(stack)` - Reload all data from node inventory. If stack is given, the stack will be inserted to slot
- `bdev:eject()` - Remove item from slot and drop them to the world nearly computer
- `bdev:format_disk(ftype, label)` - Format the disk. ftype can be "" or nil, "data" "backup" or "boot"

## Compatible Items
There is no own compatible items registrator. The item needs to match the item group to be usable with the laptops
- `laptop_removable_floppy = 1` - The item is a floppy
- `laptop_removable_usb = 1` - The item is usb storage disk

## Browser app specific functions
- `laptop.browser_api.navigate(app, mtos, pagename)` Check the "pagename" and start if the app have browser_page setting
- `formspec = laptop.browser_api.header_formspec_func(app, mtos)` Contains the formspec for navigation bar. Needs to be included to all pages
- `laptop.browser_api.header_receive_fields_func(app, mtos, sender, fields)` Process the navigation bar buttons. Needs to be included to all pages

