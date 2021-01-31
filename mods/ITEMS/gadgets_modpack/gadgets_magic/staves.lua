local plant_list = {
    "default:junglegrass",
    "default:grass_1",
    "default:grass_2",
    "default:grass_3",
    "default:bush_sapling",
    "default:blueberry_bush_sapling",
    "default:marram_grass_1",
    "default:marram_grass_2",
    "default:marram_grass_3",
    "default:fern_1",
    "default:fern_2",
    "default:fern_3",
    "default:dry_grass_1",
    "default:dry_grass_2",
    "default:dry_grass_3",
    "default:dry_shrub",
}

gadgets.register_gadget({
    name = "gadgets_magic:staff_druid",
    description = "Druid's Staff",
    texture = "gadgets_magic_staff_druid.png",

    has_durability = true,
    uses = 64,
    custom_charge = true,

    repair_with = "magic_materials:februm_crystal",
    repair_uses = 8,

    use_sound = "gadgets_magic_earth_staff_cast",
    use_sound_gain = 1,
    custom_wear = true,
    custom_on_use = function(itemstack, user, pointed_thing)
        local pos = minetest.get_pointed_thing_position(pointed_thing)
	local name = user:get_player_name()
        if not pos then return end
        local node = minetest.get_node_or_nil(pos)
        if not node or node and minetest.is_protected(pos, name) then return end
        local success = false
        if node.name == "default:stone" then
            minetest.set_node(pos, {name = "default:cobble"})
            success = true
        elseif node.name == "default:cobble" then
            minetest.set_node(pos, {name = "default:gravel"})
            success = true
        elseif node.name == "default:gravel" then
            minetest.set_node(pos, {name = "default:sand"})
            success = true
        elseif node.name == "default:sand" then
            minetest.set_node(pos, {name = "default:dirt"})
            success = true
        elseif node.name == "default:dirt" then
            minetest.set_node(pos, {name = "default:dirt_with_grass"})
            success = true
        elseif node.name == "default:dirt_with_grass" then
            local above = {x = pos.x, y = pos. y + 1, z = pos.z}
-- Try to workaround new staff bug with druid
            local name = user:get_player_name()
            if minetest.is_protected(above, name) then return end
            local node_above = minetest.get_node_or_nil(above)
            if node_above and node_above.name == "air" then
                local new_node = plant_list[math.random(#plant_list)]
                minetest.set_node(above, {name = new_node})
            end
        end
        if success then
            local tile = minetest.registered_nodes[node.name].tiles[1] or "tnt_smoke.png"
            minetest.add_particlespawner({
                amount = 32,
                time = 0.05,
                minpos = {x=pos.x-0.25, y=pos.y-0.25, z=pos.z-0.25},
                maxpos = {x=pos.x+0.25, y=pos.y+0.25, z=pos.z+0.25},
                minvel = {x=-1, y=0, z=-1},
                maxvel = {x=1, y=8, z=1},
                minacc = {x=0, y=-8, z=0},
                maxacc = {x=0, y=-8, z=0},
                minexptime = 1,
                maxexptime = 4,
                minsize = 1,
                maxsize = 3,
                texture = tile,
            })
            return true
        end
    end,
    recipe = {
        {
            {"magic_materials:magic_root", "magic_materials:magic_flower", "magic_materials:magic_root"},
            {"", "magic_materials:enchanted_staff", ""},
            {"", "magic_materials:earth_rune", ""}
        },
    },
})

local earth_staff_blacklist = {
    "df_underworld_items:slade_wall",
    "df_underworld_items:slade_brick",
    "df_underworld_items:slade",
    "df_underworld_items:slade_sand",
    "df_underworld_items:slade_seal",
    "df_underworld_items:slade_block",
    "df_underworld_items:slade_capstone",
    "df_underworld_items:inscription_block",
    "df_underworld_items:puzzle_seal",
    "stairs:slab_slade_brick",
    "stairs:stair_outer_slade_brick",
    "stairs:stair_slade_brick",
    "default:obsidian",
    "default:obsidian_block",
    "default:obsidianbrick",
    "towercrane:mast",
    "towercrane:arm",
    "towercrane:arm2",
    "towercrane:balance",
    "towercrane:mast_ctrl_off",
    "towercrane:mast_ctrl_on",
    "wielded_light:1",
    "wielded_light:2",
    "wielded_light:3",
    "wielded_light:4",
    "wielded_light:5",
    "wielded_light:6",
    "wielded_light:7",
    "wielded_light:8",
    "wielded_light:9",
    "wielded_light:10",
    "wielded_light:11",
    "wielded_light:12",
    "wielded_light:13",
    "wielded_light:14",
}

gadgets.register_gadget({
    name = "gadgets_magic:staff_earth",
    description = "Staff Of Earth",
    texture = "gadgets_magic_staff_earth.png",

    has_durability = true,
    uses = 64,
    custom_charge = true,

    repair_with = "magic_materials:februm_crystal",
    repair_uses = 8,

    use_sound = "gadgets_magic_earth_staff_cast",
    use_sound_gain = 1,

    custom_wear = true,
    custom_on_use = function(itemstack, user, pointed_thing)

        if not user then return end

        if not pointed_thing or pointed_thing and pointed_thing.type ~= "node" then
            return
        end

        local radius = 3
        local pos = minetest.get_pointed_thing_position(pointed_thing)
        local name = user:get_player_name()

        for x = -math.floor(radius/2), math.floor(radius/2) do
            for y = -math.floor(radius/2), math.floor(radius/2) do
                for z = -math.floor(radius/2), math.floor(radius/2) do
                    local t_pos = {x = pos.x + x, y = pos.y + y, z = pos.z + z}
                    if not minetest.is_protected(t_pos, name) then
                        local node = minetest.get_node_or_nil(t_pos)
                        if node and minetest.registered_nodes[node.name] and
                        (minetest.registered_nodes[node.name].liquidtype == "none" or
                        not minetest.registered_nodes[node.name].liquidtype) and
                        not earth_staff_blacklist[node.name] and
                        minetest.registered_nodes[node.name].diggable ~= false then
                            local tile = "tnt_smoke.png"
                            local glow = minetest.registered_nodes[node.name].light_source or 0
                            minetest.node_dig(t_pos, node, user)
                            minetest.add_particlespawner({
                                amount = 16,
                                time = 0.05,
                                minpos = {x=t_pos.x-0.25, y=t_pos.y-0.25, z=t_pos.z-0.25},
                                maxpos = {x=t_pos.x+0.25, y=t_pos.y+0.25, z=t_pos.z+0.25},
                                minvel = {x=-1, y=-1, z=-1},
                                maxvel = {x=1, y=1, z=1},
                                minacc = {x=0, y=-8, z=0},
                                maxacc = {x=0, y=-8, z=0},
                                minexptime = 1,
                                maxexptime = 4,
                                minsize = 1,
                                maxsize = 2.5,
                                collision_detection = true,
                                glow = glow,
                                texture = tile,
                            })
                        end
                    end
                end
            end
        end
        return true
    end,
    recipe = {
        {
            {"default:steel_ingot", "magic_materials:earth_rune", "default:steel_ingot"},
            {"", "magic_materials:enchanted_staff", ""},
            {"", "magic_materials:fire_rune", ""},
        },
    }
})
