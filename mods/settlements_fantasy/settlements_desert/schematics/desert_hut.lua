local n1 = { name = "default:dirt_with_grass" }
local n2 = { name = "default:desert_sandstone_brick" }
local n3 = { name = "stairs:stair_desert_sandstone_brick", param2 = 16 }
local n4 = { name = "stairs:stair_desert_sandstone_brick", param2 = 12 }
local n5 = { name = "default:desert_sandstone_brick", prob = 190 }
local n6 = { name = "air" }
local n7 = { name = "stairs:stair_desert_sandstone_brick" }
local n8 = { name = "default:chest", param2 = 2 }
local n9 = { name = "default:torch_wall", param2 = 3 }
local n10 = { name = "stairs:stair_desert_sandstone_brick", param2 = 1 }
local n11 = { name = "stairs:stair_desert_sandstone_brick", param2 = 3 }
local n12 = { name = "stairs:slab_desert_sandstone_brick", param2 = 1 }
local n13 = { name = "doors:door_wood_a", param2 = 3 }
local n14 = { name = "doors:hidden", param2 = 3 }
local n15 = { name = "beds:bed_top", param2 = 3 }
local n16 = { name = "beds:bed_bottom", param2 = 3 }
local n17 = { name = "stairs:stair_desert_sandstone_brick", param2 = 18 }
local n18 = { name = "stairs:stair_desert_sandstone_brick", param2 = 14 }
local n19 = { name = "stairs:stair_desert_sandstone_brick", param2 = 2 }

return {
	yslice_prob = {
		
	},
	size = {y = 5, x = 5, z = 5},
	data = {
		-- z=-4, y=0
		n1, n2, n2, n2, n1, 
		-- z=-4, y=1
		n3, n2, n2, n2, n4, 
		-- z=-4, y=2
		n3, n2, n5, n2, n4, 
		-- z=-4, y=3
		n6, n7, n7, n7, n6, 
		-- z=-4, y=4
		n6, n6, n6, n6, n6, 

		-- z=-3, y=0
		n2, n2, n2, n2, n2, 
		-- z=-3, y=1
		n2, n8, n6, n6, n2, 
		-- z=-3, y=2
		n2, n9, n6, n6, n2, 
		-- z=-3, y=3
		n10, n6, n6, n6, n11, 
		-- z=-3, y=4
		n6, n12, n12, n12, n6, 

		-- z=-2, y=0
		n2, n2, n2, n2, n2, 
		-- z=-2, y=1
		n2, n6, n6, n6, n13, 
		-- z=-2, y=2
		n5, n6, n6, n6, n14, 
		-- z=-2, y=3
		n10, n6, n6, n6, n11, 
		-- z=-2, y=4
		n6, n12, n12, n12, n6, 

		-- z=-1, y=0
		n2, n2, n2, n2, n2, 
		-- z=-1, y=1
		n2, n15, n16, n6, n2, 
		-- z=-1, y=2
		n2, n6, n6, n6, n2, 
		-- z=-1, y=3
		n10, n6, n6, n6, n11, 
		-- z=-1, y=4
		n6, n12, n12, n12, n6, 

		-- z=0, y=0
		n1, n2, n2, n2, n1, 
		-- z=0, y=1
		n17, n2, n2, n2, n18, 
		-- z=0, y=2
		n17, n2, n5, n2, n18, 
		-- z=0, y=3
		n6, n19, n19, n19, n6, 
		-- z=0, y=4
		n6, n6, n6, n6, n6, 
}
}
