-- TODO: coin press machine. copper, silver, coins. melt coins back to ingots

local path = minetest.get_modpath("coins")
dofile(path .. "/crafting.lua")

-- This number controls the number of coins per ingot.
local coins_per_ingot = 100

-- Register the gold coin craft item.
minetest.register_craftitem("coins:gold_coins", {
        description = "Gold Coins",
        inventory_image = "coins_gold_coins.png",
        stack_max = coins_per_ingot,
})
