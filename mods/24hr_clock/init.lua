-- 24hr_clock
-- By David_G (kestral246@gmail.com)
-- FreeGamers.org --> Renamed to clock for theming purposes.

local activewidth=8  -- Number of inventory slots to check.

minetest.register_globalstep(function(dtime)
	local players  = minetest.get_connected_players()
	for i,player in ipairs(players) do
		local gotaclock=false
		local wielded=false
		local activeinv=nil
		local stackidx=0
		local wielded_item = player:get_wielded_item():get_name()
		if string.sub(wielded_item, 0, 16) == "24hr_clock:clock" then
			wielded=true
			stackidx=player:get_wield_index()
			gotaclock=true
		else
			if player:get_inventory() then
				for i,stack in ipairs(player:get_inventory():get_list("main")) do
					if i<=activewidth and string.sub(stack:get_name(), 0, 16) == "24hr_clock:clock" then
						activeinv=stack
						stackidx=i
						gotaclock=true
						break
					end
				end
			end
		end
		if gotaclock then
			local clock_image = math.floor(24 * minetest.get_timeofday())

			if wielded then
				player:set_wielded_item("24hr_clock:clock"..clock_image)
			elseif activeinv then
				player:get_inventory():set_stack("main",stackidx,"24hr_clock:clock"..clock_image)
			end
		end
	end
end)

local images = {
		"24hr_clock_0.png",
		"24hr_clock_1.png",
		"24hr_clock_2.png",
		"24hr_clock_3.png",
		"24hr_clock_4.png",
		"24hr_clock_5.png",
		"24hr_clock_6.png",
		"24hr_clock_7.png",
		"24hr_clock_8.png",
		"24hr_clock_9.png",
		"24hr_clock_10.png",
		"24hr_clock_11.png",
		"24hr_clock_12.png",
		"24hr_clock_13.png",
		"24hr_clock_14.png",
		"24hr_clock_15.png",
		"24hr_clock_16.png",
		"24hr_clock_17.png",
		"24hr_clock_18.png",
		"24hr_clock_19.png",
		"24hr_clock_20.png",
		"24hr_clock_21.png",
		"24hr_clock_22.png",
		"24hr_clock_23.png",
}

local i
for i,img in ipairs(images) do
		local inv = 1
		if i == 12 then
				inv = 0
		end
		minetest.register_tool("24hr_clock:clock"..(i-1), {
				description = "24-Hour Clock",
				inventory_image = img,
				wield_image = img,
				groups = {not_in_creative_inventory=inv}
		})
end

-- crafting recipe only works if default mod present. 
	minetest.register_craft({
			output = "24hr_clock:clock11",
			recipe = {
					{"", "default:tin_ingot", ""},
					{"default:copper_ingot", "default:glass", "default:copper_ingot"},
					{"", "default:copper_ingot", ""}
			}
	})
