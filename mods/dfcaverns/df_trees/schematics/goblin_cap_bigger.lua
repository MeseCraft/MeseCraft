local n1 = { name = "air", prob=0 }
local n3 = { name = "df_trees:goblin_cap" }
local n4 = { name = "df_trees:goblin_cap_gills" }
local n5 = { name = "df_trees:goblin_cap_stem" }

return {
	yslice_prob = {},
	size = {y = 10, x = 13, z = 13},
	center_pos = {x=6, y=2, z=6},
	data = {
		-- z=0, y=0
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=0, y=1
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=0, y=2
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=0, y=3
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=0, y=4
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=0, y=5
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=0, y=6
		n1, n1, n1, n1, n1, n1, n3, n1, n1, n1, n1, n1, n1, 
		-- z=0, y=7
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=0, y=8
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=0, y=9
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 

		-- z=1, y=0
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=1, y=1
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=1, y=2
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=1, y=3
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=1, y=4
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=1, y=5
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=1, y=6
		n1, n1, n1, n3, n3, n3, n4, n3, n3, n3, n1, n1, n1, 
		-- z=1, y=7
		n1, n1, n1, n1, n1, n1, n3, n1, n1, n1, n1, n1, n1, 
		-- z=1, y=8
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=1, y=9
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 

		-- z=2, y=0
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=2, y=1
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=2, y=2
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=2, y=3
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=2, y=4
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=2, y=5
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=2, y=6
		n1, n1, n3, n4, n4, n4, n4, n4, n4, n4, n3, n1, n1, 
		-- z=2, y=7
		n1, n1, n1, n3, n3, n3, n3, n3, n3, n3, n1, n1, n1, 
		-- z=2, y=8
		n1, n1, n1, n1, n1, n1, n3, n1, n1, n1, n1, n1, n1, 
		-- z=2, y=9
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 

		-- z=3, y=0
		n1, n1, n1, n1, n1, n5, n5, n5, n1, n1, n1, n1, n1, 
		-- z=3, y=1
		n1, n1, n1, n1, n1, n5, n5, n5, n1, n1, n1, n1, n1, 
		-- z=3, y=2
		n1, n1, n1, n1, n1, n5, n5, n5, n1, n1, n1, n1, n1, 
		-- z=3, y=3
		n1, n1, n1, n1, n1, n5, n5, n5, n1, n1, n1, n1, n1, 
		-- z=3, y=4
		n1, n1, n1, n1, n1, n5, n5, n5, n1, n1, n1, n1, n1, 
		-- z=3, y=5
		n1, n1, n1, n1, n1, n5, n5, n5, n1, n1, n1, n1, n1, 
		-- z=3, y=6
		n1, n3, n4, n4, n4, n4, n5, n4, n4, n4, n4, n3, n1, 
		-- z=3, y=7
		n1, n1, n3, n3, n3, n3, n3, n3, n3, n3, n3, n1, n1, 
		-- z=3, y=8
		n1, n1, n1, n1, n3, n3, n3, n3, n3, n1, n1, n1, n1, 
		-- z=3, y=9
		n1, n1, n1, n1, n1, n1, n3, n1, n1, n1, n1, n1, n1, 

		-- z=4, y=0
		n1, n1, n1, n1, n5, n5, n5, n5, n5, n1, n1, n1, n1, 
		-- z=4, y=1
		n1, n1, n1, n1, n5, n5, n5, n5, n5, n1, n1, n1, n1, 
		-- z=4, y=2
		n1, n1, n1, n1, n5, n5, n5, n5, n5, n1, n1, n1, n1, 
		-- z=4, y=3
		n1, n1, n1, n1, n5, n5, n5, n5, n5, n1, n1, n1, n1, 
		-- z=4, y=4
		n1, n1, n1, n1, n5, n5, n5, n5, n5, n1, n1, n1, n1, 
		-- z=4, y=5
		n1, n1, n1, n1, n5, n5, n5, n5, n5, n1, n1, n1, n1, 
		-- z=4, y=6
		n1, n3, n4, n4, n4, n5, n5, n5, n4, n4, n4, n3, n1, 
		-- z=4, y=7
		n1, n1, n3, n3, n3, n3, n3, n3, n3, n3, n3, n1, n1, 
		-- z=4, y=8
		n1, n1, n1, n3, n3, n3, n3, n3, n3, n3, n1, n1, n1, 
		-- z=4, y=9
		n1, n1, n1, n1, n3, n3, n3, n3, n3, n1, n1, n1, n1, 

		-- z=5, y=0
		n1, n1, n1, n5, n5, n5, n5, n5, n5, n5, n1, n1, n1, 
		-- z=5, y=1
		n1, n1, n1, n5, n5, n5, n5, n5, n5, n5, n1, n1, n1, 
		-- z=5, y=2
		n1, n1, n1, n5, n5, n5, n5, n5, n5, n5, n1, n1, n1, 
		-- z=5, y=3
		n1, n1, n1, n5, n5, n5, n5, n5, n5, n5, n1, n1, n1, 
		-- z=5, y=4
		n1, n1, n1, n5, n5, n5, n5, n5, n5, n5, n1, n1, n1, 
		-- z=5, y=5
		n1, n1, n1, n5, n5, n5, n5, n5, n5, n5, n1, n1, n1, 
		-- z=5, y=6
		n1, n3, n4, n4, n5, n5, n5, n5, n5, n4, n4, n3, n1, 
		-- z=5, y=7
		n1, n1, n3, n3, n3, n5, n5, n5, n3, n3, n3, n1, n1, 
		-- z=5, y=8
		n1, n1, n1, n3, n3, n3, n3, n3, n3, n3, n1, n1, n1, 
		-- z=5, y=9
		n1, n1, n1, n1, n3, n3, n3, n3, n3, n1, n1, n1, n1, 

		-- z=6, y=0
		n1, n1, n1, n5, n5, n5, n5, n5, n5, n5, n1, n1, n1, 
		-- z=6, y=1
		n1, n1, n1, n5, n5, n5, n5, n5, n5, n5, n1, n1, n1, 
		-- z=6, y=2
		n1, n1, n1, n5, n5, n5, n5, n5, n5, n5, n1, n1, n1, 
		-- z=6, y=3
		n1, n1, n1, n5, n5, n5, n5, n5, n5, n5, n1, n1, n1, 
		-- z=6, y=4
		n1, n1, n1, n5, n5, n5, n5, n5, n5, n5, n1, n1, n1, 
		-- z=6, y=5
		n1, n1, n1, n5, n5, n5, n5, n5, n5, n5, n1, n1, n1, 
		-- z=6, y=6
		n3, n4, n4, n5, n5, n5, n5, n5, n5, n5, n4, n4, n3, 
		-- z=6, y=7
		n1, n3, n3, n3, n3, n5, n5, n5, n3, n3, n3, n3, n1, 
		-- z=6, y=8
		n1, n1, n3, n3, n3, n3, n3, n3, n3, n3, n3, n1, n1, 
		-- z=6, y=9
		n1, n1, n1, n3, n3, n3, n3, n3, n3, n3, n1, n1, n1, 

		-- z=7, y=0
		n1, n1, n1, n5, n5, n5, n5, n5, n5, n5, n1, n1, n1, 
		-- z=7, y=1
		n1, n1, n1, n5, n5, n5, n5, n5, n5, n5, n1, n1, n1, 
		-- z=7, y=2
		n1, n1, n1, n5, n5, n5, n5, n5, n5, n5, n1, n1, n1, 
		-- z=7, y=3
		n1, n1, n1, n5, n5, n5, n5, n5, n5, n5, n1, n1, n1, 
		-- z=7, y=4
		n1, n1, n1, n5, n5, n5, n5, n5, n5, n5, n1, n1, n1, 
		-- z=7, y=5
		n1, n1, n1, n5, n5, n5, n5, n5, n5, n5, n1, n1, n1, 
		-- z=7, y=6
		n1, n3, n4, n4, n5, n5, n5, n5, n5, n4, n4, n3, n1, 
		-- z=7, y=7
		n1, n1, n3, n3, n3, n5, n5, n5, n3, n3, n3, n1, n1, 
		-- z=7, y=8
		n1, n1, n1, n3, n3, n3, n3, n3, n3, n3, n1, n1, n1, 
		-- z=7, y=9
		n1, n1, n1, n1, n3, n3, n3, n3, n3, n1, n1, n1, n1, 

		-- z=8, y=0
		n1, n1, n1, n1, n5, n5, n5, n5, n5, n1, n1, n1, n1, 
		-- z=8, y=1
		n1, n1, n1, n1, n5, n5, n5, n5, n5, n1, n1, n1, n1, 
		-- z=8, y=2
		n1, n1, n1, n1, n5, n5, n5, n5, n5, n1, n1, n1, n1, 
		-- z=8, y=3
		n1, n1, n1, n1, n5, n5, n5, n5, n5, n1, n1, n1, n1, 
		-- z=8, y=4
		n1, n1, n1, n1, n5, n5, n5, n5, n5, n1, n1, n1, n1, 
		-- z=8, y=5
		n1, n1, n1, n1, n5, n5, n5, n5, n5, n1, n1, n1, n1, 
		-- z=8, y=6
		n1, n3, n4, n4, n4, n5, n5, n5, n4, n4, n4, n3, n1, 
		-- z=8, y=7
		n1, n1, n3, n3, n3, n3, n3, n3, n3, n3, n3, n1, n1, 
		-- z=8, y=8
		n1, n1, n1, n3, n3, n3, n3, n3, n3, n3, n1, n1, n1, 
		-- z=8, y=9
		n1, n1, n1, n1, n3, n3, n3, n3, n3, n1, n1, n1, n1, 

		-- z=9, y=0
		n1, n1, n1, n1, n1, n5, n5, n5, n1, n1, n1, n1, n1, 
		-- z=9, y=1
		n1, n1, n1, n1, n1, n5, n5, n5, n1, n1, n1, n1, n1, 
		-- z=9, y=2
		n1, n1, n1, n1, n1, n5, n5, n5, n1, n1, n1, n1, n1, 
		-- z=9, y=3
		n1, n1, n1, n1, n1, n5, n5, n5, n1, n1, n1, n1, n1, 
		-- z=9, y=4
		n1, n1, n1, n1, n1, n5, n5, n5, n1, n1, n1, n1, n1, 
		-- z=9, y=5
		n1, n1, n1, n1, n1, n5, n5, n5, n1, n1, n1, n1, n1, 
		-- z=9, y=6
		n1, n3, n4, n4, n4, n4, n5, n4, n4, n4, n4, n3, n1, 
		-- z=9, y=7
		n1, n1, n3, n3, n3, n3, n3, n3, n3, n3, n3, n1, n1, 
		-- z=9, y=8
		n1, n1, n1, n1, n3, n3, n3, n3, n3, n1, n1, n1, n1, 
		-- z=9, y=9
		n1, n1, n1, n1, n1, n1, n3, n1, n1, n1, n1, n1, n1, 

		-- z=10, y=0
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=10, y=1
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=10, y=2
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=10, y=3
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=10, y=4
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=10, y=5
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=10, y=6
		n1, n1, n3, n4, n4, n4, n4, n4, n4, n3, n3, n1, n1, 
		-- z=10, y=7
		n1, n1, n1, n3, n3, n3, n3, n3, n3, n3, n1, n1, n1, 
		-- z=10, y=8
		n1, n1, n1, n1, n1, n1, n3, n1, n1, n1, n1, n1, n1, 
		-- z=10, y=9
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 

		-- z=11, y=0
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=11, y=1
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=11, y=2
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=11, y=3
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=11, y=4
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=11, y=5
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=11, y=6
		n1, n1, n1, n3, n3, n3, n3, n3, n3, n3, n1, n1, n1, 
		-- z=11, y=7
		n1, n1, n1, n1, n1, n1, n3, n1, n1, n1, n1, n1, n1, 
		-- z=11, y=8
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=11, y=9
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 

		-- z=12, y=0
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=12, y=1
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=12, y=2
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=12, y=3
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=12, y=4
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=12, y=5
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=12, y=6
		n1, n1, n1, n1, n1, n1, n3, n1, n1, n1, n1, n1, n1, 
		-- z=12, y=7
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=12, y=8
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=12, y=9
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
}
}
