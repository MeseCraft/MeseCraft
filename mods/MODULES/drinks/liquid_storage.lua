local S = drinks.get_translator

--Craft Recipes

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

drinks.set_fullness = function(meta, fullness)
  local capacity = meta:get_int('capacity')
  if capacity == 0 then
    capacity = 256
    meta:set_int('capacity', capacity)
  end
  meta:set_int('fullness', math.floor(fullness))
  if math.floor(fullness) <= 0 then
    meta:set_string('fruit', 'empty')
    meta:set_string('infotext', S('Empty (no juice)'))
    meta:set_string('formspec', drinks.liquid_storage_formspec('no', 0, capacity))
  else
    local juice = meta:get_string('fruit')
    local juice_def = drinks.drink_table[juice]
    local juice_desc = string.lower(juice_def and juice_def.desc or juice)
    meta:set_string('infotext', S('@1 % full of @2 juice.', math.floor((fullness/capacity)*100), juice_desc))
    meta:set_string('formspec', drinks.liquid_storage_formspec(juice_desc, fullness, capacity))
  end
end

local liquid_sub = function(liq_vol, ves_typ, pos, able_to_fill, leftover_count, outputstack)
  local meta = minetest.get_meta(pos)
  local fullness = meta:get_int('fullness')
  local juice = meta:get_string('fruit')
  fullness = fullness - (liq_vol*able_to_fill)
  drinks.set_fullness(meta, fullness)
  if drinks.shortname[ves_typ] then
    local inv = meta:get_inventory()
    inv:set_stack('dst', 1, 'drinks:'..ves_typ..'_'..juice..' '..able_to_fill)
    inv:set_stack('src', 1, outputstack..' '..leftover_count)
  end
end

local liquid_avail_sub = function(liq_vol, ves_typ, outputstack, pos, count)
  local meta = minetest.get_meta(pos)
  local fullness = meta:get_int('fullness')
  if fullness - (liq_vol*count) < 0 then
    local able_to_fill = math.floor(fullness/liq_vol)
    local leftover_count = count - able_to_fill
    liquid_sub(liq_vol, ves_typ, pos, able_to_fill, leftover_count, outputstack)
  elseif fullness - (liq_vol*count) >= 0 then
    liquid_sub(liq_vol, ves_typ, pos, count, 0, outputstack)
  end
end

local liquid_add = function(liq_vol, ves_typ, pos, inputcount, leftover_count, inputstack)
  local meta = minetest.get_meta(pos)
  local fullness = meta:get_int('fullness')
  local inv = meta:get_inventory()
  inv:set_stack('src', 1, ves_typ..' '..inputcount)
  inv:set_stack('dst', 1, inputstack..' '..leftover_count)
  fullness = fullness + (liq_vol*inputcount)
  drinks.set_fullness(meta, fullness)
end

local liquid_avail_add = function(liq_vol, ves_typ, capacity, pos, inputstack, inputcount)
  local meta = minetest.get_meta(pos)
  local fullness = meta:get_int('fullness')
  if fullness + (liq_vol*inputcount) > capacity then
    local avail_ves_vol = capacity - fullness
    local can_empty = math.floor(avail_ves_vol/liq_vol)
    local leftover_count = inputcount - can_empty
    liquid_add(liq_vol, ves_typ, pos, can_empty, leftover_count, inputstack)
  elseif fullness + (liq_vol*inputcount) <= capacity then
    liquid_add(liq_vol, ves_typ, pos, inputcount, 0, inputstack)
  end
end

local allow_metadata_inventory_put = function(pos, listname, index, stack, player)
  if minetest.is_protected(pos, player:get_player_name()) then
    return 0
  end
  local inputstack = stack:get_name()
  if listname == 'src' then --adding liquid
    local valid = string.sub(inputstack, 1, 8)
    if valid == 'drinks:j' then
      return stack:get_count()
    else
      return 0
    end
  elseif listname == 'dst' then --removing liquid
    --make sure there is liquid to take_item
    local meta = minetest.get_meta(pos)
    local juice = meta:get_string('fruit')
    return juice ~= 'empty' and drinks.longname[inputstack] and stack:get_count() or 0
  end
end

local allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
  local meta = minetest.get_meta(pos)
  local inv = meta:get_inventory()
  local stack = inv:get_stack(from_list, from_index)
  return allow_metadata_inventory_put(pos, to_list, to_index, stack, player)
end

local allow_metadata_inventory_take = function(pos, listname, index, stack, player)
  if minetest.is_protected(pos, player:get_player_name()) then
    return 0
  else
    return stack:get_count()
  end
end

local on_metadata_inventory_put = function(pos, listname, index, stack, player)
  local meta = minetest.get_meta(pos)
  local inv = meta:get_inventory()
  local instack = inv:get_stack('src', 1)
  local inputstack = instack:get_name()
  local juice = string.sub(inputstack, 12, -1)
  local stored_juice = meta:get_string('fruit')
  local capacity = meta:get_int('capacity')
  if juice == stored_juice or stored_juice == 'empty' then
    meta:set_string('fruit', juice)
    local vessel = string.sub(inputstack, 8, 10)
    local vessel_def = drinks.shortname[vessel]
    if vessel_def then
      liquid_avail_add(vessel_def.size, vessel_def.name, capacity, pos, inputstack, instack:get_count())
    end
  end
  local outstack = inv:get_stack('dst', 1)
  local outputstack = outstack:get_name()
  local container = drinks.longname[outputstack]
  if container then
    liquid_avail_sub(container.size, container.name, outputstack, pos, outstack:get_count())
  end
end

local on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
  local meta = minetest.get_meta(pos)
  local inv = meta:get_inventory()
  local stack = inv:get_stack(from_list, from_index)
  return on_metadata_inventory_put(pos, to_list, to_index, stack, player)
end

local can_dig = function(pos)
  local meta = minetest.get_meta(pos)
  local inv = meta:get_inventory()
  return meta:get_int('fullness') == 0 and inv:is_empty("src") and inv:is_empty("dst")
end

local on_receive_fields = function(pos, formname, fields, sender)
  local name = sender and sender:get_player_name()
  if minetest.is_protected(pos, name) then
    minetest.record_protection_violation(pos, name)
  elseif fields['purge'] then
    local meta = minetest.get_meta(pos)
    drinks.set_fullness(meta, 0)
  end
end

local on_construct_for_volume = function(capacity)
  return function(pos)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    inv:set_size('src', 1)
    inv:set_size('dst', 1)
    meta:set_int('capacity', capacity)
    drinks.set_fullness(meta, 0)
  end
end

minetest.register_node('drinks:liquid_barrel', {
    description = S('Barrel of Liquid'),
    _doc_items_longdesc = S('A node that provides a simple way to store juice.'),
    _doc_items_usagehelp = S('Add or remove liquids from the barrel using buckets, bottles, or cups.'),
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
    on_construct = on_construct_for_volume(128),
    allow_metadata_inventory_put = allow_metadata_inventory_put,
    allow_metadata_inventory_move = allow_metadata_inventory_move,
    allow_metadata_inventory_take = allow_metadata_inventory_take,
    on_metadata_inventory_put = on_metadata_inventory_put,
    on_metadata_inventory_move = on_metadata_inventory_move,
    on_receive_fields = on_receive_fields,
    can_dig = can_dig,
  })

minetest.register_node('drinks:liquid_silo', {
    description = S('Silo of Liquid'),
    _doc_items_longdesc = S('A node that provides a simple way to store juice.'),
    _doc_items_usagehelp = S('Add or remove liquids from the silo using buckets, bottles, or cups.'),
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
    on_construct = on_construct_for_volume(256),
    allow_metadata_inventory_put = allow_metadata_inventory_put,
    allow_metadata_inventory_move = allow_metadata_inventory_move,
    allow_metadata_inventory_take = allow_metadata_inventory_take,
    on_metadata_inventory_put = on_metadata_inventory_put,
    on_metadata_inventory_move = on_metadata_inventory_move,
    on_receive_fields = on_receive_fields,
    can_dig = can_dig,
  })
