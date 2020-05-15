local n1 = { name = "default:dirt_with_grass" }
local n2 = { name = "air" }
local n3 = { name = "stairs:stair_outer_stone_block", param2 = 20 }
local n4 = { name = "stairs:stair_stone_block", param2 = 20 }
local n5 = { name = "stairs:stair_outer_stone_block", param2 = 21 }
local n6 = { name = "default:stone_block" }
local n7 = { name = "default:dirt" }
local n8 = { name = "default:cobble" }
local n9 = { name = "stairs:stair_stone_block", param2 = 23 }
local n10 = { name = "stairs:stair_stone_block", param2 = 21 }
local n11 = { name = "default:junglewood" }
local n12 = { name = "default:ladder_wood", param2 = 5 }
local n13 = { name = "default:torch_wall", param2 = 5 }
local n14 = { name = "stairs:slab_stone_block", param2 = 20 }
local n15 = { name = "stairs:slab_stone_block", param2 = 23 }
local n16 = { name = "default:torch_wall", param2 = 4 }
local n17 = { name = "doors:door_wood_a" }
local n18 = { name = "doors:hidden" }
local n19 = { name = "stairs:stair_outer_stone_block", param2 = 23 }
local n20 = { name = "stairs:stair_stone_block", param2 = 22 }
local n21 = { name = "stairs:stair_outer_stone_block", param2 = 22 }

return {
	yslice_prob = {
		
	},
	size = {
		y = 10,
		x = 7,
		z = 7
	}
,
	data = {


		-- z=0, y=0
		n1, n1, n1, n1, n1, n1, n1, 
		-- z=0, y=1
		n2, n2, n2, n2, n2, n2, n2, 
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
		-- z=0, y=7
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=0, y=8
		n3, n4, n4, n4, n4, n4, n5, 
		-- z=0, y=9
		n6, n2, n6, n2, n6, n2, n6, 

		-- z=1, y=0
		n1, n7, n7, n7, n7, n7, n1, 
		-- z=1, y=1
		n2, n6, n8, n8, n8, n6, n2, 
		-- z=1, y=2
		n2, n6, n8, n8, n8, n6, n2, 
		-- z=1, y=3
		n2, n6, n8, n8, n8, n6, n2, 
		-- z=1, y=4
		n2, n6, n6, n6, n6, n6, n2, 
		-- z=1, y=5
		n2, n6, n8, n8, n8, n6, n2, 
		-- z=1, y=6
		n2, n6, n8, n8, n8, n6, n2, 
		-- z=1, y=7
		n2, n6, n8, n8, n8, n6, n2, 
		-- z=1, y=8
		n9, n2, n2, n2, n2, n2, n10, 
		-- z=1, y=9
		n2, n2, n2, n2, n2, n2, n2, 

		-- z=2, y=0
		n1, n7, n11, n11, n11, n7, n1, 
		-- z=2, y=1
		n2, n8, n2, n12, n2, n8, n2, 
		-- z=2, y=2
		n2, n8, n2, n12, n2, n8, n2, 
		-- z=2, y=3
		n2, n8, n13, n12, n13, n8, n2, 
		-- z=2, y=4
		n2, n6, n11, n12, n11, n6, n2, 
		-- z=2, y=5
		n2, n8, n2, n12, n2, n8, n2, 
		-- z=2, y=6
		n2, n8, n2, n12, n2, n8, n2, 
		-- z=2, y=7
		n2, n8, n14, n12, n15, n8, n2, 
		-- z=2, y=8
		n9, n2, n2, n2, n2, n2, n10, 
		-- z=2, y=9
		n6, n2, n2, n2, n2, n2, n6, 

		-- z=3, y=0
		n1, n7, n11, n11, n11, n7, n1, 
		-- z=3, y=1
		n2, n8, n2, n2, n2, n8, n2, 
		-- z=3, y=2
		n2, n8, n2, n2, n2, n8, n2, 
		-- z=3, y=3
		n2, n8, n2, n2, n2, n8, n2, 
		-- z=3, y=4
		n2, n6, n11, n11, n11, n6, n2, 
		-- z=3, y=5
		n2, n8, n2, n2, n2, n8, n2, 
		-- z=3, y=6
		n2, n8, n2, n2, n2, n8, n2, 
		-- z=3, y=7
		n2, n8, n14, n14, n14, n8, n2, 
		-- z=3, y=8
		n9, n2, n2, n2, n2, n2, n10, 
		-- z=3, y=9
		n2, n2, n2, n2, n2, n2, n2, 

		-- z=4, y=0
		n1, n7, n11, n11, n11, n7, n1, 
		-- z=4, y=1
		n2, n8, n2, n2, n2, n8, n2, 
		-- z=4, y=2
		n2, n8, n2, n2, n2, n8, n2, 
		-- z=4, y=3
		n2, n8, n2, n2, n2, n8, n2, 
		-- z=4, y=4
		n2, n6, n11, n11, n11, n6, n2, 
		-- z=4, y=5
		n2, n8, n2, n2, n2, n8, n2, 
		-- z=4, y=6
		n2, n8, n2, n16, n2, n8, n2, 
		-- z=4, y=7
		n2, n8, n14, n14, n14, n8, n2, 
		-- z=4, y=8
		n9, n2, n2, n2, n2, n2, n10, 
		-- z=4, y=9
		n6, n2, n2, n2, n2, n2, n6, 

		-- z=5, y=0
		n1, n7, n7, n11, n7, n7, n1, 
		-- z=5, y=1
		n2, n6, n8, n17, n8, n6, n2, 
		-- z=5, y=2
		n2, n6, n8, n18, n8, n6, n2, 
		-- z=5, y=3
		n2, n6, n8, n8, n8, n6, n2, 
		-- z=5, y=4
		n2, n6, n6, n6, n6, n6, n2, 
		-- z=5, y=5
		n2, n6, n8, n8, n8, n6, n2, 
		-- z=5, y=6
		n2, n6, n8, n8, n8, n6, n2, 
		-- z=5, y=7
		n2, n6, n8, n8, n8, n6, n2, 
		-- z=5, y=8
		n9, n2, n2, n2, n2, n2, n10, 
		-- z=5, y=9
		n2, n2, n2, n2, n2, n2, n2, 

		-- z=6, y=0
		n1, n1, n1, n1, n1, n1, n1, 
		-- z=6, y=1
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=6, y=2
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=6, y=3
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=6, y=4
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=6, y=5
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=6, y=6
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=6, y=7
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=6, y=8
		n19, n20, n20, n20, n20, n20, n21, 
		-- z=6, y=9
		n6, n2, n6, n2, n6, n2, n6, 
}
}
