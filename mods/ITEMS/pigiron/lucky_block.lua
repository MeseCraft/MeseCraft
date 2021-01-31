
-- Add Lucky Blocks if mod found

if minetest.get_modpath("lucky_block") then

	lucky_block:add_blocks({
		{"dro", {"pigiron:iron_ingots"}, 10},
		{"nod", "pigiron:iron_block", 0},
		{"nod", "pigiron:rusted_iron_block", 0},
		{"tro", "pigiron:iron_block", nil, true},
		{"dro", {"pigiron:charcoal_lump"}, 10},
		{"dro", {"pigiron:sword_iron", "pigiron:axe_iron",
			"pigiron:pickaxe_iron", "pigiron:shovel_iron"}, 1},
		{"fal", {"pigiron:iron_block", "pigiron:rusted_iron_block",
			"pigiron:iron_block", "pigiron:rusted_iron_block",
			"pigiron:iron_block", "pigiron:rusted_iron_block"}},
	})

	if minetest.get_modpath("farming") then

		lucky_block:add_blocks({
			{"dro", {"pigiron:hoe_iron"}, 1},
		})
	end
end
