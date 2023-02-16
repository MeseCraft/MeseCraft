local S = drinks.get_translator
local do_drink = minetest.get_modpath('thirsty') and thirsty.drink or function(user,amt,max) end

--Parse Table
for juice,juice_def in pairs (drinks.drink_table) do
  local juice_desc = juice_def.desc
  local color = juice_def.color
  local health = juice_def.health or 1
  -- The color of the drink is all done in code, so we don't need to have multiple images.

  --Actual Node registration
  minetest.register_node('drinks:jbu_'..juice..'', {
      description = S('Bucket of @1 Juice',juice_desc),
      drawtype = "plantlike",
      tiles = {'mesecraft_bucket.png^(drinks_bucket_contents.png^[colorize:'..color..':200)'},
      inventory_image = 'mesecraft_bucket.png^(drinks_bucket_contents.png^[colorize:'..color..':200)',
      wield_image = 'mesecraft_bucket.png^(drinks_bucket_contents.png^[colorize:'..color..':200)',
      paramtype = "light",
      juice_type = juice_desc,
      is_ground_content = false,
      walkable = false,
      selection_box = {
        type = "fixed",
        fixed = {-0.25, -0.5, -0.25, 0.25, 0.4, 0.25}
      },
      groups = {dig_immediate=3, attached_node=1, drink = 1},
      sounds = default.node_sound_defaults(),
    })

  drinks.register_item('drinks:jcu_'..juice, 'vessels:drinking_glass', {
      description = S('Cup of @1 Juice', juice_desc),
      groups = {drink = 1},
      juice_type = juice_desc,
      inventory_image = 'drinks_glass_contents.png^[colorize:'..color..':200^drinks_drinking_glass.png',
      on_use = function(itemstack, user, pointed_thing)
        do_drink(user, drinks.longname['vessels:drinking_glass'].size * 2, 20)
        local eat_func = minetest.item_eat(health, 'vessels:drinking_glass')
        return eat_func(itemstack, user, pointed_thing)
      end,
    })

  drinks.register_item('drinks:jbo_'..juice, 'vessels:glass_bottle', {
      description = S('Bottle of @1 Juice', juice_desc),
      groups = {drink = 1},
      juice_type = juice_desc,
      inventory_image = 'drinks_bottle_contents.png^[colorize:'..color..':200^drinks_glass_bottle.png',
      on_use = function(itemstack, user, pointed_thing)
        do_drink(user, drinks.longname['vessels:glass_bottle'].size * 2, 20)
        local eat_func = minetest.item_eat((health*2), 'vessels:glass_bottle')
        return eat_func(itemstack, user, pointed_thing)
      end,
    })

  drinks.register_item('drinks:jsb_'..juice, 'vessels:steel_bottle', {
      description = S('Heavy Steel Bottle of @1 Juice', juice_desc),
      groups = {drink = 1},
      juice_type = juice_desc,
      inventory_image = 'vessels_steel_bottle.png',
      on_use = function(itemstack, user, pointed_thing)
        do_drink(user, drinks.longname['vessels:steel_bottle'].size * 2, 20)
        local eat_func = minetest.item_eat((health*2), 'vessels:steel_bottle')
        return eat_func(itemstack, user, pointed_thing)
      end,
    })

end
