lootchests = {}

lootchests.loot_table = {}

local debug = minetest.settings:get("lootchests_debug") or false

local function list_length(list)
    local count = 0
    for _,_ in pairs(list) do
        count = count + 1
    end
    return count
end

lootchests.add_to_loot_table = function(key, add)
    if not lootchests.loot_table[key] then
        lootchests.loot_table[key] = {}
    end
    for _,v in pairs(add) do
        table.insert(lootchests.loot_table[key], v)
    end
end

lootchests.register_lootchest = function(def)

    if not def.name or not def.description then
        minetest.log("error", "[lootchests] Missing fields in chest definition!")
        return
    end

    if not lootchests.loot_table[def.name] then
        minetest.log("error", "[lootchests] Missing loot table for " .. def.name .. "!")
        return
    end

    local tiles = def.tiles or {
        "default_chest_top.png",
        "default_chest_top.png",
        "default_chest_side.png",
        "default_chest_side.png",
        "default_chest_front.png",
    }

    local sounds = def.sounds or default.node_sound_wood_defaults()
    local groups = def.groups or {choppy = 2, oddly_breakable_by_hand = 2}
    local rarity = def.spawn_in_rarity or 512
    local fill_ratio = def.spawn_on_rarity or 512
    local ymax = def.ymax or 31000
    local ymin = def.ymin or -31000
    local slot_spawn_chance = def.slot_spawn_chance or 0.25
    local slots = def.slots or 32
    local node_box = def.node_box or {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
    }

    local marker_drawtype = "airlike"
    local marker_groups = {dig_immediate = 2, not_in_creative_inventory = 1}
    if debug then
        marker_drawtype = nil
        marker_groups = {dig_immediate = 2}
    end

    minetest.register_node(def.name .. "_marker", {
        drawtype = marker_drawtype,
        description = def.description .. " Spawn Marker",
        tiles = {"lootchests_marker_top.png", "lootchests_marker_side.png"},
        groups = marker_groups,
        paramtype2 = "facedir",
    })

    minetest.register_node(def.name, {
        description = def.description,
        drawtype = def.drawtype,
        tiles = tiles,
        node_box = node_box,
        selection_box = node_box,
        groups = groups,
        sounds = sounds,
        paramtype = "light",
        on_construct = function(pos)
            local meta = minetest.get_meta(pos)
            meta:set_string("formspec",
                "size[8,9]" ..
                default.gui_bg ..
                default.gui_bg_img ..
                default.gui_slots ..
                "list[current_name;main;0,0;8,5;]" ..
                "list[current_player;main;0,5;8,4;]")
            meta:set_string("infotext", def.description)
            local inv = meta:get_inventory()
            inv:set_size("main", slots)
        end,
        can_dig = function(pos,player)
            local meta = minetest.get_meta(pos)
            local inv = meta:get_inventory()
            return inv:is_empty("main")
        end,
    })

    if not debug then
        minetest.register_lbm({
            label = "Upgrade " .. def.description,
            name = def.name .. "_marker_replace",
            nodenames = def.name .. "_marker",
            run_at_every_load = true,
            action = function(pos, node)
                minetest.set_node(pos, {name = def.name, param2 = minetest.get_node(pos).param2})
                local rand = PcgRandom(pos.x * pos.y * pos.z)
                local inv = minetest.get_inventory({type = "node", pos = pos})
                for i = 1, slots do
                    if rand:next(0,100) <= slot_spawn_chance then
                        local item_def = lootchests.loot_table[def.name][rand:next(1, #lootchests.loot_table[def.name])]
                        local stack = ItemStack(item_def[1])
                        if minetest.registered_tools[item_def[1]] then
                            stack:set_wear(rand:next(1,65535))
                        else
                            stack:set_count(rand:next(1, item_def[2]))
                        end
                        inv:set_stack("main", i, stack)
                    end
                end
            end,
        })
    end

    if def.spawn_in then
        minetest.register_ore({
            ore_type = "scatter",
            ore = def.name .. "_marker",
            wherein = def.spawn_in,
            clust_scarcity = rarity * rarity * rarity,
            clust_num_ores = 1,
            clust_size = 25,
            y_min = ymin,
            y_max = ymax,
        })
    end

    if def.spawn_on then
        minetest.register_decoration({
            deco_type = "simple",
            place_on = def.spawn_on,
            sidelen = 16,
            fill_ratio = 1/fill_ratio,
            y_min = ymin,
            y_max = ymax,
            flags = "force_placement, all_floors",
            decoration = def.name .. "_marker",
        })
    end
end
