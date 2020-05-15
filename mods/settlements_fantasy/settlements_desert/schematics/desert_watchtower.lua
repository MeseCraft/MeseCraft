local n1 = { name = "default:dirt_with_grass" }
local n2 = { name = "air" }
local n3 = { name = "stairs:slab_desert_sandstone_brick", param2 = 8 }
local n4 = { name = "default:torch", param2 = 1, prob = 200 }
local n5 = { name = "default:desert_sandstone_brick" }
local n6 = { name = "stairs:stair_desert_sandstone_brick", param2 = 16 }
local n7 = { name = "stairs:stair_desert_sandstone_brick", param2 = 12 }
local n8 = { name = "stairs:stair_inner_desert_sandstone_brick", param2 = 20 }
local n9 = { name = "stairs:stair_inner_desert_sandstone_brick", param2 = 21 }
local n10 = { name = "stairs:slab_desert_sandstone_brick", param2 = 17 }
local n11 = { name = "stairs:slab_desert_sandstone_brick", param2 = 15 }
local n12 = { name = "default:ladder_wood", param2 = 5 }
local n13 = { name = "default:desert_sandstone_brick", param2 = 3 }
local n14 = { name = "doors:trapdoor", param2 = 2 }
local n15 = { name = "stairs:stair_desert_sandstone_brick", param2 = 18 }
local n16 = { name = "doors:door_wood_a", param2 = 2 }
local n17 = { name = "stairs:stair_desert_sandstone_brick", param2 = 14 }
local n18 = { name = "doors:hidden", param2 = 2 }
local n19 = { name = "stairs:stair_inner_desert_sandstone_brick", param2 = 23 }
local n20 = { name = "stairs:stair_inner_desert_sandstone_brick", param2 = 7 }
local n21 = { name = "stairs:slab_desert_sandstone_brick", param2 = 6 }

return {
	yslice_prob = {
		{ypos=0},
		{ypos=1},
		{ypos=2},
		{ypos=3, prob=190},
		{ypos=4, prob=190},
		{ypos=5, prob=190},
		{ypos=6, prob=190},
		{ypos=7, prob=190},
		{ypos=8},
		{ypos=9},
		{ypos=10},
	},
	size = {y = 11, x = 5, z = 5},
	data = {
		-- z=-4, y=0
		n1, n1, n1, n1, n1, 
		-- z=-4, y=1
		n2, n2, n2, n2, n2, 
		-- z=-4, y=2
		n2, n2, n2, n2, n2, 
		-- z=-4, y=3
		n2, n2, n2, n2, n2, 
		-- z=-4, y=4
		n2, n2, n2, n2, n2, 
		-- z=-4, y=5
		n2, n2, n2, n2, n2, 
		-- z=-4, y=6
		n2, n2, n2, n2, n2, 
		-- z=-4, y=7
		n2, n2, n2, n2, n2, 
		-- z=-4, y=8
		n2, n2, n2, n2, n2, 
		-- z=-4, y=9
		n2, n3, n3, n3, n2, 
		-- z=-4, y=10
		n2, n2, n4, n2, n2, 

		-- z=-3, y=0
		n1, n1, n5, n1, n1, 
		-- z=-3, y=1
		n2, n6, n5, n7, n2, 
		-- z=-3, y=2
		n2, n6, n5, n7, n2, 
		-- z=-3, y=3
		n2, n6, n5, n7, n2, 
		-- z=-3, y=4
		n2, n6, n5, n7, n2, 
		-- z=-3, y=5
		n2, n6, n5, n7, n2, 
		-- z=-3, y=6
		n2, n6, n5, n7, n2, 
		-- z=-3, y=7
		n2, n6, n5, n7, n2, 
		-- z=-3, y=8
		n2, n8, n5, n9, n2, 
		-- z=-3, y=9
		n10, n2, n2, n2, n11, 
		-- z=-3, y=10
		n2, n2, n2, n2, n2, 

		-- z=-2, y=0
		n1, n5, n5, n5, n1, 
		-- z=-2, y=1
		n2, n5, n12, n5, n2, 
		-- z=-2, y=2
		n2, n5, n12, n5, n2, 
		-- z=-2, y=3
		n2, n5, n12, n5, n2, 
		-- z=-2, y=4
		n2, n5, n12, n5, n2, 
		-- z=-2, y=5
		n2, n5, n12, n5, n2, 
		-- z=-2, y=6
		n2, n5, n12, n5, n2, 
		-- z=-2, y=7
		n2, n13, n12, n5, n2, 
		-- z=-2, y=8
		n2, n5, n12, n5, n2, 
		-- z=-2, y=9
		n10, n2, n14, n2, n11, 
		-- z=-2, y=10
		n4, n2, n2, n2, n4, 

		-- z=-1, y=0
		n1, n1, n5, n1, n1, 
		-- z=-1, y=1
		n2, n15, n16, n17, n2, 
		-- z=-1, y=2
		n2, n15, n18, n17, n2, 
		-- z=-1, y=3
		n2, n15, n5, n17, n2, 
		-- z=-1, y=4
		n2, n15, n5, n17, n2, 
		-- z=-1, y=5
		n2, n15, n5, n17, n2, 
		-- z=-1, y=6
		n2, n15, n5, n17, n2, 
		-- z=-1, y=7
		n2, n15, n5, n17, n2, 
		-- z=-1, y=8
		n2, n19, n5, n20, n2, 
		-- z=-1, y=9
		n10, n2, n2, n2, n11, 
		-- z=-1, y=10
		n2, n2, n2, n2, n2, 

		-- z=0, y=0
		n1, n1, n1, n1, n1, 
		-- z=0, y=1
		n2, n2, n2, n2, n2, 
		-- z=0, y=2
		n2, n2, n2, n2, n2, 
		-- z=0, y=3
		n2, n2, n2, n2, n2, 
		-- z=0, y=4
		n2, n2, n2, n2, n2, 
		-- z=0, y=5
		n2, n2, n2, n2, n2, 
		-- z=0, y=6
		n2, n2, n2, n2, n2, 
		-- z=0, y=7
		n2, n2, n2, n2, n2, 
		-- z=0, y=8
		n2, n2, n2, n2, n2, 
		-- z=0, y=9
		n2, n21, n21, n21, n2, 
		-- z=0, y=10
		n2, n2, n4, n2, n2, 
}
}
