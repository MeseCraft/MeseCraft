local S = minetest.get_translator("skinsdb")

function skins.get_formspec_context(player)
	if player then
		local playername = player:get_player_name()
		skins.ui_context[playername] = skins.ui_context[playername] or {}
		return skins.ui_context[playername]
	else
		return {}
	end
end

-- Show skin info
function skins.get_skin_info_formspec(skin)
	local texture = skin:get_texture()
	local m_name = skin:get_meta_string("name")
	local m_author = skin:get_meta_string("author")
	local m_license = skin:get_meta_string("license")
	local m_format = skin:get_meta("format")
	
	-- overview page
	local raw_size = m_format == "1.8" and "2,2" or "2,1"

	local formspec = "image[0.8,.6;1,2;"..minetest.formspec_escape(skin:get_preview()).."]"
	if m_name ~= "" then
		formspec = formspec.."label[2,.5;"..S("Name")..": "..minetest.formspec_escape(m_name).."]"
	end
	if m_author ~= "" then
		formspec = formspec.."label[2,1;"..S("Author")..": "..minetest.formspec_escape(m_author).."]"
	end
	if m_license ~= "" then
		formspec = formspec.."label[2,1.5;"..S("Description")..": "..minetest.formspec_escape(m_license).."]"
	end
	return formspec
end

function skins.get_skin_selection_formspec(player, context, y_delta)
	context.skins_list = skins.get_skinlist_for_player(player:get_player_name())
	context.total_pages = 1
	for i, skin in ipairs(context.skins_list ) do
		local page = math.floor((i-1) / 16)+1
		skin:set_meta("inv_page", page)
		skin:set_meta("inv_page_index", (i-1)%16+1)
		context.total_pages = page
	end
	context.skins_page = context.skins_page or skins.get_player_skin(player):get_meta("inv_page") or 1
	context.dropdown_values = nil

	local page = context.skins_page
	local formspec = ""
	for i = (page-1)*16+1, page*16 do
		local skin = context.skins_list[i]
		if not skin then
			break
		end

		local index_p = skin:get_meta("inv_page_index")
		local x = (index_p-1) % 8
		local y
		if index_p > 8 then
			y = y_delta + 1.9
		else
			y = y_delta
		end
		formspec = formspec.."image_button["..x..","..y..";1,2;"..
			minetest.formspec_escape(skin:get_preview())..";skins_set$"..i..";]"..
			"tooltip[skins_set$"..i..";"..minetest.formspec_escape(skin:get_meta_string("name")).."]"
	end

	if context.total_pages > 1 then
		local page_prev = page - 1
		local page_next = page + 1
		if page_prev < 1 then
			page_prev = context.total_pages
		end
		if page_next > context.total_pages then
			page_next = 1
		end
		local page_list = ""
		context.dropdown_values = {}
		for pg=1, context.total_pages do
			local pagename = S("Page").." "..pg.."/"..context.total_pages
			context.dropdown_values[pagename] = pg
			if pg > 1 then page_list = page_list.."," end
			page_list = page_list..pagename
		end
		formspec = formspec
			.."button[0,"..(y_delta+4.0)..";1,.5;skins_page$"..page_prev..";<<]"
			.."dropdown[0.9,"..(y_delta+3.88)..";6.5,.5;skins_selpg;"..page_list..";"..page.."]"
			.."button[7,"..(y_delta+4.0)..";1,.5;skins_page$"..page_next..";>>]"
	end
	return formspec
end

function skins.on_skin_selection_receive_fields(player, context, fields)
	for field, _ in pairs(fields) do
		local current = string.split(field, "$", 2)
		if current[1] == "skins_set" then
			skins.set_player_skin(player, context.skins_list[tonumber(current[2])])
			return 'set'
		elseif current[1] == "skins_page" then
			context.skins_page = tonumber(current[2])
			return 'page'
		end
	end
	if fields.skins_selpg then
		context.skins_page = tonumber(context.dropdown_values[fields.skins_selpg])
		return 'page'
	end
end
