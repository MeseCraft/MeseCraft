local oven_fs = "size[8,7]"
    .."image[3.5,1.5;1,1;default_furnace_fire_bg.png]"
    .."list[current_player;main;0,3;8,4;]"
    .."list[context;input;2,1.5;1,1;]"
    .."list[context;output;5,1.5;1,1;]"
    .."label[3,0.5;Oven]"
    .."label[1.5,1;Uncooked Food]"
    .."label[4.5,1;Cooked Food]"
    -- possibly add "fire" image?

local function get_active_oven_fs(item_percent)
    return "size[8,7]"
	    .."image[3.5,1.5;1,1;default_furnace_fire_bg.png^[lowpart:"
	    ..(item_percent)..":default_furnace_fire_fg.png]"
        .."list[current_player;main;0,3;8,4;]"
        .."list[context;input;2,1.5;1,1;]"
        .."list[context;output;5,1.5;1,1;]"
        .."label[3,0.5;Oven]"
        .."label[1.5,1;Uncooked Food]"
        .."label[4.5,1;Cooked Food]"
        -- possibly add "fire" image?
end

--x,y;w,h

-- Adding recipe API so we don't end up hardcoding items
ma_pops_furniture.oven = {}
local oven = ma_pops_furniture.oven
oven.recipes = {}
function oven.register_recipe(input, output) oven.recipes[input] = output end

local function update_formspec(progress, goal, meta)
    local formspec

    if progress > 0 and progress <= goal then
        local item_percent = math.floor(progress / goal * 100)
        formspec = get_active_oven_fs(item_percent)
    else
        formspec = oven_fs
    end

    meta:set_string("formspec", formspec)
end

local function recalculate(pos)
	local meta, timer = minetest.get_meta(pos), minetest.get_node_timer(pos)
	local inv = meta:get_inventory()
	local stack = inv:get_stack("input", 1)

	local k = oven.recipes[stack:get_name()]
	if not k then return end

	timer:stop()
    update_formspec(0, 3, meta)
    timer:start(1)
end

local function do_cook_single(pos)
    local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local food_uncooked = inv:get_stack("input", 1)
    food_uncooked:set_count(1)

    --If the uncooked food wasn't removed mid-cooking, then cook it.
    if not oven.recipes[food_uncooked:get_name()] then
        minetest.chat_send_all("Oven cooked nothing because there was nothing to cook.")
        minetest.get_node_timer(pos):stop()
        update_formspec(0, 3, meta)
    else
        inv:remove_item("input", food_uncooked) -- Clear the slot
	    local food_cooked = oven.recipes[food_uncooked:get_name()] -- Get the cooked food
	    inv:add_item("output", food_cooked) -- Put the cooked food in the slot
    end
end

minetest.register_node("ma_pops_furniture:oven", {
	description = "Oven",
	tiles = {
		"mp_oven_top.png",
		"mp_oven_bottom.png",
		"mp_oven_right.png",
		"mp_oven_left.png",
		"mp_oven_back.png",
		"mp_oven_front.png"
	},
	paramtype2 = "facedir",
	groups = {cracky = 2, tubedevice = 1, tubedevice_receiver = 1},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.3125, -0.5, 0.5, 0.5, 0.5},
			{-0.5, -0.5, -0.375, 0.5, 0.3125, 0.5},
			{-0.4375, -0.4375, -0.4375, 0.4375, 0.25, -0.375},
			{-0.375, 0.125, -0.5, 0.375, 0.1875, -0.375},
		},
	},
	can_dig = function(pos, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		return inv:is_empty("input") and inv:is_empty("output")
	end,

	on_timer = function(pos, elapsed)
        local meta = minetest.get_meta(pos)
        local stack = meta:get_inventory():get_stack("input", 1)
        local cooking_time = meta:get_int("cooking_time") or 0
        cooking_time = cooking_time + 1
        
        if cooking_time % 3 == 0 then
            do_cook_single(pos)
        end

        update_formspec(cooking_time % 3, 3, meta)
        meta:set_int("cooking_time", cooking_time)

        --Keep cooking until there is nothing left to cook.
        if not stack:is_empty() then
            return true
        else
            meta:set_int("cooking_time", 0)
            update_formspec(0, 3, meta)
            return false
        end
	end,

	on_metadata_inventory_put = recalculate,
    on_metadata_inventory_take = recalculate,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", oven_fs)
		local inv = meta:get_inventory()
		inv:set_size("input", 1)
        inv:set_size("output", 1)
	end,
	
	on_blast = function(pos)
		local drops = {}
		default.get_inventory_drops(pos, "input", drops)
        default.get_inventory_drops(pos, "output", drops)
		table.insert(drops, "ma_pops_furniture:oven")
		minetest.remove_node(pos)
		return drops
	end,

	allow_metadata_inventory_put = function(pos, list, index, stack, player)
		return oven.recipes[stack:get_name()] and stack:get_count() or 0
	end,
})

-- Recipe Registration
oven.register_recipe("default:ice", "default:water_source")
-- No milk bucket as this doesn't support substitutes for now
oven.register_recipe("mobs_mc:chicken_raw", "test:chicken_cooked")
--[[ We don't need to check mod existance when registering recipe
Recipe won't even be executed if there is no raw chicken in input ]]--
oven.register_recipe("mobs_mc:beef_raw", "test:beef_cooked")
oven.register_recipe("farming:coffee_cup", "farming:coffee_cup_hot") -- What a crutch there was...
-- Add needed recipes as you go, note that other mods can add more recipes too
