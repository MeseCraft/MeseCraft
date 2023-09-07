local S = drinks.get_translator

local get_size_factor = function(vessel)
  local size = drinks.longname[vessel].size
  return (size or 2) / 2
end

local drink_sound = 'drinks_drink_juice'
local do_drink = function(user,amt,max) end
local do_add_settings = function(item, replace_with_item, juice_def) end

if minetest.get_modpath('thirsty') then
  do_drink = thirsty.drink
  drink_sound = drink_sound or 'thirsty_drink'
end
if minetest.get_modpath('hbhunger') and minetest.settings:get_bool("enable_damage") then   -- even if it's present, hbhunger doesn't load if damage is disabled
  do_add_settings = function(item, replace_with_item, juice_def)
    local factor = get_size_factor(replace_with_item)
    hbhunger.register_food(item, (juice_def.health or 1) * factor, replace_with_item, juice_def.poison and (juice_def.poison * factor), (juice_def.health or 0) * factor, juice_def.sound or drink_sound)
  end
end

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
        local factor = get_size_factor('vessels:drinking_glass')
        do_drink(user, 2 * factor, 20)
        local eat_func = minetest.item_eat(health * factor, 'vessels:drinking_glass')
        return eat_func(itemstack, user, pointed_thing)
      end,
    })
  do_add_settings('drinks:jcu_'..juice, 'vessels:drinking_glass', juice_def)

  drinks.register_item('drinks:jbo_'..juice, 'vessels:glass_bottle', {
      description = S('Bottle of @1 Juice', juice_desc),
      groups = {drink = 1},
      juice_type = juice_desc,
      inventory_image = 'drinks_bottle_contents.png^[colorize:'..color..':200^drinks_glass_bottle.png',
      on_use = function(itemstack, user, pointed_thing)
        local factor = get_size_factor('vessels:glass_bottle')
        do_drink(user, 2 * factor, 20)
        local eat_func = minetest.item_eat(health * factor, 'vessels:glass_bottle')
        return eat_func(itemstack, user, pointed_thing)
      end,
    })
  do_add_settings('drinks:jbo_'..juice, 'vessels:glass_bottle', juice_def)

  drinks.register_item('drinks:jsb_'..juice, 'vessels:steel_bottle', {
      description = S('Heavy Steel Bottle of @1 Juice', juice_desc),
      groups = {drink = 1},
      juice_type = juice_desc,
      inventory_image = 'vessels_steel_bottle.png',
      on_use = function(itemstack, user, pointed_thing)
        local factor = get_size_factor('vessels:steel_bottle')
        do_drink(user, 2 * factor, 20)
        local eat_func = minetest.item_eat(health * factor, 'vessels:steel_bottle')
        return eat_func(itemstack, user, pointed_thing)
      end,
    })
  do_add_settings('drinks:jsb_'..juice, 'vessels:steel_bottle', juice_def)

end
