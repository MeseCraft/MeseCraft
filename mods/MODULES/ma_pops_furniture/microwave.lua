--microwave code by Wizzerine
--item_percent code by Noodlemire

local microwave_fs = 
	"size[8,7]"
	.."button[6.5,1.5;1.5,2;btn_start;START]"
    .."image[6.5,.2;1.5,.5;ma_pops_furniture_mw_bar.png^[transformR270]"
	.."list[current_player;main;0,3;8,1;]"
    .."list[current_player;main;0,4.25;8,3;8]"
	.."list[context;cook_slot;3.5,1.25;1,1;]"
	.."label[3,0.5;Microwave]"
 -- possibly add "fire" image?

local function get_active_microwave_fs(item_percent)
    return "size[8,7]"
	    .."button[6.5,1.5;1.5,2;button_start;START]"
	    .."image[6.5,.2;1.5,.5;ma_pops_furniture_mw_bar.png^[lowpart:"
	    ..(item_percent)..":ma_pops_furniture_mw_bar_on.png^[transformR270]"
	    .."list[current_player;main;0,3;8,1;]"
        .."list[current_player;main;0,4.25;8,3;8]"
	    .."list[context;cook_slot;3.5,1.25;1,1;]"
        .."label[3,0.5;Microwave]"
        -- possibly add "fire" image?
end

--x,y;w,h

-- Adding recipe API so we don't end up hardcoding items
ma_pops_furniture.microwave = {}
local microwave = ma_pops_furniture.microwave
microwave.recipes = {}
function microwave.register_recipe(input, output) microwave.recipes[input] = output end

local function update_formspec(progress, goal, meta)
    local formspec

    if progress > 0 and progress <= goal then
        local item_percent = math.floor(progress / goal * 100)
        formspec = get_active_microwave_fs(item_percent)
    else
        formspec = microwave_fs
    end

    meta:set_string("formspec", formspec)
end

local function recalculate(pos)
	local meta, timer = minetest.get_meta(pos), minetest.get_node_timer(pos)
	local inv = meta:get_inventory()
	local stack = inv:get_stack("cook_slot", 1)
    local goal = 3 * stack:get_count()

	local k = microwave.recipes[stack:get_name()]
	if not k then return end

	timer:stop()
    update_formspec(0, goal, meta)
    timer:start(1)
end

local function do_cook_all(pos)
    local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stack = meta:get_inventory():get_stack("cook_slot", 1)
	local food_uncooked = inv:remove_item("cook_slot", inv:get_stack("cook_slot", 1)) -- Clear the slot
	local food_cooked = microwave.recipes[food_uncooked:get_name()] .. " " .. tostring(food_uncooked:get_count()) -- Get the cooked food
	inv:add_item("cook_slot", food_cooked) -- Put the cooked food in the slot
end

minetest.register_node("ma_pops_furniture:microwave", {
	description = "Microwave",
	tiles = {
		"ma_pops_furniture_mw_top.png",
		"ma_pops_furniture_mw_bottom.png",
		"ma_pops_furniture_mw_right.png",
		"ma_pops_furniture_mw_left.png",
		"ma_pops_furniture_mw_back.png",
		"ma_pops_furniture_mw_front.png"
	},
	paramtype2 = "facedir",
	groups = {cracky = 2}, -- currently no pipeworks compat as I don't know how it works
	sounds = default.node_sound_stone_defaults(),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
	    	{-0.4375, -0.4375, -0.3125, 0.4375, 0.0625, 0.3125},
			{-0.375, -0.5, -0.25, 0.375, -0.4375, 0.25},
		},
	},
	can_dig = function(pos, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		return inv:is_empty("cook_slot")
	end,

	on_timer = function(pos, elapsed)
		local meta = minetest.get_meta(pos)
        local stack = meta:get_inventory():get_stack("cook_slot", 1)
        local goal = 3 * stack:get_count()
        local cooking_time = meta:get_int("cooking_time") or 0
        cooking_time = cooking_time + 1

        update_formspec(cooking_time, goal, meta)
        meta:set_int("cooking_time", cooking_time)

        --Keep cooking until there is nothing left to cook.
        if cooking_time <= goal then
            return true
        else
            do_cook_all(pos)
            meta:set_int("cooking_time", 0)
            update_formspec(0, goal, meta)
            return false
        end
	end,
	
	--on_metadata_inventory_put = recalculate,
	--on_metadata_inventory_take = recalculate,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", microwave_fs)
		local inv = meta:get_inventory()
		inv:set_size("cook_slot", 1)
	end,
    on_receive_fields = function(pos, _, fields)
        if fields.quit then return end
        if fields.btn_start then
            recalculate(pos)
        end
    end,

	on_blast = function(pos)
		local drops = {}
		default.get_inventory_drops(pos, "cook_slot", drops)
		table.insert(drops, "ma_pops_furniture:microwave")
		minetest.remove_node(pos)
		return drops
	end,

	allow_metadata_inventory_put = function(pos, list, index, stack, player)
		return microwave.recipes[stack:get_name()] and stack:get_count() or 0
	end,

    --Only allow items to be taken if the microwave hasn't started yet
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
        if not minetest.get_node_timer(pos):is_started() then
            return stack:get_count()
        else
            return 0
        end
    end
})

-- Recipe Registration
microwave.register_recipe("default:ice", "default:water_source")
-- No milk bucket as this doesn't support substitutes for now
microwave.register_recipe("mobs_mc:chicken_raw", "test:chicken_cooked")
--[[ We don't need to check mod existance when registering recipe
Recipe won't even be executed if there is no raw chicken in input ]]--
microwave.register_recipe("mobs_mc:beef_raw", "test:beef_cooked")
microwave.register_recipe("farming:coffee_cup", "farming:coffee_cup_hot") -- What a crutch there was...

-- Added for MeseCraft
microwave.register_recipe("mobs:meat_raw", "mobs:meat")
microwave.register_recipe("mobs_creatures:pork_raw", "mobs_creatures:pork_cooked")
microwave.register_recipe("mobs_creatures:mutton_raw", "mobs_creatures:mutton_cooked")
microwave.register_recipe("mobs_creatures:rabbit_raw", "mobs_creatures:rabbit_cooked")
microwave.register_recipe("mobs_creatures:chicken_raw", "mobs_creatures:chicken_cooked")
microwave.register_recipe("mobs_creatures:snapper_raw", "mobs_creatures:snapper_cooked")
microwave.register_recipe("mobs_creatures:salmon_raw", "mobs_creatures:salmon_cooked")
microwave.register_recipe("mobs_creatures:clownfish_raw", "mobs_creatures:clownfish_cooked")
microwave.register_recipe("mobs_creatures:cod_raw", "mobs_creatures:cod_cooked")
microwave.register_recipe("farming:corn", "farming:corn_cob")
microwave.register_recipe("farming:potato", "farming:baked_potato")

-- Add needed recipes as you go, note that other mods can add more recipes too
