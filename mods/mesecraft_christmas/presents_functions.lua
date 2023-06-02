-- Christmas Present Goodie Bags
-- Code primarily from ff_goodie_bags, simplified and fixed sound clip pos.
-- max 3 items per open, max 1 items per stack, each item has 1 in 5 chance of coming from exclusive item pool.
-- define namespace.
mesecraft_christmas.open_present = function (color)
    	local on_use = function(itemstack, user, pointed_thing)
    		-- Safety check to ensure at least 1 item exists to be given
    		if mesecraft_christmas["christmas_common_item_pool"][1] == nil then
    			return itemstack
    		end
    		
    		-- Get player inv
    		local player_name = user:get_player_name()
    		local player = minetest.get_player_by_name(player_name)
    		local inv = player:get_inventory()
    		local pos = player:get_pos()
    		
    		-- Select random loot
    		local item_drops = {}
    		local num_of_unique_drops = math.random(3)
    		
    		local i
    		
    		for i = 1, num_of_unique_drops, 1 do
    			local stack_num = math.random(1)
    			local color_exclusive_chance = math.random(5)
    			if color_exclusive_chance == 1 and mesecraft_christmas[color .. "_item_pool"][1] ~= nil then
    				table.insert(item_drops, mesecraft_christmas[color .. "_item_pool"][math.random(#mesecraft_christmas[color .. "_item_pool"])] .. " " .. stack_num)
    			else
    				table.insert(item_drops, mesecraft_christmas["christmas_common_item_pool"][math.random(#mesecraft_christmas["christmas_common_item_pool"])] .. " " .. stack_num)
    			end
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
    		minetest.sound_play("mesecraft_christmas_sleighbell", {pos=pos, max_hear_distance = 2, gain = 1.0,})
    		
    		-- Remove one goodie bag from the itemstack
    		itemstack:take_item()
    		return itemstack
    	end
    	return on_use
    end

