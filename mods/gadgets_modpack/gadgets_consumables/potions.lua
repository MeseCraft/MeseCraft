local effect_potions = {
    {
        desc = "Speed",
        name = "speed",
        recipe = {
            {
                {"default:papyrus", "default:cactus", "farming:seed_wheat"},
                {"", "magic_materials:magic_root", ""},
                {"", "gadgets_consumables:water_bottle", ""},
            }
        },
    },
    {
        desc = "Jump",
        name = "jump",
        recipe = {
            {
                {"default:junglegrass", "farming:cotton", "farming:seed_cotton"},
                {"", "magic_materials:magic_root", ""},
                {"", "gadgets_consumables:water_bottle", ""},
            }
        },
    },
    {
        desc = "Gravity",
        name = "gravity",
        recipe = {
            {
                {"farming:cotton", "default:obsidian_shard", "default:apple"},
                {"", "magic_materials:magic_root", ""},
                {"", "gadgets_consumables:water_bottle", ""},
            }
        },
    },
}

local regen_potions = {
    {
        desc = "Water Breathing",
        name = "water_breath",
        recipe = {
            {
                {"default:papyrus", "flowers:waterlily", "group:leaves"},
                {"", "magic_materials:magic_root", ""},
                {"", "gadgets_consumables:water_bottle", ""},
            }
        },
    },
    {
        desc = "Fire Shield",
        name = "fire_shield",
        recipe = {
            {
                {"default:obsidian_shard", "bucket:bucket_lava", "default:mese_crystal_fragment"},
                {"", "magic_materials:magic_root", ""},
                {"", "gadgets_consumables:water_bottle", ""},
            }
        },
        replacements = {{"bucket:bucket_lava", "bucket:bucket_empty"}},
    },
    {
        desc = "Health Regeneration",
        name = "health_regen",
        recipe = {
            {
                {"farming:wheat", "default:gold_ingot", "default:apple"},
                {"", "magic_materials:magic_root", ""},
                {"", "gadgets_consumables:water_bottle", ""},
            }
        },
    },
}

if minetest.get_modpath("mana") then
    table.insert(regen_potions,
        {
            desc = "Mana Regeneration",
            name = "mana_regen",
            recipe = {
                {
                    {"group:sapling", "magic_materials:februm_crystal", "group:flower"},
                    {"", "magic_materials:magic_root", ""},
                    {"", "gadgets_consumables:water_bottle", ""},
                }
            },
        })
end

if minetest.get_modpath("sprint_lite") then
    table.insert(regen_potions,
        {
            desc = "Stamina Regeneration",
            name = "stamina_regen",
            recipe = {
                {
                    {"group:sapling", "", "farming:wheat"},
                    {"", "magic_materials:magic_root", ""},
                    {"", "gadgets_consumables:water_bottle", ""},
                }
            },
        })
end

for _,v in pairs(effect_potions) do
    gadgets.register_gadget({
        name = "gadgets_consumables:potion_" .. v.name .. "_01",
        description = "Weak Potion Of " .. v.desc,
        texture = "gadgets_consumables_potion_" .. v.name .. ".png",
        consumable = true,
        stack_max = 4,
        return_item = "vessels:glass_bottle",
        conflicting_effects = {"gadgets_default_effects_" .. v.name .. "_2"},
        effect = {"gadgets_default_effects_" .. v.name .. "_1"},
        duration = 60,
        use_sound = "gadgets_consumables_potion_drink",
        use_sound_gain = 1,
        recipe = v.recipe,
        replacements = v.replacements,
    })

    gadgets.register_gadget({
        name = "gadgets_consumables:potion_" .. v.name .. "_02",
        description = "Strong Potion Of " .. v.desc,
        texture = "gadgets_consumables_potion_" .. v.name .. ".png",
        consumable = true,
        stack_max = 4,
        return_item = "vessels:glass_bottle",
        conflicting_effects = {"gadgets_default_effects_" .. v.name .. "_1"},
        effect = {"gadgets_default_effects_" .. v.name .. "_2"},
        duration = 60,
        use_sound = "gadgets_consumables_potion_drink",
        use_sound_gain = 1,
        shapeless_recipe = true,
        recipe = {
            {"gadgets_consumables:potion_" .. v.name .. "_01", "magic_materials:magic_mushroom"},
        },
    })

    gadgets.register_gadget({
        name = "gadgets_consumables:potion_" .. v.name .. "_03",
        description = "Long-Lasting Potion Of " .. v.desc,
        texture = "gadgets_consumables_potion_" .. v.name .. ".png",
        consumable = true,
        stack_max = 4,
        return_item = "vessels:glass_bottle",
        conflicting_effects = {"gadgets_default_effects_" .. v.name .. "_2"},
        effect = {"gadgets_default_effects_" .. v.name .. "_1"},
        duration = 120,
        use_sound = "gadgets_consumables_potion_drink",
        use_sound_gain = 1,
        shapeless_recipe = true,
        recipe = {
            {"gadgets_consumables:potion_" .. v.name .. "_01", "magic_materials:magic_flower"},
        },
    })
end

for _,v in pairs(regen_potions) do
    gadgets.register_gadget({
        name = "gadgets_consumables:potion_" .. v.name .. "_01",
        description = "Potion Of " .. v.desc,
        texture = "gadgets_consumables_potion_" .. v.name .. ".png",
        consumable = true,
        stack_max = 4,
        return_item = "vessels:glass_bottle",
        effect = {"gadgets_default_effects_" .. v.name},
        duration = 30,
        use_sound = "gadgets_consumables_potion_drink",
        use_sound_gain = 1,
        recipe = v.recipe,
        replacements = v.replacements,
    })

    gadgets.register_gadget({
        name = "gadgets_consumables:potion_" .. v.name .. "_02",
        description = "Long-Lasting Potion Of " .. v.desc,
        texture = "gadgets_consumables_potion_" .. v.name .. ".png",
        consumable = true,
        stack_max = 4,
        return_item = "vessels:glass_bottle",
        effect = {"gadgets_default_effects_" .. v.name},
        duration = 60,
        use_sound = "gadgets_consumables_potion_drink",
        use_sound_gain = 1,
        shapeless_recipe = true,
        recipe = {
            {"gadgets_consumables:potion_" .. v.name .. "_01", "magic_materials:magic_flower"},
        },
    })
end

gadgets.register_gadget({
    name = "gadgets_consumables:potion_dispel",
    description = "Potion of Dispelling",
    texture = "gadgets_consumables_potion_dispel.png",
    consumable = true,
    stack_max = 4,
    return_item = "vessels:glass_bottle",
    use_sound = "gadgets_consumables_potion_drink",
    use_sound_gain = 1,
    custom_on_use = function(itemstack, user, pointed_thing)
        local name = user:get_player_name()
        local effects = playereffects.get_player_effects(name)
        for k,v in pairs(effects) do
            playereffects.cancel_effect(effects[k].effect_id)
        end
    end,
    recipe = {
        {
            {"", "farming:cotton", ""},
            {"", "magic_materials:magic_root", ""},
            {"", "gadgets_consumables:water_bottle", ""},
        }
    },
})

local function get_random_pos(pos, range)
    return {x = pos.x + math.random(-range,range), y = pos.y + math.random(-range, range), z = pos.z + math.random(-range, range)}
end

gadgets.register_gadget({
    name = "gadgets_consumables:potion_teleport",
    description = "Potion of Teleport",
    texture = "gadgets_consumables_potion_teleport.png",
    consumable = true,
    stack_max = 4,
    return_item = "vessels:glass_bottle",
    use_sound = "gadgets_consumables_potion_drink",
    use_sound_gain = 1,
    custom_on_use = function(itemstack, user, pointed_thing)

        if not user then return end

        local user_pos = user:get_pos()
        local random_range = 250
        local scan_range = 50
        local attempts = 5

        local c_air = minetest.get_content_id("air")
        local c_ignore = minetest.get_content_id("ignore")

        for i = 1, attempts do
            local target_pos = get_random_pos(user_pos, random_range)
            local minpos = {x = target_pos.x - scan_range, y = target_pos.y - scan_range, z = target_pos.z - scan_range}
            local maxpos = {x = target_pos.x + scan_range, y = target_pos.y + scan_range, z = target_pos.z + scan_range}

            local vm = minetest.get_voxel_manip()
            local emin, emax = vm:read_from_map(minpos, maxpos)
            local area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
            local data = vm:get_data()

            local teleported = false

            for z = minpos.z, maxpos.z do
                for y = minpos.y, maxpos.y do
                    for x = minpos.x, maxpos.x do
                        local vi = area:index(x, y, z)
                        if not teleported and (data[vi] ~= c_air and data[vi] ~= c_ignore) and
                        data[vi + area.ystride] == c_air and data[vi + area.ystride * 2] == c_air then
                            local tpos = area:position(vi)
                            user:set_pos({x = tpos.x, y = tpos.y + 1, z = tpos.z})
                            teleported = true
                            for _,v in pairs({user_pos, tpos}) do
                                minetest.add_particlespawner({
                                    amount = 32,
                                    time = 0.05,
                                    minpos = {x=v.x-0.5, y=v.y, z=v.z-0.5},
                                    maxpos = {x=v.x+0.5, y=v.y+2, z=v.z+0.5},
                                    minvel = {x=-4, y=-4, z=-4},
                                    maxvel = {x=4, y=4, z=4},
                                    minacc = {x=0, y=2, z=0},
                                    maxacc = {x=0, y=2, z=0},
                                    minexptime = 1,
                                    maxexptime = 4,
                                    minsize = 2,
                                    maxsize = 4,
                                    glow = 14,
                                    texture = "gadgets_consumables_teleport_potion_particle.png",
                                })
                            minetest.sound_play("gadgets_consumables_teleport", {pos=v, gain=1, max_hear_distance=2*64})
                            end
                            break
                        end
                    end
                    if teleported then break end
                end
                if teleported then break end
            end
            if teleported then break end
        end
    end,
    recipe = {
        {
            {"default:obsidian_shard", "default:flint", "default:mese_crystal_fragment"},
            {"", "magic_materials:magic_root", ""},
            {"", "gadgets_consumables:water_bottle", ""},
        }
    },
})