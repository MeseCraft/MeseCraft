minetest.register_craftitem("mobs_creatures:bone", {
                description = "Bone",
                inventory_image = "mobs_creatures_items_bone.png"
        })
if minetest.get_modpath("bones") then
	minetest.register_craft({
		output = "mobs_creatures:bone 2",
               	recipe = {{ "bones:bones" }},
       	})
end


