ts_doors = {}

ts_doors.registered_doors = {}

ts_doors.sounds = {}

if default.node_sound_metal_defaults then
	ts_doors.sounds.metal = {
		sounds = default.node_sound_metal_defaults(),
		sound_open = "doors_steel_door_open",
		sound_close = "doors_steel_door_close",
	}
else
	ts_doors.sounds.metal = {
		sounds = default.node_sound_stone_defaults(),
		sound_open = "doors_steel_door_open",
		sound_close = "doors_steel_door_close",
	}
end

ts_doors.sounds.wood = {
	sounds = default.node_sound_wood_defaults(),
	sound_open = "doors_door_open",
	sound_close = "doors_door_close"
}

ts_doors.sounds.glass = {
	sounds = default.node_sound_glass_defaults(),
	sound_open = "doors_glass_door_open",
	sound_close = "doors_glass_door_close",
}

local function get_door_name(meta, item)
	local door = ""
	local trapdoor = meta:get_int("trapdoor") == 1
	local locked = meta:get_int("locked") == 1
	local solid = meta:get_int("solid") == 1
	if trapdoor then
		if locked then
			if solid then
				door = "ts_doors:trapdoor_full_locked_" .. item:gsub(":", "_")
			else
				door = "ts_doors:trapdoor_locked_" .. item:gsub(":", "_")
			end
		else
			if solid then
				door = "ts_doors:trapdoor_full_" .. item:gsub(":", "_")
			else
				door = "ts_doors:trapdoor_" .. item:gsub(":", "_")
			end
		end
	else
		if locked then
			if solid then
				door = "ts_doors:door_full_locked_" .. item:gsub(":", "_")
			else
				door = "ts_doors:door_locked_" .. item:gsub(":", "_")
			end
		else
			if solid then
				door = "ts_doors:door_full_" .. item:gsub(":", "_")
			else
				door = "ts_doors:door_" .. item:gsub(":", "_")
			end
		end
	end
	return door
end

local function register_alias(name, convert_to)
	minetest.register_alias(name, convert_to)
	minetest.register_alias(name .. "_a", convert_to .. "_a")
	minetest.register_alias(name .. "_b", convert_to .. "_b")
end

function ts_doors.register_door(item, description, texture, sounds, recipe)
	if not minetest.registered_nodes[item] then
		minetest.log("[ts_doors] bug found: "..item.." is not a registered node. Cannot create doors")
		return
	end
	if not sounds then
		sounds = {}
	end
	recipe = recipe or item
	ts_doors.registered_doors[item:gsub(":", "_")] = recipe
	register_alias("doors:ts_door_" .. item:gsub(":", "_"), "ts_doors:door_" .. item:gsub(":", "_"))
	register_alias("doors:ts_door_full_" .. item:gsub(":", "_"), "ts_doors:door_full_" .. item:gsub(":", "_"))
	register_alias("doors:ts_door_locked_" .. item:gsub(":", "_"), "ts_doors:door_locked_" .. item:gsub(":", "_"))
	register_alias("doors:ts_door_full_locked_" .. item:gsub(":", "_"), "ts_doors:door_full_locked_" .. item:gsub(":", "_"))

	local groups = minetest.registered_nodes[item].groups
	local door_groups = {door=1}
	for k, v in pairs(groups) do
		if k ~= "wood" then
			door_groups[k] = v
		end
	end

	doors.register("ts_doors:door_" .. item:gsub(":", "_"), {
		tiles = { { name = "[combine:32x38:0,0=" .. texture .. ":0,16=" .. texture .. ":0,32=" .. texture .. ":16,0=" .. texture .. ":16,16=" .. texture .. ":16,32=" .. texture .. "^[transformR90^[colorize:#fff:30^ts_doors_base.png^[noalpha^[makealpha:0,255,0", backface_culling = true } },
		description = description .. " Windowed Door",
		inventory_image = "[combine:32x32:0,8=" .. texture .. ":16,8=" .. texture .. "^[transformR90^[colorize:#fff:30^ts_doors_base_inv.png^[noalpha^[makealpha:0,255,0",
		groups = table.copy(door_groups),
		sounds = sounds.sounds or nil,
		sound_open = sounds.sound_open or nil,
		sound_close = sounds.sound_close or nil,
	})

	doors.register("ts_doors:door_full_" .. item:gsub(":", "_"), {
		tiles = { { name = "[combine:32x38:0,0=" .. texture .. ":0,16=" .. texture .. ":0,32=" .. texture .. ":16,0=" .. texture .. ":16,16=" .. texture .. ":16,32=" .. texture .. "^[transformR90^[colorize:#fff:30^ts_doors_base_full.png^[noalpha", backface_culling = true } },
		description = "Solid " .. description .. " Door",
		inventory_image = "[combine:32x32:0,8=" .. texture .. ":16,8=" .. texture .. "^[transformR90^[colorize:#fff:30^ts_doors_base_full_inv.png^[noalpha^[makealpha:0,255,0",
		groups = table.copy(door_groups),
		sounds = sounds.sounds or nil,
		sound_open = sounds.sound_open or nil,
		sound_close = sounds.sound_close or nil,
	})

	doors.register_trapdoor("ts_doors:trapdoor_" .. item:gsub(":", "_"), {
		description = "Windowed " .. description .. " Trapdoor",
		inventory_image = texture .. "^[transformR90^[colorize:#fff:30^ts_doors_base_trapdoor.png^[noalpha^[makealpha:0,255,0",
		wield_image = texture .. "^[transformR90^[colorize:#fff:30^ts_doors_base_trapdoor.png^[noalpha^[makealpha:0,255,0",
		tile_front = texture .. "^[transformR90^[colorize:#fff:30^ts_doors_base_trapdoor.png^[noalpha^[makealpha:0,255,0",
		tile_side = texture .. "^[colorize:#fff:30",
		groups = table.copy(door_groups),
		sounds = sounds.sounds or nil,
		sound_open = sounds.sound_open or nil,
		sound_close = sounds.sound_close or nil,
	})

	doors.register_trapdoor("ts_doors:trapdoor_full_" .. item:gsub(":", "_"), {
		description = "Solid " .. description .. " Trapdoor",
		inventory_image = texture .. "^[transformR90^[colorize:#fff:30^ts_doors_base_trapdoor_full.png^[noalpha",
		wield_image = texture .. "^[transformR90^[colorize:#fff:30^ts_doors_base_trapdoor_full.png^[noalpha",
		tile_front = texture .. "^[transformR90^[colorize:#fff:30^ts_doors_base_trapdoor_full.png^[noalpha",
		tile_side = texture .. "^[colorize:#fff:30",
		groups = table.copy(door_groups),
		sounds = sounds.sounds or nil,
		sound_open = sounds.sound_open or nil,
		sound_close = sounds.sound_close or nil,
	})

	door_groups.level = 2

	doors.register("ts_doors:door_locked_" .. item:gsub(":", "_"), {
		tiles = { { name = "[combine:32x38:0,0=" .. texture .. ":0,16=" .. texture .. ":0,32=" .. texture .. ":16,0=" .. texture .. ":16,16=" .. texture .. ":16,32=" .. texture .. "^[transformR90^[colorize:#fff:30^ts_doors_base_locked.png^[noalpha^[makealpha:0,255,0", backface_culling = true } },
		description = "Windowed Locked " .. description .. " Door",
		inventory_image = "[combine:32x32:0,8=" .. texture .. ":16,8=" .. texture .. "^[transformR90^[colorize:#fff:30^ts_doors_base_locked_inv.png^[noalpha^[makealpha:0,255,0",
		protected = true,
		groups = table.copy(door_groups),
		sound_open = "doors_steel_door_open",
		sound_close = "doors_steel_door_close",
		sounds = sounds.sounds or nil,
		sound_open = sounds.sound_open or nil,
		sound_close = sounds.sound_close or nil,
	})

	doors.register("ts_doors:door_full_locked_" .. item:gsub(":", "_"), {
		tiles = { { name = "[combine:32x38:0,0=" .. texture .. ":0,16=" .. texture .. ":0,32=" .. texture .. ":16,0=" .. texture .. ":16,16=" .. texture .. ":16,32=" .. texture .. "^[transformR90^[colorize:#fff:30^ts_doors_base_full_locked.png^[noalpha", backface_culling = true } },
		description = "Solid Locked " .. description .. " Door",
		inventory_image = "[combine:32x32:0,8=" .. texture .. ":16,8=" .. texture .. "^[transformR90^[colorize:#fff:30^ts_doors_base_full_locked_inv.png^[noalpha^[makealpha:0,255,0",
		protected = true,
		groups = table.copy(door_groups),
		sound_open = "doors_steel_door_open",
		sound_close = "doors_steel_door_close",
		sounds = sounds.sounds or nil,
		sound_open = sounds.sound_open or nil,
		sound_close = sounds.sound_close or nil,
	})

	doors.register_trapdoor("ts_doors:trapdoor_locked_" .. item:gsub(":", "_"), {
		description = "Windowed Locked " .. description .. " Trapdoor",
		inventory_image = texture .. "^[transformR90^[colorize:#fff:30^ts_doors_base_trapdoor_locked.png^[noalpha^[makealpha:0,255,0",
		wield_image = texture .. "^[transformR90^[colorize:#fff:30^ts_doors_base_trapdoor_locked.png^[noalpha^[makealpha:0,255,0",
		tile_front = texture .. "^[transformR90^[colorize:#fff:30^ts_doors_base_trapdoor_locked.png^[noalpha^[makealpha:0,255,0",
		tile_side = texture .. "^[colorize:#fff:30",
		protected = true,
		groups = table.copy(door_groups),
		sounds = sounds.sounds or nil,
		sound_open = sounds.sound_open or nil,
		sound_close = sounds.sound_close or nil,
	})

	doors.register_trapdoor("ts_doors:trapdoor_full_locked_" .. item:gsub(":", "_"), {
		description = "Solid Locked " .. description .. " Trapdoor",
		inventory_image = texture .. "^[transformR90^[colorize:#fff:30^ts_doors_base_trapdoor_full_locked.png^[noalpha",
		wield_image = texture .. "^[transformR90^[colorize:#fff:30^ts_doors_base_trapdoor_full_locked.png^[noalpha",
		tile_front = texture .. "^[transformR90^[colorize:#fff:30^ts_doors_base_trapdoor_full_locked.png^[noalpha",
		tile_side = texture .. "^[colorize:#fff:30",
		protected = true,
		groups = table.copy(door_groups),
		sounds = sounds.sounds or nil,
		sound_open = sounds.sound_open or nil,
		sound_close = sounds.sound_close or nil,
	})
end

ts_doors.register_door("default:aspen_wood", "Aspen", "default_aspen_wood.png", ts_doors.sounds.wood)
ts_doors.register_door("default:pine_wood", "Pine", "default_pine_wood.png", ts_doors.sounds.wood)
ts_doors.register_door("default:acacia_wood", "Acacia", "default_acacia_wood.png", ts_doors.sounds.wood)
ts_doors.register_door("default:wood", "Wooden", "default_wood.png", ts_doors.sounds.wood)
ts_doors.register_door("default:junglewood", "Jungle Wood", "default_junglewood.png", ts_doors.sounds.wood)

if minetest.get_modpath("moretrees") then
	ts_doors.register_door("moretrees:apple_tree_planks", "Apple Tree", "moretrees_apple_tree_wood.png", ts_doors.sounds.wood)
	ts_doors.register_door("moretrees:beech_planks", "Beech", "moretrees_beech_wood.png", ts_doors.sounds.wood)
	ts_doors.register_door("moretrees:birch_planks", "Birch", "moretrees_birch_wood.png", ts_doors.sounds.wood)
	ts_doors.register_door("moretrees:fir_planks", "Fir", "moretrees_fir_wood.png", ts_doors.sounds.wood)
	ts_doors.register_door("moretrees:oak_planks", "Oak", "moretrees_oak_wood.png", ts_doors.sounds.wood)
	ts_doors.register_door("moretrees:palm_planks", "Palm", "moretrees_palm_wood.png", ts_doors.sounds.wood)
	ts_doors.register_door("moretrees:rubber_tree_planks", "Rubber Tree", "moretrees_rubber_tree_wood.png", ts_doors.sounds.wood)
	ts_doors.register_door("moretrees:sequoia_planks", "Sequoia", "moretrees_sequoia_wood.png", ts_doors.sounds.wood)
	ts_doors.register_door("moretrees:spruce_planks", "Spruce", "moretrees_spruce_wood.png", ts_doors.sounds.wood)
	ts_doors.register_door("moretrees:willow_planks", "Willow", "moretrees_willow_wood.png", ts_doors.sounds.wood)
end

if minetest.get_modpath("ethereal") then
	ts_doors.register_door("ethereal:banana_wood", "Banana", "banana_wood.png", ts_doors.sounds.wood)
	ts_doors.register_door("ethereal:birch_wood", "Birch", "moretrees_birch_wood.png", ts_doors.sounds.wood)
	ts_doors.register_door("ethereal:frost_wood", "Frost", "frost_wood.png", ts_doors.sounds.wood)
	ts_doors.register_door("ethereal:mushroom_trunk", "Mushroom", "mushroom_trunk.png", ts_doors.sounds.wood)
	ts_doors.register_door("ethereal:palm_wood", "Palm", "moretrees_palm_wood.png", ts_doors.sounds.wood)
	ts_doors.register_door("ethereal:redwood_wood", "Redwood", "redwood_wood.png", ts_doors.sounds.wood)
	ts_doors.register_door("ethereal:sakura_wood", "Sakura", "ethereal_sakura_wood.png", ts_doors.sounds.wood)
	ts_doors.register_door("ethereal:scorched_tree", "Scorched", "scorched_tree.png", ts_doors.sounds.wood)
	ts_doors.register_door("ethereal:willow_wood", "Willow", "willow_wood.png", ts_doors.sounds.wood)
	ts_doors.register_door("ethereal:yellow_wood", "Healing Tree", "yellow_wood.png", ts_doors.sounds.wood)
	ts_doors.register_door("ethereal:crystal_block", "Crystal", "crystal_block.png", ts_doors.sounds.metal, "ethereal:crystal_ingot")
end


ts_doors.register_door("default:bronzeblock", "Bronze", "default_bronze_block.png", ts_doors.sounds.metal, "default:bronze_ingot")
ts_doors.register_door("default:copperblock", "Copper", "default_copper_block.png", ts_doors.sounds.metal, "default:copper_ingot")
ts_doors.register_door("default:diamondblock", "Diamond", "default_diamond_block.png", ts_doors.sounds.metal, "default:diamond")
ts_doors.register_door("default:goldblock", "Gold", "default_gold_block.png", ts_doors.sounds.metal, "default:gold_ingot")
ts_doors.register_door("default:steelblock", "Steel", minetest.registered_nodes["default:steelblock"].tiles[1], ts_doors.sounds.metal, "default:steel_ingot")

if minetest.get_modpath("moreores") then
	ts_doors.register_door("moreores:mithril_block", "Mithril", "moreores_mithril_block.png", ts_doors.sounds.metal, "moreores:mithril_ingot")
	ts_doors.register_door("moreores:silver_block", "Silver", "moreores_silver_block.png", ts_doors.sounds.metal, "moreores:silver_ingot")
--	ts_doors.register_door("moreores:tin_block", "Tin", "moreores_tin_block.png", ts_doors.sounds.metal, "moreores:tin_ingot")
end

if minetest.get_modpath("technic") then
--	ts_doors.register_door("technic:brass_block", "Brass", "technic_brass_block.png", ts_doors.sounds.metal, "technic:brass_ingot")
	ts_doors.register_door("technic:carbon_steel_block", "Carbon Steel", "technic_carbon_steel_block.png", ts_doors.sounds.metal, "technic:carbon_steel_ingot")
	ts_doors.register_door("technic:cast_iron_block", "Cast Iron", "technic_cast_iron_block.png", ts_doors.sounds.metal, "technic:cast_iron_ingot")
	ts_doors.register_door("technic:chromium_block", "Chromium", "technic_chromium_block.png", ts_doors.sounds.metal, "technic:chromium_ingot")
	ts_doors.register_door("technic:lead_block", "Lead", "technic_lead_block.png", ts_doors.sounds.metal, "technic:lead_ingot")
	ts_doors.register_door("technic:stainless_steel_block", "Stainless Steel", "technic_stainless_steel_block.png", ts_doors.sounds.metal, "technic:stainless_steel_ingot")
	ts_doors.register_door("technic:zinc_block", "Zinc", "technic_zinc_block.png", ts_doors.sounds.metal, "technic:zinc_ingot")

--	ts_doors.register_door("technic:concrete", "Concrete", "technic_concrete_block.png", ts_doors.sounds.metal)
	ts_doors.register_door("technic:blast_resistant_concrete", "Blast Resistant Concrete", "technic_blast_resistant_concrete_block.png", ts_doors.sounds.metal)
end

if minetest.get_modpath("df_trees") then
        ts_doors.register_door("df_trees:black_cap_wood", "Black Cap", "dfcaverns_black_cap_wood.png",ts_doors.sounds.wood,"df_trees:black_cap_wood")
        ts_doors.register_door("df_trees:blood_thorn_wood", "Blood Thorn", "dfcaverns_blood_thorn_wood.png",ts_doors.sounds.wood,"df_trees:blood_thorn_wood")
        ts_doors.register_door("df_trees:fungiwood_wood", "Fungiwood", "dfcaverns_fungiwood_wood.png",ts_doors.sounds.wood,"df_trees:fungiwood_wood")
        ts_doors.register_door("df_trees:goblin_cap_stem_wood", "Goblin Cap Stem", "dfcaverns_goblin_cap_stem_wood.png",ts_doors.sounds.wood,"df_trees:goblin_cap_stem_wood")
        ts_doors.register_door("df_trees:goblin_cap_wood", "Goblin Cap", "dfcaverns_goblin_cap_wood.png",ts_doors.sounds.wood,"df_trees:goblin_cap_wood")
        ts_doors.register_door("df_trees:nether_cap_wood", "Nether Cap", "dfcaverns_nether_cap_wood.png",ts_doors.sounds.wood,"df_trees:nether_cap_wood")
        ts_doors.register_door("df_trees:tower_cap_wood", "Tower Cap", "dfcaverns_tower_cap_wood.png",ts_doors.sounds.wood,"df_trees:tower_cap_wood")
        ts_doors.register_door("df_trees:spore_tree_wood", "Spore Tree", "dfcaverns_spore_tree_wood.png",ts_doors.sounds.wood,"df_trees:spore_tree_wood")
        ts_doors.register_door("df_trees:tunnel_tube_wood", "Tunnel Tube", "dfcaverns_tunnel_tube_wood_side.png",ts_doors.sounds.wood,"df_trees:tunnel_tube_wood")
end


minetest.override_item("doors:door_steel", {
	description = "Windowed Locked Plain Steel Door",
})

minetest.override_item("doors:door_wood", {
	description = "Windowed Mixed Wood Door",
})

minetest.override_item("doors:trapdoor", {
	description = "Windowed Mixed Wood Trapdoor",
})

minetest.override_item("doors:trapdoor_steel", {
	description = "Windowed Locked Plain Steel Trapdoor",
})




ts_doors.workshop = {}

function ts_doors.workshop.update_formspec(pos)
	local meta = minetest.get_meta(pos)
	local page = meta:get_int("page")
	local maxpage = meta:get_int("maxpage")
	local selection = meta:get_string("selection")

	local trapdoor = meta:get_int("trapdoor") == 1
	local locked = meta:get_int("locked") == 1
	local solid = meta:get_int("solid") == 1

	if page < 1 then
		page = maxpage
	elseif page > maxpage then
		page = 1
	end
	meta:set_int("page", page)

	local fs = "size[9,9;]"
	fs = fs .. default.gui_bg .. default.gui_bg_img .. default.gui_slots
	if minetest.colorize then
		if not locked then
			fs = fs .. "button[0,0;2,1;unlocked;" .. minetest.colorize("#ffff00", "Unlocked") .. "]"
			fs = fs .. "button[0,0.75;2,1;locked;Locked]"
		else
			fs = fs .. "button[0,0;2,1;unlocked;Unlocked]"
			fs = fs .. "button[0,0.75;2,1;locked;" .. minetest.colorize("#ffff00", "Locked") .. "]"
		end

		if not solid then
			fs = fs .. "button[2,0;2,1;windowed;" .. minetest.colorize("#ffff00", "Windowed") .. "]"
			fs = fs .. "button[2,0.75;2,1;solid;Solid]"
		else
			fs = fs .. "button[2,0;2,1;windowed;Windowed]"
			fs = fs .. "button[2,0.75;2,1;solid;" .. minetest.colorize("#ffff00", "Solid") .. "]"
		end

		if not trapdoor then
			fs = fs .. "button[4,0;2,1;doors;" .. minetest.colorize("#ffff00", "Doors") .. "]"
			fs = fs .. "button[4,0.75;2,1;trapdoors;Trapdoors]"
		else
			fs = fs .. "button[4,0;2,1;doors;Doors]"
			fs = fs .. "button[4,0.75;2,1;trapdoors;" .. minetest.colorize("#ffff00", "Trapdoors") .. "]"
		end
	else
		fs = fs .. "button[0,0;2,1;unlocked;Unlocked]"
		fs = fs .. "button[0,0.75;2,1;locked;Locked]"
		fs = fs .. "button[2,0;2,1;windowed;Windowed]"
		fs = fs .. "button[2,0.75;2,1;solid;Solid]"
		fs = fs .. "button[4,0;2,1;doors;Doors]"
		fs = fs .. "button[4,0.75;2,1;trapdoors;Trapdoors]"
	end

	fs = fs .. "label[0,1.6;Material]"
	fs = fs .. "label[0,1.9;needed]"
	fs = fs .. "list[context;material_needed;0,2.3;1,1]"
	fs = fs .. "label[0,3.25;Input]"
	fs = fs .. "list[context;material;0,3.75;1,1]"
	fs = fs .. "label[1,1.6;Steel]"
	fs = fs .. "label[1,1.9;needed]"
	fs = fs .. "list[context;steel_needed;1,2.3;1,1]"
	fs = fs .. "label[1,3.25;Input]"
	fs = fs .. "list[context;steel;1,3.75;1,1]"
	local x = 2
	local y = 1.75
	local count = 0
	for item, recipe in pairs(ts_doors.registered_doors) do
		count = count + 1
		if (count >= (page - 1) * 12 + 1 and count <= page * 12) then
			local door = get_door_name(meta, item)
			fs = fs .. "item_image_button[" .. x .. "," .. y .. ";1,1;" .. door .. ";" .. door .. ";]"
			x = x + 1
			if x > 5 then
				x = 2
				y = y + 1
			end
		end
	end
	fs = fs .. "button[6, 1;1,1;noselection;X]"
	fs = fs .. "tooltip[noselection;Remove Current Selection]"
	if maxpage > 1 then
		fs = fs .. "button[6,2.25;1,1;prevpage;<-]"
		fs = fs .. "button[6,3.25;1,1;nextpage;->]"
		fs = fs .. "label[6,4;" .. string.format("Page %s of %s", page, maxpage) .. "]"
	end
	fs = fs .. "label[7.5,0.2;Current]"
	fs = fs .. "label[7.5,0.5;Door]"
	fs = fs .. "item_image[7.5,1;1,1;" .. selection .. "]"
	fs = fs .. "image[7.5,2;1,1;gui_furnace_arrow_bg.png^[lowpart:" .. meta:get_int("progress") * 10 .. ":gui_furnace_arrow_fg.png^[transformR180]"
	fs = fs .. "list[context;output;7.5,3;1,1]"
	fs = fs .. "list[current_player;main;0.5,5;8,4]"
	fs = fs .. "listring[current_player;main]"
	fs = fs .. "listring[context;material]"
	fs = fs .. "listring[current_player;main]"
	fs = fs .. "listring[context;steel]"
	fs = fs .. "listring[current_player;main]"
	fs = fs .. "listring[context;output]"
	meta:set_string("formspec", fs)
end

local function update_inventory(pos)
	local meta = minetest.get_meta(pos)

	local itemcount = 0
	for k, v in pairs(ts_doors.registered_doors) do
		itemcount = itemcount + 1
	end

	meta:set_int("maxpage", math.ceil(itemcount / 16))
	local inv = meta:get_inventory()
	inv:set_size("material_needed", 0)
	inv:set_size("material_needed", 1)
	inv:set_size("steel_needed", 0)
	inv:set_size("steel_needed", 1)
	inv:set_size("material", 1)
	inv:set_size("steel", 1)
	inv:set_size("output", 1)

	local trapdoor = meta:get_int("trapdoor") == 1
	local locked = meta:get_int("locked") == 1
	local solid = meta:get_int("solid") == 1

	for item, recipe in pairs(ts_doors.registered_doors) do
		if trapdoor then
			if locked then
				if solid then
					inv:add_item("list", "ts_doors:trapdoor_full_locked_" .. item:gsub(":", "_"))
				else
					inv:add_item("list", "ts_doors:trapdoor_locked_" .. item:gsub(":", "_"))
				end
			else
				if solid then
					inv:add_item("list", "ts_doors:trapdoor_full_" .. item:gsub(":", "_"))
				else
					inv:add_item("list", "ts_doors:trapdoor_" .. item:gsub(":", "_"))
				end
			end
		else
			if locked then
				if solid then
					inv:add_item("list", "ts_doors:door_full_locked_" .. item:gsub(":", "_"))
				else
					inv:add_item("list", "ts_doors:door_locked_" .. item:gsub(":", "_"))
				end
			else
				if solid then
					inv:add_item("list", "ts_doors:door_full_" .. item:gsub(":", "_"))
				else
					inv:add_item("list", "ts_doors:door_" .. item:gsub(":", "_"))
				end
			end
		end
	end
	local selection = meta:get_string("selection")
	if selection and selection ~= "" then
		local door = selection:sub(10)
		if door:sub(0, 4) == "trap" then
			trapdoor = true
			door = door:sub(10)
		else
			trapdoor = false
			door = door:sub(6)
		end
		if door:sub(0, 4) == "full" then
			solid = true
			door = door:sub(6)
		else
			solid = false
		end
		if door:sub(0, 7) == "locked_" then
			locked = true
			door = door:sub(8)
		else
			locked = false
		end
		local material_needed = 1
		if trapdoor then
			material_needed = 4
		else
			material_needed = 6
		end
		if solid then
			material_needed = material_needed + 1
		end
		local steel_needed = 0
		if locked then
			steel_needed = 1
		end
		inv:add_item("material_needed", { name = ts_doors.registered_doors[door], count = material_needed })
		inv:add_item("steel_needed", { name = "default:steel_ingot", count = steel_needed })
	end
end

local function on_receive_fields(pos, formname, fields, sender)
	local meta = minetest.get_meta(pos)
	if fields.unlocked then
		meta:set_int("locked", 0)
	elseif fields.locked then
		meta:set_int("locked", 1)
	elseif fields.windowed then
		meta:set_int("solid", 0)
	elseif fields.solid then
		meta:set_int("solid", 1)
	elseif fields.doors then
		meta:set_int("trapdoor", 0)
	elseif fields.trapdoors then
		meta:set_int("trapdoor", 1)
	elseif fields.prevpage then
		meta:set_int("page", meta:get_int("page") - 1)
	elseif fields.nextpage then
		meta:set_int("page", meta:get_int("page") + 1)
	elseif fields.noselection then
		meta:set_string("selection", "")
	else
		for item, recipe in pairs(ts_doors.registered_doors) do
			if fields[get_door_name(meta, item)] then
				meta:set_string("selection", get_door_name(meta, item))
			end
		end
	end
end

local function on_construct(pos)
	local meta = minetest.get_meta(pos)
	meta:set_int("trapdoor", 0)
	meta:set_int("locked", 0)
	meta:set_int("solid", 0)
	meta:set_int("progress", 0)
	meta:set_string("working_on", "")
	meta:set_int("page", 1)
	meta:set_int("maxpage", 1)
	meta:set_string("selection", "")
end

local function allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	return 0
end

local function allow_metadata_inventory_put(pos, listname, index, stack, player)
	if listname == "material" then
		local meta = minetest.get_meta(pos)
		local selection = meta:get_string("selection")
		if selection and selection ~= "" then
			local door = selection:sub(10)
			if door:sub(0, 4) == "trap" then
				door = door:sub(10)
			else
				door = door:sub(6)
			end
			if door:sub(0, 4) == "full" then
				door = door:sub(6)
			end
			if door:sub(0, 7) == "locked_" then
				door = door:sub(8)
			end
			if stack:get_name() == ts_doors.registered_doors[door] then
				return stack:get_count()
			else
				return 0
			end
		else
			return 0
		end
	elseif listname == "steel" and (stack:get_name() == "default:steel_ingot") then
		return stack:get_count()
	else
		return 0
	end
end

local function allow_metadata_inventory_take(pos, listname, index, stack, player)
	if listname == "material" or listname == "steel" or listname == "output" then
		return stack:get_count()
	else
		return 0
	end
end

local function on_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
end

local function on_metadata_inventory_put(pos, listname, index, stack, player)
end

local function on_metadata_inventory_take(pos, listname, index, stack, player)
end

local function can_dig(pos, player)
	local inv = minetest.get_meta(pos):get_inventory()
	if inv:is_empty("material") and inv:is_empty("steel") and inv:is_empty("output") then
		return true
	else
		return false
	end
end

ts_workshop.register_workshop("ts_doors", "workshop", {
	description = "Door Workshop",
	tiles = {
		"default_wood.png",
		"default_wood.png",
		"default_wood.png^doors_item_wood.png",
		"default_wood.png^doors_item_wood.png",
		"default_wood.png",
		"default_wood.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = { choppy = 2, oddly_breakable_by_hand = 2 },
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5, -0.5, 0.5, -0.3125, 0.5 }, -- NodeBox1
			{ -0.5, -0.5, -0.5, -0.375, 0.5, 0.5 }, -- NodeBox2
			{ 0.375, -0.5, -0.5, 0.5, 0.5, 0.5 }, -- NodeBox3
			{ -0.5, -0.5, 0.375, 0.5, 0.5, 0.5 }, -- NodeBox4
			{ -0.5, 0.3125, -0.4375, 0.5, 0.4375, -0.3125 }, -- NodeBox5
		}
	},
	selection_box = {
		type = "regular"
	},
	on_receive_fields = on_receive_fields,
	on_construct = on_construct,
	allow_metadata_inventory_take = allow_metadata_inventory_take,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	allow_metadata_inventory_put = allow_metadata_inventory_put,
	on_metadata_inventory_move = on_metadata_inventory_move,
	on_metadata_inventory_put = on_metadata_inventory_put,
	on_metadata_inventory_take = on_metadata_inventory_take,
	can_dig = can_dig,
	sounds = default.node_sound_wood_defaults(),
	enough_supply = function(pos, selection)
		local meta = minetest.get_meta(pos)
		if meta:get_string("working_on") ~= "" then
			return
		end
		local inv = meta:get_inventory()
		local selection = meta:get_string("selection")
		local material = inv:get_stack("material", 1):get_name()
		local material_needed_name = inv:get_stack("material_needed", 1):get_name()
		local material_needed = inv:get_stack("material_needed", 1):get_count()
		local material_ok = inv:get_stack("material", 1):get_count() >= material_needed
		local steel = inv:get_stack("steel", 1):get_name()
		local steel_needed = inv:get_stack("steel_needed", 1):get_count()
		local steel_ok = inv:get_stack("steel", 1):get_count() >= steel_needed

		if not (material_ok and steel_ok
				and (steel and steel == "default:steel_ingot" or steel_needed == 0)
				and selection and selection ~= ""
				and material == material_needed_name)
		then
			return false
		else
			return true
		end
	end,
	remove_supply = function(pos, selection)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local material = inv:get_stack("material", 1):get_name()
		local material_needed = inv:get_stack("material_needed", 1):get_count()
		local steel_needed = inv:get_stack("steel_needed", 1):get_count()

		inv:remove_item("material", { name = material, count = material_needed })
		inv:remove_item("steel", { name = "default:steel_ingot", count = steel_needed })
	end,
	update_inventory = update_inventory,
	update_formspec = ts_doors.workshop.update_formspec,
	on_receive_fields = on_receive_fields,
	on_construct = on_construct,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_take = allow_metadata_inventory_take,
	can_dig = can_dig,
})

minetest.register_lbm({
	name = "ts_doors:update_door_workshop",
	nodenames = { "ts_doors:door_workshop" },
	action = function(pos, node)
		update_inventory(pos)
	end,
})

minetest.register_craft({
	output = "ts_doors:workshop",
	recipe = {
		{ "default:wood", "default:wood", "default:wood" },
		{ "default:wood", "doors:door_wood", "default:wood" },
		{ "default:wood", "default:wood", "default:wood" },
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "ts_doors:workshop",
	burntime = 30,
})
