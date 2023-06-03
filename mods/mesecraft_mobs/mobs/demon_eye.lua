-- DEMON EYE by FreeGamers.org
-- model by mobs_mc.
-- sounds from freedoom.
-- inspired by terraria.

mobs:register_mob("mesecraft_mobs:demon_eye", {
   type = "monster",
   passive = false,
   damage = 4,
   reach = 2,
   attack_type = "dogfight",
   hp_min = 10,
   hp_max = 10,
   armor = 125,
   knock_back = true,
   collisionbox = {-0.25, 0.25, -0.25, 0.25, 1.25, 0.25},
   visual = "mesh",
   mesh = "mesecraft_mobs_demon_eye.b3d",
   textures = {
      {"mesecraft_mobs_demon_eye.png"},
   },
   visual_size = {x=1.5, y=1.5},
   makes_footstep_sound = false,
   walk_velocity = 1,
   run_velocity = 2,
   jump = true,
   fly = true,
   floats = true,
   fall_speed = 0,
   stepheight = 1,
   water_damage = 5,
   lava_damage = 10,
   light_damage = 10,
   view_range = 16,
   sounds = {
        death = "mesecraft_mobs_demon_eye_death",
        damage = "mesecraft_mobs_demon_eye_damage",
        attack = "mesecraft_mobs_demon_eye_attack",
        },
   animation = {
	stand_speed = 50, walk_speed = 50, run_speed = 50,
	stand_start = 0,		stand_end = 40,
	walk_start = 0,		walk_end = 40,
	run_start = 0,		run_end = 40,
   },
   do_custom = function(self) -- Add downward particles of blood.
                local apos = self.object:get_pos()
                minetest.add_particlespawner({
                       amount = 1.0, --amount
                       time = 1.0, --time
                       minpos =  {x=apos.x-0.3, y=apos.y-0, z=apos.z-0.3}, --minpos
                       maxpos = {x=apos.x+0.3, y=apos.y+1, z=apos.z+0.3}, --maxpos
                       minvel =  {x=-0, y=-0, z=-0}, --minvel
                       maxvel = {x=0, y=0, z=0}, --maxvel
                       minacc =  {x=0,y=-1,z=0}, --minacc
                       maxacc =  {x=0.5,y=-1.2,z=0.5}, --maxacc
                       minexptime = 1.0, --minexptime
                       maxexptime = 2.0, --maxexptime
                       minsize = 1.0, --minsize
                       maxsize = 1.0, --maxsize
                       collisiondetection = true, --collisiondetection
                       texture = "mobs_blood.png" --texture
                })
	end,
})
-- REGISTER SPAWN PARAMETERS
mobs:spawn_specific("mesecraft_mobs:demon_eye", {"group:leaves"}, {"air"}, 0, 6, 60, 2000, 4, 5, 175, false)

-- REGISTER SPAWN EGG
mobs:register_egg("mesecraft_mobs:demon_eye", "Demon Eye Spawn Egg", "wool_red.png", 1)
