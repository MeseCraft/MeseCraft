local branch_prob = 190

local n1 = { name = "air", force_place=true }
local n4 = { name = "stairs:stair_inner_junglewood", param2 = 3, force_place=true }
local n5 = { name = "stairs:stair_junglewood", param2 = 2, force_place=true }
local n6 = { name = "stairs:stair_inner_junglewood", param2 = 2, force_place=true }
local n7 = { name = "default:fence_junglewood", force_place=true }
local n8 = { name = "default:fence_rail_junglewood", force_place=true }
local n9 = { name = "stairs:stair_outer_junglewood", param2 = 22, force_place=true }
local n10 = { name = "stairs:slab_junglewood", param2 = 21, force_place=true }
local n11 = { name = "stairs:stair_junglewood", param2 = 22, force_place=true }
local n12 = { name = "stairs:stair_outer_junglewood", param2 = 23, force_place=true }
local n14 = { name = "default:jungletree", force_place=true }
local n15 = { name = "default:ladder_wood", param2 = 4, force_place=true }
local n17 = { name = "default:chest", param2 = 3, force_place=true }
local n18 = { name = "stairs:slab_junglewood", param2 = 1, force_place=true }
local n19 = { name = "stairs:stair_junglewood", param2 = 1, force_place=true }
local n20 = { name = "stairs:stair_junglewood", param2 = 3, force_place=true }
local n21 = { name = "doors:trapdoor", force_place=true }
local n22 = { name = "default:torch_wall", param2 = 2, force_place=true }
local n23 = { name = "stairs:stair_junglewood", param2 = 21, force_place=true }
local n24 = { name = "default:torch_wall", param2 = 3, force_place=true }
local n25 = { name = "stairs:stair_inner_junglewood", force_place=true }
local n26 = { name = "stairs:stair_junglewood", force_place=true }
local n27 = { name = "stairs:stair_inner_junglewood", param2 = 1, force_place=true }
local n28 = { name = "stairs:stair_outer_junglewood", param2 = 21, force_place=true }
local n29 = { name = "stairs:stair_junglewood", param2 = 20, force_place=true }
local n30 = { name = "stairs:stair_outer_junglewood", param2 = 20, force_place=true }
local n32 = { name = "stairs:slab_junglewood", param2 = 8, force_place=true }
local n33 = { name = "default:junglewood", force_place=true }
local n34 = { name = "beds:bed_bottom", param2 = 1, force_place=true }
local n35 = { name = "beds:bed_top", param2 = 1, force_place=true }

local n31 = { name = "air", prob = 0 }

local n2 = { name = "default:jungleleaves", prob=222 }
local n3 = { name = "default:jungleleaves" }
local n13 = { name = "default:jungleleaves", prob=190 }
local n16 = { name = "default:jungletree", prob=126, force_place=true }


return {
	yslice_prob = {
		{ypos=0},
		{ypos=1},
		{ypos=2},
		{ypos=3},
		{ypos=4},
		{ypos=5, prob=branch_prob},
		{ypos=6, prob=branch_prob},
		{ypos=7, prob=branch_prob},
		{ypos=8, prob=branch_prob},
		{ypos=9, prob=branch_prob},
		{ypos=10},
		{ypos=11},
		{ypos=12},
		{ypos=13},
		{ypos=14},
		{ypos=15},
	},
	size = {x = 11, y = 16, z = 12},
	data = {
		-- z=-11, y=0
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-11, y=1
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-11, y=2
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-11, y=3
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-11, y=4
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-11, y=5
		n2, n3, n2, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-11, y=6
		n1, n1, n2, n3, n2, n1, n1, n1, n1, n1, n1, 
		-- z=-11, y=7
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-11, y=8
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-11, y=9
		n2, n3, n2, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-11, y=10
		n4, n5, n5, n5, n6, n1, n1, n1, n1, n1, n1, 
		-- z=-11, y=11
		n7, n8, n7, n8, n7, n1, n1, n1, n1, n1, n1, 
		-- z=-11, y=12
		n9, n10, n11, n10, n12, n1, n1, n1, n1, n1, n1, 
		-- z=-11, y=13
		n13, n2, n2, n2, n13, n1, n1, n1, n1, n1, n1, 
		-- z=-11, y=14
		n13, n2, n2, n2, n13, n1, n1, n1, n1, n1, n1, 
		-- z=-11, y=15
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 

		-- z=-10, y=0
		n1, n1, n14, n1, n1, n1, n1, n1, n15, n1, n1, 
		-- z=-10, y=1
		n1, n1, n16, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-10, y=2
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-10, y=3
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-10, y=4
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-10, y=5
		n3, n14, n3, n1, n1, n1, n2, n3, n2, n1, n1, 
		-- z=-10, y=6
		n1, n1, n3, n14, n3, n1, n1, n1, n2, n3, n2, 
		-- z=-10, y=7
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-10, y=8
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-10, y=9
		n3, n14, n3, n1, n1, n1, n2, n3, n2, n1, n1, 
		-- z=-10, y=10
		n17, n18, n18, n18, n19, n1, n4, n5, n5, n5, n6, 
		-- z=-10, y=11
		n8, n1, n1, n1, n7, n8, n7, n8, n7, n8, n7, 
		-- z=-10, y=12
		n10, n10, n10, n10, n10, n1, n9, n10, n11, n10, n12, 
		-- z=-10, y=13
		n2, n14, n3, n14, n2, n1, n13, n2, n2, n2, n13, 
		-- z=-10, y=14
		n2, n3, n3, n3, n2, n1, n13, n2, n2, n2, n13, 
		-- z=-10, y=15
		n1, n2, n2, n2, n1, n1, n1, n1, n1, n1, n1, 

		-- z=-9, y=0
		n1, n14, n14, n14, n1, n1, n1, n1, n14, n1, n1, 
		-- z=-9, y=1
		n1, n16, n14, n16, n1, n1, n1, n1, n15, n1, n1, 
		-- z=-9, y=2
		n1, n1, n14, n1, n1, n1, n1, n1, n15, n1, n1, 
		-- z=-9, y=3
		n1, n1, n14, n1, n1, n1, n1, n1, n15, n1, n1, 
		-- z=-9, y=4
		n1, n1, n14, n1, n1, n1, n1, n1, n15, n1, n1, 
		-- z=-9, y=5
		n2, n3, n14, n1, n1, n1, n3, n14, n15, n1, n1, 
		-- z=-9, y=6
		n1, n1, n14, n3, n2, n1, n1, n1, n15, n14, n3, 
		-- z=-9, y=7
		n1, n1, n14, n3, n2, n1, n1, n1, n15, n1, n1, 
		-- z=-9, y=8
		n2, n3, n14, n1, n1, n1, n1, n1, n15, n1, n1, 
		-- z=-9, y=9
		n2, n3, n14, n1, n1, n1, n3, n14, n15, n1, n1, 
		-- z=-9, y=10
		n20, n18, n14, n18, n18, n18, n18, n18, n21, n18, n19, 
		-- z=-9, y=11
		n7, n22, n14, n1, n1, n1, n1, n1, n1, n1, n8, 
		-- z=-9, y=12
		n23, n10, n14, n10, n10, n1, n10, n10, n10, n10, n10, 
		-- z=-9, y=13
		n2, n3, n3, n3, n2, n1, n2, n14, n3, n14, n2, 
		-- z=-9, y=14
		n2, n3, n3, n3, n2, n1, n2, n3, n3, n3, n2, 
		-- z=-9, y=15
		n1, n2, n3, n2, n1, n1, n1, n2, n2, n2, n1, 

		-- z=-8, y=0
		n1, n1, n14, n1, n1, n1, n1, n14, n14, n14, n1, 
		-- z=-8, y=1
		n1, n1, n16, n1, n1, n1, n1, n16, n14, n16, n1, 
		-- z=-8, y=2
		n1, n1, n1, n1, n1, n1, n1, n1, n14, n1, n1, 
		-- z=-8, y=3
		n1, n1, n1, n1, n1, n1, n1, n1, n14, n1, n1, 
		-- z=-8, y=4
		n1, n1, n1, n1, n1, n1, n1, n1, n14, n1, n1, 
		-- z=-8, y=5
		n1, n1, n1, n1, n1, n1, n2, n3, n14, n1, n1, 
		-- z=-8, y=6
		n1, n1, n1, n1, n1, n1, n1, n1, n14, n3, n2, 
		-- z=-8, y=7
		n1, n1, n3, n14, n3, n1, n1, n1, n14, n3, n2, 
		-- z=-8, y=8
		n3, n14, n3, n1, n1, n1, n2, n3, n14, n1, n1, 
		-- z=-8, y=9
		n1, n1, n1, n1, n1, n1, n2, n3, n14, n1, n1, 
		-- z=-8, y=10
		n17, n18, n18, n18, n19, n1, n20, n18, n14, n18, n19, 
		-- z=-8, y=11
		n8, n1, n1, n1, n7, n8, n7, n1, n14, n24, n7, 
		-- z=-8, y=12
		n10, n10, n10, n10, n10, n1, n10, n10, n14, n10, n23, 
		-- z=-8, y=13
		n2, n14, n3, n14, n2, n1, n2, n3, n3, n3, n2, 
		-- z=-8, y=14
		n2, n3, n3, n3, n2, n1, n2, n3, n3, n3, n2, 
		-- z=-8, y=15
		n1, n2, n2, n2, n1, n1, n1, n2, n3, n2, n1, 

		-- z=-7, y=0
		n1, n1, n1, n1, n1, n1, n1, n1, n14, n1, n1, 
		-- z=-7, y=1
		n1, n1, n1, n1, n1, n1, n1, n1, n16, n1, n1, 
		-- z=-7, y=2
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-7, y=3
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-7, y=4
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-7, y=5
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-7, y=6
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-7, y=7
		n1, n1, n2, n3, n2, n1, n1, n1, n3, n14, n3, 
		-- z=-7, y=8
		n2, n3, n2, n1, n1, n1, n3, n14, n3, n1, n1, 
		-- z=-7, y=9
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-7, y=10
		n25, n26, n26, n26, n27, n1, n20, n18, n18, n18, n19, 
		-- z=-7, y=11
		n7, n8, n7, n8, n7, n1, n8, n1, n1, n1, n8, 
		-- z=-7, y=12
		n28, n10, n29, n10, n30, n1, n10, n10, n10, n10, n10, 
		-- z=-7, y=13
		n13, n2, n2, n2, n13, n1, n2, n14, n3, n14, n2, 
		-- z=-7, y=14
		n13, n2, n2, n2, n13, n1, n2, n3, n3, n3, n2, 
		-- z=-7, y=15
		n1, n1, n1, n1, n1, n1, n1, n2, n2, n2, n1, 

		-- z=-6, y=0
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-6, y=1
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-6, y=2
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-6, y=3
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-6, y=4
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-6, y=5
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-6, y=6
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-6, y=7
		n1, n1, n1, n1, n1, n1, n1, n1, n2, n3, n2, 
		-- z=-6, y=8
		n1, n1, n1, n1, n1, n1, n2, n3, n2, n1, n1, 
		-- z=-6, y=9
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-6, y=10
		n1, n1, n1, n1, n1, n1, n25, n18, n26, n26, n27, 
		-- z=-6, y=11
		n1, n1, n1, n1, n1, n1, n7, n1, n7, n8, n7, 
		-- z=-6, y=12
		n1, n1, n1, n1, n1, n1, n28, n10, n29, n10, n30, 
		-- z=-6, y=13
		n1, n1, n1, n1, n1, n1, n13, n2, n2, n2, n13, 
		-- z=-6, y=14
		n1, n1, n1, n1, n1, n1, n13, n1, n2, n2, n13, 
		-- z=-6, y=15
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 

		-- z=-5, y=0
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-5, y=1
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-5, y=2
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-5, y=3
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-5, y=4
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-5, y=5
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-5, y=6
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-5, y=7
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-5, y=8
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-5, y=9
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-5, y=10
		n31, n31, n31, n1, n1, n1, n1, n18, n1, n1, n1, 
		-- z=-5, y=11
		n31, n31, n31, n1, n1, n1, n8, n1, n8, n1, n1, 
		-- z=-5, y=12
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-5, y=13
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-5, y=14
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=-5, y=15
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n1, 

		-- z=-4, y=0
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=-4, y=1
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=-4, y=2
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=-4, y=3
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=-4, y=4
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=-4, y=5
		n31, n31, n31, n1, n2, n3, n2, n1, n1, n1, n31, 
		-- z=-4, y=6
		n31, n31, n31, n1, n1, n1, n2, n3, n2, n1, n31, 
		-- z=-4, y=7
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=-4, y=8
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=-4, y=9
		n31, n31, n31, n1, n2, n3, n2, n1, n1, n1, n31, 
		-- z=-4, y=10
		n31, n31, n31, n1, n4, n5, n5, n18, n6, n1, n31, 
		-- z=-4, y=11
		n31, n31, n31, n1, n7, n8, n7, n1, n7, n1, n31, 
		-- z=-4, y=12
		n31, n31, n31, n1, n9, n10, n11, n10, n12, n1, n31, 
		-- z=-4, y=13
		n31, n31, n31, n1, n13, n2, n2, n2, n13, n1, n31, 
		-- z=-4, y=14
		n31, n31, n31, n1, n13, n2, n2, n2, n13, n1, n31, 
		-- z=-4, y=15
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 

		-- z=-3, y=0
		n31, n31, n31, n1, n1, n1, n14, n1, n1, n1, n31, 
		-- z=-3, y=1
		n31, n31, n31, n1, n1, n1, n16, n1, n1, n1, n31, 
		-- z=-3, y=2
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=-3, y=3
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=-3, y=4
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=-3, y=5
		n31, n31, n31, n1, n3, n14, n3, n1, n1, n1, n31, 
		-- z=-3, y=6
		n31, n31, n31, n1, n1, n1, n3, n14, n3, n1, n31, 
		-- z=-3, y=7
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=-3, y=8
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=-3, y=9
		n31, n31, n31, n1, n3, n14, n3, n1, n1, n1, n31, 
		-- z=-3, y=10
		n31, n31, n31, n1, n20, n18, n18, n18, n19, n1, n31, 
		-- z=-3, y=11
		n31, n31, n31, n1, n8, n1, n1, n1, n8, n1, n31, 
		-- z=-3, y=12
		n31, n31, n31, n1, n10, n10, n10, n10, n10, n1, n31, 
		-- z=-3, y=13
		n31, n31, n31, n1, n2, n14, n3, n14, n2, n1, n31, 
		-- z=-3, y=14
		n31, n31, n31, n1, n2, n3, n3, n3, n2, n1, n31, 
		-- z=-3, y=15
		n31, n31, n31, n1, n1, n2, n2, n2, n1, n1, n31, 

		-- z=-2, y=0
		n31, n31, n31, n1, n1, n14, n14, n14, n1, n1, n31, 
		-- z=-2, y=1
		n31, n31, n31, n1, n1, n16, n14, n16, n1, n1, n31, 
		-- z=-2, y=2
		n31, n31, n31, n1, n1, n1, n14, n1, n1, n1, n31, 
		-- z=-2, y=3
		n31, n31, n31, n1, n1, n1, n14, n1, n1, n1, n31, 
		-- z=-2, y=4
		n31, n31, n31, n1, n1, n1, n14, n1, n1, n1, n31, 
		-- z=-2, y=5
		n31, n31, n31, n1, n2, n3, n14, n1, n1, n1, n31, 
		-- z=-2, y=6
		n31, n31, n31, n1, n1, n1, n14, n3, n2, n1, n31, 
		-- z=-2, y=7
		n31, n31, n31, n1, n1, n1, n14, n3, n2, n1, n31, 
		-- z=-2, y=8
		n31, n31, n31, n1, n2, n3, n14, n1, n1, n1, n31, 
		-- z=-2, y=9
		n31, n31, n31, n1, n2, n3, n14, n1, n1, n1, n31, 
		-- z=-2, y=10
		n31, n31, n31, n1, n20, n18, n14, n26, n19, n1, n31, 
		-- z=-2, y=11
		n31, n31, n31, n1, n7, n22, n14, n32, n7, n1, n31, 
		-- z=-2, y=12
		n31, n31, n31, n1, n23, n10, n14, n29, n29, n1, n31, 
		-- z=-2, y=13
		n31, n31, n31, n1, n2, n3, n3, n3, n2, n1, n31, 
		-- z=-2, y=14
		n31, n31, n31, n1, n2, n3, n3, n3, n2, n1, n31, 
		-- z=-2, y=15
		n31, n31, n31, n1, n1, n2, n3, n2, n1, n1, n31, 

		-- z=-1, y=0
		n31, n31, n31, n1, n1, n1, n14, n1, n1, n1, n31, 
		-- z=-1, y=1
		n31, n31, n31, n1, n1, n1, n16, n1, n1, n1, n31, 
		-- z=-1, y=2
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=-1, y=3
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=-1, y=4
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=-1, y=5
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=-1, y=6
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=-1, y=7
		n31, n31, n31, n1, n1, n1, n3, n14, n3, n1, n31, 
		-- z=-1, y=8
		n31, n31, n31, n1, n3, n14, n3, n1, n1, n1, n31, 
		-- z=-1, y=9
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=-1, y=10
		n31, n31, n31, n1, n20, n18, n33, n33, n19, n1, n31, 
		-- z=-1, y=11
		n31, n31, n31, n1, n8, n1, n34, n35, n8, n1, n31, 
		-- z=-1, y=12
		n31, n31, n31, n1, n10, n10, n10, n10, n10, n1, n31, 
		-- z=-1, y=13
		n31, n31, n31, n1, n2, n14, n3, n14, n2, n1, n31, 
		-- z=-1, y=14
		n31, n31, n31, n1, n2, n3, n3, n3, n2, n1, n31, 
		-- z=-1, y=15
		n31, n31, n31, n1, n1, n2, n2, n2, n1, n1, n31, 

		-- z=0, y=0
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=0, y=1
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=0, y=2
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=0, y=3
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=0, y=4
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=0, y=5
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=0, y=6
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=0, y=7
		n31, n31, n31, n1, n1, n1, n2, n3, n2, n1, n31, 
		-- z=0, y=8
		n31, n31, n31, n1, n2, n3, n2, n1, n1, n1, n31, 
		-- z=0, y=9
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
		-- z=0, y=10
		n31, n31, n31, n1, n25, n26, n26, n26, n27, n1, n31, 
		-- z=0, y=11
		n31, n31, n31, n1, n7, n8, n7, n8, n7, n1, n31, 
		-- z=0, y=12
		n31, n31, n31, n1, n28, n10, n29, n10, n30, n1, n31, 
		-- z=0, y=13
		n31, n31, n31, n1, n13, n2, n2, n2, n13, n1, n31, 
		-- z=0, y=14
		n31, n31, n31, n1, n13, n2, n2, n2, n13, n1, n31, 
		-- z=0, y=15
		n31, n31, n31, n1, n1, n1, n1, n1, n1, n1, n31, 
}
}
