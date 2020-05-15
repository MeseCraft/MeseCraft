-- CACODEMON BY DOOM3D
-- EDITED BY FREEGAMERS.ORG

-- REGISTER CACODEMON
mobs:register_mob("mobs_creatures:cacodemon", {
   type = "monster",
   passive = false,
   attacks_monsters = true,
   damage = 10,
   reach = 3,
   attack_type = "shoot",
   shoot_interval = 2,
   arrow = "mobs_creatures:a_cacodemon_plasma_ball",
   shoot_offset = 1,
   hp_min = 50,
   hp_max = 50,
   armor = 100,
   collisionbox = {-0.9, -0.2, -0.9, 0.9, 1.5, 0.9},
   visual = "mesh",
   mesh = "mobs_creatures_cacodemon.b3d",
   textures = {
      {"mobs_creatures_cacodemon.png"},
   },
   visual_size = {x=2, y=2},
   makes_footstep_sound = false,
   walk_velocity = 3,
   run_velocity = 5,
        sounds = {
                distance = "20",
                random = "mobs_creatures_cacodemon_random",
                war_cry = "mobs_creatures_cacodemon_warcry",
                shoot_attack = "mobs_creatures_common_shoot_plasmaball",
                damage = "mobs_creatures_pinky_damage",
                death = "mobs_creatures_cacodemon_death",
        },
   jump = true,
   fly = true,
   fall_speed = 0,
   stepheight = 10,
   water_damage = 2,
   lava_damage = 0,
   light_damage = 0,
   view_range = 20,
   animation = {
      speed_normal = 10,
      speed_run = 20,
      walk_start = 1,
      walk_end = 20,
      stand_start = 1,
      stand_end = 20,
      run_start = 1,
      run_end = 20,
      shoot_start = 20,
      shoot_end = 40,
   },
})
-- REGISTER ARROW: CACODEMON PLASMA BALL
mobs:register_arrow("mobs_creatures:a_cacodemon_plasma_ball", {
   visual = "sprite",
   visual_size = {x = 1, y = 1},
   textures = {"mobs_creatures_arrow_plasmaball.png"},
   velocity = 12,
   glow = 5,
   tail = 1, -- enable tail
   tail_texture = "mobs_creatures_arrow_plasmaball_trail.png",

   hit_player = function(self, player)
      player:punch(self.object, 1.0, {
         full_punch_interval = 1.0,
         damage_groups = {fleshy = 25},
      }, nil)
       minetest.sound_play({name = "mobs_creatures_common_shoot_plasmaball_hit", gain = 1.0}, {pos=player:getpos(), max_hear_distance = 12})
   end,

   hit_mob = function(self, player)
      player:punch(self.object, 1.0, {
         full_punch_interval = 1.0,
         damage_groups = {fleshy = 25},
      }, nil)
   end,

   hit_node = function(self, pos, node)
       minetest.sound_play({name = "mobs_creatures_common_shoot_plasmaball_hit", gain = 1.0}, {pos=pos, max_hear_distance = 12})
      self.object:remove()
   end,
})

--mobs:register_spawn(name, nodes, max_light, min_light, chance, active_object_count, max_height, day_toggle)
mobs:spawn_specific("mobs_creatures:cacodemon", {"nether:sand","nether:glowstone","default:lava_source", "default:lava_flowing"}, {"air"}, 0, 16, 60, 10000, 6, -30912, -16000)

mobs:register_egg("mobs_creatures:cacodemon", "Cacodemon", "wool_red.png", 1)
