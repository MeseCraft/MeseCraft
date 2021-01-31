gadgets.register_gadget({
    name = "gadgets_consumables:water_bottle",
    description = "Water Bottle",
    texture = "gadgets_consumables_potion_water.png",
    consumable = true,
    stack_max = 4,
    return_item = "vessels:glass_bottle",
    use_sound = "gadgets_consumables_potion_drink",
    use_sound_gain = 1,
})

minetest.register_craft({
    output = "gadgets_consumables:water_bottle 4",
    recipe = {
		{"vessels:glass_bottle", "vessels:glass_bottle", ""},
		{"vessels:glass_bottle", "vessels:glass_bottle", ""},
		{"", "bucket:bucket_water", ""}
	},
	replacements = {{ "bucket:bucket_water", "bucket:bucket_empty"}},
})
