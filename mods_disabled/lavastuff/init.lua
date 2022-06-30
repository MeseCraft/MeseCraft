lavastuff = {}

local S

if minetest.get_translator ~= nil then
    S = minetest.get_translator(minetest.get_current_modname())
else
    S = function(str)
        return(str)
    end
end

lavastuff.enable_tool_fire = minetest.settings:get_bool("lavastuff_enable_tool_fire")
-- Places fire where the player rightclicks with a lava tool

lavastuff.cook_limit = minetest.settings:get("lavastuff_cook_limit")
-- Tools will not smelt dug items if their cooking time is too long

if lavastuff.cook_limit ~= false then
    lavastuff.cook_limit = 15
end

if lavastuff.enable_tool_fire ~= false then
    lavastuff.enable_tool_fire = true
end

lavastuff.blacklisted_items = { -- Items lava tools will not smelt
    "default:mese_crystal",
    "default:mese",
}

if minetest.registered_items["fire:basic_flame"] and lavastuff.enable_tool_fire == true then
    function lavastuff.tool_fire_func(itemstack, user, pointed)
        local name = user:get_player_name()

        if pointed.type == "node" then
            local node = minetest.get_node(pointed.under)
            local node_under = node.name
            local def = minetest.registered_nodes[node_under]

            if def.on_rightclick then
                return def.on_rightclick(pointed.under, node, user, itemstack, pointed)
            end

            if minetest.is_protected(pointed.under, name) then return end

            if def.on_ignite then
                def.on_ignite(pointed.under, user)
            elseif minetest.get_item_group(node_under, "flammable") >= 1
            and minetest.get_node(pointed.above).name == "air" then
                minetest.set_node(pointed.above, {name = "fire:basic_flame"})
            end
        end
    end
end

function lavastuff.burn_drops(tool)
    local old_handle_node_drops = minetest.handle_node_drops

    function minetest.handle_node_drops(pos, drops, digger)
        if digger:get_wielded_item():get_name() ~= (tool) then
            return old_handle_node_drops(pos, drops, digger)
        end

        -- reset new smelted drops
        local hot_drops = {}

        -- loop through current node drops
        for _, drop in pairs(drops) do -- get cooked output of current drops
            local stack = ItemStack(drop)
            local output = minetest.get_craft_result({
                method = "cooking",
                width = 1,
                items = {drop}
            })

            for _, name in pairs(lavastuff.blacklisted_items) do
                if name == drop then
                    return old_handle_node_drops(pos, drops, digger)
                end
            end

            -- if we have cooked result then add to new list
            if output and output.item and not output.item:is_empty() and output.time <= lavastuff.cook_limit then
                table.insert(hot_drops,
                    ItemStack({
                        name = output.item:get_name(),
                        count = output.item:to_table().count,
                    })
                )
            else -- if not then return normal drops
                table.insert(hot_drops, stack)
            end
        end

        return old_handle_node_drops(pos, hot_drops, digger)
    end
end

lavastuff.burn_drops("lavastuff:sword")
lavastuff.burn_drops("lavastuff:axe")
lavastuff.burn_drops("lavastuff:shovel")

--
-- Crafitems
--

minetest.register_craftitem("lavastuff:ingot", {
    description = S("Lava Ingot"),
    inventory_image = "lavastuff_ingot.png",
    light_source = 7, -- Texture will have a glow when dropped
})

minetest.register_craft({
    type = "shapeless",
    output = "lavastuff:ingot 2",
    recipe = {"default:mese_crystal", "lavastuff:orb"}
})

--
-- Crafitem Crafts
--

if not minetest.get_modpath("mobs_monster") then
    minetest.register_craftitem("lavastuff:orb", {
        description = S("Lava Orb"),
        inventory_image = "zmobs_lava_orb.png",
        light_source = 7, -- Texture will have a glow when dropped
    })

    minetest.register_alias("mobs:lava_orb", "lavastuff:orb")

    minetest.register_craft({
        output = "lavastuff:orb",
        recipe = {
            {"default:mese_crystal", "default:mese_crystal", "default:mese_crystal"},
            {"default:mese_crystal", "bucket:bucket_lava", "default:mese_crystal"},
            {"default:mese_crystal", "default:mese_crystal", "default:mese_crystal"}
        },
        replacements = {{"bucket:bucket_lava", "bucket:bucket_empty 1"}}
    })
else
    minetest.register_alias("lavastuff:orb", "mobs:lava_orb")
end

--
-- Tools
--

minetest.register_tool("lavastuff:sword", {
    description = S("Lava Sword"),
    inventory_image = "lavastuff_sword.png",
    light_source = 7, -- Texture will have a glow when dropped
    tool_capabilities = {
		full_punch_interval = 0.6,
		max_drop_level = 1,
		groupcaps = {
			snappy = {
				times = {1.7, 0.7, 0.25},
				uses = 50,
				maxlevel = 3
			},
		},
		damage_groups = {fleshy = 10, burns = 1},
	},
    on_place = lavastuff.tool_fire_func,
    sound = {breaks = "default_tool_breaks"},
})

if not minetest.get_modpath("mobs_monster") then
    minetest.register_alias("mobs:pick_lava", "lavastuff:pick")

    minetest.register_tool("lavastuff:pick", {
        description = S("Lava Pickaxe"),
        inventory_image = "lavastuff_pick.png",
        light_source = 7, -- Texture will have a glow when dropped
        tool_capabilities = {
            burns = true, -- fire_plus support
            full_punch_interval = 0.7,
            max_drop_level = 3,
            groupcaps={
                cracky = {
                    times = {[1] = 1.8, [2] = 0.8, [3] = 0.40},
                    uses = 40,
                    maxlevel = 3
                },
            },
            damage_groups = {fleshy = 6, burns = 1},
        },
        on_place = lavastuff.tool_fire_func,
    })

-- Lava Pick (restores autosmelt functionality)

    lavastuff.burn_drops("lavastuff:pick")
else
    minetest.register_alias("lavastuff:pick", "mobs:pick_lava")

    minetest.register_tool(":mobs:pick_lava", {
        description = S("Lava Pickaxe"),
        inventory_image = "lavastuff_pick.png",
        light_source = 7, -- Texture will have a glow when dropped
        tool_capabilities = {
            burns = true, -- fire_plus support
            full_punch_interval = 0.7,
            max_drop_level = 3,
            groupcaps={
                cracky = {
                    times = {[1] = 1.8, [2] = 0.8, [3] = 0.40},
                    uses = 40,
                    maxlevel = 3
                },
            },
            damage_groups = {fleshy = 6, burns = 1},
        },
        on_place = lavastuff.tool_fire_func,
    })
end

minetest.register_tool("lavastuff:shovel", {
    description = S("Lava Shovel"),
    inventory_image = "lavastuff_shovel.png",
    wield_image = "lavastuff_shovel.png^[transformR90",
    light_source = 7, -- Texture will have a glow when dropped
    tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			crumbly = {times={[1]=1.10, [2]=0.50, [3]=0.30}, uses=30, maxlevel=3},
		},
		damage_groups = {fleshy=4},
	},
    on_place = lavastuff.tool_fire_func,
    sound = {breaks = "default_tool_breaks"},
})

minetest.register_tool("lavastuff:axe", {
    description = S("Lava Axe"),
    inventory_image = "lavastuff_axe.png",
    light_source = 7, -- Texture will have a glow when dropped
    tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level = 1,
		groupcaps = {
			choppy = {
				times = {[1] = 2.00, [2] = 0.80, [3] = 0.40},
				uses = 40,
				maxlevel = 3
			},
		},
		damage_groups = {fleshy = 7, burns = 1},
	},
    on_place = lavastuff.tool_fire_func,
    sound = {breaks = "default_tool_breaks"},
})

--
-- Tool Crafts
--

minetest.register_craft({
    output = "lavastuff:sword",
    recipe = {
        {"lavastuff:ingot"},
        {"lavastuff:ingot"},
        {"default:obsidian_shard"},
    }
})

minetest.register_craft({
    output = "lavastuff:pick",
    recipe = {
        {"lavastuff:ingot", "lavastuff:ingot", "lavastuff:ingot"},
        {"", "default:obsidian_shard", ""},
        {"", "default:obsidian_shard", ""},
    }
})

minetest.register_craft({
    output = "lavastuff:shovel",
    recipe = {
        {"lavastuff:ingot"},
        {"default:obsidian_shard"},
        {"default:obsidian_shard"},
    }
})

minetest.register_craft({
    output = "lavastuff:axe",
    recipe = {
        {"lavastuff:ingot", "lavastuff:ingot", ""},
        {"lavastuff:ingot", "default:obsidian_shard", ""},
        {"", "default:obsidian_shard", ""},
    }
})

if minetest.get_modpath("mobs_monster") then
    minetest.clear_craft({
        recipe = {
            {"mobs:lava_orb", "mobs:lava_orb", "mobs:lava_orb"},
            {"", "default:obsidian_shard", ""},
            {"", "default:obsidian_shard", ""},
        }
    })
end

--
-- Armor
--

if minetest.get_modpath("3d_armor") then
    armor:register_armor("lavastuff:helmet", {
        description = S("Lava Helmet"),
        inventory_image = "lavastuff_inv_helmet.png",
        light_source = 7, -- Texture will have a glow when dropped
        groups = {armor_head=1, armor_heal=12, armor_use=100, armor_fire=10},
        armor_groups = {fleshy=15},
        damage_groups = {cracky=2, snappy=1, level=3},
        wear = 0,
    })

    armor:register_armor("lavastuff:chestplate", {
        description = S("Lava Chestplate"),
        inventory_image = "lavastuff_inv_chestplate.png",
        light_source = 7, -- Texture will have a glow when dropped
        groups = {armor_torso=1, armor_heal=12, armor_use=100, armor_fire=10},
        armor_groups = {fleshy=20},
        damage_groups = {cracky=2, snappy=1, level=3},
        wear = 0,
    })

    armor:register_armor("lavastuff:leggings", {
        description = S("Lava Leggings"),
        inventory_image = "lavastuff_inv_leggings.png",
        light_source = 7, -- Texture will have a glow when dropped
        groups = {armor_legs=1, armor_heal=12, armor_use=100, armor_fire=10},
        armor_groups = {fleshy=20},
        damage_groups = {cracky=2, snappy=1, level=3},
        wear = 0,
    })

    armor:register_armor("lavastuff:boots", {
        description = S("Lava Boots"),
        inventory_image = "lavastuff_inv_boots.png",
        light_source = 7, -- Texture will have a glow when dropped
        groups = {armor_feet=1, armor_heal=12, armor_use=100, armor_fire=10},
        armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=1, level=3},
        wear = 0,
    })

    armor:register_armor("lavastuff:shield", {
        description = S("Lava Shield"),
        inventory_image = "lavastuff_inven_shield.png",
        light_source = 7, -- Texture will have a glow when dropped
        groups = {armor_shield=1, armor_heal=10, armor_use=100, armor_fire=10},
        armor_groups = {fleshy=20},
        damage_groups = {cracky=2, snappy=1, level=3},
        wear = 0,
    })
end

--
-- Armor Crafts
--

if minetest.get_modpath("3d_armor") then
    minetest.register_craft({
        output = "lavastuff:helmet",
        recipe = {
            {"lavastuff:ingot", "lavastuff:ingot", "lavastuff:ingot"},
            {"lavastuff:ingot", "", "lavastuff:ingot"},
            {"", "", ""},
        }
    })

    minetest.register_craft({
        output = "lavastuff:chestplate",
        recipe = {
            {"lavastuff:ingot", "", "lavastuff:ingot"},
            {"lavastuff:ingot", "lavastuff:ingot", "lavastuff:ingot"},
            {"lavastuff:ingot", "lavastuff:ingot", "lavastuff:ingot"},
        }
    })

    minetest.register_craft({
        output = "lavastuff:leggings",
        recipe = {
            {"lavastuff:ingot", "lavastuff:ingot", "lavastuff:ingot"},
            {"lavastuff:ingot", "", "lavastuff:ingot"},
            {"lavastuff:ingot", "", "lavastuff:ingot"},
        }
    })

    minetest.register_craft({
        output = "lavastuff:boots",
        recipe = {
            {"lavastuff:ingot", "", "lavastuff:ingot"},
            {"lavastuff:ingot", "", "lavastuff:ingot"},
        }
    })

    minetest.register_craft({
        output = "lavastuff:shield",
        recipe = {
            {"lavastuff:ingot", "lavastuff:ingot", "lavastuff:ingot"},
            {"lavastuff:ingot", "lavastuff:ingot", "lavastuff:ingot"},
            {"", "lavastuff:ingot", ""},
        }
    })
end

--
-- Nodes
--

minetest.register_node("lavastuff:block", {
    description = S("Lava Block"),
    tiles = {"lavastuff_block.png"},
    is_ground_content = false,
    sounds = default.node_sound_stone_defaults(),
    groups = {cracky = 2, level = 2},
    light_source = 4,
})

minetest.register_craft({
    type = "shapeless",
    output = "lavastuff:ingot 9",
    recipe = {"lavastuff:block"}
})

minetest.register_craft({
    output = "lavastuff:block",
    recipe = {
        {"lavastuff:ingot", "lavastuff:ingot", "lavastuff:ingot"},
        {"lavastuff:ingot", "lavastuff:ingot", "lavastuff:ingot"},
        {"lavastuff:ingot", "lavastuff:ingot", "lavastuff:ingot"},
    }
})

if not minetest.get_modpath("moreblocks") then
    stairs.register_stair_and_slab(
        "lava",
        "lavastuff:block",
        {cracky = 2, level = 2},
        {"lavastuff_block.png"},
        S("Lava Stair"),
        S("Lava Slab"),
        default.node_sound_stone_defaults(),
        true
    )
else
    stairsplus:register_all("lavastuff", "lava", "lavastuff:ingot", {
        description = "Lava",
        tiles = {"lavastuff_block.png"},
        groups = {cracky = 2, level = 2},
        light_source = 4,
        sounds = default.node_sound_wood_defaults(),
    })
end

--
--Toolranks support
--

if minetest.get_modpath("toolranks") then
    minetest.override_item("lavastuff:sword", {
        description = toolranks.create_description(S("Lava Sword"), 0, 1),
        original_description = S("Lava Sword"),
        after_use = toolranks.new_afteruse
    })

    minetest.override_item("lavastuff:pick", {
        description = toolranks.create_description(S("Lava Pickaxe"), 0, 1),
        original_description = S("Lava Pickaxe"),
        after_use = toolranks.new_afteruse
    })

    minetest.override_item("lavastuff:axe", {
        description = toolranks.create_description(S("Lava Axe"), 0, 1),
        original_description = S("Lava Axe"),
        after_use = toolranks.new_afteruse
    })

    minetest.override_item("lavastuff:shovel", {
        description = toolranks.create_description(S("Lava Shovel"), 0, 1),
        original_description = S("Lava Shovel"),
        after_use = toolranks.new_afteruse
    })
end

--
-- Lava in a Bottle
--

minetest.register_node("lavastuff:lava_in_a_bottle", {
	description = S("Lava in a Bottle"),
	drawtype = "plantlike",
	tiles = {{
        name = "lavastuff_lava_in_a_bottle.png",
        animation = {
            type = "vertical_frames",
            aspect_w = 16,
            aspect_h = 16,
            length = 2.0
        }
    }},
	inventory_image = "lavastuff_lava_in_a_bottle.png^[verticalframe:2:0",
	wield_image = "lavastuff_lava_in_a_bottle.png^[verticalframe:2:0",
    paramtype = "light",
    light_source = 9,
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
	},
	groups = {vessel = 1, dig_immediate = 3, attached_node = 1},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_craft({
    output = "lavastuff:lava_in_a_bottle",
    recipe = {
        {"", "bucket:bucket_lava"},
        {"", "vessels:glass_bottle"},
    },
    replacements = {{"bucket:bucket_lava", "bucket:bucket_empty"}}
})
