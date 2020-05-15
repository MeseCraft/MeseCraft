local n1 = { name = "default:coral_skeleton" }
local n3 = { name = "default:coral_orange" }
local n4 = { name = "default:water_source", prob = 0}
local n5 = { name = "default:coral_orange", prob = 64}

return {
	yslice_prob = {},
	size = {y = 8, x = 7, z = 7},
	data = {
		-- z=0, y=-7
		n1, n1, n1, n1, n1, n1, n1, 
		-- z=0, y=-6
		n4, n4, n3, n3, n3, n3, n4, 
		-- z=0, y=-5
		n4, n4, n3, n5, n5, n3, n4, 
		-- z=0, y=-4
		n4, n4, n3, n5, n5, n3, n4, 
		-- z=0, y=-3
		n4, n4, n4, n3, n3, n4, n4, 
		-- z=0, y=-2
		n4, n4, n4, n4, n4, n4, n4, 
		-- z=0, y=-1
		n4, n4, n4, n4, n4, n4, n4, 
		-- z=0, y=0
		n4, n4, n4, n4, n4, n4, n4, 

		-- z=1, y=-7
		n1, n1, n1, n1, n1, n1, n1, 
		-- z=1, y=-6
		n4, n3, n4, n4, n4, n4, n3, 
		-- z=1, y=-5
		n4, n5, n4, n4, n4, n4, n3, 
		-- z=1, y=-4
		n4, n5, n3, n4, n4, n4, n3, 
		-- z=1, y=-3
		n4, n4, n3, n4, n4, n3, n4, 
		-- z=1, y=-2
		n4, n4, n4, n3, n3, n4, n4, 
		-- z=1, y=-1
		n4, n4, n4, n3, n4, n4, n4, 
		-- z=1, y=0
		n4, n4, n4, n5, n4, n4, n4, 

		-- z=2, y=-7
		n1, n1, n1, n1, n1, n1, n1, 
		-- z=2, y=-6
		n3, n4, n4, n4, n4, n4, n5, 
		-- z=2, y=-5
		n3, n4, n4, n4, n4, n4, n5, 
		-- z=2, y=-4
		n3, n3, n4, n4, n4, n4, n3, 
		-- z=2, y=-3
		n4, n3, n4, n4, n4, n4, n3, 
		-- z=2, y=-2
		n4, n5, n3, n3, n3, n3, n4, 
		-- z=2, y=-1
		n4, n4, n4, n4, n4, n3, n4, 
		-- z=2, y=0
		n4, n4, n4, n4, n4, n5, n4, 

		-- z=3, y=-7
		n1, n1, n1, n1, n1, n1, n1, 
		-- z=3, y=-6
		n3, n4, n4, n4, n4, n4, n4, 
		-- z=3, y=-5
		n5, n4, n4, n4, n4, n4, n4, 
		-- z=3, y=-4
		n5, n4, n4, n4, n4, n4, n5, 
		-- z=3, y=-3
		n4, n5, n4, n4, n4, n4, n3, 
		-- z=3, y=-2
		n4, n4, n3, n4, n5, n3, n4, 
		-- z=3, y=-1
		n4, n4, n3, n4, n4, n4, n4, 
		-- z=3, y=0
		n4, n4, n5, n4, n4, n4, n4, 

		-- z=4, y=-7
		n1, n1, n1, n1, n1, n1, n1, 
		-- z=4, y=-6
		n3, n4, n4, n4, n4, n4, n5, 
		-- z=4, y=-5
		n3, n4, n4, n4, n4, n4, n5, 
		-- z=4, y=-4
		n3, n3, n4, n4, n4, n4, n3, 
		-- z=4, y=-3
		n4, n3, n4, n4, n4, n4, n3, 
		-- z=4, y=-2
		n4, n5, n3, n3, n3, n3, n4, 
		-- z=4, y=-1
		n4, n4, n4, n4, n4, n3, n4, 
		-- z=4, y=0
		n4, n4, n4, n4, n4, n5, n4, 

		-- z=5, y=-7
		n1, n1, n1, n1, n1, n1, n1, 
		-- z=5, y=-6
		n4, n3, n4, n4, n4, n4, n3, 
		-- z=5, y=-5
		n4, n5, n4, n4, n4, n4, n3, 
		-- z=5, y=-4
		n4, n5, n3, n4, n4, n4, n3, 
		-- z=5, y=-3
		n4, n4, n3, n4, n4, n3, n4, 
		-- z=5, y=-2
		n4, n4, n4, n3, n3, n4, n4, 
		-- z=5, y=-1
		n4, n4, n4, n3, n4, n4, n4, 
		-- z=5, y=0
		n4, n4, n4, n5, n4, n4, n4, 

		-- z=6, y=-7
		n1, n1, n1, n1, n1, n1, n1, 
		-- z=6, y=-6
		n4, n4, n3, n3, n3, n3, n4, 
		-- z=6, y=-5
		n4, n4, n3, n5, n5, n3, n4, 
		-- z=6, y=-4
		n4, n4, n3, n5, n5, n3, n4, 
		-- z=6, y=-3
		n4, n4, n4, n3, n3, n4, n4, 
		-- z=6, y=-2
		n4, n4, n4, n4, n4, n4, n4, 
		-- z=6, y=-1
		n4, n4, n4, n4, n4, n4, n4, 
		-- z=6, y=0
		n4, n4, n4, n4, n4, n4, n4, 
}
}
