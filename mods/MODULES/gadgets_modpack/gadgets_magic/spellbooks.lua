gadgets.register_gadget({
    name = "gadgets_magic:tome_speed",
    description = "Tome Of Speed",
    texture = "gadgets_magic_tome_speed.png",
    mana_per_use = 100,
    light_source = 8,
    conflicting_effects = {"gadgets_default_effects_speed_2"},
    effect = {"gadgets_default_effects_speed_1"},
    duration = 60,
    use_sound = "gadgets_magic_spell_cast",
    use_sound_gain = 1,
    recipe = {
        {
            {"", "magic_materials:light_rune", ""},
            {"", "magic_materials:enchanted_book", ""},
            {"", "magic_materials:energy_rune", ""}
        },
    },
})

gadgets.register_gadget({
    name = "gadgets_magic:tome_jump",
    description = "Tome Of Jump",
    texture = "gadgets_magic_tome_jump.png",
    mana_per_use = 100,
    light_source = 7,
    conflicting_effects = {"gadgets_default_effects_jump_2"},
    effect = {"gadgets_default_effects_jump_1"},
    duration = 60,
    use_sound = "gadgets_magic_spell_cast",
    use_sound_gain = 1,
    recipe = {
        {
            {"", "magic_materials:energy_rune", ""},
            {"", "magic_materials:enchanted_book", ""},
            {"", "magic_materials:earth_rune", ""}
        },
    },
})

gadgets.register_gadget({
    name = "gadgets_magic:tome_gravity",
    description = "Tome Of Gravity",
    texture = "gadgets_magic_tome_gravity.png",
    mana_per_use = 100,
    light_source = 3,
    conflicting_effects = {"gadgets_default_effects_gravity_2"},
    effect = {"gadgets_default_effects_gravity_1"},
    duration = 60,
    use_sound = "gadgets_magic_spell_cast",
    use_sound_gain = 1,
    recipe = {
        {
            {"", "magic_materials:void_rune", ""},
            {"", "magic_materials:enchanted_book", ""},
            {"", "magic_materials:earth_rune", ""}
        },
    },
})

gadgets.register_gadget({
    name = "gadgets_magic:tome_blink",
    description = "Tome Of Blink",
    texture = "gadgets_magic_tome_blink.png",
    mana_per_use = 150,
    light_source = 5,
    use_sound = "gadgets_magic_blink",
    use_sound_gain = 1,

    custom_wear = true,
    custom_on_use = function(itemstack, user, pointed_thing)
        local dist = 50
        local pos = user:get_pos()
        local dir = user:get_look_dir()
        local ray = minetest.raycast(
            {
                x = pos.x + dir.x,
                y = pos.y + 1.625 + dir.y,
                z = pos.z + dir.z,
            },
            {
            x=pos.x + dir.x * dist,
            y=pos.y + 1.625 + dir.y * dist,
            z=pos.z + dir.z * dist,
            },
            true,
            false)
        local target = ray:next()
        if not target then return end
        if target and target.intersection_point then
            local normal = target.intersection_normal
            if normal.x == 0 and normal.y == 0 and normal.z == 0 then return end
            local b_pos = {
                x = target.intersection_point.x + normal.x * 0.5,
                y = target.intersection_point.y + normal.y * 0.5,
                z = target.intersection_point.z + normal.z * 0.5,
            }
            local node = minetest.get_node_or_nil(b_pos)
            local above = minetest.get_node_or_nil({x = b_pos.x, y = b_pos.y + 1, z = b_pos.z})
            local below = minetest.get_node_or_nil({x = b_pos.x, y = b_pos.y - 1, z = b_pos.z})
            local teleported = false
            local new_pos = {}
            if node and above and below then
                if node.name == "air" and above.name == "air" then
                    new_pos = {x = b_pos.x, y = b_pos.y - 0.5, z = b_pos.z}
                    user:set_pos(new_pos)
                    teleported = true
                elseif node.name == "air" and below.name == "air" then
                    new_pos = {x = b_pos.x, y = b_pos.y - 1.5, z = b_pos.z}
                    user:set_pos(new_pos)
                    teleported = true
                end
            end
            if teleported then
                for _,v in pairs({new_pos, pos}) do
                    minetest.add_particlespawner({
                        amount = 32,
                        time = 0.05,
                        minpos = v,
                        maxpos = v,
                        minvel = {x=-4, y=-4, z=-4},
                        maxvel = {x=4, y=4, z=4},
                        minacc = {x=0, y=2, z=0},
                        maxacc = {x=0, y=2, z=0},
                        minexptime = 1,
                        maxexptime = 4,
                        minsize = 2,
                        maxsize = 4,
                        glow = 14,
                        texture = "gadgets_magic_tome_blink_particle.png",
                    })
                    minetest.add_particle({
                        pos = v,
                        expirationtime = 1,
                        size = 35,
                        texture = "gadgets_magic_tome_blink_particle_big.png",
                        glow = 14,
                    })
                end
                return true
            end
        end
    end,
    recipe = {
        {
            {"", "magic_materials:void_rune", ""},
            {"", "magic_materials:enchanted_book", ""},
            {"", "magic_materials:storm_rune", ""}
        },
    },
})

gadgets.register_gadget({
    name = "gadgets_magic:tome_bridge",
    description = "Tome Of Magical Bridge",
    texture = "gadgets_magic_tome_magic_bridge.png",
    mana_per_use = 100,
    light_source = 7,
    use_sound = "gadgets_magic_spell_cast",
    use_sound_gain = 1,

    custom_on_use = function(itemstack, user, pointed_thing)

        local length = 20
        local width = 3
        local timeout = 30

        local pos = user:get_pos()
        local bpos = {x = pos.x, y = pos.y - 1, z = pos.z}
        local name = user:get_player_name()

        local dir = user:get_look_dir()
        local facedir = minetest.dir_to_facedir(dir)

        local dirvec = {}
        if facedir == 0 then
            dirvec = {x = 0, y = 0, z = 1}
        elseif facedir == 1 then
            dirvec = {x = 1, y = 0, z = 0}
        elseif facedir == 2 then
            dirvec = {x = 0, y = 0, z = -1}
        elseif facedir == 3 then
            dirvec = {x = -1, y = 0, z = 0}
        end

        for i = 0,length - 1 do
            for j = -math.floor(width/2),math.floor(width/2) do
                local temppos = {x = bpos.x + (i * dirvec.x) + (j * dirvec.z), y = bpos.y, z = bpos.z + (i * dirvec.z)  + (j * dirvec.x)}
                if not minetest.is_protected(temppos, name) then
                    local node = minetest.get_node_or_nil(temppos)
                    if node and node.name == "air" then
                        minetest.set_node(temppos, {name = "gadgets_magic:magic_bridge"})
                        minetest.get_node_timer(temppos):start(timeout)
                        minetest.add_particlespawner({
                            amount = 8,
                            time = 0.05,
                            minpos = {x=temppos.x-0.25, y=temppos.y, z=temppos.z-0.25},
                            maxpos = {x=temppos.x+0.25, y=temppos.y+0.5, z=temppos.z+0.25},
                            minvel = {x=-1, y=-1, z=-1},
                            maxvel = {x=1, y=1, z=1},
                            minacc = {x=0, y=2, z=0},
                            maxacc = {x=0, y=2, z=0},
                            minexptime = 1,
                            maxexptime = 4,
                            minsize = 2,
                            maxsize = 4,
                            glow = 14,
                            texture = "gadgets_magic_magic_bridge_particle.png",
                        })
                    end
                end
            end  
        end

    end,
    recipe = {
        {
            {"", "magic_materials:energy_rune", ""},
            {"", "magic_materials:enchanted_book", ""},
            {"", "magic_materials:ice_rune", ""}
        },
    },
})

gadgets.register_gadget({
    name = "gadgets_magic:tome_light",
    description = "Tome Of Magical Light",
    texture = "gadgets_magic_tome_light.png",
    mana_per_use = 100,
    light_source = 13,
    use_sound = "gadgets_magic_spell_cast",
    use_sound_gain = 1,

    custom_wear = true,
    custom_on_use = function(itemstack, user, pointed_thing)

        if not user then return end
        local name = user:get_player_name()

        if pointed_thing and pointed_thing.type == "node" then
            local pos = minetest.get_pointed_thing_position(pointed_thing)
            local node = minetest.get_node_or_nil(pos)
            if node and (node.name == "default:stone" or node.name == "default:desert_stone") then
                if not minetest.is_protected(pos, name) then
                    minetest.set_node(pos, {name = "gadgets_magic:magic_lantern"})
                    --local point = pointed_thing.intersection_point
                    minetest.add_particlespawner({
                        amount = 32,
                        time = 0.05,
                        minpos = {x=pos.x-0.25, y=pos.y-0.25, z=pos.z-0.25},
                        maxpos = {x=pos.x+0.25, y=pos.y+0.25, z=pos.z+0.25},
                        minvel = {x=-3, y=-3, z=-3},
                        maxvel = {x=3, y=3, z=3},
                        minacc = {x=0, y=-8, z=0},
                        maxacc = {x=0, y=-8, z=0},
                        minexptime = 1,
                        maxexptime = 4,
                        minsize = 2,
                        maxsize = 4,
                        glow = 14,
                        texture = "gadgets_magic_tome_light_particle.png",
                    })
                    return true
                end
            end
        end

    end,
    recipe = {
        {
            {"", "magic_materials:light_rune", ""},
            {"", "magic_materials:enchanted_book", ""},
            {"", "magic_materials:fire_rune", ""}
        },
    },
})
