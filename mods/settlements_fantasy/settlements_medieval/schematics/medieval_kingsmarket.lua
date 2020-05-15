local n1 = { name = "default:dirt_with_grass" }
local n2 = { name = "air" }
local n3 = { name = "stairs:stair_wood" }
local n4 = { name = "default:dirt" }
local n5 = { name = "default:tree", param2 = 2 }
local n6 = { name = "default:cobble" }
local n7 = { name = "default:tree", param2 = 1 }
local n8 = { name = "xpanes:pane_flat", param2 = 2 }
local n9 = { name = "default:tree", param2 = 9 }
local n10 = { name = "default:tree", param2 = 18 }
local n11 = { name = "default:tree", param2 = 10 }
local n12 = { name = "stairs:stair_wood", param2 = 1 }
local n13 = { name = "xpanes:pane_flat" }
local n14 = { name = "stairs:stair_wood", param2 = 3 }
local n15 = { name = "stairs:slab_wood", param2 = 1 }
local n16 = { name = "default:junglewood" }
local n17 = { name = "vessels:shelf", param2 = 3 }
local n18 = { name = "default:chest", param2 = 1 }
local n19 = { name = "default:torch_wall", param2 = 5 }
local n20 = { name = "stairs:slab_junglewood", param2 = 21 }
local n21 = { name = "vessels:shelf", param2 = 1 }
local n22 = { name = "default:tree", param2 = 7 }
local n23 = { name = "stairs:stair_junglewood", param2 = 22 }
local n24 = { name = "default:fence_junglewood" }
local n25 = { name = "vessels:shelf", param2 = 2 }
local n26 = { name = "default:bookshelf", param2 = 2 }
local n27 = { name = "stairs:stair_inner_wood", param2 = 1 }
local n28 = { name = "stairs:stair_inner_wood" }
local n29 = { name = "default:bookshelf", param2 = 3 }
local n30 = { name = "xpanes:pane_flat", param2 = 1 }
local n32 = { name = "default:chest", param2 = 3 }
local n33 = { name = "default:torch_wall", param2 = 3 }
local n34 = { name = "default:bookshelf", param2 = 1 }
local n35 = { name = "stairs:stair_junglewood", param2 = 2 }
local n36 = { name = "stairs:slab_junglewood", param2 = 23 }
local n37 = { name = "default:tree", param2 = 12 }
local n38 = { name = "stairs:slab_wood" }
local n39 = { name = "default:torch_wall", param2 = 2 }
local n40 = { name = "stairs:stair_junglewood", param2 = 20 }
local n41 = { name = "stairs:stair_wood", param2 = 2 }
local n42 = { name = "doors:door_wood_a", param2 = 3 }
local n43 = { name = "default:chest", param2 = 1 }
local n44 = { name = "doors:hidden", param2 = 3 }
local n45 = { name = "doors:trapdoor", param2 = 12 }
local n46 = { name = "stairs:stair_junglewood", param2 = 1 }
local n47 = { name = "default:chest" }
local n48 = { name = "stairs:stair_inner_wood", param2 = 2 }
local n49 = { name = "stairs:stair_inner_wood", param2 = 3 }
local n50 = { name = "stairs:slab_wood", param2 = 3 }

if minetest.get_modpath("commoditymarket_fantasy") and minetest.registered_items["commoditymarket_fantasy:kings_market"] then
	n43 = { name = "commoditymarket_fantasy:kings_market", param2 = 1 }
end

if not minetest.get_modpath("vessels") then
	n17 = { name = "default:chest", param2 = 3 }
	n21 = { name = "default:chest", param2 = 1 }
	n25 = { name = "default:chest", param2 = 2 }
end

return {
	yslice_prob = {},
	size = {y = 10, x = 11, z = 11},
	data = {
		-- z=0, y=-9
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=0, y=-8
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
		-- z=0, y=-7
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
		-- z=0, y=-6
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
		-- z=0, y=-5
		n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, 
		-- z=0, y=-4
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
		-- z=0, y=-3
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
		-- z=0, y=-2
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
		-- z=0, y=-1
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
		-- z=0, y=0
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 

		-- z=1, y=-9
		n1, n4, n4, n4, n4, n4, n4, n4, n4, n4, n1, 
		-- z=1, y=-8
		n2, n5, n6, n6, n6, n6, n6, n6, n6, n7, n2, 
		-- z=1, y=-7
		n2, n5, n6, n8, n6, n6, n6, n8, n6, n7, n2, 
		-- z=1, y=-6
		n2, n5, n6, n6, n6, n6, n6, n6, n6, n7, n2, 
		-- z=1, y=-5
		n2, n9, n10, n10, n10, n10, n10, n10, n10, n11, n2, 
		-- z=1, y=-4
		n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, 
		-- z=1, y=-3
		n2, n2, n2, n2, n12, n13, n14, n2, n2, n2, n2, 
		-- z=1, y=-2
		n2, n2, n2, n2, n2, n15, n2, n2, n2, n2, n2, 
		-- z=1, y=-1
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
		-- z=1, y=0
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 

		-- z=2, y=-9
		n1, n4, n16, n16, n16, n16, n16, n16, n16, n4, n1, 
		-- z=2, y=-8
		n2, n6, n2, n2, n2, n17, n2, n2, n18, n6, n2, 
		-- z=2, y=-7
		n2, n6, n2, n2, n2, n2, n19, n2, n2, n6, n2, 
		-- z=2, y=-6
		n2, n6, n2, n2, n2, n20, n2, n2, n21, n6, n2, 
		-- z=2, y=-5
		n2, n9, n2, n2, n2, n16, n16, n16, n16, n22, n2, 
		-- z=2, y=-4
		n2, n6, n2, n23, n2, n24, n25, n23, n26, n6, n2, 
		-- z=2, y=-3
		n3, n3, n3, n3, n27, n2, n28, n3, n3, n3, n3, 
		-- z=2, y=-2
		n2, n2, n2, n2, n2, n15, n2, n2, n2, n2, n2, 
		-- z=2, y=-1
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
		-- z=2, y=0
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 

		-- z=3, y=-9
		n1, n4, n16, n16, n16, n16, n16, n16, n16, n4, n1, 
		-- z=3, y=-8
		n2, n6, n2, n2, n2, n29, n2, n2, n18, n6, n2, 
		-- z=3, y=-7
		n2, n30, n2, n2, n2, n2, n2, n2, n2, n6, n2, 
		-- z=3, y=-6
		n2, n6, n2, n2, n2, n20, n2, n2, n21, n6, n2, 
		-- z=3, y=-5
		n2, n9, n2, n2, n2, n16, n16, n16, n16, n22, n2, 
		-- z=3, y=-4
		n2, n6, n2, n2, n2, n24, n2, n2, n2, n6, n2, 
		-- z=3, y=-3
		n2, n6, n2, n23, n2, n2, n2, n23, n2, n6, n2, 
		-- z=3, y=-2
		n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, 
		-- z=3, y=-1
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
		-- z=3, y=0
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 

		-- z=4, y=-9
		n1, n4, n16, n16, n16, n16, n16, n16, n16, n4, n1, 
		-- z=4, y=-8
		n2, n6, n2, n2, n2, n32, n2, n2, n18, n6, n2, 
		-- z=4, y=-7
		n2, n6, n2, n2, n2, n2, n2, n2, n2, n6, n2, 
		-- z=4, y=-6
		n2, n6, n33, n2, n2, n20, n2, n2, n34, n6, n2, 
		-- z=4, y=-5
		n2, n9, n2, n2, n2, n16, n16, n16, n16, n22, n2, 
		-- z=4, y=-4
		n2, n6, n2, n2, n2, n24, n2, n2, n2, n6, n2, 
		-- z=4, y=-3
		n2, n6, n2, n2, n2, n2, n2, n2, n2, n6, n2, 
		-- z=4, y=-2
		n2, n6, n2, n23, n2, n2, n2, n23, n2, n6, n2, 
		-- z=4, y=-1
		n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, 
		-- z=4, y=0
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 

		-- z=5, y=-9
		n1, n4, n16, n16, n16, n16, n16, n16, n16, n4, n1, 
		-- z=5, y=-8
		n2, n6, n2, n2, n2, n17, n2, n2, n18, n6, n2, 
		-- z=5, y=-7
		n2, n30, n2, n2, n2, n2, n2, n2, n2, n6, n2, 
		-- z=5, y=-6
		n2, n6, n2, n2, n2, n20, n2, n2, n21, n6, n2, 
		-- z=5, y=-5
		n2, n9, n2, n2, n2, n16, n16, n16, n35, n22, n2, 
		-- z=5, y=-4
		n2, n6, n2, n2, n2, n24, n2, n2, n2, n6, n2, 
		-- z=5, y=-3
		n2, n30, n2, n2, n2, n2, n2, n2, n2, n30, n2, 
		-- z=5, y=-2
		n2, n6, n2, n36, n2, n2, n2, n36, n2, n6, n2, 
		-- z=5, y=-1
		n10, n37, n37, n37, n37, n37, n37, n37, n37, n37, n37, 
		-- z=5, y=0
		n38, n38, n38, n38, n38, n38, n38, n38, n38, n38, n38, 

		-- z=6, y=-9
		n1, n4, n16, n16, n16, n16, n16, n16, n16, n4, n1, 
		-- z=6, y=-8
		n2, n6, n2, n2, n2, n32, n2, n2, n18, n6, n2, 
		-- z=6, y=-7
		n2, n6, n2, n2, n2, n2, n2, n2, n2, n6, n2, 
		-- z=6, y=-6
		n2, n6, n33, n2, n2, n20, n2, n2, n35, n6, n2, 
		-- z=6, y=-5
		n2, n9, n2, n2, n2, n16, n16, n16, n2, n22, n2, 
		-- z=6, y=-4
		n2, n6, n2, n2, n2, n24, n2, n2, n2, n6, n2, 
		-- z=6, y=-3
		n2, n6, n2, n2, n2, n2, n2, n2, n39, n6, n2, 
		-- z=6, y=-2
		n2, n6, n2, n40, n2, n2, n2, n40, n2, n6, n2, 
		-- z=6, y=-1
		n41, n41, n41, n41, n41, n41, n41, n41, n41, n41, n41, 
		-- z=6, y=0
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 

		-- z=7, y=-9
		n1, n16, n16, n16, n16, n16, n16, n16, n16, n4, n1, 
		-- z=7, y=-8
		n2, n42, n2, n2, n2, n43, n2, n2, n2, n6, n2, 
		-- z=7, y=-7
		n2, n44, n2, n2, n2, n2, n2, n2, n35, n6, n2, 
		-- z=7, y=-6
		n2, n6, n2, n2, n2, n20, n2, n2, n2, n6, n2, 
		-- z=7, y=-5
		n2, n9, n2, n2, n2, n16, n16, n16, n2, n22, n2, 
		-- z=7, y=-4
		n2, n6, n2, n2, n2, n24, n2, n2, n2, n6, n2, 
		-- z=7, y=-3
		n2, n6, n2, n40, n2, n2, n2, n40, n2, n6, n2, 
		-- z=7, y=-2
		n41, n41, n41, n41, n41, n41, n41, n41, n41, n41, n41, 
		-- z=7, y=-1
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
		-- z=7, y=0
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 

		-- z=8, y=-9
		n1, n4, n16, n16, n16, n16, n16, n16, n16, n4, n1, 
		-- z=8, y=-8
		n2, n6, n2, n2, n2, n45, n2, n46, n36, n6, n2, 
		-- z=8, y=-7
		n2, n6, n2, n2, n2, n2, n2, n2, n2, n6, n2, 
		-- z=8, y=-6
		n2, n6, n2, n2, n2, n20, n2, n2, n2, n6, n2, 
		-- z=8, y=-5
		n2, n9, n2, n2, n2, n16, n16, n16, n2, n22, n2, 
		-- z=8, y=-4
		n2, n6, n2, n40, n2, n24, n47, n40, n2, n6, n2, 
		-- z=8, y=-3
		n41, n41, n41, n41, n48, n2, n49, n41, n41, n41, n41, 
		-- z=8, y=-2
		n2, n2, n2, n2, n2, n50, n2, n2, n2, n2, n2, 
		-- z=8, y=-1
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
		-- z=8, y=0
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 

		-- z=9, y=-9
		n1, n4, n4, n4, n4, n4, n4, n4, n4, n4, n1, 
		-- z=9, y=-8
		n2, n7, n6, n6, n6, n6, n6, n6, n6, n7, n2, 
		-- z=9, y=-7
		n2, n7, n6, n8, n6, n6, n6, n8, n6, n7, n2, 
		-- z=9, y=-6
		n2, n7, n6, n6, n6, n6, n6, n6, n6, n7, n2, 
		-- z=9, y=-5
		n2, n11, n10, n10, n10, n10, n10, n10, n10, n22, n2, 
		-- z=9, y=-4
		n41, n41, n41, n41, n41, n41, n41, n41, n41, n41, n41, 
		-- z=9, y=-3
		n2, n2, n2, n2, n12, n8, n14, n2, n2, n2, n2, 
		-- z=9, y=-2
		n2, n2, n2, n2, n2, n50, n2, n2, n2, n2, n2, 
		-- z=9, y=-1
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
		-- z=9, y=0
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 

		-- z=10, y=-9
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=10, y=-8
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
		-- z=10, y=-7
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
		-- z=10, y=-6
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
		-- z=10, y=-5
		n41, n41, n41, n41, n41, n41, n41, n41, n41, n41, n41, 
		-- z=10, y=-4
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
		-- z=10, y=-3
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
		-- z=10, y=-2
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
		-- z=10, y=-1
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
		-- z=10, y=0
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
}
}
