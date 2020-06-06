-- Nodes.
  minetest.register_node('bees:extractor', {
    description = 'Honey Extractor Machine',
    tiles = {"bees_extractor_top.png", "bees_extractor_bottom.png", "bees_extractor_side.png", "bees_extractor_side.png", "bees_extractor_side.png", "bees_extractor_front.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    drawtype = "nodebox",
    place_param2 = 0,
    groups = {choppy=2,oddly_breakable_by_hand=2},
    sounds = default.node_sound_wood_defaults(),
    node_box = {
	type = "fixed",
	fixed = {
			{-0.4375, -0.5, -0.4375, 0.4375, 0, 0.4375},
			{-0.375, -0.0625, -0.375, 0.375, 0.5, 0.375},
			{-0.4375, 0.375, -0.4375, 0.4375, 0.4375, 0.4375},
			{0.375, 0, -0.4375, 0.4375, 0.4375, -0.375},
			{-0.4375, 0, -0.4375, -0.375, 0.4375, -0.375},
			{-0.4375, 0, 0.375, -0.375, 0.4375, 0.4375},
			{0.375, 0, 0.375, 0.4375, 0.4375, 0.4375},
		},
    },
    selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	},
    on_construct = function(pos, node)
      local meta = minetest.get_meta(pos)
      local inv  = meta:get_inventory()
      local pos = pos.x..','..pos.y..','..pos.z
      inv:set_size('frames_filled'  ,1)
      inv:set_size('frames_emptied' ,1)
      inv:set_size('bottles_empty'  ,1)
      inv:set_size('bottles_full' ,1)
      inv:set_size('wax',1)
      meta:set_string('formspec',
        'size[8,9]'..
        --input
        'list[nodemeta:'..pos..';frames_filled;2,1;1,1;]'..
        'list[nodemeta:'..pos..';bottles_empty;2,3;1,1;]'..
        --output
        'list[nodemeta:'..pos..';frames_emptied;5,0.5;1,1;]'..
        'list[nodemeta:'..pos..';wax;5,2;1,1;]'..
        'list[nodemeta:'..pos..';bottles_full;5,3.5;1,1;]'..
        --player inventory
        'list[current_player;main;0,5;8,4;]'
      )
    end,
    on_timer = function(pos, node)
      local meta = minetest.get_meta(pos)
      local inv  = meta:get_inventory()
      if not inv:contains_item('frames_filled','bees:frame_full') or not inv:contains_item('bottles_empty','vessels:glass_bottle') then
        return
      end
      if inv:room_for_item('frames_emptied', 'bees:frame_empty') 
      and inv:room_for_item('wax','bees:wax') 
      and inv:room_for_item('bottles_full', 'bees:bottle_honey') then
        --add to output
        inv:add_item('frames_emptied', 'bees:frame_empty')
        inv:add_item('wax', 'bees:wax')
        inv:add_item('bottles_full', 'bees:bottle_honey')
        --remove from input
        inv:remove_item('bottles_empty','vessels:glass_bottle')
        inv:remove_item('frames_filled','bees:frame_full')
        local p = {x=pos.x+math.random()-0.5, y=pos.y+math.random()-0.5, z=pos.z+math.random()-0.5}
        --wax flying all over the place
        minetest.add_particle({
          pos = {x=pos.x, y=pos.y, z=pos.z},
          vel = {x=math.random(-4,4),y=math.random(8),z=math.random(-4,4)},
          acc = {x=0,y=-6,z=0},
          expirationtime = 2,
          size = math.random(1,3),
          collisiondetection = false,
          texture = 'bees_wax_particle.png',
        })
        local timer = minetest.get_node_timer(pos)
        timer:start(5)
      else
        local timer = minetest.get_node_timer(pos)
        timer:start(1) -- Try again in 1 second
      end
    end,
    tube = {
      insert_object = function(pos, node, stack, direction)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local timer = minetest.get_node_timer(pos)
        if stack:get_name() == "bees:frame_full" then
          if inv:is_empty("frames_filled") then
            timer:start(5)
          end
          return inv:add_item("frames_filled",stack)
        elseif stack:get_name() == "vessels:glass_bottle" then
          if inv:is_empty("bottles_empty") then
            timer:start(5)
          end
          return inv:add_item("bottles_empty",stack)
        end
        return stack
      end,
      can_insert = function(pos,node,stack,direction)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        if stack:get_name() == "bees:frame_full" then
          return inv:room_for_item("frames_filled",stack)
        elseif stack:get_name() == "vessels:glass_bottle" then
          return inv:room_for_item("bottles_empty",stack)
        end
        return false
      end,
      input_inventory = {"frames_emptied", "bottles_full", "wax"},
      connect_sides = {left=1, right=1, back=1, front=1, bottom=1, top=1}
    },
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
      local timer = minetest.get_node_timer(pos)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      if inv:get_stack(listname, 1):get_count() == stack:get_count() then -- inv was empty -> start the timer
          timer:start(5) --create a honey bottle and empty frame and wax every 5 seconds
      end
    end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
      if (listname == 'bottles_empty' and stack:get_name() == 'vessels:glass_bottle') or (listname == 'frames_filled' and stack:get_name() == 'bees:frame_full') then
        return stack:get_count()
      else
        return 0
      end  
    end,
    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
      return 0
    end,
  })

  minetest.register_node('bees:bees', {
    description = 'Flying Bees',
    drawtype = 'plantlike',
    paramtype = 'light',
    groups = { not_in_creative_inventory=1 },
    tiles = {
      {
        name='bees_strip.png', 
        animation={type='vertical_frames', aspect_w=16,aspect_h=16, length=2.0}
      }
    },
    damage_per_second = 1,
    walkable = false,
    buildable_to = true,
    pointable = false,
    on_punch = function(pos, node, puncher)
      local health = puncher:get_hp()
      puncher:set_hp(health-2)
    end,
  })
  minetest.register_node('bees:hive_wild', {
    description = 'Wild Bee Hive',
    tiles = {"bees_hive_wild.png"}, --texture from church_candles.
    drawtype = "plantlike",
    paramtype = 'light',
    walkable = true,
    drop = {
      max_items = 6,
      items = {
        { items = {'bees:honeycomb'}, rarity = 5}
      }
    },
    groups = {choppy=2,oddly_breakable_by_hand=2,flammable=3,attached_node=1},
    on_timer = function(pos)
      local meta = minetest.get_meta(pos)
      local inv  = meta:get_inventory()
      local timer= minetest.get_node_timer(pos)
      local rad  = 10
      local minp = {x=pos.x-rad, y=pos.y-rad, z=pos.z-rad}
      local maxp = {x=pos.x+rad, y=pos.y+rad, z=pos.z+rad}
      local flowers = minetest.find_nodes_in_area(minp, maxp, 'group:flower')
      if #flowers == 0 then 
        inv:set_stack('queen', 1, '')
        meta:set_string('infotext', 'This hive colony died! Not enough flowers in area.')
        return 
      end --not any flowers nearby The queen dies!
      if #flowers < 3 then return end --requires 2 or more flowers before can make honey
      local flower = flowers[math.random(#flowers)] 
      bees.polinate_flower(flower, minetest.get_node(flower).name)
      local stacks = inv:get_list('combs')
      for k, v in pairs(stacks) do
        if inv:get_stack('combs', k):is_empty() then --then replace that with a full one and reset pro..
          inv:set_stack('combs',k,'bees:honeycomb')
          timer:start(1000/#flowers)
          return
        end
      end
      --what to do if all combs are filled
    end,
    on_construct = function(pos)
      minetest.get_node(pos).param2 = 0
      local meta = minetest.get_meta(pos)
      local inv  = meta:get_inventory()
      local timer = minetest.get_node_timer(pos)
      meta:set_int('agressive', 1)
      timer:start(100+math.random(100))
      inv:set_size('queen', 1)
      inv:set_size('combs', 5)
      inv:set_stack('queen', 1, 'bees:queen')
      for i=1,math.random(3) do
        inv:set_stack('combs', i, 'bees:honeycomb')
      end
    end,
    on_punch = function(pos, node, puncher)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      if inv:contains_item('queen','bees:queen') then
        local health = puncher:get_hp()
        puncher:set_hp(health-4)
      end
    end,
    on_metadata_inventory_take = function(pos, listname, index, stack, taker)
      local meta = minetest.get_meta(pos)
      local inv  = meta:get_inventory()
      local timer= minetest.get_node_timer(pos)
      if listname == 'combs' and inv:contains_item('queen', 'bees:queen') then
        local health = taker:get_hp()
        timer:start(10)
        taker:set_hp(health-2)
      end
    end,
    on_metadata_inventory_put = function(pos, listname, index, stack, taker) --restart the colony by adding a queen
      local timer = minetest.get_node_timer(pos)
      if not timer:is_started() then
        timer:start(10)
      end
    end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
      if listname == 'queen' and stack:get_name() == 'bees:queen' then
        return 1
      else
        return 0
      end
    end,
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
      minetest.show_formspec(
        clicker:get_player_name(),
        'bees:hive_artificial',
        formspecs.hive_wild(pos, (itemstack:get_name() == 'bees:grafting_tool'))
      )
      local meta = minetest.get_meta(pos)
      local inv  = meta:get_inventory()
      if meta:get_int('agressive') == 1 and inv:contains_item('queen', 'bees:queen') then
        local health = clicker:get_hp()
        clicker:set_hp(health-4)
      else
        meta:set_int('agressive', 1)
      end
    end,
    can_dig = function(pos,player)
      local meta = minetest.get_meta(pos)
      local inv  = meta:get_inventory()
      if inv:is_empty('queen') and inv:is_empty('combs') then
        return true
      else
        return false
      end
    end,
    after_dig_node = function(pos, oldnode, oldmetadata, user)
      local wielded if user:get_wielded_item() ~= nil then wielded = user:get_wielded_item() else return end
      if 'bees:grafting_tool' == wielded:get_name() then 
        local inv = user:get_inventory()
        if inv then
          inv:add_item('main', ItemStack('bees:queen'))
        end
      end
    end
  })

  minetest.register_node('bees:hive_artificial', {
    description = 'Bee Hive',
    tiles = {'default_wood.png','default_wood.png','default_wood.png', 'default_wood.png','default_wood.png','bees_hive_artificial.png'},
    drawtype = 'nodebox',
    paramtype = 'light',
    paramtype2 = 'facedir',
    groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1},
    sounds = default.node_sound_wood_defaults(),
    node_box = {
      type = 'fixed',
      fixed = {
        {-4/8, 2/8, -4/8, 4/8, 3/8, 4/8},
        {-3/8, -4/8, -2/8, 3/8, 2/8, 3/8},
        {-3/8, 0/8, -3/8, 3/8, 2/8, -2/8},
        {-3/8, -4/8, -3/8, 3/8, -1/8, -2/8},
        {-3/8, -1/8, -3/8, -1/8, 0/8, -2/8},
        {1/8, -1/8, -3/8, 3/8, 0/8, -2/8},
      }
    },
    on_construct = function(pos)
      local timer = minetest.get_node_timer(pos)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      meta:set_int('agressive', 1)
      inv:set_size('queen', 1)
      inv:set_size('frames', 8)
      meta:set_string('infotext','Requires a queen bee to function.')
    end,
    on_rightclick = function(pos, node, clicker, itemstack)
      minetest.show_formspec(
        clicker:get_player_name(),
        'bees:hive_artificial',
        formspecs.hive_artificial(pos)
      )
      local meta = minetest.get_meta(pos)
      local inv  = meta:get_inventory()
      if meta:get_int('agressive') == 1 and inv:contains_item('queen', 'bees:queen') then
        local health = clicker:get_hp()
        clicker:set_hp(health-4)
      else
        meta:set_int('agressive', 1)
      end
    end,
    on_timer = function(pos,elapsed)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      local timer = minetest.get_node_timer(pos)
      if inv:contains_item('queen', 'bees:queen') then
        if inv:contains_item('frames', 'bees:frame_empty') then
          timer:start(30)
          local rad  = 10
          local minp = {x=pos.x-rad, y=pos.y-rad, z=pos.z-rad}
          local maxp = {x=pos.x+rad, y=pos.y+rad, z=pos.z+rad}
          local flowers = minetest.find_nodes_in_area(minp, maxp, 'group:flower')
          local progress = meta:get_int('progress')
          progress = progress + #flowers
          meta:set_int('progress', progress)
          if progress > 1000 then
            local flower = flowers[math.random(#flowers)] 
            bees.polinate_flower(flower, minetest.get_node(flower).name)
            local stacks = inv:get_list('frames')
            for k, v in pairs(stacks) do
              if inv:get_stack('frames', k):get_name() == 'bees:frame_empty' then
                meta:set_int('progress', 0)
                inv:set_stack('frames',k,'bees:frame_full')
                return
              end
            end
          else
            meta:set_string('infotext', 'Progress: '..progress..'+'..#flowers..'/1000')
          end
        else
          meta:set_string('infotext', 'Hive does not have empty frame(s)!')
          timer:stop()
        end
      end
    end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
      if listname == 'queen' then
        local timer = minetest.get_node_timer(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string('infotext','Hive requires a queen bee to function!')
        timer:stop()
      end
    end,
    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
      local inv = minetest.get_meta(pos):get_inventory()
      if from_list == to_list then 
        if inv:get_stack(to_list, to_index):is_empty() then
          return 1
        else
          return 0
        end
      else
        return 0
      end
    end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      local timer = minetest.get_node_timer(pos)
      if listname == 'queen' or listname == 'frames' then
        meta:set_string('queen', stack:get_name())
        meta:set_string('infotext','A queen bee is inserted. Add empty frames!');
        if inv:contains_item('frames', 'bees:frame_empty') then
          timer:start(30)
          meta:set_string('infotext','Bees are settling in!');
        end
      end
    end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
      if not minetest.get_meta(pos):get_inventory():get_stack(listname, index):is_empty() then return 0 end
      if listname == 'queen' then
        if stack:get_name():match('bees:queen*') then
          return 1
        end
      elseif listname == 'frames' then
        if stack:get_name() == ('bees:frame_empty') then
          return 1
        end
      end
      return 0
    end,
  })

minetest.register_node("bees:honeycomb_block", {
        description = "Honeycomb Block",
        inventory_image = "bees_honeycomb_block.png",
        tiles = {"bees_honeycomb_block.png"},
        groups = {oddly_breakable_by_hand = 3, dig_immediate = 1},
        sounds = default.node_sound_dirt_defaults(),
})

