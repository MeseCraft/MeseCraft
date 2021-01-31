
-- Iron Pickaxe

minetest.register_tool("pigiron:pick_iron", {
	description = "Iron Pickaxe",
	inventory_image = "pigiron_iron_pick.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level = 1,
		groupcaps = {
			cracky = {
				times = {[1] = 2.5, [2] = 1.40, [3] = 0.95},
				uses = 20, maxlevel = 2
			},
		},
		damage_groups = {fleshy = 3},
	},
	groups = {pickaxe = 1},
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_craft({
	output = "pigiron:pick_iron",
	recipe = {
		{"pigiron:iron_ingot", "pigiron:iron_ingot", "pigiron:iron_ingot"},
		{"", "group:stick", ""},
		{"", "group:stick", ""},
	}
})

-- Iron Shovel

minetest.register_tool("pigiron:shovel_iron", {
	description = "Iron Shovel",
	inventory_image = "pigiron_iron_shovel.png",
	wield_image = "pigiron_iron_shovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.3,
		max_drop_level = 1,
		groupcaps = {
			crumbly = {
				times = {[1] = 1.70, [2] = 1.0, [3] = 0.45},
				uses = 25, maxlevel = 1
			},
		},
		damage_groups = {fleshy = 2},
	},
	groups = {shovel = 1},
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_craft({
	output = "pigiron:shovel_iron",
	recipe = {
		{"pigiron:iron_ingot"},
		{"group:stick"},
		{"group:stick"},
	}
})

-- Iron Axe

minetest.register_tool("pigiron:axe_iron", {
	description = "Iron Axe",
	inventory_image = "pigiron_iron_axe.png",
	tool_capabilities = {
		full_punch_interval = 1.1,
		max_drop_level = 1,
		groupcaps = {
			choppy = {
				times = {[1] = 2.70, [2] = 1.70, [3] = 1.15},
				uses = 20, maxlevel = 1
			},
		},
		damage_groups = {fleshy = 3},
	},
	groups = {axe = 1},
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_craft({
	output = "pigiron:axe_iron",
	recipe = {
		{"pigiron:iron_ingot", "pigiron:iron_ingot"},
		{"pigiron:iron_ingot", "group:stick"},
		{"", "group:stick"},
	}
})

-- Iron Sword

minetest.register_tool("pigiron:sword_iron", {
	description = "Iron Sword",
	inventory_image = "pigiron_iron_sword.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 1,
		groupcaps = {
			snappy = {
				times = {[1] = 2.0, [2] = 1.30, [3] = 0.38},
				uses = 25, maxlevel = 1
			},
		},
		damage_groups = {fleshy = 5},
	},
	groups = {sword = 1},
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_craft({
	output = "pigiron:sword_iron",
	recipe = {
		{"pigiron:iron_ingot"},
		{"pigiron:iron_ingot"},
		{"group:stick"},
	}
})

-- Iron Hoe

if minetest.get_modpath("farming") then

	farming.register_hoe(":farming:hoe_iron", {
		description = "Iron Hoe",
		inventory_image = "pigiron_iron_hoe.png",
		max_uses = 150,
		material = "pigiron:iron_ingot"
	})

	-- Toolranks support if farming redo active
	if farming and farming.mod
	and minetest.get_modpath("toolranks") then
		minetest.override_item("farming:hoe_iron", {
			original_description = "Iron Hoe",
			description = toolranks.create_description("Iron Hoe")})
	end
end

-- Switch Tool Capabilities between Steel and Bronze Tools
-- Note: Steel is much stronger than Bronze in real life.

minetest.override_item("default:pick_steel", {
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 1,
		groupcaps = {
			cracky = {
				times = {[1] = 4.50, [2] = 1.80, [3] = 0.90},
				uses = 20, maxlevel = 2
			},
		},
		damage_groups = {fleshy = 4},
	},
})

minetest.override_item("default:pick_bronze", {
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 1,
		groupcaps = {
			cracky = {
				times = {[1] = 4.00, [2] = 1.60, [3] = 0.80},
				uses = 20, maxlevel = 2
			},
		},
		damage_groups = {fleshy = 4},
	},
})

minetest.override_item("default:shovel_steel", {
	tool_capabilities = {
		full_punch_interval = 1.1,
		max_drop_level = 1,
		groupcaps = {
			crumbly = {
				times = {[1] = 1.65, [2] = 1.05, [3] = 0.45},
				uses = 25, maxlevel = 2
			},
		},
		damage_groups = {fleshy = 3},
	},
})

minetest.override_item("default:shovel_bronze", {
	tool_capabilities = {
		full_punch_interval = 1.1,
		max_drop_level = 1,
		groupcaps = {
			crumbly = {
				times = {[1] = 1.50, [2] = 0.90, [3] = 0.40},
				uses = 30, maxlevel = 2
			},
		},
		damage_groups = {fleshy = 3},
	},
})

minetest.override_item("default:axe_steel", {
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 1,
		groupcaps = {
			choppy = {
				times = {[1] = 2.75, [2] = 1.70, [3] = 1.15},
				uses = 20, maxlevel = 2
			},
		},
		damage_groups = {fleshy = 4},
	},
})

minetest.override_item("default:axe_bronze", {
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 1,
		groupcaps = {
			choppy = {
				times = {[1] = 2.50, [2] = 1.40, [3] = 1.00},
				uses = 20, maxlevel = 2
			},
		},
		damage_groups = {fleshy = 4},
	},
})

minetest.override_item("default:sword_steel", {
	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level = 1,
		groupcaps = {
			snappy = {
				times = {[1] = 2.75, [2] = 1.30, [3] = 0.375},
				uses = 25, maxlevel = 2
			},
		},
		damage_groups = {fleshy = 6},
	},
})

minetest.override_item("default:sword_bronze", {
	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level = 1,
		groupcaps = {
			snappy = {
				times = {[1] = 2.5, [2] = 1.20, [3] = 0.35},
				uses = 30, maxlevel = 2
			},
		},
		damage_groups = {fleshy = 6},
	},
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

	add_tool("pigiron:pick_iron", "Iron Pickaxe", true)
	add_tool("pigiron:axe_iron", "Iron Axe", true)
	add_tool("pigiron:shovel_iron", "Iron Shovel", true)
	add_tool("pigiron:sword_iron", "Iron Sword", true)
end
