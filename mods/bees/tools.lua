--TOOLS
  minetest.register_tool('bees:smoker', {
    description = 'Hive Smoker',
    inventory_image = 'bees_smoker.png',
    tool_capabilities = {
      full_punch_interval = 3.0,
      max_drop_level=0,
      damage_groups = {fleshy=2},
    },
    on_use = function(tool, user, node)
      if node then
        local pos = node.under
        if pos then
          for i=1,6 do
            minetest.add_particle({
              pos = {x=pos.x+math.random()-0.5, y=pos.y, z=pos.z+math.random()-0.5},
              vel = {x=0,y=0.5+math.random(),z=0},
              acc = {x=0,y=0,z=0},
              expirationtime = 2+math.random(2.5),
              size = math.random(3),
              collisiondetection = false,
              texture = 'tnt_smoke.png',
            })
          end
          --tool:add_wear(2)
          local meta = minetest.get_meta(pos)
          meta:set_int('agressive', 0)
          return nil
        end
      end
    end,
  })

  minetest.register_tool('bees:grafting_tool', {
    description = 'Beehive Grafting Tool',
    inventory_image = 'bees_grafting_tool.png',
    tool_capabilities = {
      full_punch_interval = 3.0,
      max_drop_level=0,
      damage_groups = {fleshy=2},
    },
  })
