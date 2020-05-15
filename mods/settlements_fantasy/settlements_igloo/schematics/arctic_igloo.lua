local n1 = { name = "default:ice" }
local n2 = { name = "stairs:slab_snowblock", param2 = 2 }
local n3 = { name = "air" }
local n4 = { name = "stairs:stair_outer_snowblock", param2 = 1 }
local n5 = { name = "stairs:stair_outer_snowblock" }
local n6 = { name = "stairs:stair_inner_straw", param2 = 3 }
local n7 = { name = "stairs:stair_straw", param2 = 2 }
local n8 = { name = "stairs:slab_straw", param2 = 2 }
local n9 = { name = "stairs:stair_inner_straw", param2 = 2 }
local n10 = { name = "stairs:stair_inner_snowblock", param2 = 1 }
local n11 = { name = "default:snowblock" }
local n12 = { name = "stairs:stair_inner_snowblock" }
local n13 = { name = "stairs:slab_snowblock", param2 = 20 }
local n14 = { name = "stairs:stair_straw", param2 = 3 }
local n15 = { name = "stairs:slab_straw", param2 = 1 }
local n16 = { name = "default:chest", param2 = 1 }
local n17 = { name = "stairs:stair_snowblock", param2 = 21 }
local n18 = { name = "stairs:stair_snowblock", param2 = 23 }
local n19 = { name = "stairs:stair_snowblock", param2 = 1 }
local n20 = { name = "stairs:stair_snowblock", param2 = 3 }
local n21 = { name = "stairs:slab_snowblock" }
local n22 = { name = "stairs:slab_straw" }
local n23 = { name = "default:torch", param2 = 1 }
local n24 = { name = "beds:bed_bottom" }
local n25 = { name = "stairs:stair_straw", param2 = 1 }
local n26 = { name = "stairs:slab_snowblock", param2 = 22 }
local n27 = { name = "beds:bed_bottom", param2 = 1 }
local n28 = { name = "beds:bed_top", param2 = 1 }
local n29 = { name = "beds:bed_top" }
local n30 = { name = "stairs:stair_outer_snowblock", param2 = 2 }
local n31 = { name = "stairs:stair_outer_snowblock", param2 = 3 }
local n32 = { name = "stairs:stair_inner_straw" }
local n33 = { name = "stairs:stair_straw" }
local n34 = { name = "stairs:stair_inner_straw", param2 = 1 }
local n35 = { name = "stairs:stair_inner_snowblock", param2 = 2 }
local n36 = { name = "stairs:stair_snowblock", param2 = 20 }
local n37 = { name = "stairs:stair_inner_snowblock", param2 = 3 }
local n38 = { name = "stairs:stair_snowblock", param2 = 2 }

return {
	yslice_prob = {
		
	},
	size = {
		y = 4,
		x = 7,
		z = 7
	}
,
	data = {


		-- z=-6, y=-3
		n1, n1, n1, n2, n1, n1, n1, 
		-- z=-6, y=-2
		n3, n3, n4, n3, n5, n3, n3, 
		-- z=-6, y=-1
		n3, n3, n3, n3, n3, n3, n3, 
		-- z=-6, y=0
		n3, n3, n3, n3, n3, n3, n3, 

		-- z=-5, y=-3
		n1, n6, n7, n8, n7, n9, n1, 
		-- z=-5, y=-2
		n3, n10, n11, n3, n11, n12, n3, 
		-- z=-5, y=-1
		n3, n3, n10, n13, n12, n3, n3, 
		-- z=-5, y=0
		n3, n3, n3, n3, n3, n3, n3, 

		-- z=-4, y=-3
		n1, n14, n8, n8, n15, n16, n1, 
		-- z=-4, y=-2
		n4, n17, n3, n3, n3, n18, n5, 
		-- z=-4, y=-1
		n3, n19, n3, n3, n3, n20, n3, 
		-- z=-4, y=0
		n3, n3, n21, n21, n21, n3, n3, 

		-- z=-3, y=-3
		n1, n14, n22, n23, n24, n25, n1, 
		-- z=-3, y=-2
		n19, n17, n3, n3, n3, n18, n20, 
		-- z=-3, y=-1
		n3, n19, n3, n3, n3, n20, n3, 
		-- z=-3, y=0
		n3, n3, n21, n26, n21, n3, n3, 

		-- z=-2, y=-3
		n1, n14, n27, n28, n29, n25, n1, 
		-- z=-2, y=-2
		n30, n17, n3, n3, n3, n18, n31, 
		-- z=-2, y=-1
		n3, n19, n3, n3, n3, n20, n3, 
		-- z=-2, y=0
		n3, n3, n21, n21, n21, n3, n3, 

		-- z=-1, y=-3
		n1, n32, n33, n33, n33, n34, n1, 
		-- z=-1, y=-2
		n3, n35, n36, n36, n36, n37, n3, 
		-- z=-1, y=-1
		n3, n3, n38, n38, n38, n3, n3, 
		-- z=-1, y=0
		n3, n3, n3, n3, n3, n3, n3, 

		-- z=0, y=-3
		n1, n1, n1, n1, n1, n1, n1, 
		-- z=0, y=-2
		n3, n3, n30, n38, n31, n3, n3, 
		-- z=0, y=-1
		n3, n3, n3, n3, n3, n3, n3, 
		-- z=0, y=0
		n3, n3, n3, n3, n3, n3, n3, 
}
}
