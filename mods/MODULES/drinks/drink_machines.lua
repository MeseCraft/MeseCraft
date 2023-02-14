--Craft Recipes

minetest.register_craft({
      output = 'drinks:juice_press',
      recipe = {
         {'default:stick', 'default:steel_ingot', 'default:stick'},
         {'default:stick', 'mesecraft_bucket:bucket_empty', 'default:stick'},
         {'stairs:slab_wood', 'stairs:slab_wood', 'vessels:drinking_glass'},
         }
})

minetest.register_craft({
      output = 'drinks:liquid_barrel',
      recipe = {
         {'group:wood', 'group:wood', 'group:wood'},
         {'group:wood', 'group:wood', 'group:wood'},
         {'stairs:slab_wood', '', 'stairs:slab_wood'},
         }
})

minetest.register_craft({
      output = 'drinks:liquid_silo',
      recipe = {
         {'default:steel_ingot','drinks:liquid_barrel','default:steel_ingot'},
         {'default:steel_ingot','drinks:liquid_barrel','default:steel_ingot'},
         {'default:steel_ingot','','default:steel_ingot'}
      }
})

local press_idle_formspec = drinks.juice_press_formspec('Organic juice is just a squish away.')

local press_running_formspec = drinks.juice_press_formspec('Organic juice coming right up.')

local press_error_formspec = drinks.juice_press_formspec('You need to add more fruit.')

local press_missing_formspec = drinks.juice_press_formspec('You need to place a liquid container below the juice press.')

minetest.register_node('drinks:juice_press', {
   description = 'Juice Press',
   _doc_items_longdesc = "A machine for creating drinks out of various fruits and vegetables.",
   _doc_items_usagehelp = "Right-click the press to access inventory and begin juicing.",
   drawtype = 'mesh',
   mesh = 'drinks_press.obj',
   tiles = {name='drinks_press.png'},
   groups = {choppy=2, dig_immediate=2,},
   paramtype = 'light',
   paramtype2 = 'facedir',
   selection_box = {
      type = 'fixed',
      fixed = {-.5, -.5, -.5, .5, .5, .5},
      },
   collision_box = {
      type = 'fixed',
      fixed = {-.5, -.5, -.5, .5, .5, .5},
      },
   on_construct = function(pos)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      inv:set_size('src', 1)
      inv:set_size('dst', 1)
      meta:set_string('infotext', 'Empty Juice Press')
      meta:set_string('formspec', press_idle_formspec)
   end,
   on_receive_fields = function(pos, formname, fields, sender)
      if fields ['press'] then
         local meta = minetest.get_meta(pos)
         local inv = meta:get_inventory()
         local timer = minetest.get_node_timer(pos)
         local instack = inv:get_stack("src", 1)
         local fruitstack = instack:get_name()
         local mod, fruit = fruitstack:match("([^:]+):([^:]+)")
         if drinks.juiceable[fruit] then
            if string.find(fruit, '_') then
               local fruit, junk = fruit:match('([^_]+)_([^_]+)')
               meta:set_string('fruit', fruit)
            else
               meta:set_string('fruit', fruit)
            end
            local outstack = inv:get_stack("dst", 1)
            local vessel = outstack:get_name()
            local vessel_def = drinks.longname[vessel]
            local required = vessel_def and vessel_def.size or 2
            local container = (vessel_def and vessel_def.name or 'jcu')..'_'
            if vessel_def then
               if instack:get_count() >= required then
                  meta:set_string('container', container)
                  meta:set_string('fruitnumber', required)
                  meta:set_string('infotext', 'Juicing...')
                  meta:set_string('formspec', press_running_formspec)
                  timer:start(required * 2)
               else
                  meta:set_string('infotext', 'You need more fruit.')
                  meta:set_string('formspec', press_error_formspec)
               end
            elseif vessel == 'default:papyrus' then
               if instack:get_count() >= required then
                  local under_node = {x=pos.x, y=pos.y-1, z=pos.z}
                  local under_node_name = minetest.get_node_or_nil(under_node)
                  local under_node_2 = {x=pos.x, y=pos.y-2, z=pos.z}
                  local under_node_name_2 = minetest.get_node_or_nil(under_node_2)
                  if under_node_name.name == 'drinks:liquid_barrel' then
                     local meta_u = minetest.get_meta(under_node)
                     local stored_fruit = meta_u:get_string('fruit')
                     if fruit == stored_fruit or stored_fruit == 'empty' then
                        meta:set_string('container', 'tube')
                        meta:set_string('fruitnumber', required)
                        meta:set_string('infotext', 'Juicing...')
                        meta_u:set_string('fruit', fruit)
                        timer:start(required * 2)
                     else
                        meta:set_string('infotext', "You can't mix juices.")
                     end
                  elseif under_node_name_2.name == 'drinks:liquid_silo' then
                     local meta_u = minetest.get_meta(under_node_2)
                     local stored_fruit = meta_u:get_string('fruit')
                     if fruit == stored_fruit or stored_fruit == 'empty' then
                        meta:set_string('container', 'tube')
                        meta:set_string('fruitnumber', required)
                        meta:set_string('infotext', 'Juicing...')
                        meta_u:set_string('fruit', fruit)
                        timer:start(required * 2)
                     else
                        meta:set_string('infotext', "You can't mix juices.")
                     end
                  else
                     meta:set_string('infotext', 'Missing a container below.')
                     meta:set_string('formspec', press_missing_formspec)
                  end
               else
                  meta:set_string('infotext', 'You need more fruit.')
                  meta:set_string('formspec', press_error_formspec)
               end
            end
         end
      end
   end,
   on_timer = function(pos)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      local container = meta:get_string('container')
      local instack = inv:get_stack("src", 1)
      local outstack = inv:get_stack("dst", 1)
      local fruit = meta:get_string('fruit')
      local fruitnumber = tonumber(meta:get_string('fruitnumber'))
      if container == 'tube' then
         local timer = minetest.get_node_timer(pos)
         local under_node = {x=pos.x, y=pos.y-1, z=pos.z}
         local under_node_name = minetest.get_node_or_nil(under_node)
         local under_node_2 = {x=pos.x, y=pos.y-2, z=pos.z}
         local under_node_name_2 = minetest.get_node_or_nil(under_node_2)
         if under_node_name.name == 'drinks:liquid_barrel' then
            local meta_u = minetest.get_meta(under_node)
            local fullness = tonumber(meta_u:get_string('fullness'))
            instack:take_item(tonumber(fruitnumber))
            inv:set_stack('src', 1, instack)
            if fullness + 2 > 128 then
               timer:stop()
               meta:set_string('infotext', 'Barrel is full of juice.')
               return
            else
               local fullness = fullness + 2
               meta_u:set_string('fullness', fullness)
               meta_u:set_string('infotext', (math.floor((fullness/128)*100))..' % full of '..fruit..' juice.')
               meta_u:set_string('formspec', drinks.liquid_storage_formspec(fruit, fullness, 128))
               if instack:get_count() >= 2 then
                  timer:start(4)
               else
                  meta:set_string('infotext', 'You need more fruit.')
               end
            end
         elseif under_node_name_2.name == 'drinks:liquid_silo' then
            local meta_u = minetest.get_meta(under_node_2)
            local fullness = tonumber(meta_u:get_string('fullness'))
            instack:take_item(tonumber(fruitnumber))
            inv:set_stack('src', 1, instack)
            if fullness + 2 > 256 then
               timer:stop()
               meta:set_string('infotext', 'Silo is full of juice.')
               return
            else
               local fullness = fullness + 2
               meta_u:set_string('fullness', fullness)
               meta_u:set_string('infotext', (math.floor((fullness/256)*100))..' % full of '..fruit..' juice.')
               meta_u:set_string('formspec', drinks.liquid_storage_formspec(fruit, fullness, 256))
               if instack:get_count() >= 2 then
                  timer:start(4)
               else
                  meta:set_string('infotext', 'You need more fruit.')
               end
            end
         end
      else
         meta:set_string('infotext', 'Collect your juice.')
         meta:set_string('formspec', press_idle_formspec)
         instack:take_item(tonumber(fruitnumber))
         inv:set_stack('src', 1, instack)
         inv:set_stack('dst', 1 ,'drinks:'..container..fruit)
      end
   end,
   on_metadata_inventory_take = function(pos, listname, index, stack, player)
      local timer = minetest.get_node_timer(pos)
      local meta = minetest.get_meta(pos)
      timer:stop()
      meta:set_string('infotext', 'Ready for more juicing.')
      meta:set_string('formspec', press_idle_formspec)
   end,
   on_metadata_inventory_put = function(pos, listname, index, stack, player)
      local meta = minetest.get_meta(pos)
      meta:set_string('infotext', 'Ready for juicing.')
   end,
   can_dig = function(pos)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      if inv:is_empty("src") and
         inv:is_empty("dst") then
         return true
      else
         return false
      end
   end,
   allow_metadata_inventory_put = function(pos, listname, index, stack, player)
      if listname == 'dst' then
         local meta = minetest.get_meta(pos)
         local inv = meta:get_inventory()
         if not inv:is_empty(listname) then
            return 0
         end
         local vessel = stack:get_name()
         if drinks.longname[vessel] then
            return 1
         elseif vessel == 'default:papyrus' then
            return 1
         else
            return 0
         end
      elseif listname == 'src' then
         local fruitstack = stack:get_name()
         local mod, fruit = fruitstack:match("([^:]+):([^:]+)")
         if drinks.juiceable[fruit] then
            return stack:get_count()
         else
            return 0
         end
      end
   end,
})

function drinks.drinks_liquid_sub(liq_vol, ves_typ, ves_vol, pos, able_to_fill, leftover_count, outputstack)
   local meta = minetest.get_meta(pos)
   local fullness = tonumber(meta:get_string('fullness'))
   local fruit = meta:get_string('fruit')
   local fruit_name = meta:get_string('fruit_name')
   local inv = meta:get_inventory()
   local fullness = fullness - (liq_vol*able_to_fill)
   meta:set_string('fullness', fullness)
   meta:set_string('infotext', (math.floor((fullness/ves_vol)*100))..' % full of '..fruit_name..' juice.')
   if ves_vol == 128 then
      meta:set_string('formspec', drinks.liquid_storage_formspec(fruit_name, fullness, 128))
   elseif ves_vol == 256 then
      meta:set_string('formspec', drinks.liquid_storage_formspec(fruit_name, fullness, 256))
   end
   if ves_typ == 'jcu' or ves_typ == 'jbo' or ves_typ == 'jsb' or ves_typ == 'jbu' then
      inv:set_stack('dst', 1, 'drinks:'..ves_typ..'_'..fruit..' '..able_to_fill)
      inv:set_stack('src', 1, outputstack..' '..leftover_count)
   end
end

function drinks.drinks_liquid_avail_sub(liq_vol, ves_typ, ves_vol, outputstack, pos, count)
   local meta = minetest.get_meta(pos)
   local fullness = tonumber(meta:get_string('fullness'))
   if fullness - (liq_vol*count) < 0 then
      local able_to_fill = math.floor(fullness/liq_vol)
      local leftover_count = count - able_to_fill
      drinks.drinks_liquid_sub(liq_vol, ves_typ, ves_vol, pos, able_to_fill, leftover_count, outputstack)
   elseif fullness - (liq_vol*count) >= 0 then
      drinks.drinks_liquid_sub(liq_vol, ves_typ, ves_vol, pos, count, 0, outputstack)
   end
end

function drinks.drinks_liquid_add(liq_vol, ves_typ, ves_vol, pos, inputcount, leftover_count, inputstack)
   local meta = minetest.get_meta(pos)
   local fullness = tonumber(meta:get_string('fullness'))
   local fruit = meta:get_string('fruit')
   local fruit_name = meta:get_string('fruit_name')
   local inv = meta:get_inventory()
   local fullness = fullness + (liq_vol*inputcount)
   meta:set_string('fullness', fullness)
   inv:set_stack('src', 1, ves_typ..' '..inputcount)
   inv:set_stack('dst', 1, inputstack..' '..leftover_count)
   meta:set_string('infotext', (math.floor((fullness/ves_vol)*100))..' % full of '..fruit_name..' juice.')
   meta:set_string('formspec', drinks.liquid_storage_formspec(fruit_name, fullness, ves_vol))
end

function drinks.drinks_liquid_avail_add(liq_vol, ves_typ, ves_vol, pos, inputstack, inputcount)
   local meta = minetest.get_meta(pos)
   local fullness = tonumber(meta:get_string('fullness'))
   if fullness + (liq_vol*inputcount) > ves_vol then
      local avail_ves_vol = ves_vol - fullness
      local can_empty = math.floor(avail_ves_vol/liq_vol)
      local leftover_count = inputcount - can_empty
      drinks.drinks_liquid_add(liq_vol, ves_typ, ves_vol, pos, can_empty, leftover_count, inputstack)
   elseif fullness + (liq_vol*inputcount) <= ves_vol then
      drinks.drinks_liquid_add(liq_vol, ves_typ, ves_vol, pos, inputcount, 0, inputstack)
   end
end

function drinks.drinks_barrel(pos, inputstack, inputcount)
   local meta = minetest.get_meta(pos)
   local vessel = string.sub(inputstack, 8, 10)
   drinks.drinks_liquid_avail_add(drinks.shortname[vessel].size, drinks.shortname[vessel].name, 128, pos, inputstack, inputcount)
end

function drinks.drinks_silo(pos, inputstack, inputcount)
   local meta = minetest.get_meta(pos)
   local vessel = string.sub(inputstack, 8, 10)
   drinks.drinks_liquid_avail_add(drinks.shortname[vessel].size, drinks.shortname[vessel].name, 256, pos, inputstack, inputcount)
end

local empty_container = function(pos, name, liq_vol)
   local meta = minetest.get_meta(pos)
   local fullness = 0
   local fruit_name = 'no'
   meta:set_string('fullness', 0)
   meta:set_string('fruit', 'empty')
   meta:set_string('infotext', 'Empty '..name)
   meta:set_string('formspec', drinks.liquid_storage_formspec(fruit_name, fullness, liq_vol or 0))
end

minetest.register_node('drinks:liquid_barrel', {
   description = 'Barrel of Liquid',
   _doc_items_longdesc = "A node that provides a simple way to store juice.",
   _doc_items_usagehelp = "Add or remove liquids from the barrel using buckets, bottles, or cups.",
   drawtype = 'mesh',
   mesh = 'drinks_liquid_barrel.obj',
   tiles = {name='drinks_barrel.png'},
   groups = {choppy=2, dig_immediate=2,},
   paramtype = 'light',
   paramtype2 = 'facedir',
   selection_box = {
      type = 'fixed',
      fixed = {-.5, -.5, -.5, .5, .5, .5},
      },
   collision_box = {
      type = 'fixed',
      fixed = {-.5, -.5, -.5, .5, .5, .5},
      },
   on_construct = function(pos)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      inv:set_size('src', 1)
      inv:set_size('dst', 1)
      empty_container(pos,'Drink Barrel', 128)
   end,
   on_metadata_inventory_put = function(pos, listname, index, stack, player)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      local instack = inv:get_stack('src', 1)
      local outstack = inv:get_stack('dst', 1)
      local outputstack = outstack:get_name()
      local inputstack = instack:get_name()
      local outputcount = outstack:get_count()
      local inputcount = instack:get_count()
      local fruit = string.sub(inputstack, 12, -1)
      local fruit_in = meta:get_string('fruit')
      if fruit_in == 'empty' then
         meta:set_string('fruit', fruit)
         local fruit_name = minetest.registered_nodes[instack:get_name()]
         meta:set_string('fruit_name', string.lower(fruit_name.juice_type))
         local vessel = string.sub(inputstack, 8, 10)
         drinks.drinks_barrel(pos, inputstack, inputcount)
      end
      if fruit == fruit_in then
         local vessel = string.sub(inputstack, 8, 10)
         drinks.drinks_barrel(pos, inputstack, inputcount)
      end
      if drinks.longname[outputstack] then
         drinks.drinks_liquid_avail_sub(drinks.longname[outputstack].size, drinks.longname[outputstack].name, 128, outputstack, pos, outputcount)
      end
   end,
   on_receive_fields = function(pos, formname, fields, sender)
      local name = sender and sender:get_player_name()
      if minetest.is_protected(pos, name) then
         minetest.record_protection_violation(pos, name)
      elseif fields['purge'] then
         empty_container(pos, 'Drink Barrel', 128)
      end
   end,
   can_dig = function(pos)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      if inv:is_empty("src") and
         inv:is_empty("dst") and
         tonumber(meta:get_string('fullness')) == 0 then
         return true
      else
         return false
      end
   end,
   allow_metadata_inventory_put = function(pos, listname, index, stack, player)
      local meta = minetest.get_meta(pos)
      if listname == 'src' then --adding liquid
         local inputstack = stack:get_name()
         local inputcount = stack:get_count()
         local valid = string.sub(inputstack, 1, 8)
         if valid == 'drinks:j' then
            return inputcount
         else
            return 0
         end
      elseif listname == 'dst' then --removing liquid
         --make sure there is a liquid to remove
         local juice = meta:get_string('fruit')
         if juice ~= 'empty' then
            local vessel_def = drinks.longname[inputstack]
            return vessel_def and inputcount or 0
         else
            return 0
         end
      end
   end,
})

minetest.register_node('drinks:liquid_silo', {
   description = 'Silo of Liquid',
   _doc_items_longdesc = "A node that provides a simple way to store juice.",
   _doc_items_usagehelp = "Add or remove liquids from the silo using buckets, bottles, or cups.",
   drawtype = 'mesh',
   mesh = 'drinks_silo.obj',
   tiles = {name='drinks_silo.png'},
   groups = {choppy=2, dig_immediate=2,},
   paramtype = 'light',
   paramtype2 = 'facedir',
   selection_box = {
      type = 'fixed',
      fixed = {-.5, -.5, -.5, .5, 1.5, .5},
      },
   collision_box = {
      type = 'fixed',
      fixed = {-.5, -.5, -.5, .5, 1.5, .5},
      },
   on_construct = function(pos)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      inv:set_size('src', 1)
      inv:set_size('dst', 1)
      empty_container(pos,'Drink Silo', 256)
   end,
   on_metadata_inventory_put = function(pos, listname, index, stack, player)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      local instack = inv:get_stack("src", 1)
      local outstack = inv:get_stack('dst', 1)
      local outputstack = outstack:get_name()
      local inputstack = instack:get_name()
      local outputcount = outstack:get_count()
      local inputcount = instack:get_count()
      local fruit = string.sub(inputstack, 12, -1)
      local fruit_in = meta:get_string('fruit')
      if fruit_in == 'empty' then
         meta:set_string('fruit', fruit)
         local fruit_name = minetest.registered_nodes[instack:get_name()]
         meta:set_string('fruit_name', string.lower(fruit_name.juice_type))
         local vessel = string.sub(inputstack, 8, 10)
         drinks.drinks_silo(pos, inputstack, inputcount)
      end
      if fruit == fruit_in then
         local vessel = string.sub(inputstack, 8, 10)
         drinks.drinks_silo(pos, inputstack, inputcount)
      end
      if drinks.longname[outputstack] then
         drinks.drinks_liquid_avail_sub(drinks.longname[outputstack].size, drinks.longname[outputstack].name, 256, outputstack, pos, outputcount)
      end
   end,
   on_receive_fields = function(pos, formname, fields, sender)
      local name = sender and sender:get_player_name()
      if minetest.is_protected(pos, name) then
         minetest.record_protection_violation(pos, name)
      elseif fields['purge'] then
         empty_container(pos, 'Drink Silo', 256)
      end
   end,
   can_dig = function(pos)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      if inv:is_empty("src") and
         inv:is_empty("dst") and
         tonumber(meta:get_string('fullness')) == 0 then
         return true
      else
         return false
      end
   end,
   allow_metadata_inventory_put = function(pos, listname, index, stack, player)
      local meta = minetest.get_meta(pos)
      local inputstack = stack:get_name()
      local inputcount = stack:get_count()
      if listname == 'src' then --adding liquid
         local valid = string.sub(inputstack, 1, 8)
         if valid == 'drinks:j' then
            return inputcount
         else
            return 0
         end
      elseif listname == 'dst' then --removing liquid
         --make sure there is liquid to take_item
         local juice = meta:get_string('fruit')
         if juice ~= 'empty' then
            local vessel_def = drinks.longname[inputstack]
            return vessel_def and inputcount or 0
         else
            return 0
         end
      end
   end,
})
