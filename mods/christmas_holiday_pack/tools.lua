--Register Candy Cane Pickaxe
minetest.register_tool("christmas_holiday_pack:candy_cane_pickaxe", {
	description = "Candy Cane Pickaxe",
	inventory_image = "christmas_holiday_pack_candy_cane_pickaxe.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=2.4, [2]=1.2, [3]=0.60}, uses=20, maxlevel=3},
		},
		damage_groups = {fleshy=5},
	},
})

--Register Candy Cane Axe
minetest.register_tool("christmas_holiday_pack:candy_cane_axe", {
	description = "Candy Cane Axe",
	inventory_image = "christmas_holiday_pack_candy_cane_axe.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=2.20, [2]=1.00, [3]=0.60}, uses=20, maxlevel=3},
		},
		damage_groups = {fleshy=6},
	}
})

--Register Candy Cane Sword
minetest.register_tool("christmas_holiday_pack:candy_cane_sword", {
	description = "Candy Cane Sword",
	inventory_image = "christmas_holiday_pack_candy_cane_sword.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=2.0, [2]=1.00, [3]=0.35}, uses=30, maxlevel=3},
		},
		damage_groups = {fleshy=7},
	}
})

-- Add toolranks support
if minetest.get_modpath("toolranks") then
	-- Helper function
	local function add_tool(name, desc, afteruse)
		minetest.override_item(name, {
			original_description = desc,
			description = toolranks.create_description(desc, 0, 1),
			after_use = afteruse and toolranks.new_afteruse
		})
	end
	add_tool("christmas_holiday_pack:candy_cane_pickaxe", "Candy Cane Pickaxe", true)
	add_tool("christmas_holiday_pack:candy_cane_axe", "Candy Cane Axe", true)
	add_tool("christmas_holiday_pack:candy_cane_sword", "Candy Cane Sword", true)
end
