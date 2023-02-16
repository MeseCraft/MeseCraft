local S = drinks.get_translator

--Craft Recipe
minetest.register_craft({
    output = 'drinks:juice_press',
    recipe = {
      {'default:stick', 'default:steel_ingot', 'default:stick'},
      {'default:stick', 'mesecraft_bucket:bucket_empty', 'default:stick'},
      {'stairs:slab_wood', 'stairs:slab_wood', 'vessels:drinking_glass'},
    }
  })

local modes = {
  idle = { form = S('Organic juice is just a squish away.'), info = S('Ready for juicing') },
  running = { form = S('Organic juice coming right up.'), info = S('Juicing...') },
  need = { form = S('You need to add more fruit.'), info = S('You need more fruit.') },
  missing = { form = S('You need to place a liquid container below the juice press.'), info = S('Missing a container below.') },
  mixing = { form = S('Mixing juices is not allowed.'), info = S("You can't mix juices.") },
  collect = { form = S('Organic juice is just a squish away.'), info = S('Collect your juice.') },
  full = { form = S('The container is full of juice'), info = S('Container is full of juice.') },
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
    drinks.juiceable[fruit_item] = fruit_def
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

local allow_metadata_inventory_put = function(pos, listname, index, stack, player)
  if listname == 'dst' then
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    if not inv:is_empty(listname) then
      return 0
    end
    local vessel = stack:get_name()
    if drinks.longname[vessel] then
      return 1
    elseif vessel == drinks.tube then
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
end

local allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stack = inv:get_stack(from_list, from_index)
	return allow_metadata_inventory_put(pos, to_list, to_index, stack, player)
end

minetest.register_node('drinks:juice_press', {
    description = S('Juice Press'),
    _doc_items_longdesc = S('A machine for creating drinks out of various fruits and vegetables.'),
    _doc_items_usagehelp = S('Right-click the press to access inventory and begin juicing.'),
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
        local fruit_def = get_fruit_def(instack:get_name())
        local juice = fruit_def and fruit_def.juice or get_fruit_item(instack:get_name())
        if juice then
          meta:set_string('fruit', juice)
          local outstack = inv:get_stack("dst", 1)
          local vessel = outstack:get_name()
          local vessel_def = drinks.longname[vessel]
          local required = vessel_def and vessel_def.size or 2
          local container = (vessel_def and vessel_def.name or 'jcu')..'_'
          local amount = fruit_def.amount or 1
          if vessel_def then
            required = math.ceil(required / amount)
            if instack:get_count() >= required then
              meta:set_string('container', container)
              meta:set_string('fruitnumber', required)
              set_mode(meta, modes.running)
              timer:start(required * 2)
            else
              set_mode(meta, modes.need)
            end
          elseif vessel == drinks.tube then
            local yield = amount
            required = 1
            while yield < 2 or (yield - math.floor(yield)) > 0.1 * amount do
              required = required + 1
              yield = yield + amount
            end
            if instack:get_count() >= required then
              local meta_u = find_container_under(pos)
              if meta_u then
                local stored_juice = meta_u:get_string('fruit')
                if juice == stored_juice or stored_juice == 'empty' then
                  meta:set_string('container', 'tube')
                  meta:set_float('amount', amount)
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
      local amount = meta:get_float('amount')
      local add_vol = amount * required
      if container == 'tube' then
        local timer = minetest.get_node_timer(pos)
        local meta_u = find_container_under(pos)
        if meta_u then
          local stored_juice = meta_u:get_string('fruit')
          if juice == stored_juice or stored_juice == 'empty' then
            meta_u:set_string('fruit', juice)
          else
            timer:stop()
            set_mode(meta, modes.mixing)
            return
          end
          local fullness = meta_u:get_int('fullness')
          local capacity = meta_u:get_int('capacity')
          instack:take_item(required)
          inv:set_stack('src', 1, instack)
          if fullness + add_vol > capacity then
            timer:stop()
            set_mode(meta, modes.full)
            return
          else
            fullness = fullness + add_vol
            drinks.set_fullness(meta_u, fullness)
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
    allow_metadata_inventory_put = allow_metadata_inventory_put,
    allow_metadata_inventory_move = allow_metadata_inventory_move,
  })
