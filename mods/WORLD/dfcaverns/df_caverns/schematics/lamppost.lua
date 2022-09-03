local n1 = { name = "df_underworld_items:slade_block", force_place=true }
local n2 = { name = df_dependencies.node_name_stair_outer_slade_brick, param2 = 1, force_place=true }
local n3 = { name = df_dependencies.node_name_stair_slade_brick, force_place=true }
local n4 = { name = df_dependencies.node_name_stair_outer_slade_brick, force_place=true }
local n5 = { name = "air", force_place=true }
local n6 = { name = "df_underworld_items:slade_seal", force_place=true }
local n7 = { name = df_dependencies.node_name_stair_slade_brick, param2 = 1, force_place=true }
local n8 = { name = "df_underworld_items:slade_brick", force_place=true }
local n9 = { name = df_dependencies.node_name_stair_slade_brick, param2 = 3, force_place=true }
local n10 = { name = "df_underworld_items:slade_wall", force_place=true }
local n11 = { name = "df_underworld_items:ancient_lantern_slade_worn", prob=192 } -- 50% chance of being force-placed
local n12 = { name = df_dependencies.node_name_stair_outer_slade_brick, param2 = 2, force_place=true }
local n13 = { name = df_dependencies.node_name_stair_slade_brick, param2 = 2, force_place=true }
local n14 = { name = df_dependencies.node_name_stair_outer_slade_brick, param2 = 3, force_place=true }

return {
	name = "df_caverns:lamppost",
	size = {x = 3, y = 15, z = 3},
	center_pos = {x = 1, y = 7, z = 1},
	data = {
		n1, n1, n1, n1, n1, n1, n1, n1, n1,
		n1, n1, n1, n1, n1, n1, n1, n1, n1,
		n1, n1, n1, n1, n1, n1, n2, n3, n4,
		n5, n5, n5,
		n5, n5, n5,
		n5, n5, n5,
		n5, n5, n5,
		n5, n11, n5,
		n5, n5, n5,
		n1, n1, n1, n1, n5, n1, n1, n5, n1,
		n1, n5, n1, n1, n5, n1, n1, n5, n1,
		n1, n5, n1, n1, n6, n1, n7, n8, n9,
		n5, n8, n5,
		n5, n8, n5,
		n5, n10, n5,
		n5, n10, n5,
		n11, n10, n11,
		n5, n5, n5,
		n1, n1, n1, n1, n1, n1, n1, n1, n1,
		n1, n1, n1, n1, n1, n1, n1, n1, n1,
		n1, n1, n1, n1, n1, n1, n12, n13, n14,
		n5, n5, n5,
		n5, n5, n5,
		n5, n5, n5,
		n5,	n5, n5,
		n5, n11, n5,
		n5, n5, n5, 
	}
}
