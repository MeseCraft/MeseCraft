local fireball_blacklist = {
    "default:water_source",
    "default:river_water_source",
    "default:water_flowing",
    "default:river_water_flowing",
}

bweapons.register_weapon({
    name = "bweapons_magic_pack:tome_fireball",
    description = "Tome of Fireball",
    texture = "bweapons_magic_pack_tome_fireball.png",
    mana_per_use = 35,
    liquids_stop = true,
    damage = 15,
    shot_amount = 1,
    spread = 0.035,
    cooldown = 1.5,
    aoe = true,
    aoe_radius = 2,
    flare = "bweapons_magic_pack_fireball_flare.png",
    flare_size = 10,
    flare_glow = true,
    hit_flare = "bweapons_magic_pack_fireball_hit_flare.png",
    hit_flare_size = 20,
    hit_flare_glow = true,
    hit_particle = "bweapons_magic_pack_fireball_hit_particle.png",
    hit_particle_glow = true,
    hit_particle_amount = 32,
    hit_particle_size = 10,
    hit_particle_velocity = 7,
    hit_particle_gravity = -8,
    trail_particle = "bweapons_magic_pack_fireball_trail.png",
    trail_particle_velocity = 0.4,
    trail_particle_gravity = 1,
    trail_particle_size = 6,
    trail_particle_amount = 4,
    trail_particle_displacement = 0.6,
    trail_particle_glow = true,
    fire_sound = "bweapons_magic_pack_fireball_fire",
    fire_sound_gain = 0.75,
    reload_sound = "bweapons_magic_pack_reload",
    reload_sound_gain = 0.25,
    hit_sound = "bweapons_magic_pack_fireball_hit",
    hit_sound_gain = 0.75,
    projectile_speed = 27,
    projectile_gravity = 1.5,
    projectile_timeout = 35,
    projectile_texture = "bweapons_magic_pack_fireball_projectile.png",
    projectile_glow = true,
    projectile_visual_size = 1.15,
    on_hit = function (projectile, target)
        if target.type == "node" then
            local target_pos = minetest.get_pointed_thing_position(target, false)
            local node = minetest.get_node_or_nil(target_pos)
            if minetest.is_protected(target_pos, projectile.owner:get_player_name()) then return end
            for _,v in pairs(fireball_blacklist) do
                if node and node.name == v then return end
            end
            local air_pos = minetest.find_node_near(target_pos, 2, "air", true)
            if air_pos ~= nil then
                if minetest.is_protected(air_pos, projectile.owner:get_player_name()) then return end
                local delta = {x = target_pos.x - air_pos.x, y = target_pos.y - air_pos.y, z = target_pos.z - air_pos.z}
                local rotation = minetest.dir_to_wallmounted(delta)
                minetest.set_node(air_pos, {name = "fire:basic_flame", nil, param2 = rotation})
            end
        end
    end,
    recipe = {
        {
            {"", "magic_materials:fire_rune", ""},
            {"", "magic_materials:enchanted_book", ""},
            {"", "", ""}
        },
    },
})

bweapons.register_weapon({
    name = "bweapons_magic_pack:tome_iceshard",
    description = "Tome of Ice Shard",
    texture = "bweapons_magic_pack_tome_iceshard.png",
    mana_per_use = 40,
    liquids_stop = true,
    damage = 20,
    shot_amount = 1,
    spread = 0.02,
    cooldown = 1.5,
    aoe = true,
    aoe_radius = 4,
    flare = "bweapons_magic_pack_iceshard_flare.png",
    flare_size = 10,
    flare_glow = true,
    hit_flare = "bweapons_magic_pack_iceshard_hit_flare.png",
    hit_flare_size = 25,
    hit_flare_glow = true,
    hit_particle = "bweapons_magic_pack_iceshard_hit_particle.png",
    hit_particle_glow = true,
    hit_particle_amount = 48,
    hit_particle_size = 8,
    hit_particle_velocity = 8,
    hit_particle_gravity = -8,
    trail_particle = "bweapons_magic_pack_iceshard_trail.png",
    trail_particle_velocity = 0.5,
    trail_particle_gravity = -7,
    trail_particle_size = 4,
    trail_particle_amount = 6,
    trail_particle_displacement = 0.6,
    trail_particle_glow = true,
    fire_sound = "bweapons_magic_pack_iceshard_fire",
    fire_sound_gain = 0.75,
    reload_sound = "bweapons_magic_pack_reload",
    reload_sound_gain = 0.25,
    hit_sound = "bweapons_magic_pack_iceshard_hit",
    hit_sound_gain = 0.75,
    projectile_speed = 30,
    projectile_gravity = -6,
    projectile_timeout = 35,
    projectile_texture = "bweapons_magic_pack_iceshard_projectile.png",
    projectile_glow = true,
    projectile_visual_size = 1.15,
    on_hit = function (projectile, target)
        if target.type == "node" then
            local target_pos = minetest.get_pointed_thing_position(target, false)
            local node = minetest.get_node_or_nil(target_pos)
            if not node then return end
            if minetest.is_protected(target_pos, projectile.owner:get_player_name()) then return end
            if node.name == "default:water_source" or node.name == "default:river_water_source" then
                minetest.set_node(target_pos, {name = "default:ice"})
            elseif node.name == "default:lava_source" then
                minetest.set_node(target_pos, {name = "default:obsidian"})
            elseif node.name == "default:lava_flowing" then
                minetest.set_node(target_pos, {name = "default:stone"})
            end
        end
    end,
    recipe = {
        {
            {"", "magic_materials:ice_rune", ""},
            {"", "magic_materials:enchanted_book", ""},
            {"", "", ""}
        },
    },
})

bweapons.register_weapon({
    name = "bweapons_magic_pack:tome_electrosphere",
    description = "Tome of Electrosphere",
    texture = "bweapons_magic_pack_tome_electrosphere.png",
    mana_per_use = 37,
    liquids_stop = true,
    damage = 18,
    shot_amount = 1,
    spread = 0.02,
    cooldown = 1.5,
    aoe = true,
    aoe_radius = 3,
    flare = "bweapons_magic_pack_electrosphere_flare.png",
    flare_size = 10,
    flare_glow = true,
    hit_flare = "bweapons_magic_pack_electrosphere_hit_flare.png",
    hit_flare_size = 35,
    hit_flare_glow = true,
    hit_particle = "bweapons_magic_pack_electrosphere_hit_particle.png",
    hit_particle_glow = true,
    hit_particle_amount = 48,
    hit_particle_size = 12,
    hit_particle_velocity = 8,
    hit_particle_gravity = 3,
    trail_particle = "bweapons_magic_pack_electrosphere_trail.png",
    trail_particle_velocity = 0,
    trail_particle_gravity = 1,
    trail_particle_size = 5,
    trail_particle_amount = 6,
    trail_particle_displacement = 0.9,
    trail_particle_glow = true,
    fire_sound = "bweapons_magic_pack_electrosphere_fire",
    fire_sound_gain = 1.25,
    reload_sound = "bweapons_magic_pack_reload",
    reload_sound_gain = 0.25,
    hit_sound = "bweapons_magic_pack_electrosphere_hit",
    hit_sound_gain = 1.25,
    projectile_speed = 22,
    projectile_gravity = 0,
    projectile_timeout = 45,
    projectile_texture = "bweapons_magic_pack_electrosphere_projectile.png",
    projectile_glow = true,
    projectile_visual_size = 1.3,
    on_hit = function (projectile, target)
        if target.type == "node" then
            local target_pos = minetest.get_pointed_thing_position(target, false)
            local node = minetest.get_node_or_nil(target_pos)
            if not node then return end
            if minetest.is_protected(target_pos, projectile.owner:get_player_name()) then return end
            if node.name == "default:sand" or node.name == "default:silver_sand" or node.name == "default:desert_sand" then
                minetest.set_node(target_pos, {name = "default:glass"})
            end
        end
    end,
    recipe = {
        {
            {"", "magic_materials:storm_rune", ""},
            {"", "magic_materials:enchanted_book", ""},
            {"", "", ""}
        }
    },
})

bweapons.register_weapon({
    name = "bweapons_magic_pack:staff_magic",
    description = "Staff of Energy",
    texture = "bweapons_magic_pack_staff_magic.png",
    has_durability = true,
    uses = 32,
    custom_charge = true,
    repair_with = "magic_materials:februm_crystal",
    repair_uses = 2,
    liquids_stop = true,
    damage = 27,
    shot_amount = 1,
    spread = 0.02,
    cooldown = 2,
    aoe = true,
    aoe_radius = 6,
    flare = "bweapons_magic_pack_magic_flare.png",
    flare_size = 20,
    flare_glow = true,
    hit_flare = "bweapons_magic_pack_magic_hit_flare.png",
    hit_flare_size = 40,
    hit_flare_glow = true,
    hit_particle = "bweapons_magic_pack_magic_hit_particle.png",
    hit_particle_glow = true,
    hit_particle_amount = 48,
    hit_particle_size = 12,
    hit_particle_velocity = 8,
    hit_particle_gravity = -1,
    trail_particle = "bweapons_magic_pack_magic_trail.png",
    trail_particle_velocity = 2,
    trail_particle_gravity = 0,
    trail_particle_size = 6,
    trail_particle_amount = 8,
    trail_particle_displacement = 1,
    trail_particle_glow = true,
    fire_sound = "bweapons_magic_pack_magic_fire",
    fire_sound_gain = 0.75,
    reload_sound = "bweapons_magic_pack_reload",
    reload_sound_gain = 0.25,
    hit_sound = "bweapons_magic_pack_magic_hit",
    hit_sound_gain = 1,
    projectile_speed = 30,
    projectile_gravity = -7,
    projectile_timeout = 35,
    projectile_texture = "bweapons_magic_pack_magic_projectile.png",
    projectile_glow = true,
    projectile_visual_size = 2,
    recipe = {
        {
            {"", "magic_materials:energy_rune", ""},
            {"", "magic_materials:enchanted_staff", ""},
            {"", "default:diamond", ""}
        },
    },
})

bweapons.register_weapon({
    name = "bweapons_magic_pack:staff_light",
    description = "Staff of Light",
    texture = "bweapons_magic_pack_staff_light.png",
    has_durability = true,
    uses = 32,
    custom_charge = true,
    repair_with = "magic_materials:februm_crystal",
    repair_uses = 2,
    damage = 22,
    shot_amount = 1,
    spread = 0.02,
    cooldown = 2,
    aoe = true,
    aoe_radius = 4,
    flare = "bweapons_magic_pack_light_flare.png",
    flare_size = 20,
    flare_glow = true,
    hit_flare = "bweapons_magic_pack_light_hit_flare.png",
    hit_flare_size = 30,
    hit_flare_glow = true,
    hit_particle = "bweapons_magic_pack_light_hit_particle.png",
    hit_particle_glow = true,
    hit_particle_amount = 48,
    hit_particle_size = 4,
    hit_particle_velocity = 10,
    hit_particle_gravity = 1,
    trail_particle = "bweapons_magic_pack_light_trail.png",
    trail_particle_velocity = 0.3,
    trail_particle_gravity = -0.3,
    trail_particle_size = 8,
    trail_particle_amount = 4,
    trail_particle_displacement = 0.9,
    trail_particle_glow = true,
    fire_sound = "bweapons_magic_pack_light_fire",
    fire_sound_gain = 1,
    reload_sound = "bweapons_magic_pack_reload",
    reload_sound_gain = 0.25,
    hit_sound = "bweapons_magic_pack_light_hit",
    hit_sound_gain = 1.25,
    projectile_speed = 23,
    projectile_gravity = 1.5,
    projectile_timeout = 35,
    projectile_texture = "bweapons_magic_pack_light_projectile.png",
    projectile_glow = true,
    projectile_visual_size = 3,
    recipe = {
        {
            {"", "magic_materials:light_rune", ""},
            {"", "magic_materials:enchanted_staff", ""},
            {"", "default:gold_ingot", ""}
        },
    },
})

bweapons.register_weapon({
    name = "bweapons_magic_pack:staff_void",
    description = "Staff of Void",
    texture = "bweapons_magic_pack_staff_void.png",
    has_durability = true,
    uses = 32,
    custom_charge = true,
    repair_with = "magic_materials:februm_crystal",
    repair_uses = 2,
    liquids_stop = true,
    damage = 25,
    shot_amount = 1,
    spread = 0.02,
    cooldown = 2,
    aoe = true,
    aoe_radius = 5,
    flare = "bweapons_magic_pack_void_flare.png",
    flare_size = 20,
    flare_glow = true,
    hit_flare = "bweapons_magic_pack_void_hit_flare.png",
    hit_flare_size = 30,
    hit_flare_glow = true,
    hit_particle = "bweapons_magic_pack_void_hit_particle.png",
    hit_particle_glow = true,
    hit_particle_amount = 48,
    hit_particle_size = 12,
    hit_particle_velocity = 10,
    hit_particle_gravity = 1,
    trail_particle = "bweapons_magic_pack_void_trail.png",
    trail_particle_velocity = 1,
    trail_particle_gravity = 1,
    trail_particle_size = 6,
    trail_particle_amount = 6,
    trail_particle_displacement = 0.5,
    trail_particle_glow = true,
    fire_sound = "bweapons_magic_pack_void_fire",
    fire_sound_gain = 1,
    reload_sound = "bweapons_magic_pack_reload",
    reload_sound_gain = 0.25,
    hit_sound = "bweapons_magic_pack_void_hit",
    hit_sound_gain = 1.25,
    projectile_speed = 22,
    projectile_gravity = 0,
    projectile_timeout = 45,
    projectile_texture = "bweapons_magic_pack_void_projectile.png",
    projectile_glow = true,
    projectile_visual_size = 1.5,
    on_hit = function (projectile, target)
        if target.type == "node" then
            local target_pos = minetest.get_pointed_thing_position(target, false)
            local node = minetest.get_node_or_nil(target_pos)
            if not node then return end
            if minetest.is_protected(target_pos, projectile.owner:get_player_name()) then return end
            if minetest.registered_nodes[node.name].diggable == false then return end
--            minetest.set_node(target_pos, {name = "air"})
        end
    end,
    recipe = {
        {
            {"", "magic_materials:void_rune", ""},
            {"", "magic_materials:enchanted_staff", ""},
            {"", "default:obsidian", ""}
        },
    },
})
