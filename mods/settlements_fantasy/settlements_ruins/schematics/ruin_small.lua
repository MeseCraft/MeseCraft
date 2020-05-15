local n1 = { name = "default:cobble" }
local n2 = { name = "default:cobble", prob=128 }
local n3 = { name = "default:gravel", prob=128 }
local n4 = { name = "air", prob=0 }

return {
	yslice_prob = {
		{ypos=0},
		{ypos=1},
		{ypos=2, prob=128},
		{ypos=3},
	},
	size = {y = 4, x = 5, z = 5},
	data = {
		-- z=0, y=0
		n1, n1, n1, n1, n1, 
		-- z=0, y=1
		n1, n1, n1, n1, n1, 
		-- z=0, y=2
		n1, n1, n1, n1, n1, 
		-- z=0, y=3
		n2, n2, n2, n2, n2, 

		-- z=1, y=0
		n1, n1, n1, n1, n1, 
		-- z=1, y=1
		n1, n3, n3, n3, n1, 
		-- z=1, y=2
		n1, n4, n4, n4, n1, 
		-- z=1, y=3
		n2, n4, n4, n4, n2, 

		-- z=2, y=0
		n1, n1, n1, n1, n1, 
		-- z=2, y=1
		n1, n3, n3, n3, n3, 
		-- z=2, y=2
		n1, n4, n4, n4, n4, 
		-- z=2, y=3
		n2, n4, n4, n4, n4, 

		-- z=3, y=0
		n1, n1, n1, n1, n1, 
		-- z=3, y=1
		n1, n3, n3, n3, n1, 
		-- z=3, y=2
		n1, n4, n4, n4, n1, 
		-- z=3, y=3
		n2, n4, n4, n4, n2, 

		-- z=4, y=0
		n1, n1, n1, n1, n1, 
		-- z=4, y=1
		n1, n1, n1, n1, n1, 
		-- z=4, y=2
		n1, n1, n1, n1, n1, 
		-- z=4, y=3
		n2, n2, n2, n2, n2, 
}
}
