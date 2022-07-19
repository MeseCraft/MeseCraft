--data tables definitions
meseportals={}
meseportals_network = {}
meseportals_gui = {}

meseportals.allowPrivatePortals = true
meseportals.maxPlayerPortals = 14 -- Set to 0 or lower to restrict portal placement to only players with msp_unlimited privilege
meseportals.close_after = 240 -- Automatically close portals after a while (default: 4 min)

meseportals.default_page = "main"
meseportals_gui["players"]={}
meseportals["registered_players"] = {}
meseportals.current_page={}

minetest.register_privilege("msp_admin", {
	description = "Allows full control of all mese portals.",
	give_to_singleplayer = false,
})

minetest.register_privilege("msp_unlimited", {
	description = "Allows player to place an unlimited number of mese portals.",
	give_to_singleplayer = true,
})

modpath=minetest.get_modpath("meseportals")
dofile(modpath.."/meseportal_network.lua")
dofile(modpath.."/meseportal_gui.lua")
dofile(modpath.."/portal_defs.lua")
dofile(modpath.."/recipes.lua")
dofile(modpath.."/node_behaviors.lua")
