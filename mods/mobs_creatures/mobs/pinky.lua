-- PINKY DEMON BY D00M3D
-- SOUNDS FROM FREEDOOM.

mobs:register_mob("mobs_creatures:pinky", {
   type = "monster",
   passive = false,
   damage = 15,
   reach = 2,
   attack_type = "dogfight",
   hp_min = 30,
   hp_max = 30,
   armor = 75,
   collisionbox = {-0.8, -0, -0.8, 0.8, 1.9, 0.8},
   visual = "mesh",
   mesh = "mobs_creatures_pinky.b3d",
   textures = {
      {"mobs_creatures_pinky.png"},
   },
   visual_size = {x=3, y=3},
   makes_footstep_sound = true,
   walk_velocity = 2,
   run_velocity = 3.75,
   knock_back = false,
   jump = true,
   sounds = {
                distance = "20",
                random = "mobs_creatures_pinky_random",
                war_cry = "mobs_creatures_pinky_warcry",
                attack = "mobs_creatures_pinky_attack",
                damage = "mobs_creatures_pinky_damage",
                death = "mobs_creatures_pinky_death",
   },
   drops = {
      {name = "mobs:meat_raw", chance = 2, min = 2, max = 3},
      {name = "mobs_creatures:bone", chance = 1, min = 1, max = 5},
   },
   water_damage = 0,
   lava_damage = 0,
   light_damage = 0,
   view_range = 16,
   animation = {
      speed_normal = 20,
      speed_run = 30,
      walk_start = 1,
      walk_end = 20,
      stand_start = 20,
      stand_end = 40,
      run_start = 1,
      run_end = 20,
      punch_start = 40,
      punch_end = 60,
   },
})
-- REGISTER SPAWN: PINKY
mobs:spawn_specific("mobs_creatures:pinky", {"nether:rack","nether:brick"}, {"air"}, 0, 16, 240, 4000, 2, -30912, -16000)

-- REGISTER SPAWN EGG: PINKY
mobs:register_egg("mobs_creatures:pinky", "Pinky Spawn Egg", "wool_pink.png", 1)

