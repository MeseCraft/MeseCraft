-- Graves are from church modpack. Edited to use simple text. Used for ghosts+zombies and maybe other deathly functions.

screwdriver = screwdriver or {}

grave = {}

--Register Gravestone node.
minetest.register_node("mobs_creatures:gravestone", {
        description = "Gravestone",
        tiles = {"default_stone.png", "default_stone.png",
        "default_stone.png", "default_stone.png",
        "default_stone.png", "default_stone.png"},
        groups = {cracky = 3, oddly_breakable_by_hand = 2, choppy =1, gravestone = 1,},
        drawtype = "nodebox",
        paramtype = "light",
        paramtype2 = "facedir",
        sunlight_propagates = true,
        is_ground_content = false,
        buildable_to = false,
        --light_source = 1,
        sounds = default.node_sound_stone_defaults(),
        node_box = {
                type = "fixed",
                fixed = {
                        {-0.3125, -0.3125, -0.125, 0.3125, 0.3125, 0.125},
                        {-0.375, -0.4375, -0.1875, 0.375, -0.3125, 0.1875},
                        {-0.4375, -0.5, -0.25, 0.4375, -0.4375, 0.25},
                        {-0.25, 0.3125, -0.125, 0.25, 0.375, 0.125},
                        {-0.125, 0.375, -0.125, 0.125, 0.4375, 0.125},
                }
        },
        selection_box = {
                type = "fixed",
                fixed = {
                        {-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
                }
        },
        on_construct =  function(pos)
                local meta = minetest.get_meta(pos)
                meta:set_string("formspec", "field[text;;${text}]")
                meta:set_string("infotext", "\"\"")
        end,
        on_receive_fields = function(pos, formname, fields, sender)
                local meta = minetest.get_meta(pos)
                fields.text = fields.text or ""
                print((sender:get_player_name() or "").." wrote \""..fields.text..
                                "\" to sign at "..minetest.pos_to_string(pos))
                meta:set_string("text", fields.text)
                meta:set_string("infotext", '"'..fields.text..'"')
        end,
})
-- Register Cross Gravestone
minetest.register_node("mobs_creatures:gravestone_cross", {
        description = "Cross Gravestone",
        tiles = {"default_stone.png", "default_stone.png",
        "default_stone.png", "default_stone.png",
        "default_stone.png", "default_stone.png"},
        groups = {cracky = 3, oddly_breakable_by_hand = 2, choppy =1, gravestone = 1,},
        drawtype = "nodebox",
        paramtype = "light",
        paramtype2 = "facedir",
        sunlight_propagates = true,
        is_ground_content = false,
        buildable_to = false,
        --light_source = 1,
        sounds = default.node_sound_stone_defaults(),
        on_rotate = screwdriver.rotate_simple,
        node_box = {
                type = "fixed",
                fixed = {
                        {-0.125, -0.25, -0.125, 0.125, 0.5, 0.125},
                        {-0.3125, 0.0625, -0.125, 0.3125, 0.3125, 0.125},
                        {-0.1875, -0.375, -0.1875, 0.1875, -0.25, 0.1875},
                        {-0.3125, -0.5, -0.3125, 0.3125, -0.375, 0.3125},
                }
        },
        selection_box = {
                type = "fixed",
                fixed = {
                        {-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
                }
        },
        on_construct =  function(pos)
                --local n = minetest.get_node(pos)
                local meta = minetest.get_meta(pos)
                meta:set_string("formspec", "field[text;;${text}]")
                meta:set_string("infotext", "\"\"")
        end,
        on_receive_fields = function(pos, formname, fields, sender)
                --print("Sign at "..minetest.pos_to_string(pos).." got "..dump(fields))
                local meta = minetest.get_meta(pos)
                fields.text = fields.text or ""
                print((sender:get_player_name() or "").." wrote \""..fields.text..
                                "\" to sign at "..minetest.pos_to_string(pos))
                meta:set_string("text", fields.text)
                meta:set_string("infotext", '"'..fields.text..'"')
        end,
})

-----------
--Crafting
-----------
minetest.register_craft({
        output = "mobs_creatures:gravestone",
        recipe = {
                { "", "default:stone", "" },
                { "default:stone", "default:sign_wall_wood", "default:stone" },
                { "default:stone", "default:stone", "default:stone" },
        }
})

minetest.register_craft({
        output = "mobs_creatures:gravestone_cross",
        recipe = {
                { "", "default:stone", "" },
                { "default:stone", "default:sign_wall_wood", "default:stone" },
                { "", "default:stone", "" },
        }
})


