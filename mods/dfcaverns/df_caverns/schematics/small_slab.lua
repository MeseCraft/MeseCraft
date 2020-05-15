local inner_stair = "stairs:stair_inner_slade_brick"
if stairs.register_stair_inner == nil then -- 0.4.16 compatibility
	inner_stair = "df_underworld_items:slade_brick"
end


local n1 = { name = "df_underworld_items:slade_brick", force_place=false, place_on_condition=mapgen_helper.buildable_to }
local n2 = { name = inner_stair, param2 = 1, force_place=true }
local n3 = { name = inner_stair, force_place=true }
local n4 = { name = "df_underworld_items:slade_brick", force_place=true }
local n5 = { name = inner_stair, param2 = 2, force_place=true }
local n6 = { name = inner_stair, param2 = 3, force_place=true }

return {
	name = "df_caverns:small_slab",
	size = {y = 2, x = 2, z = 3},
	center_pos = {x = 1, y = 1, z = 1},
	data = {
		n1, n1, n2, n3, n1, n1, n4, n4, n1, n1, n5, n6, 
	}
}