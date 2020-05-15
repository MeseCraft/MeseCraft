-- Unified Skins for Minetest - based modified Bags from unfied_inventory and skins from inventory_plus

-- Copyright (c) 2012 cornernote, Dean Montgomery
-- Rework 2017 by bell07
-- License: GPLv3

skins = {}
skins.modpath = minetest.get_modpath(minetest.get_current_modname())
skins.default = "character_1"

dofile(skins.modpath.."/skin_meta_api.lua")
dofile(skins.modpath.."/api.lua")
dofile(skins.modpath.."/skinlist.lua")
dofile(skins.modpath.."/formspecs.lua")
dofile(skins.modpath.."/chatcommands.lua")
if minetest.get_modpath("sfinv") then
	dofile(skins.modpath.."/sfinv_page.lua")
end

-- 3d_armor compatibility
if minetest.global_exists("armor") then
	skins.armor_loaded = true
	armor.get_player_skin = function(self, name)
		local skin = skins.get_player_skin(minetest.get_player_by_name(name))
		return skin:get_texture()
	end
	armor.get_preview = function(self, name)
		local skin = skins.get_player_skin(minetest.get_player_by_name(name))
		return skin:get_preview()
	end
	armor.update_player_visuals = function(self, player)
		if not player then
			return
		end
		local skin = skins.get_player_skin(player)
		skin:apply_skin_to_player(player)
		armor:run_callbacks("on_update", player)
	end
end

if minetest.global_exists("clothing") and clothing.player_textures then
	skins.clothing_loaded = true
	clothing:register_on_update(skins.update_player_skin)
end

-- Update skin on join
skins.ui_context = {}
minetest.register_on_joinplayer(function(player)
	skins.update_player_skin(player)
end)

minetest.register_on_leaveplayer(function(player)
	skins.ui_context[player:get_player_name()] = nil
end)

player_api.register_model("skinsdb_3d_armor_character_5.b3d", {
	animation_speed = 30,
	textures = {
		"blank.png",
		"blank.png",
		"blank.png",
		"blank.png"
	},
	animations = {
		stand = {x=0, y=79},
		lay = {x=162, y=166},
		walk = {x=168, y=187},
		mine = {x=189, y=198},
		walk_mine = {x=200, y=219},
		sit = {x=81, y=160},
	},
})

-- Register default character.png if not part of this mod
local default_skin_obj = skins.get(skins.default)
if not default_skin_obj then
	default_skin_obj = skins.new(skins.default)
	default_skin_obj:set_texture("character.png")
	default_skin_obj:set_meta("format", '1.0')
	default_skin_obj:set_meta("_sort_id", 0)
	default_skin_obj:set_meta("name", "Sam")
end
