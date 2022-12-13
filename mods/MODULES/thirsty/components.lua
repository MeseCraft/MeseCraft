--[[

Default components for Thirsty.

These are nodes and items that "implement" the functionality
from functions.lua

See init.lua for license.

]]


--[[

Drinking containers (Tier 1)

Defines a simple wooden bowl which can be used on water to fill
your hydration.

Optionally also augments the nodes from vessels to enable drinking
on use.

]]

if minetest.get_modpath("vessels") and thirsty.config.register_vessels then
    -- add "drinking" to vessels
    thirsty.augment_item_for_drinking('vessels:drinking_glass', 22)
    thirsty.augment_item_for_drinking('vessels:glass_bottle', 24)
    thirsty.augment_item_for_drinking('vessels:steel_bottle', 26)
end

if minetest.get_modpath("default") and thirsty.config.register_bowl then
    -- our own simple wooden bowl
    minetest.register_craftitem('thirsty:wooden_bowl', {
        description = "Wooden bowl",
        inventory_image = "thirsty_bowl_16.png",
        liquids_pointable = true,
        on_use = thirsty.on_use(nil),
    })

    minetest.register_craft({
        output = "thirsty:wooden_bowl",
        recipe = {
            {"group:wood", "", "group:wood"},
            {"default:stick", "group:wood", "default:stick"}
        }
    })
end

--[[

Hydro containers (Tier 2)

Defines canteens (currently two types, with different capacities),
tools which store hydro. They use wear to show their content
level in their durability bar; they do not disappear when used up.

Wear corresponds to hydro level as follows:
- a wear of 0     shows no durability bar       -> empty (initial state)
- a wear of 1     shows a full durability bar   -> full
- a wear of 65535 shows an empty durability bar -> empty

]]

if minetest.get_modpath("default") and thirsty.config.register_canteens then

    minetest.register_tool('thirsty:wood_canteen', {
        description = 'Wooden Canteen',
        inventory_image = "wood_canteen.png",
        liquids_pointable = true,
        stack_max = 1,
        on_use = thirsty.on_use(nil),
    })
    minetest.register_tool('thirsty:bronze_canteen', {
        description = 'Bronze Canteen',
        inventory_image = "bronze_canteen.png",
        liquids_pointable = true,
        stack_max = 1,
        on_use = thirsty.on_use(nil),
    })

    minetest.register_tool('thirsty:steel_canteen', {
        description = 'Steel Canteen',
        inventory_image = "steel_canteen.png",
        liquids_pointable = true,
        stack_max = 1,
        on_use = thirsty.on_use(nil),
    })

    minetest.register_tool('thirsty:silver_canteen', {
        description = 'Silver Canteen',
        inventory_image = "silver_canteen.png",
        liquids_pointable = true,
        stack_max = 1,
        on_use = thirsty.on_use(nil),
    })
    minetest.register_tool('thirsty:gold_canteen', {
        description = 'Gold Canteen',
        inventory_image = "gold_canteen.png",
        liquids_pointable = true,
        stack_max = 1,
        on_use = thirsty.on_use(nil),
    })
    minetest.register_tool('thirsty:diamond_canteen', {
        description = 'Diamond Canteen',
        inventory_image = "diamond_canteen.png",
        liquids_pointable = true,
        stack_max = 1,
        on_use = thirsty.on_use(nil),
    })
    minetest.register_tool('thirsty:mithril_canteen', {
        description = 'Mithril Canteen',
        inventory_image = "mithril_canteen.png",
        liquids_pointable = true,
        stack_max = 1,
        on_use = thirsty.on_use(nil),
    })
    minetest.register_craft({
        output = "thirsty:wood_canteen",
        recipe = {
            { "group:wood", ""},
            { "group:wood", "group:wood"},
            { "group:wood", "group:wood"}
        }
    })
    minetest.register_craft({
        output = "thirsty:bronze_canteen",
        recipe = {
            { "group:wood", ""},
            { "default:bronze_ingot", "default:bronze_ingot"},
            { "default:bronze_ingot", "default:bronze_ingot"}
        }
    })
    minetest.register_craft({
        output = "thirsty:steel_canteen",
        recipe = {
            { "group:wood", ""},
            { "default:steel_ingot", "default:steel_ingot"},
            { "default:steel_ingot", "default:steel_ingot"}
        }
    })
    minetest.register_craft({
        output = "thirsty:silver_canteen",
        recipe = {
            { "group:wood", ""},
            { "moreores:silver_ingot", "moreores:silver_ingot"},
            { "moreores:silver_ingot", "moreores:silver_ingot"}
        }
    })
    minetest.register_craft({
        output = "thirsty:gold_canteen",
        recipe = {
            { "group:wood", ""},
            { "default:gold_ingot", "default:gold_ingot"},
            { "default:gold_ingot", "default:gold_ingot"}
        }
    })
    minetest.register_craft({
        output = "thirsty:diamond_canteen",
        recipe = {
            { "group:wood", ""},
            { "default:diamond", "default:diamond"},
            { "default:diamond", "default:diamond"}
        }
    })
    minetest.register_craft({
        output = "thirsty:mithril_canteen",
        recipe = {
            { "group:wood", ""},
            { "moreores:mithril_ingot", "moreores:mithril_ingot"},
            { "moreores:mithril_ingot", "moreores:mithril_ingot"}
        }
    })


end

--[[

Tier 3

]]

if minetest.get_modpath("default") and minetest.get_modpath("mesecraft_bucket") and thirsty.config.register_drinking_fountain then

    minetest.register_node('thirsty:drinking_fountain', {
        description = 'Drinking fountain',
        drawtype = 'nodebox',
        tiles = {
            -- top, bottom, right, left, front, back
            'thirsty_drinkfount_top.png',
            'thirsty_drinkfount_bottom.png',
            'thirsty_drinkfount_side.png',
            'thirsty_drinkfount_side.png',
            'thirsty_drinkfount_side.png',
            'thirsty_drinkfount_side.png',
        },
        paramtype = 'light',
        groups = { cracky = 2 },
        node_box = {
            type = "fixed",
            fixed = {
                { -3/16, -8/16, -3/16, 3/16, 3/16, 3/16 },
                { -8/16, 3/16, -8/16, 8/16, 6/16, 8/16 },
                { -8/16, 6/16, -8/16, 8/16, 8/16, -6/16 },
                { -8/16, 6/16, 6/16, 8/16, 8/16, 8/16 },
                { -8/16, 6/16, -6/16, -6/16, 8/16, 6/16 },
                { 6/16, 6/16, -6/16, 8/16, 8/16, 6/16 },
            },
        },
        selection_box = {
            type = "regular",
        },
        collision_box = {
            type = "regular",
        },
        on_rightclick = thirsty.on_rightclick(nil),
    })

    minetest.register_craft({
        output = "thirsty:drinking_fountain",
        recipe = {
            { "default:stone", "mesecraft_bucket:bucket_water", "default:stone"},
            { "", "default:stone", ""},
            { "", "default:stone", ""}
        }
    })

end

--[[

Tier 4+: the water fountains, plus extenders

]]

if minetest.get_modpath("default") and minetest.get_modpath("mesecraft_bucket") and thirsty.config.register_fountains then

    minetest.register_node('thirsty:water_fountain', {
        description = 'Water fountain',
        tiles = {
            -- top, bottom, right, left, front, back
            'thirsty_waterfountain_top.png',
            'thirsty_waterfountain_top.png',
            'thirsty_waterfountain_side.png',
            'thirsty_waterfountain_side.png',
            'thirsty_waterfountain_side.png',
            'thirsty_waterfountain_side.png',
        },
        paramtype = 'light',
        groups = { cracky = 2 },
    })

    minetest.register_node('thirsty:water_extender', {
        description = 'Water fountain extender',
        tiles = {
            'thirsty_waterextender_top.png',
            'thirsty_waterextender_top.png',
            'thirsty_waterextender_side.png',
            'thirsty_waterextender_side.png',
            'thirsty_waterextender_side.png',
            'thirsty_waterextender_side.png',
        },
        paramtype = 'light',
        groups = { cracky = 2 },
    })

    minetest.register_craft({
        output = "thirsty:water_fountain",
        recipe = {
            { "default:copper_ingot", "mesecraft_bucket:bucket_water", "default:copper_ingot"},
            { "", "default:copper_ingot", ""},
            { "default:copper_ingot", "default:mese_crystal", "default:copper_ingot"}
        }
    })
    minetest.register_craft({
        output = "thirsty:water_extender",
        recipe = {
            { "", "mesecraft_bucket:bucket_water", ""},
            { "", "default:copper_ingot", ""},
            { "default:copper_ingot", "default:mese_crystal", "default:copper_ingot"}
        }
    })


    minetest.register_abm({
        nodenames = {'thirsty:water_fountain'},
        interval = 2,
        chance = 5,
        action = thirsty.fountain_abm,
    })

end

--[[

Tier 5

These amulets don't do much; the actual code is above, where
they are searched for in player's inventories

]]

if minetest.get_modpath("default") and minetest.get_modpath("mesecraft_bucket") and thirsty.config.register_amulets then

    minetest.register_craftitem('thirsty:injector', {
        description = 'Water injector',
        inventory_image = 'thirsty_injector.png',
    })
    minetest.register_craft({
        output = "thirsty:injector",
        recipe = {
            { "default:diamond", "default:mese_crystal", "default:diamond"},
            { "default:mese_crystal", "mesecraft_bucket:bucket_water", "default:mese_crystal"},
            { "default:diamond", "default:mese_crystal", "default:diamond"}
        }
    })

    minetest.register_craftitem('thirsty:extractor', {
        description = 'Water extractor',
        inventory_image = 'thirsty_extractor.png',
    })
    minetest.register_craft({
        output = "thirsty:extractor",
        recipe = {
            { "default:mese_crystal", "default:diamond", "default:mese_crystal"},
            { "default:diamond", "mesecraft_bucket:bucket_water", "default:diamond"},
            { "default:mese_crystal", "default:diamond", "default:mese_crystal"}
        }
    })

end
