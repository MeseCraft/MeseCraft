

minetest.register_on_craft(function(itemstack, tool_capabilities, player,  old_craft_grid, craft_inv)
	if itemstack:get_definition().tool_capabilities ~= nil then
		itm_mt = itemstack:get_meta() 
		local def_fpi = itemstack:get_tool_capabilities().full_punch_interval
		local def_mdl = itemstack:get_tool_capabilities().max_drop_level
		local def_gc = itemstack:get_tool_capabilities().groupcaps
		local def_dg = itemstack:get_tool_capabilities().damage_groups
		local default_atk = 0
		local atk = itemstack:get_tool_capabilities().damage_groups.fleshy
------------------------------------------------------
		if itemstack:get_definition().tool_capabilities.groupcaps.cracky ~= nil then
			 def_cracky3 = itemstack:get_tool_capabilities().groupcaps.cracky.times[3] or 5
			 def_cracky2 = itemstack:get_tool_capabilities().groupcaps.cracky.times[2] or 600000
			 def_cracky1 = itemstack:get_tool_capabilities().groupcaps.cracky.times[1] or 600000
			 def_cracky_uses = itemstack:get_tool_capabilities().groupcaps.cracky.uses or 0
			 def_cracky_maxlevel = itemstack:get_tool_capabilities().groupcaps.cracky.maxlevel or 1
		else
			 def_cracky3 = 600000
			 def_cracky2 = 600000
			 def_cracky1 = 600000
			 def_cracky_uses = 0
			 def_cracky_maxlevel = 1
		end
------------------------------------------------------
		if itemstack:get_definition().tool_capabilities.groupcaps.choppy ~= nil then
			 def_choppy3 = itemstack:get_tool_capabilities().groupcaps.choppy.times[3] or 5
			 def_choppy2 = itemstack:get_tool_capabilities().groupcaps.choppy.times[2] or 600000
			 def_choppy1 = itemstack:get_tool_capabilities().groupcaps.choppy.times[1] or 600000
			 def_choppy_uses = itemstack:get_tool_capabilities().groupcaps.choppy.uses or 0
			 def_choppy_maxlevel = itemstack:get_tool_capabilities().groupcaps.choppy.maxlevel or 1
		else
			 def_choppy3 = 4
			 def_choppy2 = 600000
			 def_choppy1 = 600000
			 def_choppy_uses = 0
			 def_choppy_maxlevel = 1
		end
------------------------------------------------------
		if itemstack:get_definition().tool_capabilities.groupcaps.snappy ~= nil then
			 def_snappy3 = itemstack:get_tool_capabilities().groupcaps.snappy.times[3] or 5
			 def_snappy2 = itemstack:get_tool_capabilities().groupcaps.snappy.times[2] or 600000
			 def_snappy1 = itemstack:get_tool_capabilities().groupcaps.snappy.times[1] or 600000
			 def_snappy_uses = itemstack:get_tool_capabilities().groupcaps.snappy.uses or 0
			 def_snappy_maxlevel = itemstack:get_tool_capabilities().groupcaps.snappy.maxlevel or 1
		else
			 def_snappy3 = 4
			 def_snappy2 = 600000
			 def_snappy1 = 600000
			 def_snappy_uses = 0
			 def_snappy_maxlevel = 1
		end
------------------------------------------------------
		if itemstack:get_definition().tool_capabilities.groupcaps.crumbly ~= nil then
			 def_crumbly3 = itemstack:get_tool_capabilities().groupcaps.crumbly.times[3] or 5
			 def_crumbly2 = itemstack:get_tool_capabilities().groupcaps.crumbly.times[2] or 600000
			 def_crumbly1 = itemstack:get_tool_capabilities().groupcaps.crumbly.times[1] or 600000
			 def_crumbly_uses = itemstack:get_tool_capabilities().groupcaps.crumbly.uses or 0
			 def_crumbly_maxlevel = itemstack:get_tool_capabilities().groupcaps.crumbly.maxlevel or 1
		
		else
			 def_crumbly3 =  4
			 def_crumbly2 =  600000
			 def_crumbly1 =  600000
			 def_crumbly_uses = 0
			 def_crumbly_maxlevel = 1
		end
-----------------------------------------------------


		if math.random(1,2) == 1 then
			local modifier = math.random (1,12)
			local default_name = itemstack:get_definition().description
			--local default_name = itemstack:get_definition().original_description
			
			if def_dg.fleshy and atk ~= nil then
				if def_dg.damage_groups ~= nil then
					if def_dg ~= nil then
						atk = def_dg.damage_groups.fleshy
					end
				end
			else
				atk = default_atk
			end
			
			if modifier == 1 then
				itm_mt:set_tool_capabilities({
					full_punch_interval = def_fpi,
					max_drop_level=def_mdl,
					groupcaps=def_gc,
					damage_groups = {fleshy = atk * 1.25},
				})
				itm_mt:set_string("description", "" .. core.colorize("#00eaff", "Sharp "..default_name.."\n")..core.colorize("#40d000", "+25% melee damage"))
				itm_mt:set_string("original_description", "" .. core.colorize("#00eaff", "Sharp "..default_name.."\n"))
				itm_mt:set_string("tmod_name", "#00eaff,Sharp ")
				itm_mt:set_string("tmod_stat", "#40d000,+25% melee damage")
			end
		
			if modifier == 2 then
				itm_mt:set_tool_capabilities({
					full_punch_interval = def_fpi,
					max_drop_level=def_mdl,
					groupcaps=def_gc,
					damage_groups = {fleshy = atk * 0.80},
				})
				itm_mt:set_string("description", "" .. core.colorize("#aaaaaa", "Dull "..default_name.."\n")..core.colorize("#ff0000", "-20% melee damage"))
				itm_mt:set_string("original_description", "" .. core.colorize("#aaaaaa", "Dull "..default_name.."\n"))
				itm_mt:set_string("tmod_name", "#aaaaaa,Dull ")
				itm_mt:set_string("tmod_stat", "#ff0000,-20% melee damage")
			end
			
			if modifier == 3 then
				itm_mt:set_tool_capabilities({
					full_punch_interval = def_fpi,
					max_drop_level=def_mdl,
					groupcaps={
						cracky = {times={[1]=def_cracky1 * 0.75, [2]=def_cracky2 * 0.75, [3]=def_cracky3 * 0.75}, uses=cracky_uses, maxlevel=def_cracky_maxlevel},
						crumbly = {times={[1]=def_crumbly1 * 0.75, [2]=def_crumbly2 * 0.75, [3]=def_crumbly3 * 0.75}, uses=crumbly_uses, maxlevel=def_crumbly_maxlevel},
						choppy = {times={[1]=def_choppy1 * 0.75, [2]=def_choppy2 * 0.75, [3]=def_choppy3 * 0.75}, uses=choppy_uses, maxlevel=def_choppy_maxlevel},
						snappy = {times={[1]=def_snappy1 * 0.75, [2]=def_snappy2 * 0.75, [3]=def_snappy3 * 0.75}, uses=snappy_uses, maxlevel=def_snappy_maxlevel},
					},
					damage_groups = {fleshy = atk},
				})
				itm_mt:set_string("description", "" .. core.colorize("#00eaff", "Efficient "..default_name.."\n")..core.colorize("#40d000", "+25% Digging speed"))
				itm_mt:set_string("original_description", "" .. core.colorize("#00eaff", "Efficient "..default_name.."\n"))
				itm_mt:set_string("tmod_name", "#00eaff,Efficient ")
				itm_mt:set_string("tmod_stat", "#40d000,+25% Digging speed")
			end
		
			if modifier == 4 then
				itm_mt:set_tool_capabilities({
					full_punch_interval = def_fpi,
					max_drop_level=def_mdl,
					groupcaps={
						cracky = {times={[1]=def_cracky1 * 1.333, [2]=def_cracky2 * 1.333, [3]=def_cracky3 * 1.333}, uses=cracky_uses, maxlevel=def_cracky_maxlevel},
						crumbly = {times={[1]=def_crumbly1 * 1.333, [2]=def_crumbly2 * 1.333, [3]=def_crumbly3 * 1.333}, uses=crumbly_uses, maxlevel=def_crumbly_maxlevel},
						choppy = {times={[1]=def_choppy1 * 1.333, [2]=def_choppy2 * 1.333, [3]=def_choppy3 * 1.333}, uses=choppy_uses, maxlevel=def_choppy_maxlevel},
						snappy = {times={[1]=def_snappy1 * 1.333, [2]=def_snappy2 * 1.333, [3]=def_snappy3 * 1.333}, uses=snappy_uses, maxlevel=def_snappy_maxlevel},
					},
					damage_groups = {fleshy = atk},
				})
				itm_mt:set_string("description", "" .. core.colorize("#aaaaaa", "Lazy "..default_name.."\n")..core.colorize("#ff0000", "-25% Digging speed"))
				itm_mt:set_string("original_description", "" .. core.colorize("#aaaaaa", "Lazy "..default_name.."\n"))
				itm_mt:set_string("tmod_name", "#aaaaaa,Lazy ")
				itm_mt:set_string("tmod_stat", "#ff0000,-25% Digging speed")
			end
		
			if modifier == 5 then
				itm_mt:set_tool_capabilities({
					full_punch_interval = def_fpi * 1.25,
					max_drop_level=def_mdl,
					groupcaps=def_gc,
					damage_groups = {fleshy = atk * 1.25},
				})
				itm_mt:set_string("description", "" .. core.colorize("#ffffff", "Heavy "..default_name.."\n")..core.colorize("#40d000", "+25% Melee damage\n")..core.colorize("#ff0000", "+25% Attack cooldown"))
				itm_mt:set_string("original_description", "" .. core.colorize("#ffffff", "Heavy "..default_name.."\n"))
				itm_mt:set_string("tmod_name", "#ffffff,Heavy ")
				itm_mt:set_string("tmod_stat", "#40d000,+25% Melee damage\n;#ff0000,+25% Attack cooldown")
			end
		
			if modifier == 6 then
				itm_mt:set_tool_capabilities({
					full_punch_interval = def_fpi * 0.75,
					max_drop_level=def_mdl,
					groupcaps=def_gc,
					damage_groups = {fleshy = atk * 0.80},
				})
				itm_mt:set_string("description", "" .. core.colorize("#ffffff", "Light "..default_name.."\n")..core.colorize("#ff0000", "-20% Melee damage\n")..core.colorize("#40d000", "-25% Attack cooldown"))
				itm_mt:set_string("original_description", "" .. core.colorize("#ffffff", "Light "..default_name.."\n"))
				itm_mt:set_string("tmod_name", "#ffffff,Light ")
				itm_mt:set_string("tmod_stat", "#ff0000,-20% Melee damage\n;#40d000,-25% Attack cooldown")
			end
		
			if modifier == 7 then
				fnl_cracky_uses = math.floor(tonumber(def_cracky_uses) * 1.5)
				fnl_snappy_uses = math.floor(tonumber(def_snappy_uses) * 1.5)
				fnl_crumbly_uses = math.floor(tonumber(def_crumbly_uses) * 1.5)
				fnl_choppy_uses = math.floor(tonumber(def_choppy_uses) * 1.5)
				itm_mt:set_tool_capabilities({
					full_punch_interval = def_fpi,
					max_drop_level=def_mdl,
					groupcaps={
						cracky = {times={[1]=def_cracky1 * 1, [2]=def_cracky2 * 1, [3]=def_cracky3 * 1}, uses=fnl_cracky_uses, maxlevel=def_cracky_maxlevel},
						crumbly = {times={[1]=def_crumbly1 * 1, [2]=def_crumbly2 * 1, [3]=def_crumbly3 * 1}, uses=fnl_crumbly_uses, maxlevel=def_crumbly_maxlevel},
						choppy = {times={[1]=def_choppy1 * 1, [2]=def_choppy2 * 1, [3]=def_choppy3 * 1}, uses=fnl_choppy_uses, maxlevel=def_choppy_maxlevel},
						snappy = {times={[1]=def_snappy1 * 1, [2]=def_snappy2 * 1, [3]=def_snappy3 * 1}, uses=fnl_snappy_uses, maxlevel=def_snappy_maxlevel},
					},
					damage_groups = {fleshy = atk},
				})
				itm_mt:set_string("description", "" .. core.colorize("#00eaff", "Durable "..default_name.."\n")..core.colorize("#40d000", "+50% Durability"))
				itm_mt:set_string("original_description", "" .. core.colorize("#00eaff", "Durable "..default_name.."\n"))
				itm_mt:set_string("tmod_name", "#00eaff,Durable ")
				itm_mt:set_string("tmod_stat", "#40d000,+50% Durability")
			end
		
			if modifier == 8 then
				fnl_cracky_uses = math.floor(tonumber(def_cracky_uses) * 0.6)
				fnl_snappy_uses = math.floor(tonumber(def_snappy_uses) * 0.6)
				fnl_crumbly_uses = math.floor(tonumber(def_crumbly_uses) * 0.6)
				fnl_choppy_uses = math.floor(tonumber(def_choppy_uses) * 0.6)
				itm_mt:set_tool_capabilities({
					full_punch_interval = def_fpi,
					max_drop_level=def_mdl,
					groupcaps={
						cracky = {times={[1]=def_cracky1 * 1, [2]=def_cracky2 * 1, [3]=def_cracky3 * 1}, uses=fnl_cracky_uses, maxlevel=def_cracky_maxlevel},
						crumbly = {times={[1]=def_crumbly1 * 1, [2]=def_crumbly2 * 1, [3]=def_crumbly3 * 1}, uses=fnl_crumbly_uses, maxlevel=def_crumbly_maxlevel},
						choppy = {times={[1]=def_choppy1 * 1, [2]=def_choppy2 * 1, [3]=def_choppy3 * 1}, uses=fnl_choppy_uses, maxlevel=def_choppy_maxlevel},
						snappy = {times={[1]=def_snappy1 * 1, [2]=def_snappy2 * 1, [3]=def_snappy3 * 1}, uses=fnl_snappy_uses, maxlevel=def_snappy_maxlevel},
					},
					damage_groups = {fleshy = atk},
				})
				itm_mt:set_string("description", "" .. core.colorize("#aaaaaa", "Fragile "..default_name.."\n")..core.colorize("#ff0000", "-40% Durability"))
				itm_mt:set_string("original_description", "" .. core.colorize("#aaaaaa", "Fragile "..default_name.."\n"))
				itm_mt:set_string("tmod_name", "#aaaaaa,Fragile ")
				itm_mt:set_string("tmod_stat", "#ff0000,-40% Durability")
			end
		
			if modifier == 9 then
				fnl_cracky_uses = math.floor(tonumber(def_cracky_uses) * 1.25)
				fnl_snappy_uses = math.floor(tonumber(def_snappy_uses) * 1.25)
				fnl_crumbly_uses = math.floor(tonumber(def_crumbly_uses) * 1.25)
				fnl_choppy_uses = math.floor(tonumber(def_choppy_uses) * 1.25)
				itm_mt:set_tool_capabilities({
					full_punch_interval = def_fpi,
					max_drop_level=def_mdl,
					groupcaps={
						cracky = {times={[1]=def_cracky1 * 0.84, [2]=def_cracky2 * 0.84, [3]=def_cracky3 * 0.84}, uses=fnl_cracky_uses, maxlevel=def_cracky_maxlevel},
						crumbly = {times={[1]=def_crumbly1 * 0.84, [2]=def_crumbly2 * 0.84, [3]=def_crumbly3 * 0.84}, uses=fnl_crumbly_uses, maxlevel=def_crumbly_maxlevel},
						choppy = {times={[1]=def_choppy1 * 0.84, [2]=def_choppy2 * 0.84, [3]=def_choppy3 * 0.84}, uses=fnl_choppy_uses, maxlevel=def_choppy_maxlevel},
						snappy = {times={[1]=def_snappy1 * 0.84, [2]=def_snappy2 * 0.84, [3]=def_snappy3 * 0.84}, uses=fnl_snappy_uses, maxlevel=def_snappy_maxlevel},
					},
					damage_groups = {fleshy = atk * 1.18},
				})
				itm_mt:set_string("description", "" .. core.colorize("#00ffa2", "Demonic "..default_name.."\n")..core.colorize("#40d000", "+25% Durability\n")..core.colorize("#40d000", "+18% Melee damage\n")..core.colorize("#40d000", "+16% Mining speed"))
				itm_mt:set_string("original_description", "" .. core.colorize("#00ffa2", "Demonic "..default_name.."\n"))
				itm_mt:set_string("tmod_name", "#00ffa2,Demonic ")
				itm_mt:set_string("tmod_stat", "#40d000,+25% Durability\n;#40d000,+18% Melee damage\n;#40d000,+16% Mining speed")
			end
		
			if modifier == 10 then
				fnl_cracky_uses = math.floor(tonumber(def_cracky_uses) * 0.75)
				fnl_snappy_uses = math.floor(tonumber(def_snappy_uses) * 0.75)
				fnl_crumbly_uses = math.floor(tonumber(def_crumbly_uses) * 0.75)
				fnl_choppy_uses = math.floor(tonumber(def_choppy_uses) * 0.75)
				itm_mt:set_tool_capabilities({
					full_punch_interval = def_fpi,
					max_drop_level=def_mdl,
					groupcaps={
						cracky = {times={[1]=def_cracky1 * 1.191, [2]=def_cracky2 * 1.191, [3]=def_cracky3 * 1.191}, uses=fnl_cracky_uses, maxlevel=def_cracky_maxlevel},
						crumbly = {times={[1]=def_crumbly1 * 1.191, [2]=def_crumbly2 * 1.191, [3]=def_crumbly3 * 1.191}, uses=fnl_crumbly_uses, maxlevel=def_crumbly_maxlevel},
						choppy = {times={[1]=def_choppy1 * 1.191, [2]=def_choppy2 * 1.191, [3]=def_choppy3 * 1.191}, uses=fnl_choppy_uses, maxlevel=def_choppy_maxlevel},
						snappy = {times={[1]=def_snappy1 * 1.191, [2]=def_snappy2 * 1.191, [3]=def_snappy3 * 1.191}, uses=fnl_snappy_uses, maxlevel=def_snappy_maxlevel},
					},
					damage_groups = {fleshy = atk * 0.82},
				})
				itm_mt:set_string("description", "" .. core.colorize("#666666", "Broken "..default_name.."\n")..core.colorize("#ff0000", "-25% Durability\n")..core.colorize("#ff0000", "-18% Melee damage\n")..core.colorize("#ff0000", "-16% Mining speed"))
				itm_mt:set_string("original_description", "" .. core.colorize("#666666", "Broken "..default_name.."\n"))
				itm_mt:set_string("tmod_name", "#666666,Broken ")
				itm_mt:set_string("tmod_stat", "#ff0000,-25% Durability\n;#ff0000,-18% Melee damage\n;#ff0000,-16% Mining speed")
			end
		
			if modifier == 11 then
				fnl_cracky_uses = math.floor(tonumber(def_cracky_uses) * 1.75)
				fnl_snappy_uses = math.floor(tonumber(def_snappy_uses) * 1.75)
				fnl_crumbly_uses = math.floor(tonumber(def_crumbly_uses) * 1.75)
				fnl_choppy_uses = math.floor(tonumber(def_choppy_uses) * 1.75)
				itm_mt:set_tool_capabilities({
					full_punch_interval = def_fpi * 0.75,
					max_drop_level=def_mdl,
					groupcaps={
						cracky = {times={[1]=def_cracky1 * 0.6, [2]=def_cracky2 * 0.6, [3]=def_cracky3 * 0.6}, uses=fnl_cracky_uses, maxlevel=def_cracky_maxlevel},
						crumbly = {times={[1]=def_crumbly1 * 0.6, [2]=def_crumbly2 * 0.6, [3]=def_crumbly3 * 0.6}, uses=fnl_crumbly_uses, maxlevel=def_crumbly_maxlevel},
						choppy = {times={[1]=def_choppy1 * 0.6, [2]=def_choppy2 * 0.6, [3]=def_choppy3 * 0.6}, uses=fnl_choppy_uses, maxlevel=def_choppy_maxlevel},
						snappy = {times={[1]=def_snappy1 * 0.6, [2]=def_snappy2 * 0.6, [3]=def_snappy3 * 0.6}, uses=fnl_snappy_uses, maxlevel=def_snappy_maxlevel},
					},
					damage_groups = {fleshy = atk * 1.40},
				})
				itm_mt:set_string("description", "" .. core.colorize("#ff954e", "Legendary "..default_name.."\n")..core.colorize("#40d000", "+75% Durability\n")..core.colorize("#40d000", "+40% Melee damage\n")..core.colorize("#40d000", "+40% Mining speed\n")..core.colorize("#40d000", "-25% attack cooldown"))
				itm_mt:set_string("original_description", "" .. core.colorize("#ff954e", "Legendary "..default_name.."\n"))
				itm_mt:set_string("tmod_name", "#ff954e,Legendary ")
				itm_mt:set_string("tmod_stat", "#40d000,+75% Durability\n;#40d000,+40% Melee damage\n;#40d000,+40% Mining speed\n;#40d000,-25% attack cooldown")
			end
		
			if modifier == 12 then
				fnl_cracky_uses = math.floor(tonumber(def_cracky_uses) * 0.4)
				fnl_snappy_uses = math.floor(tonumber(def_snappy_uses) * 0.4)
				fnl_crumbly_uses = math.floor(tonumber(def_crumbly_uses) * 0.4)
				fnl_choppy_uses = math.floor(tonumber(def_choppy_uses) * 0.4)
				itm_mt:set_tool_capabilities({
					full_punch_interval = def_fpi * 1.3,
					max_drop_level=def_mdl,
					groupcaps={
						cracky = {times={[1]=def_cracky1 * 1.666, [2]=def_cracky2 * 1.666, [3]=def_cracky3 * 1.666}, uses=fnl_cracky_uses, maxlevel=def_cracky_maxlevel},
						crumbly = {times={[1]=def_crumbly1 * 1.666, [2]=def_crumbly2 * 1.666, [3]=def_crumbly3 * 1.666}, uses=fnl_crumbly_uses, maxlevel=def_crumbly_maxlevel},
						choppy = {times={[1]=def_choppy1 * 1.666, [2]=def_choppy2 * 1.666, [3]=def_choppy3 * 1.666}, uses=fnl_choppy_uses, maxlevel=def_choppy_maxlevel},
						snappy = {times={[1]=def_snappy1 * 1.666, [2]=def_snappy2 * 1.666, [3]=def_snappy3 * 1.666}, uses=fnl_snappy_uses, maxlevel=def_snappy_maxlevel},
					},
					damage_groups = {fleshy = atk * 0.65},
				})
				itm_mt:set_string("description", "" .. core.colorize("#161616", "Terrible "..default_name.."\n")..core.colorize("#ff0000", "-60% Durability\n")..core.colorize("#ff0000", "-35% Melee damage\n")..core.colorize("#ff0000", "-40% Mining speed\n")..core.colorize("#ff0000", "+30% attack cooldown"))
				itm_mt:set_string("original_description", "" .. core.colorize("#161616", "Terrible "..default_name.."\n"))
				itm_mt:set_string("tmod_name", "#161616,Terrible ")
				itm_mt:set_string("tmod_stat", "#ff0000,-60% Durability\n;#ff0000,-35% Melee damage\n;#ff0000,-40% Mining speed\n;#ff0000,+30% attack cooldown")
			end
		end
		return itemstack
	end
end)
