--SKELETON ARCHER
-- TODO: Add arrows dropping. Make sure shoot switch works OK.
--REGISTER ARROW SHOT
mobs:register_arrow("mesecraft_mobs:skeleton_archer_arrow", {
   visual = "sprite",
   visual_size = {x = 0.75, y = 0.75},
--   collisionbox = {-1/8,-1/8,-1/8, 1/8,1/8,1/8},
   textures = {"mesecraft_mobs_arrow_arrow.png"},
   velocity = 10,
   tail = 1, -- enable tail
   expire = 0.25,
   glow = 5,
   tail_texture = "mesecraft_mobs_arrow_arrow_trail.png",
   tail_size = 3,
   hit_player = function(self, player)
      player:punch(self.object, 1.0, {
         full_punch_interval = 1.0,
         damage_groups = {fleshy = 10},
      }, nil)
       minetest.sound_play({name = "mesecraft_mobs_common_shoot_arrow_hit", gain = 1.0}, {pos=player:get_pos(), max_hear_distance = 12})
   end,

   hit_mob = function(self, player)
      player:punch(self.object, 1.0, {
         full_punch_interval = 1.0,
         damage_groups = {fleshy = 10},
      }, nil)
   end,
   hit_node = function(self, pos, node)
      minetest.sound_play({name = "mesecraft_mobs_common_shoot_arrow_hit", gain = 1.0}, {pos=pos, max_hear_distance = 12})
--      minetest.add_entity(pos, "bweapons_bows_pack:arrow") 	--Needs to not be added at pos, but rather right before.
      self.object:remove()
   end,
})
-- REGISTER SKELETON ARCHER
mobs:register_mob("mesecraft_mobs:skeleton_archer", {
	type = "monster",
	hp_min = 20,
	hp_max = 20,
	collisionbox = {-0.3, -0.01, -0.3, 0.3, 1.98, 0.3},
	group_attack = true,
	visual = "mesh",
	mesh = "mesecraft_mobs_skeleton.b3d",
	textures = {
		{"mesecraft_mobs_skeleton.png^mesecraft_mobs_skeleton_bow.png"},
	},
	visual_size = {x=3, y=3},
	makes_footstep_sound = true,
	sounds = {
		random = "mesecraft_mobs_skeleton_random",
		death = "mesecraft_mobs_skeleton_death",
		damage = "mesecraft_mobs_skeleton_damage",
		shoot_attack = "mesecraft_mobs_common_shoot_arrow",
		attack = "mesecraft_mobs_skeleton_attack",
		jump = "mesecraft_mobs_skeleton_jump",
		distance = 16,
	},
	walk_chance = 25,
	walk_velocity = 1.2,
	run_velocity = 2.4,
	damage = 5,
	reach = 1,
	drops = {
		{name = "bweapons_bows_pack:arrow", chance = 1, min = 0, max = 5,},
		{name = "mesecraft_mobs:bone", chance = 1, min = 0, max = 5,},
		{name = "bweapons_bows_pack:wooden_bow", chance = 12, min = 1, max = 1,},
	},
	animation = {
		stand_start = 0,
		stand_end = 40,
		stand_speed = 5,
		walk_start = 40,
		walk_end = 60,
	        walk_speed = 15,
		run_start = 40,
		run_end = 60,
		run_speed = 30,
	        shoot_start = 70,
	        shoot_end = 90,
	        punch_start = 70,
	        punch_end = 90,
	        die_start = 120,
	        die_end = 130,
		die_loop = false,
	},
	water_damage = 1,
	lava_damage = 4,
	light_damage = 4,
	view_range = 12,
	fear_height = 4,
	attack_type = "dogshoot",
	arrow = "mesecraft_mobs:skeleton_archer_arrow",
	shoot_interval = 2.5,
	shoot_offset = 1,
	dogshoot_swith = 1,
	dogshoot_count_max = 1.8,
	shoot_offset = 1,
	blood_amount = 0,
})

-- Overworld spawn
mobs:spawn_specific("mesecraft_mobs:skeleton_archer", {"group:cracky", "group:crumbly", "group:shovely", "group:pickaxey"}, {"air"}, 0, 16, 240, 8000, 1, -16000, 100)

-- spawn eggs
mobs:register_egg("mesecraft_mobs:skeleton_archer", "Skeleton Archer Spawn Egg", "wool_white.png", 1)
