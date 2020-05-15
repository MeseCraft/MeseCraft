
if minetest.get_modpath("default") then
	minetest.register_craft({
		output = "hopper:hopper",
		recipe = {
			{"default:steel_ingot","default:chest","default:steel_ingot"},
			{"","default:steel_ingot",""},
		}
	})
	
	minetest.register_craft({
		output = "hopper:chute",
		recipe = {
			{"default:steel_ingot","default:chest","default:steel_ingot"},
		}
	})
	
	minetest.register_craft({
		output = "hopper:sorter",
		recipe = {
			{"","default:mese_crystal",""},
			{"default:steel_ingot","default:chest","default:steel_ingot"},
			{"","default:steel_ingot",""},
		}
	})
	
	if not hopper.config.single_craftable_item then
		minetest.register_craft({
			output = "hopper:hopper_side",
			recipe = {
				{"default:steel_ingot","default:chest","default:steel_ingot"},
				{"","","default:steel_ingot"},
			}
		})
		
		minetest.register_craft({
			output = "hopper:hopper_side",
			type="shapeless",
			recipe = {"hopper:hopper"},
		})
	
		minetest.register_craft({
			output = "hopper:hopper",
			type="shapeless",
			recipe = {"hopper:hopper_side"},
		})
	end
end