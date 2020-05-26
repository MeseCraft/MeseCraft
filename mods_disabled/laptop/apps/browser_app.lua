laptop.browser_api  = {} -- Be useable from other mods


-- Helper function - navigate to page
function laptop.browser_api.navigate(app, mtos, pagename)
	local page_prep = minetest.strip_colors(pagename)
	if page_prep == "" then
		return
	end

	local page_prep = page_prep:lower()
	local page = laptop.apps[page_prep]
	if page and page.browser_page then
		mtos:set_app(page_prep)
	else
		mtos:set_app("error.404")
	end
end

--- Navigation bar - Shown on each page - needs to be included to each page
function laptop.browser_api.header_formspec_func(app, mtos)
	local currentpage = ""
	if app.browser_page then
		currentpage = app.name
	end
	local formspec = "field[.2,.5;13,1;input_field;;"..currentpage.."]field_close_on_enter[input_field;false]"..
			mtos.theme:get_image_button('12.9,.3;.8,.8', 'toolbar', 'go_button', 'laptop_go_web.png', '', 'Go') ..
			mtos.theme:get_image_button('13.6,.3;.8,.8', 'toolbar', 'home_button', 'laptop_home_web.png', '', 'Home') ..
			mtos.theme:get_image_button('14.3,.3;.8,.8', 'toolbar', 'settings_button', 'laptop_settings_web.png', '', 'Settings')
	return formspec
end

-- Page header / Navigation bar buttons processing. Needs to be included to each page
function laptop.browser_api.header_receive_fields_func(app, mtos, sender, fields)
	if (fields.key_enter and fields.key_enter_field == "input_field") or fields.go_button then
		laptop.browser_api.navigate(app, mtos, fields.input_field)
	elseif fields.home_button then
		mtos:set_app("browser")
	elseif fields.settings_button then
		mtos:set_app("browser:settings")
	elseif fields.page_link then
		laptop.browser_api.navigate(app, mtos, fields.page_link)
	end
end

--------------------------------------------
-- Browser home page
--------------------------------------------
laptop.register_app("browser", {
	app_name = "MineBrowse",
	app_icon = "laptop_browser.png",
	app_info = "Web Browser",
	os_min_version = "5.51",
	formspec_func = function(app, mtos)
		local formspec = laptop.browser_api.header_formspec_func(app, mtos) ..
				--"image[.1,1.3;18,1.6;laptop_header_web.png]"..
				"image[0,1.3;18,1.6;laptop_welcome_web.png]"..
				mtos.theme:get_label('.1,2.7', 'MineBrowse is a working web browser powered by formspecs. It is community driven,', 'contrast') ..
				mtos.theme:get_label('.1,3', 'which means websites are created by the community. If you like to add your own site', 'contrast') ..
				mtos.theme:get_label('.1,3.3', 'visit submit.official for further details.', 'contrast') ..
				"background[0,1.2;15,9;laptop_background.png]"..
				mtos.theme:get_button('11.3,9.3;3,.8', 'url_bright', 'page_link', 'submit.official') ..
				"image[11,2.8;4,8.1;laptop_ad1_web.png]"..
				"image[.1,3.8;12,1.2;laptop_wa_web.png]"

		-- Prepare / Generate Pages list
		local c_row_count = 12

		local pageslist_sorted = {}
		for name, def in pairs(laptop.apps) do
			if def.browser_page and mtos:is_app_compatible(name) then
				table.insert(pageslist_sorted, {name = name, def = def})
			end
		end
		table.sort(pageslist_sorted, function(a,b) return a.name < b.name end)
		for i, e in ipairs(pageslist_sorted) do
			local x = math.floor((i-1) / c_row_count)*5 + 0.3
			local y = ((i-1) % c_row_count)*0.4 + 4.7
			formspec = formspec .. mtos.theme:get_button(x..','..y..';3,.5', 'url_dark', "page_link", e.name)..
			 mtos.theme:get_label((x+3)..','..y, e.def.app_info, 'contrast')
		end

		return formspec
	end,
	receive_fields_func = function(app, mtos, sender, fields)
		laptop.browser_api.header_receive_fields_func(app, mtos, sender, fields)
	end
})

--------------------------------------------
-- Error 404 - Page not found
--------------------------------------------
laptop.register_view("error.404", {
	app_info = "Page not found",
	formspec_func = function(app, mtos)
		local formspec = laptop.browser_api.header_formspec_func(app, mtos) ..
			mtos.theme:get_label('.3,1.1','Error 404 - Page not found')
		return formspec
	end,
	receive_fields_func = function(app, mtos, sender, fields)
		laptop.browser_api.header_receive_fields_func(app, mtos, sender, fields)
	end
})

--------------------------------------------
-- Settings
--------------------------------------------
laptop.register_view("browser:settings", {
	app_info = "Browser settings",
	formspec_func = function(app, mtos)
		local formspec = mtos.theme:get_label('.3,1.1','Settings')
		return formspec
	end,
	receive_fields_func = function(app, mtos, sender, fields)
		laptop.browser_api.header_receive_fields_func(app, mtos, sender, fields)
	end
})

--------------------------------------------
-- Submit informations
--------------------------------------------
laptop.register_view("submit.official", {
	app_info = "Contribute to Minetest Laptop Mod",
	browser_page = true,
	formspec_func = function(app, mtos)
		local formspec = laptop.browser_api.header_formspec_func(app, mtos) ..
				mtos.theme:get_label('.1,2.8', 'You can help create many more websites that people can explore!', 'contrast') ..
				mtos.theme:get_label('.1,3.1', 'Each website can have multiple pages.', 'contrast') ..
				mtos.theme:get_label('.1,3.4', 'Please submit your website/webpages to:', 'contrast') ..
				mtos.theme:get_label('.1,3.7', 'https://github.com/Gerold55/MineBrowse-Sites', 'contrast') ..
				"background[0,1.2;15,9;laptop_background.png]"
		return formspec
	end,
	receive_fields_func = function(app, mtos, sender, fields)
		laptop.browser_api.header_receive_fields_func(app, mtos, sender, fields)
	end
})