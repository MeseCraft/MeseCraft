local n1 = { name = "default:dirt_with_grass" }
local n2 = { name = "air" }
local n3 = { name = "stairs:stair_wood" }
local n4 = { name = "default:junglewood" }
local n5 = { name = "default:tree", param2 = 2 }
local n6 = { name = "default:cobble" }
local n7 = { name = "doors:door_wood_a", param2 = 2 }
local n8 = { name = "doors:hidden", param2 = 2 }
local n9 = { name = "default:tree", param2 = 3 }
local n10 = { name = "default:tree", param2 = 7 }
local n11 = { name = "default:tree", param2 = 9 }
local n12 = { name = "stairs:stair_wood", param2 = 2 }
local n13 = { name = "beds:bed_bottom" }
local n14 = { name = "default:fence_wood" }
local n15 = { name = "xpanes:pane_flat", param2 = 3 }
local n16 = { name = "doors:trapdoor", param2 = 1 }
local n17 = { name = "default:torch_wall", param2 = 2 }
local n18 = { name = "default:torch_wall", param2 = 3 }
local n19 = { name = "stairs:stair_wood", param2 = 1 }
local n20 = { name = "default:wood" }
local n21 = { name = "stairs:stair_wood", param2 = 3 }
local n22 = { name = "beds:bed_top" }
local n23 = { name = "default:chest", param2 = 1 }
local n24 = { name = "default:tree", param2 = 1 }
local n25 = { name = "xpanes:pane_flat" }

return {
	yslice_prob = {
		
	},
	size = {
		y = 8,
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
		n3, n3, n3, n3, n3, n3, n3, 
		-- z=0, y=5
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=0, y=6
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=0, y=7
		n2, n2, n2, n2, n2, n2, n2, 

		-- z=1, y=0
		n1, n4, n4, n4, n4, n4, n1, 
		-- z=1, y=1
		n2, n5, n6, n7, n6, n5, n2, 
		-- z=1, y=2
		n2, n5, n6, n8, n6, n5, n2, 
		-- z=1, y=3
		n2, n9, n6, n6, n6, n9, n2, 
		-- z=1, y=4
		n2, n10, n2, n10, n2, n11, n2, 
		-- z=1, y=5
		n3, n3, n3, n3, n3, n3, n3, 
		-- z=1, y=6
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=1, y=7
		n2, n2, n2, n2, n2, n2, n2, 

		-- z=2, y=0
		n1, n4, n4, n4, n4, n4, n1, 
		-- z=2, y=1
		n2, n6, n2, n2, n12, n6, n2, 
		-- z=2, y=2
		n2, n6, n2, n2, n2, n6, n2, 
		-- z=2, y=3
		n2, n6, n2, n2, n2, n6, n2, 
		-- z=2, y=4
		n2, n11, n2, n10, n2, n11, n2, 
		-- z=2, y=5
		n2, n6, n2, n2, n2, n6, n2, 
		-- z=2, y=6
		n3, n3, n3, n3, n3, n3, n3, 
		-- z=2, y=7
		n2, n2, n2, n2, n2, n2, n2, 

		-- z=3, y=0
		n1, n4, n4, n4, n4, n4, n1, 
		-- z=3, y=1
		n2, n6, n13, n2, n14, n6, n2, 
		-- z=3, y=2
		n2, n15, n2, n2, n16, n15, n2, 
		-- z=3, y=3
		n2, n6, n2, n2, n2, n6, n2, 
		-- z=3, y=4
		n2, n11, n17, n11, n18, n11, n2, 
		-- z=3, y=5
		n2, n6, n2, n2, n2, n6, n2, 
		-- z=3, y=6
		n2, n6, n2, n2, n2, n6, n2, 
		-- z=3, y=7
		n19, n20, n20, n20, n20, n20, n21, 

		-- z=4, y=0
		n1, n4, n4, n4, n4, n4, n1, 
		-- z=4, y=1
		n2, n6, n22, n2, n23, n6, n2, 
		-- z=4, y=2
		n2, n6, n2, n2, n2, n6, n2, 
		-- z=4, y=3
		n2, n6, n2, n2, n2, n6, n2, 
		-- z=4, y=4
		n2, n11, n2, n11, n2, n11, n2, 
		-- z=4, y=5
		n2, n6, n2, n2, n2, n6, n2, 
		-- z=4, y=6
		n12, n12, n12, n12, n12, n12, n12, 
		-- z=4, y=7
		n2, n2, n2, n2, n2, n2, n2, 

		-- z=5, y=0
		n1, n4, n4, n4, n4, n4, n1, 
		-- z=5, y=1
		n2, n9, n6, n6, n6, n24, n2, 
		-- z=5, y=2
		n2, n9, n6, n25, n6, n24, n2, 
		-- z=5, y=3
		n2, n9, n6, n6, n6, n24, n2, 
		-- z=5, y=4
		n2, n11, n2, n11, n2, n11, n2, 
		-- z=5, y=5
		n12, n12, n12, n12, n12, n12, n12, 
		-- z=5, y=6
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=5, y=7
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
		n12, n12, n12, n12, n12, n12, n12, 
		-- z=6, y=5
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=6, y=6
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=6, y=7
		n2, n2, n2, n2, n2, n2, n2, 
}
}
