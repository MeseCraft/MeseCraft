-- REPTILIAN ELITE ALIEN BY FREEGAMERS.ORG
-- TODO, ACID SPIT ATTACK texture, Blood Texture, drops, credits, spit sounds and hit sounds
mobs:register_mob('mobs_creatures:reptilian_elite', {
	type = "monster",
	passive = false,
	attack_type = "dogshoot",
	shoot_interval = 2.5,
	dogshoot_switch = 2,
	dogshoot_count = 0,
	dogshoot_count_max =5,
	arrow = "mobs_creatures:reptilian_acid_spit",
	shoot_offset = 1.5,
	reach = 3,
	damage = 15,
	hp_min = 30,
	hp_max = 30,
	armor = 50,
	knock_back = false,
        collisionbox = {-0.5,-1.5,-0.5, 0.5,1.2,0.5},
        visual = "mesh",
        mesh = "mobs_character.b3d",
	visual_size = {x=1.5, y=1.5},
        textures = {
                {"mobs_creatures_reptilian_elite.png"},
        },
	blood_texture = "mobs_blood.png",
	makes_footstep_sound = true,
	sounds = {
		random ="mobs_creatures_reptilian_elite_random",
		attack = "mobs_creatures_bogeyman_attack",
		damage = "mobs_creatures_crocodile_damage",
		death = "mobs_creatures_crocodile_death",
		distance = 32,
	},
	walk_velocity = 2.0,
	run_velocity = 3.5,
	jump = true,
	floats = true,
	suffocation = false,
	view_range = 16,
	drops = {
	{name = "mobs:meat_raw", chance = 1, min = 1, max = 1},
	},
	lava_damage = 3,
	water_damage = 0,
	light_damage = 0,
	fall_damage = 2,
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
-- Spawn Parameters, Anywhere on the moon.
mobs:spawn_specific("mobs_creatures:reptilian_elite",{"default:gravel"},{"vacuum:vacuum"},0,7,960,4000,2,3000,3300,false)

--Spawn Eggs
mobs:register_egg("mobs_creatures:reptilian_elite", "Reptilian Elite Spawn Egg", "mobs_meat_raw.png", 1)

--REPTILIAN ACID SPIT PROJECTILE
mobs:register_arrow("mobs_creatures:reptilian_acid_spit", {
   visual = "sprite",
   visual_size = {x = 0.5, y = 0.5},
   textures = {"mobs_creatures_arrow_poisonball.png"},
   velocity = 7,
   glow = 5,
   tail = 1, -- enable tail
   tail_texture = "mobs_creatures_poisonball_trail.png",
   hit_player = function(self, player)
      player:punch(self.object, 1.0, {
         full_punch_interval = 1.0,
         damage_groups = {fleshy = 8},
      }, nil)
   end,

   hit_mob = function(self, player)
      player:punch(self.object, 1.0, {
         full_punch_interval = 1.0,
         damage_groups = {fleshy = 8},
      }, nil)
   end,

   hit_node = function(self, pos, node)
      self.object:remove()
   end,
})

-------- CREDITS & ATTRIBUTIONS --------
-- Concept and implementation by FreeGamers.org
-- Texture by OpportunisticMilk
-- Sounds by JarAxe - https://freesound.org/people/JarAxe/packs/13148/
