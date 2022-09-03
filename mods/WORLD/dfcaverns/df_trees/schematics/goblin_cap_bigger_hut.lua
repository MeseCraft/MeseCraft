local n1 = { name = "air" } -- external air
local n2 = { name = "df_trees:goblin_cap_stem"} -- below ground, don't force place these
local n3 = { name = "df_trees:goblin_cap" }
local n4 = { name = "df_trees:goblin_cap_gills" }
local n5 = { name = "df_trees:goblin_cap_stem", force_place = true } -- walls, force place these
local n6 = { name = "df_trees:goblin_cap_stem", prob = 198, force_place=true } -- possible window holes
local n7 = { name = "df_trees:goblin_cap_stem_wood", force_place=true } -- internal floor
local n8 = { name = df_dependencies.node_name_furnace, param2 = 2, force_place=true }
local n9 = { name = "air", force_place=true } -- internal air
local n10 = { name = df_dependencies.node_name_torch_wall, param2 = 3, force_place = true }
local n12 = {name = df_dependencies.node_name_slab_goblin_cap_stem_wood, param2 = 2} -- porch top
local n13 = { name = df_dependencies.node_name_door_wood_a or "air", param2 = 3, force_place = true }
local n14 = { name = df_dependencies.node_name_door_hidden or "air", param2 = 3, force_place = true }
local n15 = n9 -- internal air, but could be a vessel shelf
local n16 = { name = df_dependencies.node_name_bed_top or "air", param2 = 3, force_place = true }
local n17 = { name = df_dependencies.node_name_bed_bottom or "air", param2 = 3, force_place = true }
local n18 = { name = df_dependencies.node_name_chest, force_place = true }
local n19 = { name = df_dependencies.node_name_torch_wall, param2 = 2, force_place = true }
local n20 = {name = df_dependencies.node_name_stair_goblin_cap_stem_wood }
local n21 = {name = df_dependencies.node_name_stair_goblin_cap_stem_wood, param2 = 2 }
local n22 = {name = df_dependencies.node_name_slab_goblin_cap_stem_wood, param2 = 22}

if df_dependencies.node_name_shelf then
	-- replace torches with glowing bottles, add vessel shelf
	n10 = { name = "df_trees:glowing_bottle_red", force_place=true}
	n19 = n10
	n15 = { name = df_dependencies.node_name_shelf, param2 = 3, force_place = true }
end

local schematic = {
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
		n1, n1, n1, n1, n1, n2, n2, n2, n1, n1, n1, n1, n1, 
		-- z=3, y=1
		n1, n1, n1, n1, n1, n2, n2, n2, n1, n1, n1, n1, n1, 
		-- z=3, y=2
		n1, n1, n1, n1, n1, n5, n5, n5, n1, n1, n1, n1, n1, 
		-- z=3, y=3
		n1, n1, n1, n1, n1, n5, n5, n5, n1, n1, n1, n1, n1, 
		-- z=3, y=4
		n1, n1, n1, n1, n1, n5, n6, n5, n1, n1, n1, n1, n1, 
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
		n1, n1, n1, n1, n2, n2, n2, n2, n2, n12, n22, n1, n1, 
		-- z=4, y=1
		n1, n1, n1, n1, n2, n2, n2, n2, n2, n1, n1, n1, n1, 
		-- z=4, y=2
		n1, n1, n1, n1, n5, n7, n7, n7, n5, n1, n1, n1, n1, 
		-- z=4, y=3
		n1, n1, n1, n1, n5, n8, n9, n9, n5, n1, n1, n1, n1, 
		-- z=4, y=4
		n1, n1, n1, n1, n5, n10, n9, n9, n5, n1, n1, n1, n1, 
		-- z=4, y=5
		n1, n1, n1, n1, n5, n5, n9, n5, n5, n1, n1, n1, n1, 
		-- z=4, y=6
		n1, n3, n4, n4, n4, n5, n5, n5, n4, n4, n4, n3, n1, 
		-- z=4, y=7
		n1, n1, n3, n3, n3, n3, n3, n3, n3, n3, n3, n1, n1, 
		-- z=4, y=8
		n1, n1, n1, n3, n3, n3, n3, n3, n3, n3, n1, n1, n1, 
		-- z=4, y=9
		n1, n1, n1, n1, n3, n3, n3, n3, n3, n1, n1, n1, n1, 

		-- z=5, y=0
		n1, n1, n1, n2, n2, n2, n2, n2, n2, n2, n1, n1, n1, 
		-- z=5, y=1
		n1, n1, n1, n2, n2, n2, n2, n2, n2, n2, n20, n1, n1, 
		-- z=5, y=2
		n1, n1, n1, n5, n7, n7, n7, n7, n7, n5, n1, n1, n1, 
		-- z=5, y=3
		n1, n1, n1, n5, n9, n9, n9, n9, n9, n5, n1, n1, n1, 
		-- z=5, y=4
		n1, n1, n1, n5, n9, n9, n9, n9, n9, n5, n1, n1, n1, 
		-- z=5, y=5
		n1, n1, n1, n5, n5, n9, n9, n9, n5, n5, n1, n1, n1, 
		-- z=5, y=6
		n1, n3, n4, n4, n5, n9, n9, n9, n5, n4, n4, n3, n1, 
		-- z=5, y=7
		n1, n1, n3, n3, n3, n5, n5, n5, n3, n3, n3, n1, n1, 
		-- z=5, y=8
		n1, n1, n1, n3, n3, n3, n3, n3, n3, n3, n1, n1, n1, 
		-- z=5, y=9
		n1, n1, n1, n1, n3, n3, n3, n3, n3, n1, n1, n1, n1, 

		-- z=6, y=0
		n1, n1, n1, n2, n2, n2, n2, n2, n2, n2, n1, n1, n1,
		-- z=6, y=1
		n1, n1, n1, n2, n2, n2, n2, n2, n2, n2, n1, n1, n1, 
		-- z=6, y=2
		n1, n1, n1, n5, n7, n7, n7, n7, n7, n7, n12, n1, n1, 
		-- z=6, y=3
		n1, n1, n1, n5, n9, n9, n9, n9, n9, n13, n9, n9, n1, 
		-- z=6, y=4
		n1, n1, n1, n6, n9, n9, n9, n9, n9, n14, n9, n9, n1, 
		-- z=6, y=5
		n1, n1, n1, n5, n9, n9, n9, n9, n9, n5, n1, n1, n1, 
		-- z=6, y=6
		n3, n4, n4, n5, n5, n9, n9, n9, n5, n5, n4, n4, n3, 
		-- z=6, y=7
		n1, n3, n3, n3, n3, n5, n5, n5, n3, n3, n3, n3, n1, 
		-- z=6, y=8
		n1, n1, n3, n3, n3, n3, n3, n3, n3, n3, n3, n1, n1, 
		-- z=6, y=9
		n1, n1, n1, n3, n3, n3, n3, n3, n3, n3, n1, n1, n1, 

		-- z=7, y=0
		n1, n1, n1, n2, n2, n2, n2, n2, n2, n2, n1, n1, n1, 
		-- z=7, y=1
		n1, n1, n1, n2, n2, n2, n2, n2, n2, n2, n21, n1, n1, 
		-- z=7, y=2
		n1, n1, n1, n5, n7, n7, n7, n7, n7, n5, n1, n1, n1, 
		-- z=7, y=3
		n1, n1, n1, n5, n15, n9, n9, n9, n9, n5, n1, n1, n1, 
		-- z=7, y=4
		n1, n1, n1, n5, n9, n9, n9, n9, n9, n5, n1, n1, n1, 
		-- z=7, y=5
		n1, n1, n1, n5, n5, n9, n9, n9, n5, n5, n1, n1, n1, 
		-- z=7, y=6
		n1, n3, n4, n4, n5, n9, n9, n9, n5, n4, n4, n3, n1, 
		-- z=7, y=7
		n1, n1, n3, n3, n3, n5, n5, n5, n3, n3, n3, n1, n1, 
		-- z=7, y=8
		n1, n1, n1, n3, n3, n3, n3, n3, n3, n3, n1, n1, n1, 
		-- z=7, y=9
		n1, n1, n1, n1, n3, n3, n3, n3, n3, n1, n1, n1, n1, 

		-- z=8, y=0
		n1, n1, n1, n1, n2, n2, n2, n2, n2, n12, n22, n1, n1, 
		-- z=8, y=1
		n1, n1, n1, n1, n2, n2, n2, n2, n2, n1, n1, n1, n1, 
		-- z=8, y=2
		n1, n1, n1, n1, n5, n7, n7, n7, n5, n1, n1, n1, n1, 
		-- z=8, y=3
		n1, n1, n1, n1, n5, n16, n17, n18, n5, n1, n1, n1, n1, 
		-- z=8, y=4
		n1, n1, n1, n1, n5, n9, n9, n19, n5, n1, n1, n1, n1, 
		-- z=8, y=5
		n1, n1, n1, n1, n5, n5, n9, n5, n5, n1, n1, n1, n1, 
		-- z=8, y=6
		n1, n3, n4, n4, n4, n5, n5, n5, n4, n4, n4, n3, n1, 
		-- z=8, y=7
		n1, n1, n3, n3, n3, n3, n3, n3, n3, n3, n3, n1, n1, 
		-- z=8, y=8
		n1, n1, n1, n3, n3, n3, n3, n3, n3, n3, n1, n1, n1, 
		-- z=8, y=9
		n1, n1, n1, n1, n3, n3, n3, n3, n3, n1, n1, n1, n1, 

		-- z=9, y=0
		n1, n1, n1, n1, n1, n2, n2, n2, n1, n1, n1, n1, n1, 
		-- z=9, y=1
		n1, n1, n1, n1, n1, n2, n2, n2, n1, n1, n1, n1, n1, 
		-- z=9, y=2
		n1, n1, n1, n1, n1, n5, n5, n5, n1, n1, n1, n1, n1, 
		-- z=9, y=3
		n1, n1, n1, n1, n1, n5, n5, n5, n1, n1, n1, n1, n1, 
		-- z=9, y=4
		n1, n1, n1, n1, n1, n5, n6, n5, n1, n1, n1, n1, n1, 
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

for index, node in ipairs(schematic.data) do
	assert(node.name ~= nil, "undefined node name for index " .. tostring(index) .. " in goblin_cap_bigger_hut schematic data")
end

return schematic