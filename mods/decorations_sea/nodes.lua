local function register_sand_decoration(def)
    minetest.register_node(def.id .. "_node", {
        description = "Sand With " .. def.description,
        tiles = {"default_sand.png^" .. def.overlay, "default_sand.png"},
        groups = {crumbly = 3, falling_node = 1, sand = 1, not_in_creative_inventory = 1},
        sounds = default.node_sound_sand_defaults(),
        node_dig_prediction = "default:sand",
        node_placement_prediction = "",
        drop = def.id,
        after_destruct = function(pos, oldnode)
            minetest.set_node(pos, {name = "default:sand"})
        end
    })

    minetest.register_craftitem(def.id, {
        description = def.description,
        inventory_image = def.texture,
        on_place = function(itemstack, user, pointed_thing)
            if not user then return end
            if pointed_thing and pointed_thing.type == "node" then
                local pos = minetest.get_pointed_thing_position(pointed_thing)
                local node = minetest.get_node_or_nil(pos)
                if node and minetest.registered_nodes[node.name].name == "default:sand" then
                    local name = user:get_player_name()
                    if not minetest.is_protected(pos, name) then
                        minetest.set_node(pos, {name = def.id .. "_node"})
                        itemstack:take_item()
                        return itemstack
                    end
                end
            end
        end
    })
end

local function register_seagrass(def)
    local max_height = def.max_height or 3
    minetest.register_node(def.id, {
        description = def.description,
        drawtype = "plantlike_rooted",
        waving = 1,
        tiles = {"default_sand.png"},
        light_source = def.light_source,
        special_tiles = {{name = def.texture, tileable_vertical = true}},
        inventory_image = def.texture,
        paramtype = "light",
        paramtype2 = "leveled",
        groups = {snappy = 3},
        node_dig_prediction = "default:sand",
        node_placement_prediction = "",
        sounds = default.node_sound_sand_defaults({
            dig = {name = "default_dig_snappy", gain = 0.2},
            dug = {name = "default_grass_footstep", gain = 0.25},
        }),

        on_place = function(itemstack, placer, pointed_thing)
            -- Call on_rightclick if the pointed node defines it
            if pointed_thing.type == "node" and placer and
                    not placer:get_player_control().sneak then
                local node_ptu = minetest.get_node(pointed_thing.under)
                local def_ptu = minetest.registered_nodes[node_ptu.name]
                if def_ptu and def_ptu.on_rightclick then
                    return def_ptu.on_rightclick(pointed_thing.under, node_ptu, placer,
                        itemstack, pointed_thing)
                end
            end

            local pos = pointed_thing.under
            if minetest.get_node(pos).name ~= "default:sand" then
                return itemstack
            end

            local height = math.random(1, max_height)
            local pos_top = {x = pos.x, y = pos.y + height, z = pos.z}
            local node_top = minetest.get_node(pos_top)
            local def_top = minetest.registered_nodes[node_top.name]
            local player_name = placer:get_player_name()

            if def_top and def_top.liquidtype == "source" and
                    minetest.get_item_group(node_top.name, "water") > 0 then
                if not minetest.is_protected(pos, player_name) and
                        not minetest.is_protected(pos_top, player_name) then
                    minetest.set_node(pos, {name = def.id,
                        param2 = height * 16})
                    if not (creative and creative.is_enabled_for
                            and creative.is_enabled_for(player_name)) then
                        itemstack:take_item()
                    end
                else
                    minetest.chat_send_player(player_name, "Node is protected")
                    minetest.record_protection_violation(pos, player_name)
                end
            end

            return itemstack
        end,

        after_destruct  = function(pos, oldnode)
            minetest.set_node(pos, {name = "default:sand"})
        end
    })
end

local corals = {
    "Blue",
    "Orange",
    "Pink",
    "Violet",
    "Red",
    "Yellow",
    "Red",
    "Green"
}

local plantlike_corals = {5, 7, 8, 1, 6}

for k,v in pairs(corals) do
    minetest.register_node("decorations_sea:coral_0" .. k, {
        description = v .. " Coral",
        tiles = {"decorations_sea_coral_node_0" .. k .. ".png"},
        groups = {cracky = 3},
        drop = "default:coral_skeleton",
        sounds = default.node_sound_stone_defaults(),
    })
end

for k,v in pairs(plantlike_corals) do
    minetest.register_node("decorations_sea:coral_plantlike_0" .. k, {
        description = "Coral",
        drawtype = "plantlike_rooted",
        paramtype2 = "meshoptions",
        place_param2 = 4,
        tiles = {"decorations_sea_coral_node_0" .. v .. ".png"},
        special_tiles = {{name = "decorations_sea_coral_0" .. k .. ".png", tileable_vertical = true}},
        inventory_image = "decorations_sea_coral_0" .. k .. ".png",
        paramtype = "light",
        groups = {cracky = 3},
        sounds = default.node_sound_stone_defaults({
            dig = {name = "default_dig_snappy", gain = 0.2},
            dug = {name = "default_grass_footstep", gain = 0.25},
        }),
    })
end

for i = 1, 6 do
    local height = 5
    if i > 3 then height = 1 end
    register_seagrass({
        id = "decorations_sea:seagrass_0" .. i,
        description = "Seagrass",
        texture = "decorations_sea_seagrass_0" .. i .. ".png",
        max_height = height,
    })
end

for i = 1, 3 do
    register_sand_decoration({
        id = "decorations_sea:seashell_0" .. i,
        description = "Seashell",
        texture = "decorations_sea_seashell_0" .. i .. ".png",
        overlay = "decorations_sea_seashell_0" .. i .. "_overlay.png"
    })
end

for i = 1, 2 do
    register_sand_decoration({
        id = "decorations_sea:starfish_0" .. i,
        description = "Starfish",
        texture = "decorations_sea_starfish_0" .. i .. ".png",
        overlay = "decorations_sea_starfish_0" .. i .. ".png"
    })
end

register_seagrass({
    id = "decorations_sea:sea_pickle",
    description = "Sea Pickle",
    texture = "decorations_sea_pickle.png",
    light_source = 8,
    max_height = 1,
})
