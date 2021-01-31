local n1 = { name = "default:dirt_with_grass" }
local n2 = { name = "air" }
local n3 = { name = "air", param2 = 240 }
local n4 = { name = "default:desert_sandstone_brick" }
local n5 = { name = "stairs:stair_desert_sandstone_brick", param2 = 16 }
local n6 = { name = "stairs:stair_desert_sandstone_brick", param2 = 12 }
local n7 = { name = "stairs:stair_desert_sandstone_brick" }
local n8 = { name = "stairs:slab_desert_sandstone_brick", param2 = 8 }
local n9 = { name = "default:chest", param2 = 1 }
local n10 = { name = "default:torch_wall", param2 = 5 }
local n11 = { name = "stairs:stair_desert_sandstone_brick", param2 = 1 }
local n12 = { name = "stairs:slab_wood", param2 = 21 }
local n13 = { name = "stairs:slab_wood", param2 = 23 }
local n14 = { name = "stairs:slab_desert_sandstone_brick", param2 = 22 }
local n15 = { name = "stairs:stair_desert_sandstone_brick", param2 = 3 }
local n16 = { name = "stairs:slab_desert_sandstone_brick", param2 = 17 }
local n17 = { name = "stairs:slab_desert_sandstone_brick", param2 = 15 }
local n18 = { name = "default:chest", param2 = 2 }
local n19 = { name = "default:chest", param2 = 2 }
local n20 = { name = "stairs:stair_desert_sandstone_brick", param2 = 18 }
local n21 = { name = "doors:door_wood_a", param2 = 2 }
local n22 = { name = "doors:hidden", param2 = 2 }
local n23 = { name = "stairs:slab_desert_sandstone_brick", param2 = 19 }
local n24 = { name = "default:torch_wall", param2 = 3 }
local n25 = { name = "stairs:stair_desert_sandstone_brick", param2 = 22 }
local n26 = { name = "stairs:stair_desert_sandstone_brick", param2 = 20 }
local n27 = { name = "doors:door_wood_a" }
local n28 = { name = "doors:hidden" }
local n29 = { name = "default:ladder_wood", param2 = 3 }
local n30 = { name = "default:chest" }
local n31 = { name = "stairs:stair_desert_sandstone_brick", param2 = 11 }
local n32 = { name = "doors:trapdoor", param2 = 3 }
local n33 = { name = "default:bookshelf", param2 = 3 }
local n34 = { name = "default:torch_wall", param2 = 4 }
local n35 = { name = "stairs:slab_wood", param2 = 20 }
local n36 = { name = "stairs:stair_desert_sandstone_brick", param2 = 5 }
local n37 = { name = "stairs:stair_desert_sandstone_brick", param2 = 14 }
local n38 = { name = "stairs:stair_desert_sandstone_brick", param2 = 2 }
local n39 = { name = "stairs:slab_desert_sandstone_brick", param2 = 6 }

if minetest.get_modpath("commoditymarket_fantasy") then
	if minetest.registered_items["commoditymarket_fantasy:kings_market"] then
		n30 = { name = "commoditymarket_fantasy:kings_market", param2 = 0 }
	end
	if minetest.registered_items["commoditymarket_fantasy:night_market"] then
		n18 = { name = "commoditymarket_fantasy:night_market", param2 = 2 }
	end
end

return {
	yslice_prob = {
		
	},
	size = {
		y = 5,
		x = 12,
		z = 12
	}
,
	data = {


		-- z=0, y=0
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=0, y=1
		n2, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, 
		-- z=0, y=2
		n2, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n2, 
		-- z=0, y=3
		n2, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n2, 
		-- z=0, y=4
		n2, n2, n3, n3, n3, n3, n3, n3, n3, n3, n2, n2, 

		-- z=1, y=0
		n1, n1, n4, n4, n4, n4, n4, n4, n4, n4, n1, n1, 
		-- z=1, y=1
		n3, n5, n4, n4, n4, n4, n4, n4, n4, n4, n6, n3, 
		-- z=1, y=2
		n3, n5, n4, n4, n4, n4, n4, n4, n4, n4, n6, n3, 
		-- z=1, y=3
		n3, n3, n7, n7, n7, n7, n7, n7, n7, n7, n3, n3, 
		-- z=1, y=4
		n2, n3, n8, n8, n8, n8, n8, n8, n8, n8, n3, n2, 

		-- z=2, y=0
		n1, n4, n4, n4, n4, n4, n4, n4, n4, n4, n4, n1, 
		-- z=2, y=1
		n3, n4, n3, n2, n3, n2, n3, n2, n2, n9, n4, n3, 
		-- z=2, y=2
		n3, n4, n2, n2, n2, n2, n3, n2, n2, n10, n4, n2, 
		-- z=2, y=3
		n3, n11, n12, n4, n13, n4, n13, n4, n14, n14, n15, n2, 
		-- z=2, y=4
		n3, n16, n3, n3, n3, n3, n3, n3, n3, n3, n17, n2, 

		-- z=3, y=0
		n1, n4, n4, n4, n4, n4, n4, n4, n4, n4, n4, n1, 
		-- z=3, y=1
		n3, n4, n18, n4, n19, n4, n19, n4, n2, n2, n4, n3, 
		-- z=3, y=2
		n3, n4, n2, n4, n2, n4, n3, n4, n2, n2, n4, n2, 
		-- z=3, y=3
		n3, n11, n12, n4, n13, n4, n13, n4, n14, n14, n15, n2, 
		-- z=3, y=4
		n3, n16, n3, n3, n3, n3, n3, n3, n3, n3, n17, n2, 

		-- z=4, y=0
		n1, n4, n1, n1, n1, n1, n1, n1, n4, n4, n4, n1, 
		-- z=4, y=1
		n3, n4, n3, n3, n3, n3, n3, n20, n21, n4, n4, n3, 
		-- z=4, y=2
		n3, n4, n2, n2, n2, n2, n3, n20, n22, n4, n4, n2, 
		-- z=4, y=3
		n3, n11, n12, n2, n2, n2, n3, n20, n4, n4, n4, n2, 
		-- z=4, y=4
		n3, n16, n3, n3, n3, n3, n3, n3, n3, n3, n23, n2, 

		-- z=5, y=0
		n1, n4, n1, n1, n1, n1, n1, n1, n1, n1, n4, n1, 
		-- z=5, y=1
		n3, n4, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, 
		-- z=5, y=2
		n3, n4, n24, n2, n2, n2, n3, n3, n3, n3, n3, n3, 
		-- z=5, y=3
		n3, n11, n12, n2, n2, n2, n3, n3, n3, n13, n25, n2, 
		-- z=5, y=4
		n3, n16, n3, n3, n3, n3, n3, n3, n3, n3, n23, n2, 

		-- z=6, y=0
		n1, n4, n1, n1, n1, n1, n1, n1, n1, n1, n4, n1, 
		-- z=6, y=1
		n3, n4, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, 
		-- z=6, y=2
		n3, n4, n3, n3, n3, n3, n3, n3, n3, n3, n3, n2, 
		-- z=6, y=3
		n3, n11, n12, n2, n3, n3, n3, n3, n3, n13, n26, n2, 
		-- z=6, y=4
		n3, n16, n3, n3, n3, n3, n3, n3, n3, n3, n23, n2, 

		-- z=7, y=0
		n1, n4, n4, n4, n1, n1, n1, n1, n1, n1, n4, n1, 
		-- z=7, y=1
		n3, n4, n4, n27, n6, n3, n3, n3, n3, n3, n4, n3, 
		-- z=7, y=2
		n3, n4, n4, n28, n6, n3, n3, n3, n3, n3, n4, n2, 
		-- z=7, y=3
		n3, n11, n4, n4, n6, n3, n3, n3, n3, n13, n4, n2, 
		-- z=7, y=4
		n3, n16, n3, n3, n3, n3, n3, n3, n3, n3, n23, n2, 

		-- z=8, y=0
		n1, n4, n4, n4, n4, n4, n1, n1, n1, n1, n4, n1, 
		-- z=8, y=1
		n3, n4, n29, n2, n4, n30, n31, n3, n2, n3, n4, n3, 
		-- z=8, y=2
		n3, n4, n29, n2, n4, n3, n31, n3, n3, n3, n4, n2, 
		-- z=8, y=3
		n3, n11, n29, n14, n4, n4, n31, n3, n3, n13, n15, n2, 
		-- z=8, y=4
		n3, n16, n32, n3, n3, n3, n3, n3, n2, n2, n17, n2, 

		-- z=9, y=0
		n1, n4, n4, n4, n4, n4, n4, n1, n1, n1, n4, n1, 
		-- z=9, y=1
		n3, n4, n33, n2, n2, n3, n4, n3, n3, n3, n4, n3, 
		-- z=9, y=2
		n3, n4, n34, n2, n2, n3, n4, n3, n3, n3, n4, n2, 
		-- z=9, y=3
		n3, n11, n14, n14, n4, n14, n4, n35, n35, n35, n15, n2, 
		-- z=9, y=4
		n3, n16, n3, n3, n3, n3, n3, n3, n3, n2, n17, n2, 

		-- z=10, y=0
		n1, n1, n4, n4, n4, n4, n4, n4, n4, n4, n1, n1, 
		-- z=10, y=1
		n3, n36, n4, n4, n4, n4, n4, n4, n4, n4, n37, n2, 
		-- z=10, y=2
		n3, n36, n4, n4, n4, n4, n4, n4, n4, n4, n37, n2, 
		-- z=10, y=3
		n3, n3, n38, n38, n38, n38, n38, n38, n38, n38, n2, n2, 
		-- z=10, y=4
		n2, n3, n39, n39, n39, n39, n39, n39, n39, n39, n2, n2, 

		-- z=11, y=0
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
		-- z=11, y=1
		n2, n3, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
		-- z=11, y=2
		n2, n3, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
		-- z=11, y=3
		n2, n3, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
		-- z=11, y=4
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, 
}
}
