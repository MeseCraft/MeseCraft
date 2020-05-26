-- Rainbow_Ore Test Mod ----------- Copyright Robin Kuhn 2015

--Check for mods
if minetest.get_modpath("3d_armor") then
dofile(minetest.get_modpath("rainbow_ore").."/rainbow_armor.lua")
end

if minetest.get_modpath("shields") then
dofile(minetest.get_modpath("rainbow_ore").."/rainbow_shield.lua")
end

-- Define Rainbow_Ore_Block node
minetest.register_node("rainbow_ore:rainbow_ore_block", {
	description = "Rainbow Ore",
	tile_images = {"rainbow_ore_block.png"},
	groups = {stone=2, cracky=3},
	drop = "rainbow_ore:rainbow_ore_block",
	is_ground_content = true,
})


--Define Rainbow_Ore_Ingot node
minetest.register_craftitem("rainbow_ore:rainbow_ore_ingot", {
	description = "Rainbow Ore Ingot",
	inventory_image = "rainbow_ore_ingot.png",
})

--Define Rainbow_Ore Smelt Recipe
minetest.register_craft({
	type = "cooking",
	output = "rainbow_ore:rainbow_ore_ingot",
	recipe = "rainbow_ore:rainbow_ore_block",
	cooktime = 10,
})


--Register Rainbow Pickaxe
minetest.register_tool("rainbow_ore:rainbow_ore_pickaxe", {
	description = "Rainbow Pickaxe",
	inventory_image = "rainbow_ore_pickaxe.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=1.0, [2]=0.5, [3]=0.25}, uses=15, maxlevel=3},
		},
		damage_groups = {fleshy=5},
	},
})


--Define Rainbow_Ore_Pickaxe crafting recipe
minetest.register_craft({
	output = "rainbow_ore:rainbow_ore_pickaxe",
	recipe = {
		{"rainbow_ore:rainbow_ore_ingot", "rainbow_ore:rainbow_ore_ingot", "rainbow_ore:rainbow_ore_ingot", ""},
		{"", "default:stick", "", ""},
		{"", "default:stick", "", ""}
	}
})


--Register Rainbow Axe
minetest.register_tool("rainbow_ore:rainbow_ore_axe", {
	description = "Rainbow Axe",
	inventory_image = "rainbow_ore_axe.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=3,
		groupcaps={
			choppy={times={[1]=1.05, [2]=0.45, [3]=0.25}, uses=15, maxlevel=3},
		},
		damage_groups = {fleshy=7},
	}
})


--Define Rainbow Axe crafting recipe
minetest.register_craft({
	output = "rainbow_ore:rainbow_ore_axe",
	recipe = {
		{"rainbow_ore:rainbow_ore_ingot", "rainbow_ore:rainbow_ore_ingot", "", ""},
		{"rainbow_ore:rainbow_ore_ingot", "default:stick", "", ""},
		{"", "default:stick", "", ""}
	}
})

minetest.register_craft({
	output = "rainbow_ore:rainbow_ore_axe",
	recipe = {
		{"", "rainbow_ore:rainbow_ore_ingot", "rainbow_ore:rainbow_ore_ingot", ""},
		{"", "default:stick", "rainbow_ore:rainbow_ore_ingot", ""},
		{"", "default:stick", "", ""}
	}
})


--Register Rainbow shovel
minetest.register_tool("rainbow_ore:rainbow_ore_shovel", {
	description = "Rainbow Shovel",
	inventory_image = "rainbow_ore_shovel.png",
	wield_image = "rainbow_ore_shovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=3,
		groupcaps={
			crumbly = {times={[1]=0.55, [2]=0.25, [3]=0.15}, uses=15, maxlevel=3},
		},
		damage_groups = {fleshy=4},
	},
})


--Define Rainbow shovel crafting recipe
minetest.register_craft({
	output = "rainbow_ore:rainbow_ore_shovel",
	recipe = {
		{"", "rainbow_ore:rainbow_ore_ingot", "", ""},
		{"", "default:stick", "", ""},
		{"", "default:stick", "", ""}
	}
})


--Register Rainbow sword
minetest.register_tool("rainbow_ore:rainbow_ore_sword", {
	description = "Rainbow Sword",
	inventory_image = "rainbow_ore_sword.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level=3,
		groupcaps={
			snappy={times={[1]=0.95, [2]=0.45, [3]=0.15}, uses=20, maxlevel=3},
		},
		damage_groups = {fleshy=8},
	}
})


--Define Rainbow sword crafting recipe
minetest.register_craft({
	output = "rainbow_ore:rainbow_ore_sword",
	recipe = {
		{"", "rainbow_ore:rainbow_ore_ingot", "", ""},
		{"", "rainbow_ore:rainbow_ore_ingot", "", ""},
		{"", "default:stick", "", ""}
	}
})


--Define MooGNU Rainbow crafting recipe
minetest.register_craft({
	output = "moognu:moognu_rainbow",
	recipe = {
		{"rainbow_ore:rainbow_ore_ingot", "rainbow_ore:rainbow_ore_ingot", "rainbow_ore:rainbow_ore_ingot"},
		{"rainbow_ore:rainbow_ore_ingot", "rainbow_ore:rainbow_ore_ingot", "rainbow_ore:rainbow_ore_ingot"},
		{"rainbow_ore:rainbow_ore_ingot", "rainbow_ore:rainbow_ore_ingot", "rainbow_ore:rainbow_ore_ingot"}
	}
})


--Make Rainbow Ore spawn
minetest.register_ore({
	ore_type = "scatter",
	ore = "rainbow_ore:rainbow_ore_block",
	wherein = "default:stone",
	clust_scarcity = 128*128*128,
	clust_num_ores = 3,
	clust_size = 3,
	height_min = -31000,
	height_max = -4000,
})


-- Add [toolranks] mod support if found
if minetest.get_modpath("toolranks") then
	-- Helper function
	local function add_tool(name, desc, afteruse)
		minetest.override_item(name, {
			original_description = desc,
			description = toolranks.create_description(desc, 0, 1),
			after_use = afteruse and toolranks.new_afteruse
		})
	end
	add_tool("rainbow_ore:rainbow_ore_pickaxe", "Rainbow Pickaxe", true)
	add_tool("rainbow_ore:rainbow_ore_axe", "Rainbow Axe", true)
	add_tool("rainbow_ore:rainbow_ore_shovel", "Rainbow Shovel", true)
	add_tool("rainbow_ore:rainbow_ore_sword", "Rainbow Sword", true)
end

