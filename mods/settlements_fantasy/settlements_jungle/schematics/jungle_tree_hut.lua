local branch_prob = 190

local n2 = { name = "default:ladder_wood", param2 = 4, force_place=true }
local n6 = { name = "stairs:stair_inner_junglewood", param2 = 3, force_place=true }
local n7 = { name = "stairs:stair_junglewood", param2 = 2, force_place=true }
local n8 = { name = "stairs:stair_inner_junglewood", param2 = 2, force_place=true }
local n9 = { name = "default:fence_junglewood", force_place=true }
local n10 = { name = "default:fence_rail_junglewood", force_place=true }
local n11 = { name = "stairs:stair_outer_junglewood", param2 = 22, force_place=true }
local n12 = { name = "stairs:slab_junglewood", param2 = 21, force_place=true }
local n13 = { name = "stairs:stair_junglewood", param2 = 22, force_place=true }
local n14 = { name = "stairs:stair_outer_junglewood", param2 = 23, force_place=true }
local n17 = { name = "default:jungletree", force_place=true }
local n19 = { name = "stairs:stair_junglewood", param2 = 3, force_place=true }
local n20 = { name = "stairs:slab_junglewood", param2 = 1, force_place=true }
local n21 = { name = "doors:trapdoor", force_place=true }
local n22 = { name = "stairs:stair_junglewood", param2 = 1, force_place=true }
local n26 = { name = "default:torch_wall", param2 = 2, force_place=true }
local n27 = { name = "stairs:stair_junglewood", param2 = 21, force_place=true }
local n29 = { name = "default:junglewood", force_place=true }
local n30 = { name = "beds:bed_bottom", param2 = 1, force_place=true }
local n31 = { name = "beds:bed_top", param2 = 1, force_place=true }
local n32 = { name = "stairs:stair_inner_junglewood", force_place=true }
local n33 = { name = "stairs:stair_junglewood", force_place=true }
local n34 = { name = "stairs:stair_inner_junglewood", param2 = 1, force_place=true }
local n35 = { name = "stairs:stair_outer_junglewood", param2 = 21, force_place=true }
local n36 = { name = "stairs:stair_junglewood", param2 = 20, force_place=true }
local n37 = { name = "stairs:stair_outer_junglewood", param2 = 20, force_place=true }
local n23 = { name = "air", force_place=true }

local n3 = { name = "default:jungleleaves", prob=222 }
local n15 = { name = "default:jungleleaves", prob=190 }
local n24 = { name = "default:jungletree", prob=126, force_place=true }

-- non-force-place
local n5 = { name = "default:jungleleaves" }
local n16 = { name = "default:jungletree" }

local n1 = { name = "air", prob=0 }

return {
	yslice_prob = {
		{ypos=0},
		{ypos=1},
		{ypos=2},
		{ypos=3},
		{ypos=4},
		{ypos=5},
		{ypos=6, prob=branch_prob},
		{ypos=7, prob=branch_prob},
		{ypos=8, prob=branch_prob},
		{ypos=9, prob=branch_prob},
		{ypos=10, prob=branch_prob},
		{ypos=11},
		{ypos=12},
		{ypos=13},
		{ypos=14},
		{ypos=15},
		{ypos=16},
	},
	size = {x = 5, y = 17, z = 5},
	data = {
		-- z=0, y=0
		n1, n1, n1, n1, n1, 
		-- z=0, y=1
		n1, n1, n2, n1, n1, 
		-- z=0, y=2
		n1, n1, n1, n1, n1, 
		-- z=0, y=3
		n1, n1, n1, n1, n1, 
		-- z=0, y=4
		n1, n1, n1, n1, n1, 
		-- z=0, y=5
		n1, n1, n1, n1, n1, 
		-- z=0, y=6
		n3, n5, n3, n1, n1, 
		-- z=0, y=7
		n1, n1, n3, n5, n3, 
		-- z=0, y=8
		n1, n1, n1, n1, n1, 
		-- z=0, y=9
		n1, n1, n1, n1, n1, 
		-- z=0, y=10
		n3, n5, n3, n1, n1, 
		-- z=0, y=11
		n6, n7, n7, n7, n8, 
		-- z=0, y=12
		n9, n10, n9, n10, n9, 
		-- z=0, y=13
		n11, n12, n13, n12, n14, 
		-- z=0, y=14
		n15, n3, n3, n3, n15, 
		-- z=0, y=15
		n15, n3, n3, n3, n15, 
		-- z=0, y=16
		n1, n1, n1, n1, n1, 

		-- z=1, y=0
		n1, n1, n16, n1, n1, 
		-- z=1, y=1
		n1, n1, n17, n1, n1, 
		-- z=1, y=2
		n1, n1, n2, n1, n1, 
		-- z=1, y=3
		n1, n1, n2, n1, n1, 
		-- z=1, y=4
		n1, n1, n2, n1, n1, 
		-- z=1, y=5
		n1, n1, n2, n1, n1, 
		-- z=1, y=6
		n5, n17, n2, n1, n1, 
		-- z=1, y=7
		n1, n1, n2, n17, n5, 
		-- z=1, y=8
		n1, n1, n2, n1, n1, 
		-- z=1, y=9
		n1, n1, n2, n1, n1, 
		-- z=1, y=10
		n5, n17, n2, n1, n1, 
		-- z=1, y=11
		n19, n20, n21, n20, n22, 
		-- z=1, y=12
		n10, n23, n23, n23, n10, 
		-- z=1, y=13
		n12, n12, n12, n12, n12, 
		-- z=1, y=14
		n3, n17, n5, n17, n3, 
		-- z=1, y=15
		n3, n5, n5, n5, n3, 
		-- z=1, y=16
		n1, n3, n3, n3, n1, 

		-- z=2, y=0
		n1, n16, n16, n16, n1, 
		-- z=2, y=1
		n1, n17, n17, n17, n1, 
		-- z=2, y=2
		n1, n24, n17, n24, n1, 
		-- z=2, y=3
		n1, n1, n17, n1, n1, 
		-- z=2, y=4
		n1, n1, n17, n1, n1, 
		-- z=2, y=5
		n1, n1, n17, n1, n1, 
		-- z=2, y=6
		n3, n5, n17, n1, n1, 
		-- z=2, y=7
		n1, n1, n17, n5, n3, 
		-- z=2, y=8
		n1, n1, n17, n5, n3, 
		-- z=2, y=9
		n3, n5, n17, n1, n1, 
		-- z=2, y=10
		n3, n5, n17, n1, n1, 
		-- z=2, y=11
		n19, n20, n17, n20, n22, 
		-- z=2, y=12
		n9, n26, n17, n23, n9, 
		-- z=2, y=13
		n27, n12, n17, n12, n27, 
		-- z=2, y=14
		n3, n5, n5, n5, n3, 
		-- z=2, y=15
		n3, n5, n5, n5, n3, 
		-- z=2, y=16
		n1, n3, n5, n3, n1, 

		-- z=3, y=0
		n1, n1, n16, n1, n1, 
		-- z=3, y=1
		n1, n1, n17, n1, n1, 
		-- z=3, y=2
		n1, n1, n24, n1, n1, 
		-- z=3, y=3
		n1, n1, n1, n1, n1, 
		-- z=3, y=4
		n1, n1, n1, n1, n1, 
		-- z=3, y=5
		n1, n1, n1, n1, n1, 
		-- z=3, y=6
		n1, n1, n1, n1, n1, 
		-- z=3, y=7
		n1, n1, n1, n1, n1, 
		-- z=3, y=8
		n1, n1, n5, n17, n5, 
		-- z=3, y=9
		n5, n17, n5, n1, n1, 
		-- z=3, y=10
		n1, n1, n1, n1, n1, 
		-- z=3, y=11
		n19, n20, n29, n29, n22, 
		-- z=3, y=12
		n10, n23, n30, n31, n10, 
		-- z=3, y=13
		n12, n12, n12, n12, n12, 
		-- z=3, y=14
		n3, n17, n5, n17, n3, 
		-- z=3, y=15
		n3, n5, n5, n5, n3, 
		-- z=3, y=16
		n1, n3, n3, n3, n1, 

		-- z=4, y=0
		n1, n1, n1, n1, n1, 
		-- z=4, y=1
		n1, n1, n1, n1, n1, 
		-- z=4, y=2
		n1, n1, n1, n1, n1, 
		-- z=4, y=3
		n1, n1, n1, n1, n1, 
		-- z=4, y=4
		n1, n1, n1, n1, n1, 
		-- z=4, y=5
		n1, n1, n1, n1, n1, 
		-- z=4, y=6
		n1, n1, n1, n1, n1, 
		-- z=4, y=7
		n1, n1, n1, n1, n1, 
		-- z=4, y=8
		n1, n1, n3, n5, n3, 
		-- z=4, y=9
		n3, n5, n3, n1, n1, 
		-- z=4, y=10
		n1, n1, n1, n1, n1, 
		-- z=4, y=11
		n32, n33, n33, n33, n34, 
		-- z=4, y=12
		n9, n10, n9, n10, n9, 
		-- z=4, y=13
		n35, n12, n36, n12, n37, 
		-- z=4, y=14
		n15, n3, n3, n3, n15, 
		-- z=4, y=15
		n15, n3, n3, n3, n15, 
		-- z=4, y=16
		n1, n1, n1, n1, n1, 
}
}
