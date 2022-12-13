local n1 = { name = "default:dirt_with_grass" }
local n2 = { name = "air" }
local n3 = { name = "default:dirt" }
local n4 = { name = "stairs:stair_outer_mossycobble", param2 = 1 }
local n5 = { name = "stairs:stair_mossycobble" }
local n6 = { name = "stairs:stair_outer_mossycobble" }
local n7 = { name = "stairs:stair_mossycobble", param2 = 1 }
local n8 = { name = "farming:soil_wet" }
local n9 = { name = "stairs:stair_mossycobble", param2 = 3 }
local n10 = { name = "farming:wheat_3", param2 = 3 }
local n11 = { name = "farming:wheat_2", param2 = 3 }
local n12 = { name = "default:water_source" }
local n13 = { name = "farming:wheat_1", param2 = 3 }
local n14 = { name = "stairs:stair_outer_mossycobble", param2 = 2 }
local n15 = { name = "stairs:stair_mossycobble", param2 = 2 }
local n16 = { name = "stairs:stair_outer_mossycobble", param2 = 3 }

return {
	yslice_prob = {
		
	},
	size = {
		y = 3,
		x = 7,
		z = 7
	}
,
	data = {


		-- z=-6, y=-2
		n1, n1, n1, n1, n1, n1, n1, 
		-- z=-6, y=-1
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=-6, y=0
		n2, n2, n2, n2, n2, n2, n2, 

		-- z=-5, y=-2
		n3, n3, n3, n3, n3, n3, n3, 
		-- z=-5, y=-1
		n4, n5, n5, n5, n5, n5, n6, 
		-- z=-5, y=0
		n2, n2, n2, n2, n2, n2, n2, 

		-- z=-4, y=-2
		n3, n3, n3, n3, n3, n3, n3, 
		-- z=-4, y=-1
		n7, n8, n8, n8, n8, n8, n9, 
		-- z=-4, y=0
		n2, n10, n11, n10, n11, n10, n2, 

		-- z=-3, y=-2
		n3, n3, n3, n3, n3, n3, n3, 
		-- z=-3, y=-1
		n7, n8, n8, n12, n8, n8, n9, 
		-- z=-3, y=0
		n2, n11, n10, n2, n10, n11, n2, 

		-- z=-2, y=-2
		n3, n3, n3, n3, n3, n3, n3, 
		-- z=-2, y=-1
		n7, n8, n8, n8, n8, n8, n9, 
		-- z=-2, y=0
		n2, n13, n11, n10, n11, n13, n2, 

		-- z=-1, y=-2
		n3, n3, n3, n3, n3, n3, n3, 
		-- z=-1, y=-1
		n14, n15, n15, n15, n15, n15, n16, 
		-- z=-1, y=0
		n2, n2, n2, n2, n2, n2, n2, 

		-- z=0, y=-2
		n1, n1, n1, n1, n1, n1, n1, 
		-- z=0, y=-1
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=0, y=0
		n2, n2, n2, n2, n2, n2, n2, 
}
}
