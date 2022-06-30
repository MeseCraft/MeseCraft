-- TODO: coin press machine? (copper, silver) coins? melt coins back to ingots.

-- Get mod path and execute additional modules.
local path = minetest.get_modpath("coins")
dofile(path .. "/crafting.lua")

-- Register the gold coin craft item.
minetest.register_craftitem("coins:gold_coins", {
        description = "Gold Coins",
        inventory_image = "coins_gold_coins.png",
        stack_max = "99",
})

-- Register the gold coin scrap bucket.
minetest.register_craftitem("coins:gold_scrap_bucket", {
        description = "Bucket of Gold Scrap",
        inventory_image = "coins_bucket_scrap_gold.png",
        stack_max = 1,
})