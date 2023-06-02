-- BY FREEGAMERS.ORG
-- CAVE FLOATER,INSPIRED BY DF
-- ASSETS FROM D00MED'S HORROR PACK MOGALL
-- (TODO: MAKE POSIONOUS GAS) Reference NSSM:venomous_gas and df_caverbs mine_gas:gas, drops mesecraft_mobs:leather

mobs:register_mob("mesecraft_mobs:cave_floater", {
   type = "animal",
   passive = false,
   damage = 0, -- simulate push attack
   reach = 2,
   attack_type = "dogshoot",
   arrow = "mesecraft_mobs:a_cave_floater_gasball",
   shoot_interval = 2.5,
   dogshoot_switch = 2,
   dogshoot_count = 0,
   dogshoot_count_max =2,
   hp_min = 20,
   hp_max = 20,
   armor = 150,
   knock_back = true,
   collisionbox = {-0.6, -0.25, -0.6, 0.6, 0.9, 0.6},
   visual = "mesh",
   mesh = "mesecraft_mobs_cave_floater.b3d",
   textures = {
      {"mesecraft_mobs_cave_floater.png"},
   },
   visual_size = {x=3, y=3},
   makes_footstep_sound = false,
   walk_velocity = 1,
   run_velocity = 2,
   jump = true,
   fly = true,
   floats = true,
   fall_speed = 0,
   stepheight = 1,
   water_damage = 0,
   lava_damage = 10,
   light_damage = 0,
   view_range = 32,
   sounds = {
        death = "mesecraft_mobs_demon_eye_death",
        damage = "mesecraft_mobs_demon_eye_damage",
        attack = "mesecraft_mobs_demon_eye_attack",
	shoot_attack = "mesecraft_mobs_common_shoot_poisonball",
	},
   animation = {
      speed_normal = 5,
      speed_run = 6,
      walk_start = 20,
      walk_end = 60,
      stand_start = 1,
      stand_end = 20,
      run_start = 20,
      run_end = 60,
      punch_start = 20,
      punch_end = 60,
   },
   on_die = function(self,pos)
	      minetest.set_node(pos, {name = "mine_gas:gas"})
            end
})
-- REGISTER ARROW: Gas Attack 
mobs:register_arrow("mesecraft_mobs:a_cave_floater_gasball", {
   visual = "sprite",
   visual_size = {x = 1, y = 1},
   textures = {"mesecraft_mobs_arrow_poisonball.png"},
   velocity = 6,
   glow = 5,
   tail = 1, -- enable tail
   tail_texture = "mesecraft_mobs_arrow_poisonball_trail.png",

   hit_player = function(self, player)
      player:punch(self.object, 1.0, {
         full_punch_interval = 1.0,
         damage_groups = {fleshy = 10},
      }, nil)
       minetest.sound_play({name = "mesecraft_mobs_common_shoot_poisonball_hit", gain = 1.0}, {pos=player:get_pos(), max_hear_distance = 12})
       minetest.set_node(player:get_pos(), {name = "mine_gas:gas"})
   end,

   hit_mob = function(self, player)
      player:punch(self.object, 1.0, {
         full_punch_interval = 1.0,
         damage_groups = {fleshy = 10},
      }, nil)
   end,

   hit_node = function(self, pos, node)
       minetest.sound_play({name = "mesecraft_mobs_common_shoot_poisonball_hit", gain = 1.0}, {pos=pos, max_hear_distance = 12})
      minetest.set_node(pos, {name = "mine_gas:gas"})
      self.object:remove()
   end,
})
-- REGISTER SPAWN PARAMETERS: spawns on top of air by glow worms, flowstones, stalagtite. 
mobs:spawn_specific("mesecraft_mobs:cave_floater", {"df_mapitems:glow_worm", "df_mapitems:wet_stal_1","df_mapitems:wet_stal_2", "df_mapitems:wet_stal_3","df_mapitems:wet_stal_4"},{"air"},  0, 10, 60, 2500, 8, -9500, -3500)   

-- REGISTER SPAWN EGG
mobs:register_egg("mesecraft_mobs:cave_floater", "Cave Floater Spawn Egg", "default_obsidian.png", 1)
