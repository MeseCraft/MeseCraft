laptop.register_app("launcher_settings", {
	app_name = "Settings",
	app_icon = "laptop_setting_wrench.png",
	app_info = "Desktop settings.",
	os_min_version = '5.00',
	formspec_func = function(app, mtos)
		local settings_data = mtos.bdev:get_app_storage('ram', 'launcher_settings')

		-- Change background setting
		local current_theme_name = settings_data.selected_theme or mtos:get_theme().name or "default"
		local current_theme = mtos:get_theme(current_theme_name)
		local current_idx

		settings_data.themes_tab = {}
		for name, _ in pairs(laptop.themes) do
			if name ~= "default" and mtos:is_theme_compatible(name) then
				table.insert(settings_data.themes_tab, name)
			end
		end
		table.sort(settings_data.themes_tab)


		local formspec = mtos.theme:get_label('0,0.5', "Select theme")

		local formspec = formspec..mtos.theme:get_tableoptions()..
				"tablecolumns[text]"..
				"table[0,1;5,2;sel_theme;"
		for i, theme in ipairs(settings_data.themes_tab) do
			if i > 1 then
				formspec = formspec..','
			end
			if theme == current_theme_name then
				current_idx = i
			end
			formspec = formspec..theme
		end
		if current_idx then
			formspec = formspec..";"..current_idx
		end
		formspec = formspec.."]"

		if current_theme then
			formspec = formspec.."image[5.5,1;5,3.75;"..current_theme.desktop_background.."]"
		end

		formspec = formspec .. mtos.theme:get_button('0,3.2;2.5,0.6', 'major', 'theme_apply', 'Apply', 'Apply theme')

		return formspec
	end,

	receive_fields_func = function(app, mtos, sender, fields)
		local settings_data = mtos.bdev:get_app_storage('ram', 'launcher_settings')
		if fields.sel_theme then
			local event = minetest.explode_table_event(fields.sel_theme)
			settings_data.selected_theme = settings_data.themes_tab[event.row]
		end

		if fields.theme_apply and settings_data.selected_theme then
			mtos:set_theme(settings_data.selected_theme)
			settings_data.selected_theme = nil
		end
	end
})
