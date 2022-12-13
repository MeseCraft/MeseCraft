local n1 = { name = "default:dirt" }
local n2 = { name = "default:cobble" }
local n3 = { name = "walls:cobble" }
local n4 = { name = "air" }
local n5 = { name = "stairs:slab_cobble" }
local n6 = { name = "default:water_source" }
local n7 = { name = "default:ladder_wood", param2 = 2 }

return {
	yslice_prob = {
		
	},
	size = {
		y = 7,
		x = 5,
		z = 5
	}
,
	data = {


		-- z=0, y=0
		n1, n1, n1, n1, n1, 
		-- z=0, y=1
		n1, n1, n1, n1, n1, 
		-- z=0, y=2
		n2, n2, n2, n2, n2, 
		-- z=0, y=3
		n2, n3, n3, n3, n2, 
		-- z=0, y=4
		n3, n4, n4, n4, n3, 
		-- z=0, y=5
		n3, n4, n4, n4, n3, 
		-- z=0, y=6
		n5, n5, n5, n5, n5, 

		-- z=1, y=0
		n1, n6, n6, n6, n1, 
		-- z=1, y=1
		n1, n6, n6, n6, n1, 
		-- z=1, y=2
		n2, n4, n4, n4, n2, 
		-- z=1, y=3
		n3, n4, n4, n4, n3, 
		-- z=1, y=4
		n4, n4, n4, n4, n4, 
		-- z=1, y=5
		n4, n4, n4, n4, n4, 
		-- z=1, y=6
		n5, n5, n5, n5, n5, 

		-- z=2, y=0
		n1, n6, n6, n6, n1, 
		-- z=2, y=1
		n1, n6, n6, n6, n1, 
		-- z=2, y=2
		n2, n4, n4, n7, n2, 
		-- z=2, y=3
		n3, n4, n4, n4, n3, 
		-- z=2, y=4
		n4, n4, n4, n4, n4, 
		-- z=2, y=5
		n4, n4, n4, n4, n4, 
		-- z=2, y=6
		n5, n5, n5, n5, n5, 

		-- z=3, y=0
		n1, n6, n6, n6, n1, 
		-- z=3, y=1
		n1, n6, n6, n6, n1, 
		-- z=3, y=2
		n2, n4, n4, n4, n2, 
		-- z=3, y=3
		n3, n4, n4, n4, n3, 
		-- z=3, y=4
		n4, n4, n4, n4, n4, 
		-- z=3, y=5
		n4, n4, n4, n4, n4, 
		-- z=3, y=6
		n5, n5, n5, n5, n5, 

		-- z=4, y=0
		n1, n1, n1, n1, n1, 
		-- z=4, y=1
		n1, n1, n1, n1, n1, 
		-- z=4, y=2
		n2, n2, n2, n2, n2, 
		-- z=4, y=3
		n2, n3, n3, n3, n2, 
		-- z=4, y=4
		n3, n4, n4, n4, n3, 
		-- z=4, y=5
		n3, n4, n4, n4, n3, 
		-- z=4, y=6
		n5, n5, n5, n5, n5, 
}
}
