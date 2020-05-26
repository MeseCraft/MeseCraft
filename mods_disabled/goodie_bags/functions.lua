-- Googie Bags
ff_goodie_bags.goodie_bag_on_use = function (color)
	local on_use = function(itemstack, user, pointed_thing)
		-- Safety check to ensure at least 1 item exists to be given
		if ff_goodie_bags["general_item_pool"][1] == nil then
			return itemstack
		end
		
		-- Get player inv
		local player_name = user:get_player_name()
		local player = minetest.get_player_by_name(player_name)
		local inv = player:get_inventory()
		local pos = player:getpos()
		
		-- Select random loot
		local item_drops = {}
		local num_of_unique_drops = math.random(3)
		
		local i
		
		for i = 1, num_of_unique_drops, 1 do
			local stack_num = math.random(10)
			local color_exclusive_chance = math.random(15)
			if color_exclusive_chance == 1 and ff_goodie_bags[color .. "_item_pool"][1] ~= nil then
				table.insert(item_drops, ff_goodie_bags[color .. "_item_pool"][math.random(#ff_goodie_bags[color .. "_item_pool"])] .. " " .. stack_num)
			else
				table.insert(item_drops, ff_goodie_bags["general_item_pool"][math.random(#ff_goodie_bags["general_item_pool"])] .. " " .. stack_num)
			end
		end
		
		-- Display what loot the player got via the HUD
		local hud_ids = {}
		local hud_ids_config = {}
		
		hud_ids_config["scale_x_bg_img"] = 1
		hud_ids_config["scale_y_bg_img"] = 1
		hud_ids_config["offset_x_bg_img"] = 0
		hud_ids_config["offset_y_bg_img"] = 50
		
		hud_ids_config["scale_x_1"] = 1
		hud_ids_config["scale_y_1"] = 1
		hud_ids_config["offset_x_1"] = 0
		hud_ids_config["offset_y_1"] = 54
		
		hud_ids_config["scale_x_2"] = 1
		hud_ids_config["scale_y_2"] = 1
		hud_ids_config["offset_x_2"] = 0
		hud_ids_config["offset_y_2"] = 74
		
		hud_ids_config["scale_x_3"] = 1
		hud_ids_config["scale_y_3"] = 1
		hud_ids_config["offset_x_3"] = 0
		hud_ids_config["offset_y_3"] = 94
		
		-- Adds background image to HUD
		local hud_elem_type = "image"
		local text = "ff_goodie_bags_goodie_bag_contents.png"
		
		hud_ids["bg_img"] = player:hud_add({
			hud_elem_type = hud_elem_type,
			position  = {x = 0.5, y = 0.01},
			offset    = {x = hud_ids_config["offset_x_bg_img"], y = hud_ids_config["offset_y_bg_img"]},
			text      = text,
			scale     = { x = hud_ids_config["scale_x_bg_img"], y = hud_ids_config["scale_y_bg_img"]},
			alignment = { x = 0, y = 0 },
		})
		
		-- Remove the background image from the HUD after 4 seconds
		local idx = hud_ids["bg_img"]
		minetest.after(4, function(player_name, idx)
			local player = minetest.get_player_by_name(player_name)
			if player then
				player:hud_remove(idx)
			end
		end, player_name, idx)
		
		-- Adds the item drop names to the HUD
		for i = 1, #item_drops, 1 do
			-- Random HUD ID
			local random_id = math.random(99999) + i
			
			hud_elem_type = "text"
			text = item_drops[i]
			
			-- Limits the loot text length and appends ... at the end if needed
			if string.len(text) > 25 then
				text = string.sub(text, 1, 22)
				text = text .. "..."
			end
			
			hud_ids[random_id] = player:hud_add({
				hud_elem_type = hud_elem_type,
				position  = {x = 0.5, y = 0.01},
				offset    = {x = hud_ids_config["offset_x_" .. i], y = hud_ids_config["offset_y_" .. i]},
				text      = text,
				number    = 0xFFFFFF,
				scale     = { x = hud_ids_config["scale_x_" .. i], y = hud_ids_config["scale_y_" .. i]},
				alignment = { x = 0, y = 0 },
			})
			
			-- Remove the text from the HUD after 4 seconds
			local idx = hud_ids[random_id]
			minetest.after(4, function(player_name, idx)
				local player = minetest.get_player_by_name(player_name)
				if player then
					player:hud_remove(idx)
				end
			end, player_name, idx)
		end
		
		-- Give the loot to the player
		for _,v in pairs(item_drops) do
			local leftover = inv:add_item("main", v)
			if leftover:get_count() > 0 then
				local droppos = pos
				local xposrandom = math.random() * math.random(-0.9, 0.9)
				local zposrandom = math.random() * math.random(-0.9, 0.9)
				droppos.x = droppos.x + xposrandom
				droppos.z = droppos.z + zposrandom
				minetest.add_item(droppos, leftover)
			end
		end
		
		-- Play the sound
		minetest.sound_play("ff_goodie_bags_Coin01", {pos, max_hear_distance = 2, gain = 1.0,})
		
		-- Remove one goodie bag from the itemstack
		itemstack:take_item()
		return itemstack
	end
	return on_use
end