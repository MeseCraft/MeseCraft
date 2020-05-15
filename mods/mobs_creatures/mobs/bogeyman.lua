-- BOGEYMAN by freegamers.org
-- Insult clips edited from "Iceofdoom" https://freesound.org/people/Iceofdoom/sounds/396900/
-- Laughs from "cacti225" https://freesound.org/people/cacti225/sounds/405613/
-- Snarl sounds from "Desyncho" https://freesound.org/people/Darsycho/sounds/443404/
mobs:register_mob("mobs_creatures:bogeyman", {
   type = "monster",
   passive = false,
   damage = 9,
   reach = 2,
   attack_type = "dogfight",
   hp_min = 10,
   hp_max = 20,
   armor = 75,
   knock_back = false,
   collisionbox = {-0.25,-0.5,-0.25, 0.25,0.4,0.25},
   visual = "mesh",
   mesh = "mobs_character.b3d",
   textures = {
      {"mobs_creatures_bogeyman.png"},
   },
   blood_amount = 4,
   blood_texture = "mobs_creatures_common_shadow.png",
   visual_size = {x=0.5, y=0.5},
   makes_footstep_sound = false,
   walk_velocity = 2,
   run_velocity = 3.25,
   floats = 1,
   jump = true,
   sounds = {
                distance = "16",
		war_cry = "mobs_creatures_bogeyman_warcry",
                random = "mobs_creatures_bogeyman_random",
                attack = "mobs_creatures_bogeyman_attack",
                damage = "mobs_creatures_bogeyman_damage",
                death = "mobs_creatures_bogeyman_death",
   },
   water_damage = 0,
   lava_damage = 0,
   light_damage = 20,
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
--          punch_start = 200,
--          punch_end = 219,
        },
--particle spawner
   do_custom = function(self)
   		local apos = self.object:getpos()
		minetest.add_particlespawner({
                        1, --amount
                        0.3, --time
                        {x=apos.x-0.3, y=apos.y+0.0, z=apos.z-0.3}, --minpos
                        {x=apos.x+0.3, y=apos.y+0.0, z=apos.z+0.3}, --maxpos
                        {x=-0, y=-0, z=-0}, --minvel
                        {x=0, y=0, z=0}, --maxvel
                        {x=0,y=1,z=0}, --minacc
                        {x=0.5,y=1.2,z=0.5}, --maxacc
                        3, --minexptime
                        5, --maxexptime
                        2, --minsize
                        3, --maxsize
                        true, --collisiondetection
                        "mobs_creatures_common_shadow.png" --texture
                	})
	end,
})

--Spawn Functions
--API Template: mobs:spawn_specfic(name, nodes, neighbors, min_light, max_light, interval, chance, active_object_count, min_height, max_height, day_toggle, on_spawn)
mobs:spawn_specific("mobs_creatures:bogeyman", {"group:cracky", "group:crumbly", "group:shovely", "group:pickaxey"}, {"air"}, 0, 1, 480, 25000, 2, 0, 100, false)
mobs:register_egg("mobs_creatures:bogeyman", "Bogeyman Spawn Egg", "wool_black.png", 1)
