local n1 = { name = "default:dirt_with_grass" }
local n2 = { name = "air" }
local n3 = { name = "stairs:stair_cobble" }
local n4 = { name = "stairs:stair_wood", param2 = 1 }
local n5 = { name = "stairs:stair_wood", param2 = 3 }
local n6 = { name = "stairs:slab_wood", param2 = 20 }
local n7 = { name = "default:dirt" }
local n8 = { name = "default:stone_block" }
local n9 = { name = "default:cobble" }
local n10 = { name = "default:junglewood" }
local n11 = { name = "doors:door_wood_a", param2 = 2 }
local n12 = { name = "doors:hidden", param2 = 2 }
local n13 = { name = "default:glass" }
local n14 = { name = "stairs:slab_wood" }
local n15 = { name = "stairs:stair_wood", param2 = 2 }
local n16 = { name = "stairs:slab_wood", param2 = 1 }
local n17 = { name = "stairs:stair_outer_wood", param2 = 1 }
local n18 = { name = "stairs:stair_wood" }
local n19 = { name = "stairs:stair_outer_wood" }
local n20 = { name = "stairs:stair_cobble", param2 = 21 }
local n21 = { name = "stairs:stair_cobble", param2 = 23 }
local n22 = { name = "stairs:stair_obsidian" }
local n23 = { name = "default:torch_wall", param2 = 4 }
local n24 = { name = "stairs:stair_outer_wood", param2 = 2 }
local n25 = { name = "stairs:stair_outer_wood", param2 = 3 }
local n26 = { name = "air" }

if minetest.get_modpath("bell") and minetest.registered_nodes["bell:bell"] then
	n26 = { name = "bell:bell" }
end


return {
	yslice_prob = {
		
	},
	size = {
		y = 13,
		x = 7,
		z = 10
	}
,
	data = {


		-- z=0, y=0
		n1, n1, n1, n1, n1, n1, n1, 
		-- z=0, y=1
		n2, n2, n2, n3, n2, n2, n2, 
		-- z=0, y=2
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=0, y=3
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=0, y=4
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=0, y=5
		n4, n2, n2, n2, n2, n2, n5, 
		-- z=0, y=6
		n2, n4, n2, n2, n2, n5, n2, 
		-- z=0, y=7
		n2, n2, n4, n6, n5, n2, n2, 
		-- z=0, y=8
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=0, y=9
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=0, y=10
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=0, y=11
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=0, y=12
		n2, n2, n2, n2, n2, n2, n2, 

		-- z=1, y=0
		n1, n7, n7, n7, n7, n7, n1, 
		-- z=1, y=1
		n2, n8, n9, n10, n9, n8, n2, 
		-- z=1, y=2
		n2, n8, n9, n11, n9, n8, n2, 
		-- z=1, y=3
		n2, n8, n9, n12, n9, n8, n2, 
		-- z=1, y=4
		n2, n8, n9, n9, n9, n8, n2, 
		-- z=1, y=5
		n4, n8, n9, n13, n9, n8, n5, 
		-- z=1, y=6
		n2, n4, n9, n9, n9, n5, n2, 
		-- z=1, y=7
		n2, n2, n4, n9, n5, n2, n2, 
		-- z=1, y=8
		n2, n2, n2, n14, n2, n2, n2, 
		-- z=1, y=9
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=1, y=10
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=1, y=11
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=1, y=12
		n2, n2, n2, n2, n2, n2, n2, 

		-- z=2, y=0
		n1, n7, n7, n7, n7, n7, n1, 
		-- z=2, y=1
		n2, n9, n10, n10, n10, n9, n2, 
		-- z=2, y=2
		n2, n9, n2, n2, n2, n9, n2, 
		-- z=2, y=3
		n2, n9, n2, n2, n2, n9, n2, 
		-- z=2, y=4
		n2, n9, n2, n2, n2, n9, n2, 
		-- z=2, y=5
		n4, n2, n2, n2, n2, n2, n5, 
		-- z=2, y=6
		n2, n4, n2, n2, n2, n5, n2, 
		-- z=2, y=7
		n2, n2, n4, n2, n5, n2, n2, 
		-- z=2, y=8
		n2, n2, n2, n14, n2, n2, n2, 
		-- z=2, y=9
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=2, y=10
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=2, y=11
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=2, y=12
		n2, n2, n2, n2, n2, n2, n2, 

		-- z=3, y=0
		n1, n7, n7, n7, n7, n7, n1, 
		-- z=3, y=1
		n2, n9, n10, n10, n10, n9, n2, 
		-- z=3, y=2
		n2, n9, n15, n2, n15, n9, n2, 
		-- z=3, y=3
		n2, n13, n2, n2, n2, n13, n2, 
		-- z=3, y=4
		n2, n9, n2, n2, n2, n9, n2, 
		-- z=3, y=5
		n4, n2, n2, n2, n2, n2, n5, 
		-- z=3, y=6
		n2, n4, n2, n2, n2, n5, n2, 
		-- z=3, y=7
		n2, n2, n4, n2, n5, n2, n2, 
		-- z=3, y=8
		n2, n2, n2, n14, n2, n2, n2, 
		-- z=3, y=9
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=3, y=10
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=3, y=11
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=3, y=12
		n2, n2, n2, n2, n2, n2, n2, 

		-- z=4, y=0
		n1, n7, n7, n7, n7, n7, n1, 
		-- z=4, y=1
		n2, n9, n10, n10, n10, n9, n2, 
		-- z=4, y=2
		n2, n9, n2, n2, n2, n9, n2, 
		-- z=4, y=3
		n2, n9, n2, n2, n2, n9, n2, 
		-- z=4, y=4
		n2, n9, n2, n2, n2, n9, n2, 
		-- z=4, y=5
		n4, n2, n2, n2, n2, n2, n5, 
		-- z=4, y=6
		n2, n4, n2, n2, n2, n5, n2, 
		-- z=4, y=7
		n2, n2, n4, n2, n5, n2, n2, 
		-- z=4, y=8
		n2, n2, n2, n16, n2, n2, n2, 
		-- z=4, y=9
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=4, y=10
		n17, n18, n18, n18, n18, n18, n19, 
		-- z=4, y=11
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=4, y=12
		n2, n2, n2, n2, n2, n2, n2, 

		-- z=5, y=0
		n1, n7, n7, n7, n7, n7, n1, 
		-- z=5, y=1
		n2, n9, n10, n10, n10, n9, n2, 
		-- z=5, y=2
		n2, n9, n15, n2, n15, n9, n2, 
		-- z=5, y=3
		n2, n13, n2, n2, n2, n13, n2, 
		-- z=5, y=4
		n2, n9, n2, n2, n2, n9, n2, 
		-- z=5, y=5
		n2, n8, n20, n2, n21, n8, n2, 
		-- z=5, y=6
		n2, n8, n9, n9, n9, n8, n2, 
		-- z=5, y=7
		n2, n8, n9, n9, n9, n8, n2, 
		-- z=5, y=8
		n2, n8, n9, n9, n9, n8, n2, 
		-- z=5, y=9
		n2, n8, n9, n9, n9, n8, n2, 
		-- z=5, y=10
		n4, n9, n9, n9, n9, n9, n5, 
		-- z=5, y=11
		n2, n17, n18, n18, n18, n19, n2, 
		-- z=5, y=12
		n2, n2, n2, n2, n2, n2, n2, 

		-- z=6, y=0
		n1, n7, n7, n7, n7, n7, n1, 
		-- z=6, y=1
		n2, n9, n10, n10, n10, n9, n2, 
		-- z=6, y=2
		n2, n9, n2, n2, n2, n9, n2, 
		-- z=6, y=3
		n2, n9, n2, n2, n2, n9, n2, 
		-- z=6, y=4
		n2, n9, n2, n2, n2, n9, n2, 
		-- z=6, y=5
		n2, n9, n2, n2, n2, n9, n2, 
		-- z=6, y=6
		n2, n9, n2, n2, n2, n9, n2, 
		-- z=6, y=7
		n2, n9, n2, n2, n2, n9, n2, 
		-- z=6, y=8
		n2, n9, n2, n2, n2, n9, n2, 
		-- z=6, y=9
		n2, n9, n2, n2, n2, n9, n2, 
		-- z=6, y=10
		n4, n9, n2, n2, n2, n9, n5, 
		-- z=6, y=11
		n2, n4, n2, n26, n2, n5, n2, 
		-- z=6, y=12
		n2, n2, n18, n18, n18, n2, n2, 

		-- z=7, y=0
		n1, n7, n7, n7, n7, n7, n1, 
		-- z=7, y=1
		n2, n9, n10, n10, n10, n9, n2, 
		-- z=7, y=2
		n2, n9, n2, n22, n2, n9, n2, 
		-- z=7, y=3
		n2, n9, n2, n2, n2, n9, n2, 
		-- z=7, y=4
		n2, n9, n23, n2, n23, n9, n2, 
		-- z=7, y=5
		n2, n9, n2, n2, n2, n9, n2, 
		-- z=7, y=6
		n2, n9, n2, n2, n2, n9, n2, 
		-- z=7, y=7
		n2, n9, n2, n2, n2, n9, n2, 
		-- z=7, y=8
		n2, n9, n2, n2, n2, n9, n2, 
		-- z=7, y=9
		n2, n9, n2, n2, n2, n9, n2, 
		-- z=7, y=10
		n4, n9, n2, n2, n2, n9, n5, 
		-- z=7, y=11
		n2, n4, n2, n2, n2, n5, n2, 
		-- z=7, y=12
		n2, n2, n15, n15, n15, n2, n2, 

		-- z=8, y=0
		n1, n7, n7, n7, n7, n7, n1, 
		-- z=8, y=1
		n2, n8, n9, n9, n9, n8, n2, 
		-- z=8, y=2
		n2, n8, n9, n9, n9, n8, n2, 
		-- z=8, y=3
		n2, n8, n9, n9, n9, n8, n2, 
		-- z=8, y=4
		n2, n8, n9, n13, n9, n8, n2, 
		-- z=8, y=5
		n2, n8, n13, n13, n13, n8, n2, 
		-- z=8, y=6
		n2, n8, n9, n13, n9, n8, n2, 
		-- z=8, y=7
		n2, n8, n9, n9, n9, n8, n2, 
		-- z=8, y=8
		n2, n8, n9, n9, n9, n8, n2, 
		-- z=8, y=9
		n2, n8, n9, n9, n9, n8, n2, 
		-- z=8, y=10
		n4, n9, n9, n9, n9, n9, n5, 
		-- z=8, y=11
		n2, n24, n15, n15, n15, n25, n2, 
		-- z=8, y=12
		n2, n2, n2, n2, n2, n2, n2, 

		-- z=9, y=0
		n1, n1, n1, n1, n1, n1, n1, 
		-- z=9, y=1
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=9, y=2
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=9, y=3
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=9, y=4
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=9, y=5
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=9, y=6
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=9, y=7
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=9, y=8
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=9, y=9
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=9, y=10
		n24, n15, n15, n15, n15, n15, n25, 
		-- z=9, y=11
		n2, n2, n2, n2, n2, n2, n2, 
		-- z=9, y=12
		n2, n2, n2, n2, n2, n2, n2, 
}
}
