
local S = ethereal.intllib

-- Crystal Spike (Hurts if you touch it - thanks to ZonerDarkRevention for his DokuCraft DeviantArt crystal texture)
minetest.register_node("ethereal:crystal_spike", {
	description = S("Crystal Spike"),
	drawtype = "plantlike",
	tiles = { "crystal_spike.png" },
	inventory_image = "crystal_spike.png",
	wield_image = "crystal_spike.png",
	paramtype = "light",
	light_source = 7,
	sunlight_propagates = true,
	walkable = true,
	damage_per_second = 1,
	groups = {cracky = 1, falling_node = 1, puts_out_fire = 1, cools_lava = 1},
	sounds = default.node_sound_glass_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-5 / 16, -0.5, -5 / 16, 5 / 16, 0, 5 / 16},
	},
	node_box = {
		type = "fixed",
		fixed = {-5 / 16, -0.5, -5 / 16, 5 / 16, 0, 5 / 16},
	},
})

-- Crystal Ingot
minetest.register_craftitem("ethereal:crystal_ingot", {
	description = S("Crystal Ingot"),
	inventory_image = "crystal_ingot.png",
	wield_image = "crystal_ingot.png",
})

if minetest.get_modpath("builtin_item") then

	minetest.override_item("ethereal:crystal_spike", {

		dropped_step = function(self, pos, dtime)

			self.ctimer = (self.ctimer or 0) + dtime
			if self.ctimer < 5.0 then return end
			self.ctimer = 0

			if self.node_inside
			and self.node_inside.name ~= "default:water_source" then
				return
			end

			local objs = core.get_objects_inside_radius(pos, 0.8)

			if not objs or #objs ~= 2 then return end

			local crystal, mese, ent = nil, nil, nil

			for k, obj in pairs(objs) do

				ent = obj:get_luaentity()

				if ent and ent.name == "__builtin:item" then

					if ent.itemstring == "default:mese_crystal 2"
					and not mese then

						mese = obj

					elseif ent.itemstring == "ethereal:crystal_spike 2"
					and not crystal then

						crystal = obj
					end
				end
			end

			if mese and crystal then

				mese:remove()
				crystal:remove()

				core.add_item(pos, "ethereal:crystal_ingot")

				return false
			end
		end
	})
end

minetest.register_craft({
	type = "shapeless",
	output = "ethereal:crystal_ingot",
	recipe = {
		"default:mese_crystal", "ethereal:crystal_spike",
		"ethereal:crystal_spike", "default:mese_crystal", "bucket:bucket_water"
	},
	replacements = { {"bucket:bucket_water", "bucket:bucket_empty"} }
})

-- Crystal Block
minetest.register_node("ethereal:crystal_block", {
	description = S("Crystal Block"),
	tiles = {"crystal_block.png"},
	light_source = 9,
	is_ground_content = false,
	groups = {cracky = 1, level = 2, puts_out_fire = 1, cools_lava = 1},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_craft({
	output = "ethereal:crystal_block",
	recipe = {
		{"ethereal:crystal_ingot", "ethereal:crystal_ingot", "ethereal:crystal_ingot"},
		{"ethereal:crystal_ingot", "ethereal:crystal_ingot", "ethereal:crystal_ingot"},
		{"ethereal:crystal_ingot", "ethereal:crystal_ingot", "ethereal:crystal_ingot"},
	}
})

minetest.register_craft({
	output = "ethereal:crystal_ingot 9",
	recipe = {
		{"ethereal:crystal_block"},
	}
})

-- Crystal Sword (Powerful wee beastie)
minetest.register_tool("ethereal:sword_crystal", {
	description = S("Crystal Sword"),
	inventory_image = "crystal_sword.png",
	wield_image = "crystal_sword.png",
	tool_capabilities = {
		full_punch_interval = 0.6,
		max_drop_level = 1,
		groupcaps = {
			snappy = {
				times = {[1] = 1.70, [2] = 0.70, [3] = 0.25},
				uses = 50,
				maxlevel = 3
			},
		},
		damage_groups = {fleshy = 10},
	},
	groups = {sword = 1},
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_craft({
	output = "ethereal:sword_crystal",
	recipe = {
		{"ethereal:crystal_ingot"},
		{"ethereal:crystal_ingot"},
		{"default:steel_ingot"},
	}
})

-- Crystal Axe
minetest.register_tool("ethereal:axe_crystal", {
	description = S("Crystal Axe"),
	inventory_image = "crystal_axe.png",
	wield_image = "crystal_axe.png",
	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level = 1,
		groupcaps = {
			choppy = {
				times = {[1] = 2.00, [2] = 0.80, [3] = 0.40},
				uses = 40,
				maxlevel = 3
			},
		},
		damage_groups = {fleshy = 7},
	},
	groups = {axe = 1},
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_craft({
	output = "ethereal:axe_crystal",
	recipe = {
		{"ethereal:crystal_ingot", "ethereal:crystal_ingot"},
		{"ethereal:crystal_ingot", "default:steel_ingot"},
		{"", "default:steel_ingot"},
	}
})

minetest.register_craft({
	output = "ethereal:axe_crystal",
	recipe = {
		{"ethereal:crystal_ingot", "ethereal:crystal_ingot"},
		{"default:steel_ingot", "ethereal:crystal_ingot"},
		{"default:steel_ingot", ""},
	}
})

-- Crystal Pick (This will last a while)
minetest.register_tool("ethereal:pick_crystal", {
	description = S("Crystal Pickaxe"),
	inventory_image = "crystal_pick.png",
	wield_image = "crystal_pick.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level = 3,
		groupcaps={
			cracky = {
				times = {[1] = 1.8, [2] = 0.8, [3] = 0.40},
				uses = 40,
				maxlevel = 3
			},
		},
		damage_groups = {fleshy = 6},
	},
	groups = {pickaxe = 1},
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_craft({
	output = "ethereal:pick_crystal",
	recipe = {
		{"ethereal:crystal_ingot", "ethereal:crystal_ingot", "ethereal:crystal_ingot"},
		{"", "default:steel_ingot", ""},
		{"", "default:steel_ingot", ""},
	}
})

local old_handle_node_drops = minetest.handle_node_drops

function minetest.handle_node_drops(pos, drops, digger)

	-- are we holding Crystal Shovel?
	if not digger
	or digger:get_wielded_item():get_name() ~= "ethereal:shovel_crystal" then
		return old_handle_node_drops(pos, drops, digger)
	end

	local nn = minetest.get_node(pos).name

	if minetest.get_item_group(nn, "crumbly") == 0 then
		return old_handle_node_drops(pos, drops, digger)
	end

	return old_handle_node_drops(pos, {ItemStack(nn)}, digger)
end


minetest.register_tool("ethereal:shovel_crystal", {
	description = "Crystal Shovel",
	inventory_image = "crystal_shovel.png",
	wield_image = "crystal_shovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 1,
		groupcaps = {
			crumbly = {
				times = {[1] = 1.10, [2] = 0.50, [3] = 0.30},
				uses = 30,
				maxlevel = 3
			},
		},
		damage_groups = {fleshy = 4},
	},
	groups = {shovel = 1},
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_craft({
	output = "ethereal:shovel_crystal",
	recipe = {
		{"ethereal:crystal_ingot"},
		{"default:steel_ingot"},
		{"default:steel_ingot"},
	}
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

	add_tool("ethereal:pick_crystal", "Crystal Pickaxe", true)
	add_tool("ethereal:axe_crystal", "Crystal Axe", true)
	add_tool("ethereal:shovel_crystal", "Crystal Shovel", true)
	add_tool("ethereal:sword_crystal", "Crystal Sword", true)
end
