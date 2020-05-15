local n1 = { name = "default:dirt_with_grass" }
local n2 = { name = "air" }
local n3 = { name = "stairs:stair_stone_block" }
local n4 = { name = "default:dirt" }
local n5 = { name = "default:stonebrick" }
local n6 = { name = "walls:cobble" }
local n7 = { name = "stairs:slab_cobble", param2 = 3 }
local n8 = { name = "xpanes:bar_flat", param2 = 1 }
local n9 = { name = "stairs:slab_cobble", param2 = 21 }
local n10 = { name = "default:lava_source" }
local n11 = { name = "xpanes:bar_flat", param2 = 3 }
local n12 = { name = "default:cobble" }
local n13 = { name = "default:furnace" }
local n14 = { name = "stairs:slab_cobble", param2 = 1 }

return {
	yslice_prob = {
		
	},
	size = {
		y = 7,
		x = 7,
		z = 6
	}
,
	data = {


		-- z=0, y=0
		n1, n1, n1, n1, n1, n1, n1, 
		-- z=0, y=1
		n2, n2, n3, n3, n3, n2, n2, 
		-- z=0, y=2
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=0, y=3
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=0, y=4
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=0, y=5
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=0, y=6
		n2, n2, n2, n2, n2, n2, n2, 

		-- z=1, y=0
		n1, n4, n1, n4, n4, n4, n1, 
		-- z=1, y=1
		n2, n5, n5, n5, n5, n5, n2, 
		-- z=1, y=2
		n2, n6, n2, n2, n2, n6, n2, 
		-- z=1, y=3
		n2, n6, n2, n2, n2, n6, n2, 
		-- z=1, y=4
		n2, n6, n2, n2, n2, n6, n2, 
		-- z=1, y=5
		n2, n7, n7, n7, n7, n7, n2, 
		-- z=1, y=6
		n2, n2, n2, n2, n2, n2, n2, 

		-- z=2, y=0
		n1, n4, n4, n4, n4, n4, n1, 
		-- z=2, y=1
		n2, n5, n5, n5, n5, n5, n2, 
		-- z=2, y=2
		n2, n6, n2, n2, n2, n6, n2, 
		-- z=2, y=3
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=2, y=4
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=2, y=5
		n2, n7, n7, n7, n7, n7, n2, 
		-- z=2, y=6
		n2, n2, n2, n2, n2, n2, n2, 

		-- z=3, y=0
		n1, n4, n4, n4, n4, n4, n1, 
		-- z=3, y=1
		n2, n5, n5, n5, n5, n5, n2, 
		-- z=3, y=2
		n2, n6, n6, n6, n2, n6, n2, 
		-- z=3, y=3
		n2, n8, n2, n2, n2, n2, n2, 
		-- z=3, y=4
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=3, y=5
		n2, n9, n9, n9, n9, n9, n2, 
		-- z=3, y=6
		n2, n2, n2, n2, n2, n2, n2, 

		-- z=4, y=0
		n1, n4, n4, n4, n4, n4, n1, 
		-- z=4, y=1
		n2, n5, n5, n5, n5, n5, n2, 
		-- z=4, y=2
		n2, n6, n10, n6, n2, n6, n2, 
		-- z=4, y=3
		n2, n11, n2, n8, n2, n2, n2, 
		-- z=4, y=4
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=4, y=5
		n2, n9, n9, n9, n9, n9, n2, 
		-- z=4, y=6
		n2, n2, n2, n2, n2, n2, n2, 

		-- z=5, y=0
		n1, n4, n4, n4, n4, n4, n1, 
		-- z=5, y=1
		n2, n5, n5, n5, n5, n5, n2, 
		-- z=5, y=2
		n2, n12, n12, n12, n13, n12, n2, 
		-- z=5, y=3
		n2, n12, n12, n12, n12, n12, n2, 
		-- z=5, y=4
		n2, n12, n12, n12, n12, n12, n2, 
		-- z=5, y=5
		n2, n6, n2, n2, n2, n6, n2, 
		-- z=5, y=6
		n2, n14, n14, n14, n14, n14, n2, 
}
}
