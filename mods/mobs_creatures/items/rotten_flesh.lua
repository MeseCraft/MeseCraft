-- Rotten flesh texture from mc_mobs.

-- If "hbhunger" mod is present, rotten flesh is made poisonous.
if minetest.get_modpath("hbhunger") ~= nil then
--        hbhunger.register_food("mobs_creatures:rotten_flesh", 1, "", 20) -- causing a weird issue with hbhunger "nil value" server fatal.
end

-- Register rotten flesh.
minetest.register_craftitem("mobs_creatures:rotten_flesh", {
        description = "Rotten Flesh",
        inventory_image = "mobs_creatures_items_rotten_flesh.png",
        on_use = minetest.item_eat(1),
})

