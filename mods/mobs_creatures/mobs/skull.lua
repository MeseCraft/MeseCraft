-- LOST SOUL BY DOOM3D
-- SOUNDS FROM FREEDOOM

mobs:register_mob("mobs_creatures:skull", {
   type = "monster",
   passive = false,
   damage = 10,
   reach = 2,
   attack_type = "dogfight",
   hp_min = 20,
   hp_max = 20,
   armor = 100,
   collisionbox = {-0.2, -0.05, -0.2, 0.2, 0.75, 0.2},
   visual = "mesh",
   mesh = "mobs_creatures_skull.b3d",
   textures = {
      {"mobs_creatures_skull.png"},
   },
   visual_size = {x=1.5, y=1.5},
   makes_footstep_sound = true,
   sounds = {
                distance = "20",
                random = "mobs_creatures_skull_random",
                war_cry = "mobs_creatures_skull_warcry",
                attack = "mobs_creatures_skull_attack",
                damage = "mobs_creature_pinky_damage",
                death = "mobs_creatures_skull_death",
   },
   walk_velocity = 2,
   run_velocity = 4,
   jump = true,
   fly = true,
   do_custom = function(self)
		local apos = self.object:getpos()
                part = minetest.add_particlespawner({
                        8, --amount
                        0.3, --time
                        {x=apos.x-0.3, y=apos.y+0.6, z=apos.z-0.3}, --minpos
                        {x=apos.x+0.3, y=apos.y+0.6, z=apos.z+0.3}, --maxpos
                        {x=-0, y=-0, z=-0}, --minvel
                        {x=0, y=0, z=0}, --maxvel
                        {x=0,y=1.5,z=0}, --minacc
                        {x=0.5,y=1.5,z=0.5}, --maxacc
                        1, --minexptime
                        1, --maxexptime
                       2, --minsize
                        3, --maxsize
                        false, --collisiondetection
                        "mobs_creatures_arrow_fireball_trail.png" --texture
                })
   end,
   fall_speed = 0,
   stepheight = 10,
   water_damage = 0,
   lava_damage = 0,
   light_damage = 0,
   view_range = 16,
   glow = 6,
   animation = {
      speed_normal = 10,
      speed_run = 20,
      walk_start = 20,
      walk_end = 40,
      stand_start = 1,
      stand_end = 20,
      run_start = 20,
      run_end = 40,
      punch_start = 40,
      punch_end = 65,
   },
})

-- REGISTER SPAWN PARAMETERS
mobs:spawn_specific("mobs_creatures:skull", {"nether:sand", "nether:glowstone", "default:lava_source"}, {"air"}, 0, 16, 480, 4000, 5, -30912, -16000)

-- REGISTER SPAWN EGG
mobs:register_egg("mobs_creatures:skull", "Skull Spawn Egg", "wool_orange.png", 1)

