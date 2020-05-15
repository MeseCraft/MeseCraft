--CYBERDEMON
mobs:register_mob("mobs_creatures:cyberdemon", {
        type = "monster",
        passive = false,
        reach = 6,
        damage = 2,
        attack_type = "shoot",
	shoot_interval = 2,
	arrow = "mobs_creatures:a_cyberdemon_rocket",
	shoot_offset = 1,
        hp_min = 666,
        hp_max = 666,
        armor = 100,
	visual = "mesh",
	mesh = "mobs_character.b3d",
	collisionbox = {-1.0,-3.0,-1.0, 1.0,2.4,1.0},
	visual_size = {x=3.0, y=3.0},
        textures = {
                {"mobs_creatures_cyberdemon.png"},
        },
	knock_back = false,
        makes_footstep_sound = true,
        walk_velocity = 1,
        run_velocity = 2.1,
        sounds = {
                distance = "32",
                random = "mobs_creatures_cyberdemon_random",
                war_cry = "mobs_creatures_cyberdemon_warcry",
                shoot_attack = "mobs_creatures_cyberdemon_shoot",
                death = "mobs_creatures_cyberdemon_death",
        },
        jump = true,
        drops = {
                {name = "bweapons_hitech_pack:missile_launcher", chance = 100, min = 1, max = 1}, -- Uses bweapons_modpack for drops
                {name = "bweapons_hitech_pack:missile", chance = 1, min = 1, max = 24},
        },
        water_damage = 0,
        lava_damage = 0,
        light_damage = 0,
        view_range = 32,
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
                shoot_start = 200,
                shoot_end = 219,
        },
   on_die = function(self,pos)
                          mobs:explosion(pos, 3, 5, 3)
            end,
})
-- CYBERDEMON, EXPLOSIVE VERSION PROJECTILE
mobs:register_arrow("mobs_creatures:a_cyberdemon_rocket", {
   visual = "sprite",
   visual_size = {x = 1.0, y = 1.0},
   textures = {"mobs_creatures_arrow_rocket.png"},
   velocity = 15,
   tail = 1, -- enable tail
   glow = 5,
   tail_texture = "mobs_creatures_arrow_rocket_trail.png",

   hit_player = function(self, player)
      player:punch(self.object, 1.0, {
         full_punch_interval = 1.0,
         damage_groups = {fleshy = 20},
      }, nil)
   end,
   
   hit_mob = function(self, player)
      player:punch(self.object, 1.0, {
         full_punch_interval = 1.0,
         damage_groups = {fleshy = 20},
      }, nil)
   end,

   hit_node = function(self, pos, node)
        if minetest.get_node(pos).name ~= "default:cobble" then
              mobs:explosion(pos, 2, 2, 2)
        end
   end,
})

-- REGISTER SPAWN PARAMETERS
mobs:spawn_specific("mobs_creatures:cyberdemon", {"nether:sand","default:lava_source","nether:glowstone"},{"air"}, 0, 16, 600, 10000, 1, -30912, -16000)

-- REGISTER SPAWN EGG
mobs:register_egg("mobs_creatures:cyberdemon", "Cyberdemon Spawn Egg", "wool_red.png", 1)
