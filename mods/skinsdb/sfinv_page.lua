local S = minetest.get_translator("skinsdb")

-- generate the current formspec
local function get_formspec(player, context)
	local skin = skins.get_player_skin(player)
	local formspec = skins.get_skin_info_formspec(skin)
	formspec = formspec..skins.get_skin_selection_formspec(player, context, 4)
	return formspec
end

sfinv.register_page("skins:overview", {
	title = S("Skins"),
	get = function(self, player, context)
		-- collect skins data
		return sfinv.make_formspec(player, context, get_formspec(player, context))
	end,
	on_player_receive_fields = function(self, player, context, fields)
		skins.on_skin_selection_receive_fields(player, context, fields)
		sfinv.set_player_inventory_formspec(player)
	end
})
