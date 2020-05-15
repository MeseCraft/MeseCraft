
-- add lucky blocks

if minetest.get_modpath("lucky_block") then

	lucky_block:add_blocks({
		{"dro", {"protector:protect"}, 3},
		{"dro", {"protector:protect2"}, 3},
		{"dro", {"protector:door_wood"}, 1},
		{"dro", {"protector:door_steel"}, 1},
		{"exp", 5, true},
		{"dro", {"protector:trapdoor"}, 1},
		{"dro", {"protector:trapdoor_steel"}, 1},
		{"dro", {"protector:tool"}, 1},
		{"dro", {"protector:chest"}, 1},
		{"exp"},
	})
end
