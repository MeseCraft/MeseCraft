--   _________  __   .__          __        __________                  __
--  /   _____/_/  |_ |__|  ____  |  | __    \______   \_____     ____  |  | __
--  \_____  \ \   __\|  |_/ ___\ |  |/ /     |     ___/\__  \  _/ ___\ |  |/ /
--  /        \ |  |  |  |\  \___ |    <      |    |     / __ \_\  \___ |    <
-- /_______  / |__|  |__| \___  >|__|_ \     |____|    (____  / \___  >|__|_ \
--         \/                 \/      \/                    \/      \/      \/
-- A Minetest mod that adds fancy sticks

stickpack = {}
stickpack.version = "0.1.0"

-- Some stuff to restrict certain sticks to staff
minetest.register_privilege("admin_stick", "Allows the user to use restricted sticks.")
stickpack.admin_sticks_creative = (tonumber(minetest.setting_get("stickpack_admin_sticks_creative")) or 0)

-- Sticks to restrict, these sticks will require the admin_stick privilege
stickpack.restricted_sticks = string.split(minetest.setting_get("stickpack_restricted_sticks") or "godstick,ripstick,kickstick", ",")

-- Family friendliness
stickpack.family_friendly = (minetest.setting_getbool("stickpack_family_friendly") or false)

-- Number of hitmarker HUDs to add
stickpack.litstick_hitmarker_count = (tonumber(minetest.setting_get("stickpack_litstick_hitmarker_count")) or 3)

-- Variable to limit sticks which modify player skins (so only one skin will be modified at once)
stickpack.limited = {}

-------------
-- Helpers --
-------------

-- Convert restricted sticks string into a usable format

local temp_table = {}

for i in pairs(stickpack.restricted_sticks) do
    temp_table[stickpack.restricted_sticks[i]] = true
end

stickpack.restricted_sticks = temp_table

function table.length(t)
    l = 0
    for i in pairs(t) do
        l = l + 1
    end
    return l
end

-- Privilege check function --

stickpack.priv_check = function(player, itemstack, itemname)
    if stickpack.restricted_sticks[itemname] then
        local name = player:get_player_name()
        if not minetest.check_player_privs(name, {admin_stick = true}) then
            minetest.chat_send_player(name, "This stick is too powerful for mere mortals!")
            minetest.log("action", name.." just tried to use a "..itemstack:get_name().." with insufficient privileges, confiscating.")
            itemstack:take_item()
            return false, itemstack
        end
    end
    return true, itemstack
end

-- Particle effect spawner --

stickpack.particle_effect = function(pos, amount, texture, min_size, max_size, radius, gravity, glow, time)
    radius = radius or 2
    min_size = min_size or 0.5
    max_size = max_size or 1
    gravity = gravity or -10
    glow = glow or 0
    time = time or 10

    minetest.add_particlespawner({
        amount = amount,
        time = time,
        minpos = pos,
        maxpos = pos,
        minvel = {x = -radius, y = -radius, z = -radius},
        maxvel = {x = radius, y = radius, z = radius},
        minacc = {x = 0, y = gravity, z = 0},
        maxacc = {x = 0, y = gravity, z = 0},
        minexptime = 0.1,
        maxexptime = 1,
        minsize = min_size,
        maxsize = max_size,
        texture = texture,
        glow = glow,
    })
end

-- Player-following particle effect function --

stickpack.following_particle_effects = {}

stickpack.update_particle_effects = function()
    for i in pairs(stickpack.following_particle_effects) do
        local player = minetest.get_player_by_name(i)
        local def = stickpack.following_particle_effects[i]
        local pos = player:get_pos()
        pos.y = pos.y + 1
        local node = minetest.get_node(pos).name

        -- If within a stopnode, do not resume
        local stop = false
        if def.stopnodes then
            for n in pairs(def.stopnodes) do
                if def.stopnodes[n] == node then
                    minetest.log("mark")
                    stickpack.following_particle_effects[i] = nil
                    stop = true
                end
            end
        end

        if not stop then
            stickpack.particle_effect(pos, def.quantity_per_second, def.texture, def.min_size, def.max_size, def.radius, def.gravity, def.glow, 1)
            if def.damage_per_second then
                player:set_hp(player:get_hp() - def.damage_per_second)
            end
        end
    end
    minetest.after(1, stickpack.update_particle_effects)
end

minetest.after(1, stickpack.update_particle_effects)

stickpack.create_following_particle_effect = function(player_name, time, def)
    -- If player doesn't already have a particle spawner, set it up
    if not stickpack.following_particle_effects[player_name] then
        stickpack.following_particle_effects[player_name] = def

        -- After "time" remove particle spawner
        minetest.after(time, function(player_name)
            stickpack.following_particle_effects[player_name] = nil
        end, player_name)
        return true
    else
        return false
    end
end

minetest.register_on_respawnplayer(function(player)
    local name = player:get_player_name()
    if stickpack.following_particle_effects[name] then
        stickpack.following_particle_effects[name] = nil
    end
end)

-- Temporary skin application function --

stickpack.skin_limit = {}

stickpack.apply_tempskin = function(time, player, skin)
    local name = player:get_player_name()

    -- If there is already a skin overlay, don't add another one
    if stickpack.skin_limit[name] then return end

    -- Add limiter
    stickpack.skin_limit[name] = true

    -- Copy old skin for re-application later


    -- Make and apply new skin
    if minetest.get_modpath("3d_armor") then
        -- Copy old skin for re-application later
        local old_skin = armor.textures[name].skin

        local new_skin = armor.textures[name].skin.."^"..skin
        armor.textures[name].skin = new_skin
        armor:set_player_armor(player)

        -- Reset skin later
        minetest.after(time, function(name, old_skin)
            armor.textures[name].skin = old_skin
            armor:set_player_armor(player)
            stickpack.skin_limit[name] = nil
        end, name, old_skin)
    else
        -- Copy old skin for re-application later
        local old_textures = player:get_properties().textures

        -- Apply new skin
        local new_textures = player:get_properties().textures
        new_textures[1] = new_textures[1].."^"..skin
        player:set_properties({
            textures = new_textures,
        })

        -- Reset skin later
        minetest.after(time, function(name, old_textures)
            player:set_properties({
                textures = old_textures,
            })
            stickpack.skin_limit[name] = nil
        end, name, old_textures)
    end
end

-- Stick register function, mostly a minetest.register_tool() wrapper but adds priv checks

stickpack.register_stick = function(name, def)
    def.groups = def.groups or {}
    def.groups.not_in_creative_invenory = ((stickpack.admin_sticks_creative and stickpack.restricted_sticks[name]) and 1) or 0

    local old_on_use = def.on_use
    local old_on_place = def.on_place

    def.on_use = function(itemstack, player, pointed_thing)
        local can_use, newstack = stickpack.priv_check(player, itemstack, name)
        if not can_use then return newstack end
        if old_on_use then
            return old_on_use(itemstack, player, pointed_thing)
        end
    end

    def.on_place = function(itemstack, player, pointed_thing)
        local can_use, newstack = stickpack.priv_check(player, itemstack, name)
        if not can_use then return newstack end
        if old_on_place then
            return old_on_place(itemstack, player, pointed_thing)
        end
    end

    minetest.register_tool("stickpack:"..name, def)
end

--------------
-- RIPstick --
--------------

stickpack.register_stick("ripstick", {
    description = "RIPstick",
    inventory_image = "stick_rip.png",
    on_use = function(itemstack, player, pointed_thing)
        -- modify object's HP directly to bypass armor, etc
        if pointed_thing.type == "object" and pointed_thing.ref:get_hp() > 0 then
            if pointed_thing.ref:is_player() then
                minetest.chat_send_all("RIP "..pointed_thing.ref:get_player_name()..". They will be missed.")
            end
            pointed_thing.ref:set_hp(0)
        end
    end,
})

-------------------
-- Springy Stick --
-------------------

stickpack.register_stick("springy_stick", {
    description = "Springy Stick",
    inventory_image = "stick_springy.png",
    on_use = function(itemstack, player, pointed_thing)
        if pointed_thing.type == "object" and pointed_thing.ref:is_player() then
            minetest.chat_send_player(pointed_thing.ref:get_player_name(), "You have been hit with a Springy Stick! Yay!")
            pointed_thing.ref:set_physics_override({
                jump = 2,
                gravity = 0.5,
            })
        end
    end,
})

----------------
-- Lead Stick --
----------------

stickpack.register_stick("lead_stick", {
    description = "Lead Stick",
    inventory_image = "stick_lead.png",
    on_use = function(itemstack, player, pointed_thing)
        if pointed_thing.type == "object" and pointed_thing.ref:is_player() then
            minetest.chat_send_player(pointed_thing.ref:get_player_name(), "You have been hit with a Lead Stick, rip.")
            pointed_thing.ref:set_physics_override({
                jump = 1,
                gravity = 1.5,
                speed = 0.5,
            })
        end
    end,
})

--------------
-- SadStick --
--------------

stickpack.sadstick_old_skins = {}

stickpack.register_stick("sadstick", {
    description = "Sadstick",
    inventory_image = "stick_sad.png",
    on_use = function(itemstack, player, pointed_thing)
        local name = player:get_player_name()
        if pointed_thing.type == "object" and pointed_thing.ref:is_player() and (not stickpack.limited[name]) then
            local hit_player = pointed_thing.ref
            local hit_player_name = hit_player:get_player_name()
            local pos = hit_player:get_pos()

            stickpack.limited[name] = true

            -- Play 2sad4me
            minetest.sound_play("2sad4me", {
                pos = pos,
                max_hear_distance = 10,
                gain = 0.3,
            })

            -- Append tears
            stickpack.apply_tempskin(22, hit_player, "cry.png")

            -- Remove limiter
            minetest.after(22, function(name)
                stickpack.limited[name] = nil
            end, name)
        end
    end,
})

---------------------
-- Knockback Stick --
---------------------

stickpack.register_stick("knockback_stick", {
    description = "Knockback Stick",
    inventory_image = "stick_knockback.png",
    on_use = function(itemstack, player, pointed_thing)
        if pointed_thing.type == "object" then
            local hit_thing = pointed_thing.ref
            local pos = hit_thing:get_pos() -- Entity pos
            pos.y = pos.y + 1.0
            local dir = player:get_look_dir()

            -- Setting player velocity is not possible due to engine limitations, so if it's a player use setpos() instead
            if pointed_thing.ref:is_player() then
                local moveoff = vector.multiply(dir, 8.0)
                local newpos = vector.add(pos, moveoff)
                newpos = vector.add(newpos, {x = 0, y = 2, z = 0})
                hit_thing:setpos(newpos)
            else
                hit_thing:setvelocity({
                    x = dir.x * 8,
                    y = 2,
                    z = dir.z * 8
                })
            end
        end
    end,
})

-----------------------
-- 1000 Degree Stick --
-----------------------

stickpack.register_stick("1000_degree_stick", {
    description = "1000 Degree Stick",
    inventory_image = "stick_1000degree.png",
    on_use = function(itemstack, player, pointed_thing)
        if pointed_thing.type == "object" and pointed_thing.ref:is_player() then
            local hit_player = pointed_thing.ref
            local hit_player_name = hit_player:get_player_name()

            stickpack.create_following_particle_effect(hit_player_name, 10, {
                quantity_per_second = 20,
                texture = "fire_basic_flame.png",
                min_size = 1,
                max_size = 5,
                gravity = 0.2,
                stopnodes = {"default:water_source", "default:water_flowing", "default:river_water_source", "default:river_water_flowing"},
                damage_per_second = 1,
            })
        end
    end,
})

---------------
-- Rickstick --
---------------

stickpack.register_stick("rickstick", {
    description = "Rickstick",
    inventory_image = "stick_rick.png",
    on_use = function(itemstack, player, pointed_thing)
        local name = player:get_player_name()
        if pointed_thing.type == "object" and pointed_thing.ref:is_player() and not stickpack.limited[name] then
            local hit_player = pointed_thing.ref
            local hit_player_name = hit_player:get_player_name()
            local pos = hit_player:get_pos()
            pos.y = pos.y + 1

            stickpack.limited[name] = true

            -- Make following particle effect
            stickpack.create_following_particle_effect(hit_player_name, 17, {
                quantity_per_second = 10,
                texture = "rick.png",
                min_size = 1,
                max_size = 5,
                gravity = 0.2,
            })

            -- Play rickroll
            minetest.sound_play("roll", {
                pos = pos,
                max_hear_distance = 10,
                gain = 1,
            })

            -- Remove limiter
            minetest.after(17, function(name)
                stickpack.limited[name] = nil
            end, name)
        end
    end,
})

----------------
-- Trumpstick --
----------------

-- Barbed wire to "top" things off ;) (from "army" mod)
minetest.register_node("stickpack:barbedwire", {
    description = "Barbed Wire",
    drawtype = "plantlike",
    visual_scale = 1.2,
    tiles = {"army_barbedwire.png"},
    inventory_image = "army_barbedwire.png",
    wield_image = "army_barbedwire.png",
    paramtype = "light",
    walkable = false,
    damage_per_second = 2,
    drop = "stickpack:barbedwire",
    groups = {snappy=2},
})

minetest.register_craft({
    output = "stickpack:barbedwire",
    recipe = {
        {"default:stick"},
        {"default:steel_ingot"},
    }
})

-- Changes yaw to position offset
local function offset_pos(pos, yaw, difference)
    if yaw < 45 or yaw >= 315 then
        pos.x = pos.x - difference
    elseif yaw < 315 and yaw >= 225 then
        pos.z = pos.z + difference
    elseif yaw < 225 and yaw >= 135 then
        pos.x = pos.x + difference
    elseif yaw < 135 and yaw >= 45 then
        pos.z = pos.z - difference
    end
    return pos
end

-- Places column height number of nodes high at pos
stickpack.place_column = function(player, pos, height, node, node_top)
    local function place_node(player, p, node)
        if not minetest.is_protected(p, player:get_player_name()) and minetest.registered_nodes[minetest.get_node(p).name].buildable_to then
            local removed = player:get_inventory():remove_item("main", ItemStack(node.name))
            if removed:get_count() >= 1 then
                minetest.set_node(p, node)
            end
        end
    end

    local temp_pos = {x = pos.x, y = pos.y, z = pos.z}
    for i=1, height do
        if i == height then
            place_node(player, temp_pos, node_top)
        else
            place_node(player, temp_pos, node)
        end
        temp_pos.y = temp_pos.y + 1
    end
end


-- Function to place walls:
-- player for getting yaw
-- pos is the position of the bottom centre of the wall
-- width is the number of columns on either side of the centre to place
-- height is the height of the wall
-- node is the type of node to place (same as required by minetest.set_node)
-- node_top is the node to place on top of the wall (if nil, equals node)
stickpack.place_wall = function(player, pos, width, height, node, node_top)
    -- Get yaw, convert to degrees as I understand them better
    local yaw = math.deg(player:get_look_horizontal())

    -- If node_top is nil, set it to node
    if not node_top then
        node_top = table.copy(node)
    end

    -- Place column in center
    stickpack.place_column(player, pos, height, node, node_top)

    -- Iterate over and place columns on either side
    for i=1, width do
        -- Set up temporary variables
        local left = {x = pos.x, y = pos.y, z = pos.z}
        local right = {x = pos.x, y = pos.y, z = pos.z}

        -- Place a column on either side
        stickpack.place_column(player, offset_pos(left, yaw, i), height, node, node_top)
        stickpack.place_column(player, offset_pos(right, yaw, -i), height, node, node_top)
    end
end

stickpack.register_stick("trumpstick", {
    description = "Trumpstick",
    inventory_image = "stick_trump.png",
    on_use = function(itemstack, player, pointed_thing)
        if pointed_thing.type == "node" then
            minetest.sound_play({pos = pos, name = "default_place_node_metal", gain = 0.5, max_hear_distance = 5})
            stickpack.place_wall(player, pointed_thing.above, 4, 4, {name="default:stone"}, {name="stickpack:barbedwire"})
        end
    end,
})

----------------
-- Clearstick --
----------------

stickpack.register_stick("clearstick", {
    description = "Clearstick",
    inventory_image = "stick_clear.png",
    on_use = function(itemstack, player, pointed_thing)
        local can_use = stickpack.priv_check(player, itemstack, "clearstick")
        if can_use then
            local pos = player:get_pos()
            local objs = nil
            objs = minetest.get_objects_inside_radius(pos, 10)
            if objs then
                for _, obj in ipairs(objs) do
                    if obj and obj:get_luaentity() then
                        obj:remove()
                    end
                end
            end
        end
    end,
    on_place = function(itemstack, placer, pointed_thing)
        local inv = placer:get_inventory()
        local pos = placer:get_pos()
        local objs = nil
        objs = minetest.get_objects_inside_radius(pos, 10)
        if objs then
            for _, obj in ipairs(objs) do
                if obj and obj:get_luaentity() and obj:get_luaentity().name == "__builtin:item" then
                    local leftover = inv:add_item("main", obj:get_luaentity().itemstring)
                    if leftover and not leftover:is_empty() then
                        minetest.add_item(pos, obj:get_luaentity().itemstring)
                    end
                    obj:get_luaentity().itemstring = ""
                    obj:remove()
                end
            end
        end
    end
})

---------------
-- Lavastick --
---------------

stickpack.register_stick("lavastick", {
    description = "Lavastick",
    inventory_image = "stick_lava.png",
    on_use = function(itemstack, player, pointed_thing)
        local name = player:get_player_name()
        local inv = player:get_inventory()
        local pos = player:get_pos()
        local r = 10
        local minp = {x = pos.x - r,y = pos.y - r,z = pos.z - r}
        local maxp = {x = pos.x + r,y = pos.y + r,z = pos.z + r}
        local nodes = minetest.find_nodes_in_area(minp, maxp, "default:snow")

        for i, p in ipairs(nodes) do
            if not minetest.is_protected(p, name) then
                minetest.remove_node(p)
                local leftover = inv:add_item("main", "default:snow")
                if leftover and not leftover:is_empty() then
                    minetest.add_item(pos, "default:snow")
                end
            end
        end
    end,
})

--------------
-- Godstick --
--------------

stickpack.lightning_strike = function(player)
    local pos = player:get_pos()
    local size = 100

    minetest.add_particlespawner({
        amount = 1,
        time = 0.2,
        -- make it hit the top of a block exactly with the bottom
        minpos = {x = pos.x, y = pos.y + (size / 2) + 1/2, z = pos.z },
        maxpos = {x = pos.x, y = pos.y + (size / 2) + 1/2, z = pos.z },
        minvel = {x = 0, y = 0, z = 0},
        maxvel = {x = 0, y = 0, z = 0},
        minacc = {x = 0, y = 0, z = 0},
        maxacc = {x = 0, y = 0, z = 0},
        minexptime = 0.2,
        maxexptime = 0.2,
        minsize = size * 10,
        maxsize = size * 10,
        collisiondetection = true,
        vertical = true,
        -- to make it appear hitting the node that will get set on fire, make sure
        -- to make the texture lightning bolt hit exactly in the middle of the
        -- texture (e.g. 127/128 on a 256x wide texture)
        texture = "lightning.png",
        -- 0.4.15+
        glow = 14,
    })

    minetest.sound_play({ pos = pos, name = "lightning_thunder", gain = 10, max_hear_distance = 500 })

    player:set_hp(0)
end

stickpack.register_stick("godstick", {
    description = "Godstick",
    inventory_image = "stick_god.png",
    on_use = function(itemstack, player, pointed_thing)
        local pos = player:get_pos()
        local objs = nil
        objs = minetest.get_objects_inside_radius(pos, 40)
        if objs then
            for _, obj in ipairs(objs) do
                if obj and obj:is_player() and obj:get_player_name() ~= player:get_player_name() and obj:get_hp() > 0 then
                    stickpack.lightning_strike(obj)
                end
            end
        end
    end,
})

--------------------
-- Summoner Stick --
--------------------

stickpack.register_stick("summoner_stick", {
    description = "Summoner Stick",
    inventory_image = "stick_summoner.png",
    range = 100,
    on_use = function(itemstack, player, pointed_thing)
        if pointed_thing.type == "object" then
            pointed_thing.ref:set_pos(player:get_pos())
        end
    end,
})

---------------
-- Icestick --
---------------

stickpack.register_stick("icestick", {
    description = "Icestick",
    inventory_image = "stick_ice.png",
    on_use = function(itemstack, player, pointed_thing)
        local name = player:get_player_name()
        if pointed_thing.type == "object" and pointed_thing.ref:is_player() and (not stickpack.limited[name]) then
            local hit_player = pointed_thing.ref
            local pos = hit_player:get_pos()

            stickpack.limited[name] = true

            -- Play freeze sound
            minetest.sound_play("freeze", {
                pos = pos,
                max_hear_distance = 10,
                gain = 0.3,
            })

            -- Append ice
            stickpack.apply_tempskin(30, hit_player, "freeze.png")

            -- Freeze
            hit_player:set_physics_override({
                jump = 0,
                speed = 0,
                gravity = 0,
            })

            -- Remove limiter
            minetest.after(30, function(name, hit_player)
                stickpack.limited[name] = nil
                hit_player:set_physics_override({
                    jump = 1,
                    speed = 1,
                    gravity = 1,
                })
            end, name, hit_player)
        end
    end,
})

---------------
-- Firestick --
---------------

stickpack.register_stick("firestick", {
    description = "Firestick",
    inventory_image = "stick_fire.png",
    on_use = function(itemstack, player, pointed_thing)
        if pointed_thing.type == "node" then
            local name = player:get_player_name()
            local pos = minetest.get_pointed_thing_position(pointed_thing, true)
            if not minetest.is_protected(pos, name) then
                local inv = player:get_inventory()
                local old_node = minetest.get_node(pos)
                if old_node.name == "air" then
                    minetest.set_node(pos, {name = "fire:permanent_flame"})
                end
            end
        end
    end,
})

---------------
-- Kickstick --
---------------

local reasons = {
    "Kicked for using the kickstick",
    "Kicked for dabbing too hard.",
    "Kicked for watching the emoji movie and enjoying it.",
}

stickpack.register_stick("kickstick", {
    description = "Kickstick",
    inventory_image = "stick_kick.png",
    on_use = function(itemstack, player, pointed_thing)
        if pointed_thing.type == "object" and pointed_thing.ref:is_player() then
            minetest.kick_player(pointed_thing.ref:get_player_name(), reasons[math.random(1, table.length(reasons))])
        end
    end,
})

dofile(minetest.get_modpath("stickpack").."/crafts.lua")
