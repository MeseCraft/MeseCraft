
-- Pig Iron Ingot

minetest.register_craftitem("pigiron:iron_ingot", {
	description = "Iron Ingot",
	inventory_image = "pigiron_iron_ingot.png",
})

-- Remove Iron Lump -> Steel Ingot Recipe

minetest.clear_craft({
	type = "cooking",
	recipe = "default:iron_lump"
})

-- Iron Lump -> Iron Ingot

minetest.register_craft({
	type = "cooking",
	output = "pigiron:iron_ingot",
	recipe = "default:iron_lump",
})

-- Pig Iron Block

minetest.register_node("pigiron:iron_block", {
	description = "Iron Block",
	tiles = {"pigiron_iron_block.png"},
	is_ground_content = false,
	groups = {cracky = 1},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "pigiron:iron_block",
	recipe = {
		{"pigiron:iron_ingot", "pigiron:iron_ingot", "pigiron:iron_ingot"},
		{"pigiron:iron_ingot", "pigiron:iron_ingot", "pigiron:iron_ingot"},
		{"pigiron:iron_ingot", "pigiron:iron_ingot", "pigiron:iron_ingot"},
	}
})

minetest.register_craft({
	output = "pigiron:iron_ingot 9",
	type = "shapeless",
	recipe = {"pigiron:iron_block"}
})

-- Rusted Pig Iron Block

minetest.register_node("pigiron:rusted_iron_block", {
	description = "Rusted Iron Block",
	tiles = {"pigiron_rusted_iron_block.png"},
	is_ground_content = false,
	groups = {cracky = 1},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "pigiron:rusted_iron_block 8",
	recipe = {
		{"pigiron:iron_block", "pigiron:iron_block", "pigiron:iron_block"},
		{"pigiron:iron_block", "bucket:bucket_water", "pigiron:iron_block"},
		{"pigiron:iron_block", "pigiron:iron_block", "pigiron:iron_block"},
	},
	replacements = {
		{"bucket:bucket_water", "bucket:bucket_empty"}
	}
})

-- Cook Rusted Block Into Normal Block

minetest.register_craft({
	output = "pigiron:iron_block",
	type = "cooking",
	recipe = "pigiron:rusted_iron_block",
	cooktime = 5
})

-- Do not register these items and recipes if Ethereal mod active
if not minetest.get_modpath("ethereal") then

	-- Charcoal

	minetest.register_craftitem("pigiron:charcoal_lump", {
		description = "Lump of Charcoal",
		inventory_image = "pigiron_charcoal_lump.png",
	})

	-- Tree -> Charcoal Recipe

	minetest.register_craft({
		output = "pigiron:charcoal_lump 2",
		type = "cooking",
		recipe = "group:tree",
		cooktime = 4
	})

	-- Charcoal Fuel

	minetest.register_craft({
		type = "fuel",
		recipe = "pigiron:charcoal_lump",
		burntime = 10,
	})

	-- Charcoal Torch Recipe

	minetest.register_craft({
		output = "default:torch 4",
		recipe = {
			{"pigiron:charcoal_lump"},
			{"group:stick"},
		}
	})

else

	-- Alias charcoal lump to the one used in Ethereal mod
	minetest.register_alias("pigiron:charcoal_lump", "ethereal:charcoal_lump")

end -- END If Ethereal

-- Iron/Charcoal Mix

minetest.register_craftitem("pigiron:iron_charcoal_mix", {
	description = "Iron and Charcoal Mix",
	inventory_image = "pigiron_iron_ingot.png^pigiron_charcoal_lump.png",
})

minetest.register_craft({
	output = "pigiron:iron_charcoal_mix",
	type = "shapeless",
	recipe = {
		"pigiron:iron_ingot", "pigiron:charcoal_lump",
		"pigiron:charcoal_lump", "pigiron:charcoal_lump"
	}
})

-- Cook Iron/Charcoal Mix into Steel Ingot

minetest.register_craft({
	output = "default:steel_ingot",
	type = "cooking",
	recipe = "pigiron:iron_charcoal_mix",
	cooktime = 10
})

-- Abm to turn Iron Block into Rusted Iron Block

minetest.register_abm({
	label = "Rust Iron Block",
	nodenames = {
		"pigiron:iron_block", "stairs:slab_iron_block",
		"stairs:stair_iron_block"
	},
	neighbors = {"group:water"},
	interval = 20,
	chance = 300,
	catch_up = false,
	action = function(pos, node)

		if node.name == "pigiron:iron_block" then
			minetest.set_node(pos, {name = "pigiron:rusted_iron_block"})

		elseif node.name == "stairs:slab_iron_block" then
			minetest.set_node(pos, {name = "stairs:slab_rusted_iron_block",
					param2 = node.param2})

		elseif node.name == "stairs:stair_iron_block" then
			minetest.set_node(pos, {name = "stairs:stair_rusted_iron_block",
					param2 = node.param2})
		end
	end
})

-- Add Tools and Lucky Blocks

local path = minetest.get_modpath("pigiron")

dofile(path .. "/tools.lua")
dofile(path .. "/lucky_block.lua")

-- Change Xpanes Iron Bar Recipe to use Iron Ingots

if minetest.get_modpath("xpanes")
and minetest.registered_nodes["xpanes:bar_flat"]
and not minetest.registered_nodes["default:permafrost"] then

	minetest.clear_craft({
		output = "xpanes:bar_flat"
	})

	minetest.register_craft({
		output = "xpanes:bar_flat",
		recipe = {
			{"pigiron:iron_ingot", "pigiron:iron_ingot", "pigiron:iron_ingot"},
			{"pigiron:iron_ingot", "pigiron:iron_ingot", "pigiron:iron_ingot"}
		}
	})
end

-- Register Stairs

if minetest.get_modpath("stairs") then

	stairs.register_stair_and_slab("iron_block", "pigiron:iron_block",
		{cracky = 1},
		{"pigiron_iron_block.png"},
		"Iron Block Stair",
		"Iron Block Slab",
		default.node_sound_metal_defaults())

	stairs.register_stair_and_slab("rusted_iron_block", "pigiron:rusted_iron_block",
		{cracky = 1},
		{"pigiron_rusted_iron_block.png"},
		"Rusted Iron Block Stair",
		"Rusted Iron Block Slab",
		default.node_sound_metal_defaults())

	-- Cook Rusted Iron Stairs and Slabs Back Into Normal Iron Stairs
	minetest.register_craft({
		output = "stairs:stair_iron_block",
		type = "cooking",
		recipe = "stairs:stair_rusted_iron_block",
		cooktime = 5
	})

	minetest.register_craft({
		output = "stairs:slab_iron_block",
		type = "cooking",
		recipe = "stairs:slab_rusted_iron_block",
		cooktime = 5
	})
end

print("[MOD] Pig Iron loaded")
