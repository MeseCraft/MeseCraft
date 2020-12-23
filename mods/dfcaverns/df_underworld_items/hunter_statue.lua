if minetest.get_modpath("hunter_statue") and df_underworld_items.config.underworld_hunter_statues then

	local S = df_underworld_items.S

	hunter_statue.register_hunter_statue("df_underworld_items:hunter_statue", {
		description = S("Guardian Statue"),
		chance = 2,
		tiles = {
			{ name = "dfcaverns_slade.png", backface_culling = true },
			{ name = "dfcaverns_slade.png^(dfcaverns_statue_eyes.png^[opacity:128)", backface_culling = true },
			{ name = "dfcaverns_slade.png^(dfcaverns_statue_fang_overlay.png^[opacity:128)", backface_culling = true },
		},
		tnt_vulnerable = true,
		tnt_debris = "df_underworld_items:slade_sand",
		groups = {hunter_statue = 1, falling_node = 1, immortal = 1},
		other_overrides = {
			can_dig = function(pos, player)
				if player then
					return minetest.check_player_privs(player, "server")
				end
				return false
			end,
		}
	})

end