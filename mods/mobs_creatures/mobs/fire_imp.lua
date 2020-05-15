-- FIREIMP BY FREEGAMERS.ORG
-- INSPIRED BY DWARF FORTRESS.

-- BUG: FIRE IMPS ARE NOT FLOATING IN LAVA.

-- FIRE IMP
mobs:register_mob("mobs_creatures:fire_imp", {
   type = "monster",
   passive = false,
   damage = 4,
   reach = 2,
   attack_type = "dogshoot",
   shoot_interval = 2.5,
   dogshoot_switch = 2,
   dogshoot_count = 0,
   dogshoot_count_max =2,
   arrow = "mobs_creatures:fire_imp_fireball",
   shoot_offset = 1.5,
   hp_min = 10,
   hp_max = 10,
   armor = 100,
   collisionbox = {-0.25,-0.5,-0.25, 0.25,0.4,0.25},
   visual = "mesh",
   mesh = "mobs_character.b3d",
   textures = {
      {"mobs_creatures_fire_imp.png"},
   },
   blood_amount = 8,
   visual_size = {x=0.5, y=0.5},
   makes_footstep_sound = true,
   walk_velocity = 2,
   suffocation = false,
   run_velocity = 2.5,
   floats = 1,
   jump = true,
-- not sure if this works without fly enabled.   fly_in = "default:lava_source",
   sounds = {
                distance = "16",
                random = "mobs_creatures_fire_imp_random",
                attack = "mobs_creatures_fire_imp_attack",
                shoot_attack = "mobs_creatures_common_shoot_fireball",
                damage = "mobs_creatures_fire_imp_damage",
                death = "mobs_creatures_fire_imp_death",
   },
   drops = {
      {name = "mobs:meat", chance = 1, min = 1, max = 2}, 
      {name = "mobs:leather", chance =1, min = 1, max = 1},
      {name = "mobs_creatures:bone", chance = 1, min = 1, max = 3},
   },
   water_damage = 0,
   lava_damage = 0,
   light_damage = 0,
   view_range = 12,
   animation = {
          speed_normal = 30,
          speed_run = 30,
          stand_start = 0,
          stand_end = 79,
          walk_start = 168,
          walk_end = 187,
          run_start = 168,
          run_end = 187,
          punch_start = 200,
          punch_end = 219,
        },
        do_custom = function(self, dtime, nodef)
	-- heats up water if it comes into contact with it and it evaporates.
        local pos = self.object:getpos()
        if minetest.get_node(pos).name == "default:water_source" or minetest.get_node(pos).name == "default:water_flowing" or minetest.get_node(pos).name == "default:river_water_source" or minetest.get_node(pos).name == "default:river_water_flowing" or minetest.get_node(pos).name == "default:snow" or minetest.get_node(pos).name == "default:ice" then
                minetest.add_particlespawner({
                        amount = 1,
                        time = 1,
                        minpos = pos,
                        maxpos = pos,
                        minvel = {x=-1, y=0, z=-1},
                        maxvel = {x=1, y=1, z=1},
                        minacc = {x=0, y=2, z=0},
                        maxacc = {x=0, y=2, z=0},
                        minexptime = 1,
                        maxexptime = 2,
                        minsize = 4,
                        maxsize = 8,
                        collisiondetection = false,
                        vertical = false,
                        texture = "smoke_puff.png",
                })
                minetest.sound_play({name = "default_cool_lava", gain = 1.0}, {pos=pos, max_hear_distance = 16})
                minetest.set_node(pos, {name = "air"})
        else
                return
        end
    end,
    on_die = function(self, pos) -- on die, spawn a fire:permanent flame.
        if minetest.get_node(pos).name == "air" then
                minetest.set_node(pos, {name = "fire:permanent_flame"})
        end
        self.object:remove()
    end,
})
-- FIRE IMP PROJECTILE
mobs:register_arrow("mobs_creatures:fire_imp_fireball", {
   visual = "sprite",
   visual_size = {x = 0.5, y = 0.5},
   textures = {"mobs_creatures_arrow_fireball.png"},
   velocity = 7,
   glow = 5,
   tail = 1, -- enable tail
   tail_texture = "mobs_creatures_arrow_fireball_trail.png",
   hit_player = function(self, player)
      player:punch(self.object, 1.0, {
         full_punch_interval = 1.0,
         damage_groups = {fleshy = 32},
      }, nil)
       minetest.sound_play({name = "mobs_creatures_common_shoot_fireball_hit", gain = 1.0}, {pos=player:getpos(), max_hear_distance = 12})
   end,

   hit_mob = function(self, player)
      player:punch(self.object, 1.0, {
         full_punch_interval = 1.0,
         damage_groups = {fleshy = 32},
      }, nil)
   end,

   hit_node = function(self, pos, node)
        minetest.sound_play({name = "mobs_creatures_common_shoot_fireball_hit", gain = 1.0}, {pos=pos, max_hear_distance = 12})
	minetest.set_node(pos, {name = "fire:permanent_flame"})
	self.object:remove()
   end,
})
-- REGISTER SPAWN PARAMETERS
mobs:spawn_specific("mobs_creatures:fire_imp",  {"default:cobblestone", "default:stone", "magma_conduits:hot_cobble", "magma_conduits:glow_obsidian", "magma_conduits:stone", "group:stone"}, {"default:lava_flowing", "default:lava_source"}, 0, 20, 120, 2500, 6, -15500, 0)

-- REGISTER SPAWN EGG
mobs:register_egg("mobs_creatures:fire_imp", "Fire Imp Spawn Egg", "default_lava.png", 1)
