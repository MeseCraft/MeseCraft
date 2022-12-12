------------------------------------------------------------
--        ___ _        __       ___        _              --
--       | __| |_  _  / _|___  / __|_ __ _(_)_ __         --
--       | _|| | || | > _|_ _| \__ \ V  V / | '  \        --
--       |_| |_|\_, | \_____|  |___/\_/\_/|_|_|_|_|       --
--          |__/                                          --
--                   Crouch and Climb                     --
------------------------------------------------------------
--                     Example Cape                       --
------------------------------------------------------------
	armor:register_armor("3d_armor_flyswim:demo_cape", {
		description = "Someones Cape",
		inventory_image = "3d_armor_flyswim_demo_cape_inv.png",
		groups = {armor_capes=1, physics_speed=1, armor_use=1000},
		armor_groups = {fleshy=5},
		damage_groups = {cracky=3, snappy=3, choppy=2, crumbly=2, level=1},
		on_equip = function(player)
					local privs = minetest.get_player_privs(player:get_player_name())				
					privs.fly = true
					minetest.set_player_privs(player:get_player_name(), privs)
				  end,
				  
		on_unequip = function(player)
					local privs = minetest.get_player_privs(player:get_player_name())
					privs.fly = nil
					minetest.set_player_privs(player:get_player_name(), privs)
				  end,
	})
