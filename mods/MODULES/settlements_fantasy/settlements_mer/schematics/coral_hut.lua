local n1 = { name = "default:coral_skeleton" }
local n2 = { name = "default:coral_orange" }
local n3 = { name = "default:coral_orange", prob = 64 }
local n5 = { name = "default:water_source", prob = 0 }

return {
	yslice_prob = {},
	size = {y = 8, x = 5, z = 5},
	data = {
		-- z=-4, y=0
		n1, n1, n1, n1, n1, 
		-- z=-4, y=1
		n2, n2, n2, n2, n2, 
		-- z=-4, y=2
		n2, n2, n3, n2, n2, 
		-- z=-4, y=3
		n3, n2, n3, n2, n3, 
		-- z=-4, y=4
		n5, n3, n2, n3, n5, 
		-- z=-4, y=5
		n5, n5, n5, n5, n5, 
		-- z=-4, y=6
		n5, n5, n5, n5, n5, 
		-- z=-4, y=7
		n5, n5, n5, n5, n5, 

		-- z=-3, y=0
		n1, n1, n1, n1, n1, 
		-- z=-3, y=1
		n2, n5, n5, n5, n2, 
		-- z=-3, y=2
		n2, n5, n5, n5, n3, 
		-- z=-3, y=3
		n2, n5, n5, n5, n2, 
		-- z=-3, y=4
		n3, n2, n5, n2, n3, 
		-- z=-3, y=5
		n5, n2, n2, n2, n5, 
		-- z=-3, y=6
		n5, n2, n5, n2, n5, 
		-- z=-3, y=7
		n5, n3, n5, n3, n5, 

		-- z=-2, y=0
		n1, n1, n1, n1, n1, 
		-- z=-2, y=1
		n2, n5, n5, n5, n5, 
		-- z=-2, y=2
		n3, n5, n5, n5, n5, 
		-- z=-2, y=3
		n3, n5, n5, n5, n3, 
		-- z=-2, y=4
		n2, n5, n5, n5, n2, 
		-- z=-2, y=5
		n5, n2, n5, n2, n5, 
		-- z=-2, y=6
		n5, n5, n5, n5, n5, 
		-- z=-2, y=7
		n5, n5, n5, n5, n5, 

		-- z=-1, y=0
		n1, n1, n1, n1, n1, 
		-- z=-1, y=1
		n2, n5, n5, n5, n2, 
		-- z=-1, y=2
		n2, n5, n5, n5, n3, 
		-- z=-1, y=3
		n2, n5, n5, n5, n2, 
		-- z=-1, y=4
		n3, n2, n5, n2, n3, 
		-- z=-1, y=5
		n5, n2, n2, n2, n5, 
		-- z=-1, y=6
		n5, n2, n5, n2, n5, 
		-- z=-1, y=7
		n5, n3, n5, n3, n5, 

		-- z=0, y=0
		n1, n1, n1, n1, n1, 
		-- z=0, y=1
		n2, n2, n2, n2, n2, 
		-- z=0, y=2
		n2, n2, n3, n2, n2, 
		-- z=0, y=3
		n3, n2, n3, n2, n3, 
		-- z=0, y=4
		n5, n2, n2, n3, n5, 
		-- z=0, y=5
		n5, n5, n5, n5, n5, 
		-- z=0, y=6
		n5, n5, n5, n5, n5, 
		-- z=0, y=7
		n5, n5, n5, n5, n5, 
}
}
