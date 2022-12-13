if not minetest.get_modpath("loot") then
	return
end

loot.register_loot({
	weights = { generic = 300 },
	payload = {
		stack = ItemStack("ropes:ropesegment"),
		min_size = 1,
		max_size = 50,
	},
})

if ropes.ropeLadderLength > 0 then
loot.register_loot({
	weights = { generic = 150 },
	payload = {
		stack = ItemStack("ropes:ropeladder_top"),
		min_size = 1,
		max_size = 20,
	},
})
end

if ropes.woodRopeBoxMaxMultiple > 0 then
loot.register_loot({
	weights = { generic = 100 },
	payload = {
		stack = ItemStack("ropes:wood1rope_block"),
		min_size = 1,
		max_size = 20,
	},
})
end

if ropes.copperRopeBoxMaxMultiple > 0 then
loot.register_loot({
	weights = { generic = 75 },
	payload = {
		stack = ItemStack("ropes:copper1rope_block"),
		min_size = 1,
		max_size = 15,
	},
})
end

if ropes.steelRopeBoxMaxMultiple > 0 then
loot.register_loot({
	weights = { generic = 50 },
	payload = {
		stack = ItemStack("ropes:steel1rope_block"),
		min_size = 1,
		max_size = 10,
	},
})
end