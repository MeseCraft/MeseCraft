-- IMP
mobs:register_mob("mobs_creatures:imp", {
   type = "monster",
   passive = false,
   damage = 15,
   reach = 2,
   attack_type = "dogshoot",
   shoot_interval = 2.5,
        dogshoot_switch = 2,
        dogshoot_count = 2,
        dogshoot_count_max =5,
   arrow = "mobs_creatures:an_imp_fireball",
   shoot_offset = 1.5,
   hp_min = 20,
   hp_max = 20,
   armor = 100,
   collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
   visual = "mesh",
   mesh = "mobs_character.b3d",
   textures = {
      {"mobs_creatures_imp.png"},
   },
   visual_size = {x=1, y=1},
   makes_footstep_sound = true,
   walk_velocity = 2,
   run_velocity = 3,
   jump = true,
   sounds = {
                distance = "20",
                random = "mobs_creatures_imp_random",
                war_cry = "mobs_creatures_imp_warcry",
                attack = "mobs_creatures_common_attack_claw",
                shoot_attack = "mobs_creatures_common_shoot_fireball",
                damage = "mobs_creatures_zombie_damage",
                death = "mobs_creatures_imp_death",
   },
   drops = {
--      {name = "default:coal_lump", chance = 1, min = 1, max = 2},
   },
   water_damage = 2,
   lava_damage = 0,
   light_damage = 0,
   view_range = 20,
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
          shoot_start = 200,
          shoot_end = 219,
        },
})
--REGISTER ARROW: IMP PROJECTILE
mobs:register_arrow("mobs_creatures:an_imp_fireball", {
   visual = "sprite",
   visual_size = {x = 1, y = 1},
   textures = {"mobs_creatures_arrow_fireball.png"},
   velocity = 8,
   glow = 5,
   tail = 1, -- enable trail
   tail_texture = "mobs_creatures_arrow_fireball_trail.png",
   hit_player = function(self, player)
      player:punch(self.object, 1.0, {
         full_punch_interval = 1.0,
         damage_groups = {fleshy = 15},
      }, nil)
       minetest.sound_play({name = "mobs_creatures_common_shoot_fireball_hit", gain = 1.0}, {pos=player:get_pos(), max_hear_distance = 12})
   end,

   hit_mob = function(self, player)
      player:punch(self.object, 1.0, {
         full_punch_interval = 1.0,
         damage_groups = {fleshy = 15},
      }, nil)
       minetest.sound_play({name = "mobs_creatures_common_shoot_fireball_hit", gain = 1.0}, {pos=pos, max_hear_distance = 12})
   end,

   hit_node = function(self, pos, node)
       minetest.sound_play({name = "mobs_creatures_common_shoot_fireball_hit", gain = 1.0}, {pos=pos, max_hear_distance = 12})
      self.object:remove()
   end,
})

-- REGISTER SPAWN PARAMETERS
mobs:spawn_specific("mobs_creatures:imp", {"nether:rack"}, {"air"}, 0, 16, 240, 1000, 6, -30912, -16000)

-- REGISTER SPAWN EGG
mobs:register_egg("mobs_creatures:imp", "Imp Spawn Egg", "default_dirt.png", 1)
