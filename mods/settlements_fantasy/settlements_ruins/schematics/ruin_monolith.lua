local n1 = { name = "default:cobble" }
local n2 = { name = "stairs:stair_outer_cobble", param2 = 1 }
local n3 = { name = "stairs:stair_cobble" }
local n4 = { name = "stairs:stair_outer_cobble" }
local n5 = { name = "air" }
local n6 = { name = "stairs:slab_cobble", param2 = 8 }
local n7 = { name = "stairs:stair_cobble", param2 = 1 }
local n8 = { name = "stairs:stair_cobble", param2 = 3 }
local n9 = { name = "stairs:slab_cobble", param2 = 16 }
local n10 = { name = "stairs:slab_cobble", param2 = 12 }
local n11 = { name = "walls:cobble" }
local n12 = { name = "default:mese_post_light", prob = 64 }
local n13 = { name = "stairs:stair_outer_cobble", param2 = 2 }
local n14 = { name = "stairs:stair_cobble", param2 = 2 }
local n15 = { name = "stairs:stair_outer_cobble", param2 = 3 }
local n16 = { name = "stairs:slab_cobble", param2 = 4 }
local n17 = { name = "default:cobble" }

if minetest.get_modpath("commoditymarket_fantasy") and minetest.registered_items["commoditymarket_fantasy:under_market"] then
	n17 = { name = "commoditymarket_fantasy:under_market", prob = 64}
end

return {
	yslice_prob = {},
	size = {y = 8, x = 3, z = 3},
	data = {
		-- z=0, y=-7
		n1, n1, n1, 
		-- z=0, y=-6
		n2, n3, n4, 
		-- z=0, y=-5
		n5, n6, n5, 
		-- z=0, y=-4
		n5, n6, n5, 
		-- z=0, y=-3
		n5, n5, n5, 
		-- z=0, y=-2
		n5, n5, n5, 
		-- z=0, y=-1
		n5, n5, n5, 
		-- z=0, y=0
		n5, n5, n5, 

		-- z=1, y=-7
		n1, n17, n1, 
		-- z=1, y=-6
		n7, n1, n8, 
		-- z=1, y=-5
		n9, n1, n10, 
		-- z=1, y=-4
		n9, n1, n10, 
		-- z=1, y=-3
		n5, n1, n5, 
		-- z=1, y=-2
		n5, n1, n5, 
		-- z=1, y=-1
		n5, n11, n5, 
		-- z=1, y=0
		n5, n12, n5, 

		-- z=2, y=-7
		n1, n1, n1, 
		-- z=2, y=-6
		n13, n14, n15, 
		-- z=2, y=-5
		n5, n16, n5, 
		-- z=2, y=-4
		n5, n16, n5, 
		-- z=2, y=-3
		n5, n5, n5, 
		-- z=2, y=-2
		n5, n5, n5, 
		-- z=2, y=-1
		n5, n5, n5, 
		-- z=2, y=0
		n5, n5, n5, 
}
}
