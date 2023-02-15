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

local modes = {
  idle = { form = 'Organic juice is just a squish away.', info = 'Ready for juicing' },
  running = { form = 'Organic juice coming right up.', info = 'Juicing...' },
  need = { form = 'You need to add more fruit.', info = 'You need more fruit.' },
  missing = { form = 'You need to place a liquid container below the juice press.', info = 'Missing a container below.' },
  mixing = { form = 'Mixing juices is not allowed.', info = "You can't mix juices." },
  collect = { form = 'Organic juice is just a squish away.', info = 'Collect your juice.' },
  full = { form = 'The container is full of juice', info = 'Container is full of juice.' },
}

local set_mode = function(meta, mode)
  meta:set_string('infotext', mode.info)
  meta:set_string('formspec', drinks.juice_press_formspec(mode.form))
end

local get_fruit_item = function(item_name)
  local _, fruit_item = item_name:match("([^:]+):([^:]+)")
  return fruit_item
end

local is_juiceable = function(item_name)
  return drinks.juiceable[get_fruit_item(item_name)]
end

local get_fruit_def = function(item_name)
  local fruit_item = get_fruit_item(item_name)
  local fruit_def = drinks.juiceable[fruit_item]
  fruit_def = type(fruit_def) == 'table' and fruit_def or (fruit_def and {})
  if fruit_def then
    if not fruit_def.juice then
      if string.find(fruit_item, '_') then
        local fruit, _ = fruit_item:match('([^_]+)_([^_]+)')
        fruit_def.juice = fruit
      end
    end
    fruit_def.amount = fruit_def.amount or 1
  end
  return fruit_def
end

local get_juice_name = function(item_name)
  local fruit_def = get_fruit_def(item_name)
  return fruit_def and fruit_def.juice or get_fruit_item(item_name)
end

local set_fullness = function(meta, fullness)
  local capacity = meta:get_int('capacity')
  if capacity == 0 then
    capacity = 256
    meta:set_int('capacity', capacity)
  end
  meta:set_string('fullness', fullness)
  if fullness == 0 then
    meta:set_string('fruit', 'empty')
    meta:set_string('infotext', 'Empty (no juice)')
    meta:set_string('formspec', drinks.liquid_storage_formspec('no', 0, capacity))
  else
    local juice = meta:get_string('fruit')
    local juice_def = drinks.drink_table[juice]
    local juice_desc = string.lower(juice_def and juice_def.desc or juice)
    meta:set_string('infotext', (math.floor((fullness/capacity)*100))..' % full of '..juice_desc..' juice.')
    meta:set_string('formspec', drinks.liquid_storage_formspec(juice_desc, fullness, capacity))
  end
end

local find_container_under = function(pos)
  local under_node = {x=pos.x, y=pos.y-1, z=pos.z}
  local under_node_name = minetest.get_node_or_nil(under_node)
  local under_node_2 = {x=pos.x, y=pos.y-2, z=pos.z}
  local under_node_name_2 = minetest.get_node_or_nil(under_node_2)
  if under_node_name.name == 'drinks:liquid_barrel' then
    local meta_u = minetest.get_meta(under_node)
    meta_u:set_int('capacity', 128)
    return meta_u
  elseif under_node_name_2.name == 'drinks:liquid_silo' then
    local meta_u = minetest.get_meta(under_node_2)
    meta_u:set_int('capacity', 256)
    return meta_u
  end
end

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
      set_mode(meta, modes.idle)
    end,
    on_receive_fields = function(pos, formname, fields, sender)
      if fields ['press'] then
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local timer = minetest.get_node_timer(pos)
        local instack = inv:get_stack("src", 1)
        local juice = get_juice_name(instack:get_name())
        if juice then
          meta:set_string('fruit', juice)
          local outstack = inv:get_stack("dst", 1)
          local vessel = outstack:get_name()
          local vessel_def = drinks.longname[vessel]
          local required = vessel_def and vessel_def.size or 2
          local container = (vessel_def and vessel_def.name or 'jcu')..'_'
          if vessel_def then
            if instack:get_count() >= required then
              meta:set_string('container', container)
              meta:set_string('fruitnumber', required)
              set_mode(meta, modes.running)
              timer:start(required * 2)
            else
              set_mode(meta, modes.need)
            end
          elseif vessel == 'default:papyrus' then
            if instack:get_count() >= required then
              local meta_u = find_container_under(pos)
              if meta_u then
                local stored_juice = meta_u:get_string('fruit')
                if juice == stored_juice or stored_juice == 'empty' then
                  meta_u:set_string('fruit', juice)
                  meta:set_string('container', 'tube')
                  meta:set_int('fruitnumber', required)
                  set_mode(meta, modes.running)
                  timer:start(required * 2)
                else
                  set_mode(meta, modes.mixing)
                end
              else
                set_mode(meta,modes.missing)
              end
            else
              set_mode(meta, modes.need)
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
      local juice = meta:get_string('fruit')
      local required = meta:get_int('fruitnumber')
      if container == 'tube' then
        local timer = minetest.get_node_timer(pos)
        local meta_u = find_container_under(pos)
        if meta_u then
          local fullness = meta_u:get_int('fullness')
          local capacity = meta_u:get_int('capacity')
          instack:take_item(required)
          inv:set_stack('src', 1, instack)
          if fullness + 2 > capacity then
            timer:stop()
            set_mode(meta, modes.full)
            return
          else
            local fullness = fullness + 2
            set_fullness(meta_u, fullness)
            if instack:get_count() >= required then
              timer:start(required * 2)
            else
              set_mode(meta, modes.need)
            end
          end
        end
      else
        set_mode(meta, modes.collect)
        instack:take_item(required)
        inv:set_stack('src', 1, instack)
        inv:set_stack('dst', 1 ,'drinks:'..container..juice)
      end
    end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
      local timer = minetest.get_node_timer(pos)
      local meta = minetest.get_meta(pos)
      timer:stop()
      set_mode(meta, modes.idle)
    end,
    can_dig = function(pos)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      return inv:is_empty("src") and inv:is_empty("dst")
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
        if is_juiceable(stack:get_name()) then
          return stack:get_count()
        else
          return 0
        end
      end
    end,
  })

function drinks.drinks_liquid_sub(liq_vol, ves_typ, pos, able_to_fill, leftover_count, outputstack)
  local meta = minetest.get_meta(pos)
  local fullness = meta:get_int('fullness')
  local juice = meta:get_string('fruit')
  fullness = fullness - (liq_vol*able_to_fill)
  set_fullness(meta, fullness)
  if drinks.shortname[ves_typ] then
    local inv = meta:get_inventory()
    inv:set_stack('dst', 1, 'drinks:'..ves_typ..'_'..juice..' '..able_to_fill)
    inv:set_stack('src', 1, outputstack..' '..leftover_count)
  end
end

function drinks.drinks_liquid_avail_sub(liq_vol, ves_typ, outputstack, pos, count)
  local meta = minetest.get_meta(pos)
  local fullness = meta:get_int('fullness')
  if fullness - (liq_vol*count) < 0 then
    local able_to_fill = math.floor(fullness/liq_vol)
    local leftover_count = count - able_to_fill
    drinks.drinks_liquid_sub(liq_vol, ves_typ, pos, able_to_fill, leftover_count, outputstack)
  elseif fullness - (liq_vol*count) >= 0 then
    drinks.drinks_liquid_sub(liq_vol, ves_typ, pos, count, 0, outputstack)
  end
end

function drinks.drinks_liquid_add(liq_vol, ves_typ, pos, inputcount, leftover_count, inputstack)
  local meta = minetest.get_meta(pos)
  local fullness = meta:get_int('fullness')
  local inv = meta:get_inventory()
  inv:set_stack('src', 1, ves_typ..' '..inputcount)
  inv:set_stack('dst', 1, inputstack..' '..leftover_count)
  fullness = fullness + (liq_vol*inputcount)
  set_fullness(meta, fullness)
end

function drinks.drinks_liquid_avail_add(liq_vol, ves_typ, capacity, pos, inputstack, inputcount)
  local meta = minetest.get_meta(pos)
  local fullness = meta:get_int('fullness')
  if fullness + (liq_vol*inputcount) > capacity then
    local avail_ves_vol = capacity - fullness
    local can_empty = math.floor(avail_ves_vol/liq_vol)
    local leftover_count = inputcount - can_empty
    drinks.drinks_liquid_add(liq_vol, ves_typ, pos, can_empty, leftover_count, inputstack)
  elseif fullness + (liq_vol*inputcount) <= capacity then
    drinks.drinks_liquid_add(liq_vol, ves_typ, pos, inputcount, 0, inputstack)
  end
end

local allow_metadata_inventory_put = function(pos, listname, index, stack, player)
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
      drinks.drinks_liquid_avail_add(vessel_def.size, vessel_def.name, capacity, pos, inputstack, instack:get_count())
    end
  end
  local outstack = inv:get_stack('dst', 1)
  local outputstack = outstack:get_name()
  local container = drinks.longname[outputstack]
  if container then
    drinks.drinks_liquid_avail_sub(container.size, container.name, outputstack, pos, outstack:get_count())
  end
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
    set_fullness(meta, 0)
  end
end

local on_construct_for_volume = function(capacity)
  return function(pos)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    inv:set_size('src', 1)
    inv:set_size('dst', 1)
    meta:set_int('capacity', capacity)
    set_fullness(meta, 0)
  end
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
    on_construct = on_construct_for_volume(128),
    allow_metadata_inventory_put = allow_metadata_inventory_put,
    on_metadata_inventory_put = on_metadata_inventory_put,
    on_receive_fields = on_receive_fields,
    can_dig = can_dig,
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
    on_construct = on_construct_for_volume(256),
    allow_metadata_inventory_put = allow_metadata_inventory_put,
    on_metadata_inventory_put = on_metadata_inventory_put,
    on_receive_fields = on_receive_fields,
    can_dig = can_dig,
  })
