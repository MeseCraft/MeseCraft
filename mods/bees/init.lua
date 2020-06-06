-- EDITED BY FREEGAMERS, Fall, 2019
-- CHANGES:
-- INCLUDED NICER TEXTURES FROM CHURCH_CANDLES MOD
-- USED TEXTURES FROM DEFAULT TO REDUCE REDUNDANCY,
-- REMOVED AUTOMATION VIA INDUSTRIAL HIVE & PIPEWORKS SUPPORT TO RETAIN PLAYER ENGAGEMENT.
-- CLEANED UP DESCRIPTION FIELDS' CASING
-- REMOVE BACKWARDS COMPATIBLITY
-- ADDED LOCATIONAL SOUND EFFECTS.
-- TODO: ADD HONEY LIQUID / BUCKET, maybe a honey/bee biomes.
-- TODO: Giant Bee Mob for mobs_Creatures.

--Bees by Bas080
--Note: This branch was modified by clockgen in summer, 2019.
--Version	2.2
--License	WTFPL

--VARIABLES
  local bees = {}
  local formspecs = {}

--FUNCTIONS
  function formspecs.hive_wild(pos, grafting)
    local spos = pos.x .. ',' .. pos.y .. ',' ..pos.z
    local formspec =
      'size[8,9]'..
      'list[nodemeta:'.. spos .. ';combs;1.5,3;5,1;]'..
      'list[current_player;main;0,5;8,4;]'
    if grafting then
      formspec = formspec..'list[nodemeta:'.. spos .. ';queen;3.5,1;1,1;]'
    end
    return formspec
  end

  function formspecs.hive_artificial(pos)
    local spos = pos.x..','..pos.y..','..pos.z
    local formspec =
      'size[8,9]'..
      'list[nodemeta:'..spos..';queen;3.5,1;1,1;]'..
      'list[nodemeta:'..spos..';frames;0,3;8,1;]'..
      'list[current_player;main;0,5;8,4;]'
    return formspec
  end

  function bees.polinate_flower(pos, flower)
    local spawn_pos = { x=pos.x+math.random(-3,3) , y=pos.y+math.random(-3,3) , z=pos.z+math.random(-3,3) }
    local floor_pos = { x=spawn_pos.x , y=spawn_pos.y-1 , z=spawn_pos.z }
    local spawn = minetest.get_node(spawn_pos).name
    local floor = minetest.get_node(floor_pos).name
    if floor == 'default:dirt_with_grass' and spawn == 'air' then
      minetest.set_node(spawn_pos, {name=flower})
    end
  end


--ABMS
  minetest.register_abm({ --particles
    nodenames = {'bees:hive_artificial', 'bees:hive_wild'},
    interval  = 10,
    chance    = 4,
    action = function(pos)
      minetest.add_particle({
        pos = {x=pos.x, y=pos.y, z=pos.z},
        vel = {x=(math.random()-0.5)*5,y=(math.random()-0.5)*5,z=(math.random()-0.5)*5},
        acc = {x=math.random()-0.5,y=math.random()-0.5,z=math.random()-0.5},
        expirationtime = math.random(2.5),
        size = math.random(3),
        collisiondetection = true,
        texture = 'bees_particle_bee.png',
      })
    end,
  })

  minetest.register_abm({ --spawn abm. This should be changed to a more realistic type of spawning
    nodenames = {'group:leaves'},
    interval = 1600,
    chance = 20,
    action = function(pos, node)
      local p = {x=pos.x, y=pos.y-1, z=pos.z}
      if minetest.get_node(pos).walkable == false then return end
      if (minetest.find_node_near(p, 5, 'group:flower') ~= nil and minetest.find_node_near(p, 40, 'bees:hive_wild') == nil) then
        minetest.add_node(p, {name='bees:hive_wild'})
	minetest.sound_play({name = "bees", gain = 1.0}, {pos=p, max_hear_distance = 8})
      end
    end,
  })

  minetest.register_abm({ --spawning bees around bee hive
    nodenames = {'bees:hive_wild', 'bees:hive_artificial'},
    neighbors = {'group:flower', 'group:leaves'},
    interval = 30,
    chance = 4,
    action = function(pos, node, _, _)
      local p = {x=pos.x+math.random(-5,5), y=pos.y-math.random(0,3), z=pos.z+math.random(-5,5)}
      if minetest.get_node(p).name == 'air' then
        minetest.add_node(p, {name='bees:bees'})
       	minetest.sound_play({name = "bees", gain = 1.0}, {pos=p, max_hear_distance = 8})
      end
    end,
  })

  minetest.register_abm({ --remove bees
    nodenames = {'bees:bees'},
    interval = 30,
    chance = 5,
    action = function(pos, node, _, _)
      minetest.remove_node(pos)
    end,
  })

-- Load other modules for the mod.
local default_path = minetest.get_modpath("bees")

dofile(default_path.."/crafting.lua")
dofile(default_path.."/craftitems.lua")
dofile(default_path.."/nodes.lua")
dofile(default_path.."/tools.lua")