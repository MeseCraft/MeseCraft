local S = minetest.get_translator(minetest.get_current_modname())

local dungeon_loot_path = minetest.get_modpath("dungeon_loot")

bones_loot = {}

local bones_formspec =
	"size[8,9]"
	.."list[current_name;main;0,0.3;8,4;]"
	.."list[current_player;main;0,4.85;8,1;]"
	.."list[current_player;main;0,6.08;8,3;8]"
	.."listring[current_name;main]"
	.."listring[current_player;main]"
	..df_dependencies.get_itemslot_bg(0,0.3,8,4)
	..df_dependencies.get_itemslot_bg(0,4.85,8,1)
	..df_dependencies.get_itemslot_bg(0,6.08,8,3)
if minetest.get_modpath("default") then
	bones_formspec = bones_formspec .. default.get_hotbar_bg(0,4.85)
end

if minetest.get_modpath("bones") then
	df_dependencies.node_name_bones = "bones:bones"
else

	local function drop_item_stack(pos, stack)
		if not stack or stack:is_empty() then return end
		local drop_offset = vector.new(math.random() - 0.5, 0, math.random() - 0.5)
		minetest.add_item(vector.add(pos, drop_offset), stack)
	end

	minetest.register_node("bones_loot:bones", {
		description = S("Bones"),
		tiles = {
			"bones_top.png^[transform2",
			"bones_bottom.png",
			"bones_side.png",
			"bones_side.png",
			"bones_rear.png",
			"bones_front.png"
		},
		paramtype2 = "facedir",
		groups = {oddly_diggable_by_hand=1, handy=1, container=2},
		sounds = df_dependencies.sound_gravel(),
		_mcl_hardness = 1.5,
		_mcl_blast_resistance = 6,
		can_dig = function(pos, player)
			local inv = minetest.get_meta(pos):get_inventory()
			return inv:is_empty("main")
		end,
	
		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_string("formspec", bones_formspec)
			local inv = meta:get_inventory()
			inv:set_size("main", 8*4)
		end,

		on_blast = function(pos, intensity)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			for i = 1, inv:get_size("main") do
				drop_item_stack(pos, inv:get_stack("main", i))
			end
			meta:from_table()
			minetest.remove_node(pos)
			if math.random(1, math.floor((intensity or 1) * 2)) ~= 1 then return end
			drop_item_stack(pos, "bones_loot:bones")
		end
	})

	df_dependencies.node_name_bones = "bones_loot:bones"
end

local bones_node = df_dependencies.node_name_bones

local local_loot = {}
local local_loot_register = function(t)
	if t.name ~= nil then
		t = {t} -- single entry
	end
	for _, loot in ipairs(t) do
		table.insert(local_loot, loot)
	end
end

-- we could do this for the dungeon_loot registered loot table as well,
-- but best not to meddle in other mods' internals if it can be helped.
local clean_up_local_loot = function()
	if local_loot == nil then return end
	for i = #local_loot, 1, -1 do
		if not minetest.registered_items[local_loot[i].name] then
			table.remove(local_loot, i)
		end
	end
end

-- Uses same table format as dungeon_loot
-- eg, 	{name = "bucket:bucket_water", chance = 0.45, types = {"sandstone", "desert"}},
-- if dungeon_loot is installed it uses dungeon_loot's registration function directly.
if dungeon_loot_path then
	bones_loot.register_loot = dungeon_loot.register
else
	bones_loot.register_loot = local_loot_register
	minetest.after(0, clean_up_local_loot)
end

local get_loot_list = function(pos, loot_type, exclusive_loot_type)
	local loot_table
	if dungeon_loot_path then
		loot_table = dungeon_loot.registered_loot
	else
		loot_table = local_loot
	end
	
	local item_list = {}
	local pos_y = pos.y
	for _, loot in ipairs(loot_table) do
		if loot.y == nil or (pos_y >= loot.y[1] and pos_y <= loot.y[2]) then
			if (not exclusive_loot_type and loot.types == nil) or
				(loot.types and table.indexof(loot.types, loot_type) ~= -1) then
				table.insert(item_list, loot)
			end
		end
	end

	return item_list
end

local shuffle = function(tbl)
	for i = #tbl, 2, -1 do
		local rand = math.random(i)
		tbl[i], tbl[rand] = tbl[rand], tbl[i]
	end
	return tbl
end

-- "exclusive" set to true means that loot table entries without a loot_type won't be considered.
bones_loot.get_loot = function(pos, loot_type, max_stacks, exclusive_loot_type)
	local item_list = get_loot_list(pos, loot_type, exclusive_loot_type)
	shuffle(item_list)
	
	-- apply chances / randomized amounts and collect resulting items
	local items = {}
	for _, loot in ipairs(item_list) do
		if math.random() <= loot.chance then
			local itemdef = minetest.registered_items[loot.name]
			if itemdef then
				local amount = 1
				if loot.count ~= nil then
					amount = math.random(loot.count[1], loot.count[2])
				end
			
				if itemdef.tool_capabilities then
					for n = 1, amount do
						local wear = math.random(0.20 * 65535, 0.75 * 65535) -- 20% to 75% wear
						table.insert(items, ItemStack({name = loot.name, wear = wear}))
						max_stacks = max_stacks - 1
						if max_stacks <= 0 then break end
					end
				else
					local stack_max = itemdef.stack_max
					while amount > 0 do
						table.insert(items, ItemStack({name = loot.name, count = math.min(stack_max, amount)}))
						amount = amount - stack_max
						max_stacks = max_stacks - 1
						if max_stacks <= 0 then break end
					end
				end
			end
		end
		if max_stacks <= 0 then break end
	end	
	return items
end

bones_loot.place_bones = function(pos, loot_type, max_stacks, infotext, exclusive_loot_type)
	minetest.set_node(pos, {name=bones_node, param2 = math.random(1,4)-1})
	local meta = minetest.get_meta(pos)
	if infotext == nil then
		infotext = S("Someone's old bones")
	end
	meta:set_string("infotext", infotext)
	meta:set_string("formspec", bones_formspec)
	
	if max_stacks and max_stacks > 0 then
		local loot = bones_loot.get_loot(pos, loot_type, max_stacks, exclusive_loot_type)
		local inv = meta:get_inventory()
		inv:set_size("main", 8 * 4)
		for _, item in ipairs(loot) do
			inv:add_item("main", item)
		end
	end
end

minetest.register_lbm({
	label = "Repair underworld bones formspec",
	name = "bones_loot:repair_underworld_bones_formspec",
	nodenames = {bones_node},	
	action = function(pos, node)
		local meta = minetest.get_meta(pos)
		if not meta:get("formspec") then
			meta:set_string("formspec", bones_formspec)
		end	
	end,
})
