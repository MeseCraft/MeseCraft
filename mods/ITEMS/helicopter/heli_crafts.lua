--
-- items
--

-- blades
minetest.register_craftitem("helicopter:blades",{
	description = "Helicopter Blades",
	inventory_image = "helicopter_blades_inv.png",
})
-- cabin
minetest.register_craftitem("helicopter:cabin",{
	description = "Cabin for Helicopter",
	inventory_image = "helicopter_cabin_inv.png",
})
-- heli
minetest.register_craftitem("helicopter:heli", {
	description = "Helicopter",
	inventory_image = "helicopter_heli_inv.png",

	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		if minetest.get_node(pointed_thing.above).name ~= "air" then
			return
		end
       
        local obj = minetest.add_entity(pointed_thing.above, "helicopter:heli")
        local ent = obj:get_luaentity()
        --local imeta = itemstack:get_meta()
        local owner = placer:get_player_name()
        ent.owner = owner
        --[[
        ent.energy = imeta:get_int("energy")
        ent.hp = imeta:get_int("hp")]]--

        local properties = ent.object:get_properties()
        properties.infotext = owner .. " nice helicopter"
        ent.object:set_properties(properties)

		if not (creative_exists and placer and
				creative.is_enabled_for(placer:get_player_name())) then
			itemstack:take_item()
		end
		return itemstack
	end,
})

--
-- crafting
--

if minetest.get_modpath("default") then
	minetest.register_craft({
		output = "helicopter:blades",
		recipe = {
			{"basic_materials:steel_bar", "default:steel_ingot", "basic_materials:steel_bar"},
			{"default:steel_ingot", "basic_materials:gear_steel", "default:steel_ingot"},
			{"basic_materials:steel_bar", "default:steel_ingot", "basic_materials:steel_bar"},
		}
	})
	minetest.register_craft({
		output = "helicopter:cabin",
		recipe = {
			{"mesecons_materials:glue",           "group:wood",           "mesecons_materials:glue"},
			{"group:wood", "", "default:glass"},
			{"group:wood", "group:wood",           "group:wood"},
		}
	})
	minetest.register_craft({
		output = "helicopter:heli",
		recipe = {
			{"", "", "helicopter:blades"},
			{"", "oil:oil_bucket", "basic_materials:motor"},
			{"helicopter:blades", "basic_materials:motor", "helicopter:cabin"},
		}
	})
end


