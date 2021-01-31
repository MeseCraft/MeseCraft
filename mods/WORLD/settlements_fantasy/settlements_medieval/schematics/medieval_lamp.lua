local n1 = { name = "default:dirt_with_grass" }
local n2 = { name = "air" }
local n3 = { name = "stairs:stair_cobble" }
local n4 = { name = "stairs:stair_cobble", param2 = 20 }
local n5 = { name = "walls:cobble" }
local n6 = { name = "default:dirt" }
local n7 = { name = "stairs:stair_cobble", param2 = 1 }
local n8 = { name = "default:cobble" }
local n9 = { name = "stairs:stair_cobble", param2 = 3 }
local n10 = { name = "stairs:stair_cobble", param2 = 23 }
local n11 = { name = "default:coalblock" }
local n12 = { name = "stairs:stair_cobble", param2 = 21 }
local n13 = { name = "fire:permanent_flame" }
local n14 = { name = "stairs:slab_cobble" }
local n15 = { name = "stairs:stair_cobble", param2 = 2 }
local n16 = { name = "stairs:stair_cobble", param2 = 22 }

return {
	yslice_prob = {},
	size = {y = 7, x = 3, z = 3},
	data = {
		-- z=-2, y=-6
		n1, n1, n1, 
		-- z=-2, y=-5
		n2, n3, n2, 
		-- z=-2, y=-4
		n2, n2, n2, 
		-- z=-2, y=-3
		n2, n4, n2, 
		-- z=-2, y=-2
		n2, n5, n2, 
		-- z=-2, y=-1
		n2, n3, n2, 
		-- z=-2, y=0
		n2, n2, n2, 

		-- z=-1, y=-6
		n1, n6, n1, 
		-- z=-1, y=-5
		n7, n8, n9, 
		-- z=-1, y=-4
		n2, n8, n2, 
		-- z=-1, y=-3
		n10, n11, n12, 
		-- z=-1, y=-2
		n5, n13, n5, 
		-- z=-1, y=-1
		n7, n2, n9, 
		-- z=-1, y=0
		n2, n14, n2, 

		-- z=0, y=-6
		n1, n1, n1, 
		-- z=0, y=-5
		n2, n15, n2, 
		-- z=0, y=-4
		n2, n2, n2, 
		-- z=0, y=-3
		n2, n16, n2, 
		-- z=0, y=-2
		n2, n5, n2, 
		-- z=0, y=-1
		n2, n15, n2, 
		-- z=0, y=0
		n2, n2, n2, 
}
}
