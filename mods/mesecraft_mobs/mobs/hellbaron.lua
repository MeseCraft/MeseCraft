-- HELLBARON BY D00MED
mobs:register_mob("mesecraft_mobs:hellbaron", {
   type = "monster",
   passive = false,
   attacks_monsters = true,
   damage = 15,
   reach = 2,
   attack_type = "dogshoot",
   shoot_interval = 2.5,
        dogshoot_switch = 2,
        dogshoot_count = 0,
        dogshoot_count_max =5,
   arrow = "mesecraft_mobs:a_hellbaron_plasmaball",
   hp_min = 100,
   hp_max = 100,
   armor = 85,
   visual = "mesh",
   mesh = "mobs_character.b3d",
   collisionbox = {-0.5,-1.5,-0.5, 0.5,1.2,0.5},
   visual_size = {x=1.5, y=1.5},
   textures = {
      {"mesecraft_mobs_hellbaron.png"},
   },
   knock_back = false,
   makes_footstep_sound = true,
   walk_velocity = 2,
   run_velocity = 3,
   jump = true,
   sounds = {
                distance = "16",
                random = "mesecraft_mobs_hellbaron_random",
                war_cry = "mesecraft_mobs_hellbaron_warcry",
                attack = "mesecraft_mobs_common_attack_claw",
                shoot_attack = "mesecraft_mobs_common_shoot_plasmaball",
	        damage = "mesecraft_mobs_pinky_damage",
                death = "mesecraft_mobs_hellbaron_death",
   },
   drops = {
      {name = "mesecraft_mobs:bone", chance = 1, min = 1, max = 5},
   },
   water_damage = 0,
   lava_damage = 0,
   light_damage = 0,
   view_range = 12,
   animation = {
	        speed_normal = 30,
	        speed_run = 45,
	        stand_start = 0,
	        stand_end = 79,
	        walk_start = 168,
	        walk_end = 187,
	        run_start = 168,
	        run_end = 187,
	        punch_start = 200,
	        punch_end = 219,
    },
})
--HELLBARON PROJECTILE
mobs:register_arrow("mesecraft_mobs:a_hellbaron_plasmaball", {
   visual = "sprite",
   visual_size = {x = 1, y = 1},
   textures = {"mesecraft_mobs_arrow_plasmaball.png"},
   velocity = 14,
   glow = 5,
   tail = 1, -- enable tail
   tail_texture = "mesecraft_mobs_arrow_plasmaball_trail.png",

   hit_player = function(self, player)
      player:punch(self.object, 1.0, {
         full_punch_interval = 1.0,
         damage_groups = {fleshy = 15},
      }, nil)
       minetest.sound_play({name = "mesecraft_mobs_common_shoot_plasmaball_hit", gain = 1.0}, {pos=player:get_pos(), max_hear_distance = 12})
   end,
   
   hit_mob = function(self, player)
      player:punch(self.object, 1.0, {
         full_punch_interval = 1.0,
         damage_groups = {fleshy = 15},
      }, nil)
   end,
   hit_node = function(self, pos, node)
       minetest.sound_play({name = "mesecraft_mobs_common_shoot_plasmaball_hit", gain = 1.0}, {pos=pos, max_hear_distance = 12})
      self.object:remove()
   end,
})
-- REGISTER SPAWN PARAMETERS
mobs:spawn_specific("mesecraft_mobs:hellbaron", {"nether:sand", "default:lava_source", "nether:glowstone"},{"air"}, 0, 20, 480, 2000, -31920, -16000)

-- REGISTER SPAWN EGG
mobs:register_egg("mesecraft_mobs:hellbaron", "Hellbaron Spawn Egg", "default_dirt.png", 1)
