local n1 = { name = "ignore" }
local n10 = { name = "air", force_place=true }

local n3 = { name = "df_underworld_items:slade_brick", force_place=true }
local n4 = { name = "df_underworld_items:slade_wall", force_place=true }
local n5 = { name = df_dependencies.node_name_stair_outer_slade_brick, param2 = 1, force_place=true }
local n6 = { name = df_dependencies.node_name_stair_slade_brick, force_place=true }
local n7 = { name = df_dependencies.node_name_stair_outer_slade_brick, force_place=true }
local n11 = { name = df_dependencies.node_name_stair_slade_brick, param2 = 1, force_place=true }
local n12 = { name = df_dependencies.node_name_slab_slade_brick, param2 = 22, force_place=true}
local n13 = { name = df_dependencies.node_name_stair_slade_brick, param2 = 3, force_place=true }
local n15 = { name = df_dependencies.node_name_stair_outer_slade_brick, param2 = 2, force_place=true }
local n16 = { name = df_dependencies.node_name_stair_slade_brick, param2 = 2, force_place=true }
local n17 = { name = df_dependencies.node_name_stair_outer_slade_brick, param2 = 3, force_place=true }

-- foundation nodes
local n2 = { name = "df_underworld_items:slade_brick", force_place=false, place_on_condition=mapgen_helper.buildable_to }
local n8 = { name = df_dependencies.node_name_stair_slade_brick, param2 = 2, force_place=false, place_on_condition=mapgen_helper.buildable_to }
local n9 = { name = df_dependencies.node_name_stair_slade_brick, force_place=false, place_on_condition=mapgen_helper.buildable_to }
local n14 = { name = df_dependencies.node_name_stair_slade_brick, param2 = 1, force_place=false, place_on_condition=mapgen_helper.buildable_to }


local n18 = { name = "df_underworld_items:puzzle_chest_closed", param2 = 1, prob=192 } -- 50% chance of being force-placed.

return {
	name = "df_caverns:small_building",
	size = {x = 11, y = 9, z = 7},
	center_pos = {x = 7, y = 5, z = 3},
	data = {
		n1, n1, n2, n2, n2, n2, n2, n2, n2, n2, n2, n1, n1, n2, n2, n2, n2, 
		n2, n2, n2, n2, n2, n1, n1, n2, n2, n2, n2, n2, n2, n2, n2, n2, n1, 
		n1, n2, n2, n2, n2, n2, n2, n2, n2, n2, n1, n1, n1, n1, n2, n2, n2, 
		n2, n2, n2, n2, n1, n1, n1, n1, n3, n3, n3, n3, n3, n3, n3, n1, n1, 
		n1, n1, n3, n4, n4, n4, n4, n4, n3, n1, n1, n1, n1, n3, n4, n4, n4, 
		n4, n4, n3, n1, n1, n1, n1, n5, n6, n6, n6, n6, n6, n7, n1, n1, n2, 
		n2, n2, n2, n2, n2, n2, n2, n2, n1, n1, n2, n2, n2, n2, n2, n2, n2, 
		n2, n2, n1, n1, n2, n2, n2, n2, n2, n2, n2, n2, n2, n1, n1, n8, n2, 
		n2, n2, n2, n2, n2, n2, n2, n1, n1, n1, n9, n2, n2, n2, n2, n2, n2, 
		n2, n1, n1, n1, n1, n3, n3, n3, n3, n3, n3, n3, n1, n1, n1, n10, n4, 
		n10, n10, n10, n10, n10, n4, n1, n1, n1, n10, n4, n10, n10, n10, n10, 
		n10, n4, n1, n1, n1, n1, n11, n12, n12, n12, n12, n12, n13, n1, n1, 
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n1, n1, n2, n2, n2, n2, n2, n2, 
		n2, n2, n2, n1, n1, n8, n2, n2, n2, n2, n2, n2, n2, n2, n1, n1, n1, 
		n2, n2, n2, n2, n2, n2, n2, n2, n1, n1, n1, n2, n2, n2, n2, n2, n2, 
		n2, n2, n1, n1, n1, n9, n3, n3, n3, n3, n3, n3, n3, n1, n1, n1, n10, 
		n3, n10, n10, n10, n10, n10, n4, n1, n1, n1, n10, n3, n10, n10, n10, 
		n10, n10, n4, n1, n1, n1, n1, n11, n12, n12, n12, n12, n12, n13, n14, 
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n2, n1, n14, n2, n2, n2, n2, n2, 
		n2, n2, n2, n2, n1, n1, n1, n2, n2, n2, n2, n2, n2, n2, n2, n1, n1, 
		n1, n2, n2, n2, n2, n2, n2, n2, n2, n1, n1, n1, n2, n2, n2, n2, n2, 
		n2, n2, n2, n1, n1, n1, n2, n3, n3, n3, n3, n3, n3, n3, n1, n1, n1, 
		n10, n10, n10, n10, n10, n10, n18, n4, n1, n1, n1, n10, n10, n10, 
		n10, n10, n10, n10, n4, n1, n1, n1, n1, n11, n12, n12, n12, n12, n12, 
		n13, n1, n1, n2, n2, n2, n2, n2, n2, n2, n2, n2, n1, n1, n2, n2, n2, 
		n2, n2, n2, n2, n2, n2, n1, n1, n9, n2, n2, n2, n2, n2, n2, n2, n2, 
		n1, n1, n1, n2, n2, n2, n2, n2, n2, n2, n2, n1, n1, n1, n2, n2, n2, 
		n2, n2, n2, n2, n2, n1, n1, n1, n8, n3, n3, n3, n3, n3, n3, n3, n1, 
		n1, n1, n10, n3, n10, n10, n10, n10, n10, n4, n1, n1, n1, n10, n3, 
		n10, n10, n10, n10, n10, n4, n1, n1, n1, n1, n11, n12, n12, n12, n12, 
		n12, n13, n1, n1, n2, n2, n2, n2, n2, n2, n2, n2, n2, n1, n1, n2, n2, 
		n2, n2, n2, n2, n2, n2, n2, n1, n1, n2, n2, n2, n2, n2, n2, n2, n2, 
		n2, n1, n1, n9, n2, n2, n2, n2, n2, n2, n2, n2, n1, n1, n1, n8, n2, 
		n2, n2, n2, n2, n2, n2, n1, n1, n1, n1, n3, n3, n3, n3, n3, n3, n3, 
		n1, n1, n1, n10, n4, n10, n10, n10, n10, n10, n4, n1, n1, n1, n10, 
		n4, n10, n10, n10, n10, n10, n4, n1, n1, n1, n1, n11, n12, n12, n12, 
		n12, n12, n13, n1, n1, n2, n2, n2, n2, n2, n2, n2, n2, n2, n1, n1, 
		n2, n2, n2, n2, n2, n2, n2, n2, n2, n1, n1, n2, n2, n2, n2, n2, n2, 
		n2, n2, n2, n1, n1, n2, n2, n2, n2, n2, n2, n2, n2, n2, n1, n1, n1, 
		n1, n2, n2, n2, n2, n2, n2, n2, n1, n1, n1, n1, n3, n3, n3, n3, n3, 
		n3, n3, n1, n1, n1, n1, n3, n4, n4, n4, n4, n4, n3, n1, n1, n1, n1, 
		n3, n4, n4, n4, n4, n4, n3, n1, n1, n1, n1, n15, n16, n16, n16, n16, 
		n16, n17, 
	}
}
