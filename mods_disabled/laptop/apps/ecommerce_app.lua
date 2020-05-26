laptop.register_app("ecommerce", {
	app_name = "eCommerce",
	app_icon = "commoditymarket_gold_coins.png",
	app_info = "Online Commodity Market",
	formspec_func = function(app, mtos)		
	
	-- No player, so go back to the app launcher
		if not mtos.sysram.current_player then
			mtos:set_app()
			return false
		end	

	-- Declare variable used to hold the player name for commoditymarket function.
		local name = (mtos.sysram.current_player)


		commoditymarket.show_market("kings", name)
		local market = commoditymarket.registered_markets["kings"]
		
		if market == nil 
			then
				return
		end

	local formspec = market:get_formspec(market:get_account(player_name))
	return formspec or false

	-- End the formspec_func function.	
	end
	end
end,
	receive_fields_func = function (app, mtos)

	-- if the player changed, return to app launcher.		
		if mtos.sysram.current_player ~= mtos.sysram.last_player then
			mtos:set_app() -- wrong player. Back to launcher
			return
		end

	-- End the receive_fields_func.	
	end,
})
