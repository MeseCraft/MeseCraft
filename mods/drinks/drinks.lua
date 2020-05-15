--Parse Table
for i in ipairs (drinks.drink_table) do
   local desc = drinks.drink_table[i][1]
   local craft = drinks.drink_table[i][2]
   local color = drinks.drink_table[i][3]
   local health = drinks.drink_table[i][4]
   health = health or 1
   -- The color of the drink is all done in code, so we don't need to have multiple images.

--Actual Node registration
minetest.register_node('drinks:jbu_'..desc..'', {
	description = 'Bucket of '..craft..' Juice',
	drawtype = "plantlike",
	tiles = {'bucket.png^(drinks_bucket_contents.png^[colorize:'..color..':200)'},
	inventory_image = 'bucket.png^(drinks_bucket_contents.png^[colorize:'..color..':200)',
	wield_image = 'bucket.png^(drinks_bucket_contents.png^[colorize:'..color..':200)',
	paramtype = "light",
   juice_type = craft,
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.4, 0.25}
	},
	groups = {vessel=1,dig_immediate=3,attached_node=1, drink = 1},
	sounds = default.node_sound_defaults(),
})

drinks.register_item('drinks:jcu_'..desc,  'vessels:drinking_glass', {
   description = 'Cup of '..craft..' Juice',
   groups = {drink=1},
   juice_type = craft,
   inventory_image = 'drinks_glass_contents.png^[colorize:'..color..':200^drinks_drinking_glass.png',
   on_use = function(itemstack, user, pointed_thing)
      thirsty.drink(user, 4, 20)
      local eat_func = minetest.item_eat(health, 'vessels:drinking_glass')
      return eat_func(itemstack, user, pointed_thing)
   end,
})

drinks.register_item('drinks:jbo_'..desc, 'vessels:glass_bottle',{
   description = 'Bottle of '..craft..' Juice',
   groups = {drink = 1},
   juice_type = craft,
   inventory_image = 'drinks_bottle_contents.png^[colorize:'..color..':200^drinks_glass_bottle.png',
   on_use = function(itemstack, user, pointed_thing)
      thirsty.drink(user, 8, 20)
      local eat_func = minetest.item_eat((health*2), 'vessels:glass_bottle')
      return eat_func(itemstack, user, pointed_thing)
   end,
})

drinks.register_item('drinks:jsb_'..desc, 'vessels:steel_bottle',{
   description = 'Heavy Steel Bottle ('..craft..' Juice)',
   groups = {drink = 1},
   juice_type = craft,
   inventory_image = 'vessels_steel_bottle.png',
   on_use = function(itemstack, user, pointed_thing)
      thirsty.drink(user, 8, 20)
      local eat_func = minetest.item_eat((health*2), 'vessels:steel_bottle')
      return eat_func(itemstack, user, pointed_thing)
   end,
})

end
