-- TODO: coin press machine? (copper, silver) coins? melt coins back to ingots.

local path = minetest.get_modpath("coins")
dofile(path .. "/crafting.lua")

-- Register the gold coin craft item.
minetest.register_craftitem("coins:gold_coins", {
        description = "Gold Coins",
        inventory_image = "coins_gold_coins.png",
        stack_max = "100",
})