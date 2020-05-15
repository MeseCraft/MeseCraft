local n1 = { name = "default:cobble" }
local n2 = { name = "default:cobble", prob=128 }
local n3 = { name = "default:gravel", prob=128 }
local n4 = { name = "stairs:stair_cobble", param2 = 1 }
local n5 = { name = "air", prob=0 }
local n6 = { name = "stairs:slab_cobble", param2 = 22, prob=128 }
local n7 = { name = "stairs:stair_cobble", param2 = 1, prob=128 }
local n8 = { name = "stairs:stair_cobble" }
local n9 = { name = "stairs:slab_cobble", param2 = 21, prob=128 }
local n10 = { name = "stairs:stair_cobble", param2 = 2, prob=128 }
local n11 = { name = "stairs:slab_cobble", param2 = 23, prob=128 }
local n12 = { name = "stairs:stair_cobble", param2 = 23 }
local n13 = { name = "stairs:stair_cobble", param2 = 3 }

return {
	yslice_prob = {
		{ypos=0},
		{ypos=1},
		{ypos=2},
		{ypos=3},
		{ypos=4},
		{ypos=5, prob=128},
		{ypos=6},		
	},
	size = {y = 7, x = 5, z = 5},
	data = {
		-- z=-4, y=0
		n1, n1, n1, n1, n1, 
		-- z=-4, y=1
		n1, n1, n1, n1, n1, 
		-- z=-4, y=2
		n1, n1, n1, n1, n1, 
		-- z=-4, y=3
		n1, n1, n1, n1, n1, 
		-- z=-4, y=4
		n1, n1, n1, n1, n1, 
		-- z=-4, y=5
		n1, n1, n1, n1, n1, 
		-- z=-4, y=6
		n2, n2, n2, n2, n2, 

		-- z=-3, y=0
		n1, n1, n1, n1, n1, 
		-- z=-3, y=1
		n1, n3, n4, n1, n1, 
		-- z=-3, y=2
		n1, n5, n5, n5, n1, 
		-- z=-3, y=3
		n1, n5, n5, n5, n1, 
		-- z=-3, y=4
		n1, n2, n6, n5, n1, 
		-- z=-3, y=5
		n1, n5, n7, n2, n1, 
		-- z=-3, y=6
		n2, n5, n5, n5, n2, 

		-- z=-2, y=0
		n1, n1, n1, n1, n1, 
		-- z=-2, y=1
		n5, n3, n3, n1, n1, 
		-- z=-2, y=2
		n5, n5, n5, n8, n1, 
		-- z=-2, y=3
		n1, n9, n5, n5, n1, 
		-- z=-2, y=4
		n1, n10, n5, n5, n2, 
		-- z=-2, y=5
		n1, n5, n5, n11, n1, 
		-- z=-2, y=6
		n2, n5, n5, n5, n2, 

		-- z=-1, y=0
		n1, n1, n1, n1, n1, 
		-- z=-1, y=1
		n1, n3, n1, n1, n1, 
		-- z=-1, y=2
		n1, n5, n1, n1, n1, 
		-- z=-1, y=3
		n1, n12, n13, n5, n1, 
		-- z=-1, y=4
		n1, n5, n5, n5, n1, 
		-- z=-1, y=5
		n1, n5, n5, n5, n1, 
		-- z=-1, y=6
		n2, n5, n5, n5, n2, 

		-- z=0, y=0
		n1, n1, n1, n1, n1, 
		-- z=0, y=1
		n1, n1, n1, n1, n1, 
		-- z=0, y=2
		n1, n1, n1, n1, n1, 
		-- z=0, y=3
		n1, n1, n1, n1, n1, 
		-- z=0, y=4
		n1, n1, n1, n1, n1, 
		-- z=0, y=5
		n1, n1, n1, n1, n1, 
		-- z=0, y=6
		n2, n2, n2, n2, n2, 
}
}
