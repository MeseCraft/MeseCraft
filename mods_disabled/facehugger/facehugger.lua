-- By FreeGamers.org
-- Facehuggers inspired by Alien,Aliens.
-- Texture, model, and foundation from "mobs_scifi" by D00Med.
mobs:register_mob("mobs_creatures:facehugger", {
   type = "monster",
   passive = false,
   attacks_monsters = false,
   damage = 5,
   reach = 2,
   attack_type = "dogfight",
   hp_min = 5,
   hp_max = 5,
   armor = 100,
   collisionbox = {-0.3, -0.1, -0.3, 0.3, 0.1, 0.3},
   visual = "mesh",
   mesh = "mobs_creatures_facehugger.b3d",
   textures = {
      {"mobs_creatures_facehugger.png"},
   },
   sounds = {
            random ="mobs_creatures_facehugger_random",
            jump = "mobs_creatures_facehugger_jump",
            damage = "mobs_creatures_facehugger_damage",
            death = "mobs_creatures_facehugger_death",
   },
   blood_texture = "mobs_blood.png",
   visual_size = {x=1, y=1},
   makes_footstep_sound = true,
   walk_velocity = 1,
   run_velocity = 3,
   jump = true,
   stepheight = 1.5,
   water_damage = 0,
   lava_damage = 2,
   light_damage = 0,
   view_range = 7,
   animation = {
      speed_normal = 12,
      speed_run = 20,
      walk_start = 10,
      walk_end = 30,
      run_start = 10,
      run_end = 30,
      punch_start = 30,
      punch_end = 43,
   },
--    do_custom = function(self)
--                 local pos = self.object:getpos()
--                 local objs = minetest.get_objects_inside_radius(pos, 2)
--                 for _, obj in pairs(objs) do
--                         if obj:is_player() and obj:get_attach() == nil then
--                                         obj:set_attach(self.object, "", {x=.2, y=15, z=3}, {x=-100, y=225, z=90})
--                                         self.object:set_animation({x=46, y=46}, 20, 0)
--                                 end
--                         end
--    end,
--    on_die = function(
})
-- Register Spawn Egg
mobs:register_egg("mobs_creatures:facehugger", "Facehugger Spawn Egg", "default_obsidian.png", 1)

-- Register Spawn Parameters
--mobs:spawn_specific("mobs_creatures:facehugger", {"default:dirt_with_dry_grass"}, {"default:stone"}, 20, 0, 300, 15000, 2, 31000, 31001)

