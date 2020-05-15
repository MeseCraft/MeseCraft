local has_vacuum = minetest.get_modpath("vacuum")

if has_vacuum then

	function repair_recipe(partname)
		minetest.register_craft({
			type = "shapeless",
			output = partname,
			recipe = {
				"vacuum:air_bottle",
				partname
			},
			replacements = {
				{"vacuum:air_bottle", "vessels:steel_bottle"}
			}
		})
	end

	repair_recipe("spacesuit:helmet")
	repair_recipe("spacesuit:chestplate")
	repair_recipe("spacesuit:pants")
	repair_recipe("spacesuit:boots")


end

