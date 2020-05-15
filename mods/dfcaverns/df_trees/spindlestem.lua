-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

local vessels = minetest.get_modpath("vessels")

-- pre-declare
local get_spindlestem_cap_type

-- Copied from subterrane's features.lua
-- Figured that was nicer than adding a dependency for just this little bit
local stem_on_place = function(itemstack, placer, pointed_thing)
	local pt = pointed_thing
	-- check if pointing at a node
	if not pt then
		return itemstack
	end
	if pt.type ~= "node" then
		return itemstack
	end

	local under = minetest.get_node(pt.under)
	local above = minetest.get_node(pt.above)

	if minetest.is_protected(pt.above, placer:get_player_name()) then
		minetest.record_protection_violation(pt.above, placer:get_player_name())
		return
	end

	-- return if any of the nodes is not registered
	if not minetest.registered_nodes[under.name] or not minetest.registered_nodes[above.name] then
		return itemstack
	end
	-- check if you can replace the node above the pointed node
	if not minetest.registered_nodes[above.name].buildable_to then
		return itemstack
	end

	local new_param2
	-- check if pointing at an existing spindlestem
	if minetest.get_item_group(under.name, "spindlestem") > 0 then
		new_param2 = under.param2
	else
		new_param2 = math.random(0,3)
	end

	-- add the node and remove 1 item from the itemstack
	minetest.add_node(pt.above, {name = itemstack:get_name(), param2 = new_param2})
	if not minetest.settings:get_bool("creative_mode", false) then
		itemstack:take_item()
	end
	return itemstack
end

local growth_delay = function()
	return math.random(
		df_trees.config.tower_cap_delay_multiplier*df_trees.config.tree_min_growth_delay,
		df_trees.config.tower_cap_delay_multiplier*df_trees.config.tree_max_growth_delay)
end

local disp = 0.0625 -- adjusting position a bit

minetest.register_node("df_trees:spindlestem_stem", {
	description = S("Spindlestem"),
	_doc_items_longdesc = df_trees.doc.spindlestem_desc,
	_doc_items_usagehelp = df_trees.doc.spindlestem_usage,
	is_ground_content = false,
	groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, spindlestem = 1},
	sounds = default.node_sound_wood_defaults(),
	tiles = {
		"dfcaverns_tower_cap.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625+disp, -0.5, -0.125+disp, 0.1875+disp, 0.5, 0.25+disp},
			{-0.125+disp, -0.5, -0.0625+disp, 0.25+disp, 0.5, 0.1875+disp},
		}
	},
	on_place = stem_on_place,
})

minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:spindlestem_stem",
	burntime = 5,
})

local register_spindlestem_type = function(item_suffix, colour_name, colour_code, light_level)
	local cap_item = "df_trees:spindlestem_cap_"..item_suffix
	
	minetest.register_node(cap_item, {
		description = S("@1 Spindlestem Cap", colour_name),
		is_ground_content = false,
		_doc_items_longdesc = df_trees.doc["spindlestem_cap_"..item_suffix.."_desc"],
		_doc_items_usagehelp = df_trees.doc["spindlestem_cap_"..item_suffix.."_usage"],
		groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, spindlestem = 1},
		sounds = default.node_sound_wood_defaults(),
		tiles = {
			"dfcaverns_tower_cap.png^[multiply:#"..colour_code,
			"dfcaverns_spindlestem_cap.png^[multiply:#"..colour_code,
			"dfcaverns_tower_cap.png^[multiply:#"..colour_code,
			"dfcaverns_tower_cap.png^[multiply:#"..colour_code,
			"dfcaverns_tower_cap.png^[multiply:#"..colour_code,
			"dfcaverns_tower_cap.png^[multiply:#"..colour_code,
		},
		light_source = light_level,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		sunlight_propagates = true,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.1875+disp, -0.5, -0.3125+disp, 0.3125+disp, -0.3125, 0.4375+disp},
				{-0.3125+disp, -0.5, -0.1875+disp, 0.4375+disp, -0.3125, 0.3125+disp},
				{-0.0625+disp, -0.1875, -0.0625+disp, 0.1875+disp, -0.125, 0.1875+disp},
				{-0.1875+disp, -0.3125, -0.1875+disp, 0.3125+disp, -0.1875, 0.3125+disp},
			}
		},
		
		drop = {
            -- Maximum number of items to drop
            max_items = 1,
            -- Choose max_items randomly from this list
            items = {
                {
                    items = {cap_item, "df_trees:spindlestem_seedling"},  -- Items to drop
                    rarity = 2,  -- Probability of dropping is 1 / rarity
                },
                {
                    items = {cap_item, "df_trees:spindlestem_seedling", "df_trees:spindlestem_seedling"},  -- Items to drop
                    rarity = 2,  -- Probability of dropping is 1 / rarity
                },
                {
                    items = {cap_item, "df_trees:spindlestem_seedling", "df_trees:spindlestem_seedling", "df_trees:spindlestem_seedling"},  -- Items to drop
                    rarity = 2,  -- Probability of dropping is 1 / rarity
                },
                {
                    items = {cap_item},  -- Items to drop
                    rarity = 1,  -- Probability of dropping is 1 / rarity
                },
            },
        },
		
		on_place = stem_on_place,
		on_timer = function(pos, elapsed)
			local meta = minetest.get_meta(pos)
			local height = meta:get_int("spindlestem_to_grow")
			local delay = meta:get_int("spindlestem_delay")
			if delay == 0 then
				delay = growth_delay() -- compatibility code to ensure no crash for previous version
			end
			local node = minetest.get_node(pos)
		
			while height > 0 and elapsed >= delay do
				elapsed = elapsed - delay
				local this_pos = pos
				pos = vector.add(this_pos, {x=0,y=1,z=0})
				local node_above = minetest.get_node(pos)
				local above_def = minetest.registered_nodes[node_above.name]
				if not above_def or not above_def.buildable_to then
					-- can't grow any more, exit
					return
				end
				minetest.set_node(this_pos, {name="df_trees:spindlestem_stem", param2 = node.param2})
				minetest.set_node(pos, {name=cap_item, param2 = node.param2})
				height = height - 1
			end
			
			if height > 0 then
				meta = minetest.get_meta(pos)
				meta:set_int("spindlestem_to_grow", height)
				meta:set_int("spindlestem_delay", delay)
				minetest.get_node_timer(pos):start(delay-elapsed)
			end
		end,
	})

	minetest.register_craft({
		type = "fuel",
		recipe = cap_item,
		burntime = 10,
	})

	local c_stem = minetest.get_content_id("df_trees:spindlestem_stem")
	local c_cap = minetest.get_content_id(cap_item)
	
	if vessels and light_level > 0 then
		local tex = "dfcaverns_vessels_glowing_liquid.png^[multiply:#"..colour_code.."^vessels_glass_bottle.png"
		local new_light = light_level + math.floor((minetest.LIGHT_MAX-light_level)/2)
		minetest.register_node("df_trees:glowing_bottle_"..item_suffix, {
			description = S("@1 Spindlestem Extract", colour_name),
			drawtype = "plantlike",
			_doc_items_longdesc = df_trees.doc["spindlestem_extract_"..item_suffix.."_desc"],
			_doc_items_usagehelp = df_trees.doc["spindlestem_extract_"..item_suffix.."_usage"],
			tiles = {tex},
			inventory_image = tex,
			wield_image = tex,
			paramtype = "light",
			is_ground_content = false,
			walkable = false,
			selection_box = {
				type = "fixed",
				fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
			},
			groups = {vessel = 1, dig_immediate = 3, attached_node = 1},
			sounds = default.node_sound_glass_defaults(),
			light_source = new_light,
		})
		
		minetest.register_craft( {
			output = "df_trees:glowing_bottle_"..item_suffix.." 3",
			type = "shapeless",
			recipe = {
				"vessels:glass_bottle",
				"vessels:glass_bottle",
				"vessels:glass_bottle",
				cap_item,
			}
		})

		minetest.register_craft( {
			output = "vessels:glass_bottle",
			type = "shapeless",
			recipe = {
				"df_trees:glowing_bottle_"..item_suffix,
			}
		})
	end
end

minetest.register_node("df_trees:spindlestem_seedling", {
	description = S("Spindlestem Spawn"),
	_doc_items_longdesc = df_trees.doc.spindlestem_desc,
	_doc_items_usagehelp = df_trees.doc.spindlestem_usage,
	tiles = {
		"dfcaverns_tower_cap.png",
	},
	groups = {snappy = 3, flammable = 2, plant = 1, attached_node = 1, light_sensitive_fungus = 11, digtron_on_place=1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	walkable = false,
	floodable = true,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625 + 0.125, -0.5, -0.125 + 0.125, 0.125 + 0.125, -0.375, 0.0625 + 0.125},
		}
	},
	
	on_place = stem_on_place,
	on_construct = function(pos)
		if minetest.get_item_group(minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name, "soil") == 0 then
			return
		end
		minetest.get_node_timer(pos):start(growth_delay())
	end,
	on_destruct = function(pos)
		minetest.get_node_timer(pos):stop()
	end,
	
	on_timer = function(pos, elapsed)
		if df_farming and df_farming.kill_if_sunlit(pos) then
			return
		end

		local cap_item = minetest.get_name_from_content_id(get_spindlestem_cap_type(pos))
		local node = minetest.get_node(pos)
		minetest.set_node(pos, {name=cap_item, param2 = node.param2})
		local meta = minetest.get_meta(pos)
		local disp = {x=3, y=3, z=3}
		local nearby = minetest.find_nodes_in_area(vector.add(pos, disp), vector.subtract(pos, disp), {"group:spindlestem"})
		local count = #nearby
		local height = math.random(1,3)
		if count > 10 then height = height + 2 end -- if there are a lot of nearby spindlestems, grow taller
		if height > 0 then
			local delay = growth_delay()
			meta:set_int("spindlestem_to_grow", height)
			meta:set_int("spindlestem_delay", delay)
			minetest.get_node_timer(pos):start(delay)
		end
	end,
})

register_spindlestem_type("white", S("White"), "FFFFFF", 0)
register_spindlestem_type("red", S("Red"), "FFC3C3", 3)
register_spindlestem_type("green", S("Green"), "C3FFC3", 4)
register_spindlestem_type("cyan", S("Cyan"), "C3FFFF", 6)
register_spindlestem_type("golden", S("Golden"), "FFFFC3", 12)

local c_air = minetest.get_content_id("air")
local c_stem = minetest.get_content_id("df_trees:spindlestem_stem")

df_trees.spawn_spindlestem_vm = function(vi, area, data, data_param2, c_cap)
	if data[vi] ~= c_air then return end
	
	if c_cap == nil then
		-- note: this won't account for rock removed by subterrane, so may not be entirely accurate. Good enough!
		c_cap = get_spindlestem_cap_type(area:position(vi))
	end
	
	local stem_height = math.random(1,3)
	local param2 = math.random(1,4)-1
	local i = 0
	local top = 0
	local index
	while i <= stem_height do
		index = vi + i * area.ystride
		if data[index] == c_air then
			data[index] = c_stem
			data_param2[index] = param2
			top = i
		else
			i = 100
		end
		i = i + 1
	end
	index = vi + top * area.ystride
	data[index] = c_cap
end

local c_white = minetest.get_content_id("df_trees:spindlestem_cap_white")
local c_red = minetest.get_content_id("df_trees:spindlestem_cap_red")
local c_green = minetest.get_content_id("df_trees:spindlestem_cap_green")
local c_cyan = minetest.get_content_id("df_trees:spindlestem_cap_cyan")
local c_golden = minetest.get_content_id("df_trees:spindlestem_cap_golden")

get_spindlestem_cap_type = function(pos)
	if minetest.find_node_near(pos, 15, "group:tower_cap") then
		return c_white
	end
	if minetest.find_node_near(pos, 15, "group:goblin_cap") then
		return c_red
	end
	
	local iron = minetest.find_node_near(pos, 5, {"default:stone_with_iron", "default:steelblock"})
	local copper = minetest.find_node_near(pos, 5, {"default:stone_with_copper", "default:copperblock"})
	local mese = minetest.find_node_near(pos, 5, {"default:stone_with_mese", "default:mese"})
	local possibilities = {}

	if mese then table.insert(possibilities, c_golden) end
	if copper then table.insert(possibilities, c_green) end
	if iron then table.insert(possibilities, c_red) end
	if iron and copper then table.insert(possibilities, c_cyan) end
	if #possibilities == 0 then
		return c_white
	else
		local pick = math.random(1, #possibilities)
		return possibilities[pick]
	end	
end
