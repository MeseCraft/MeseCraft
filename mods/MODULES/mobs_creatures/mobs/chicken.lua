--License for code WTFPL and otherwise stated in readmes
mobs:register_mob("mobs_creatures:chicken", {
        type = "animal",
        hp_min = 4,
        hp_max = 4,
        collisionbox = {-0.2, -0.01, -0.2, 0.2, 0.69, 0.2},
        runaway = true,
        jump = false,
        floats = 1,
        visual = "mesh",
        mesh = "mobs_creatures_chicken.b3d",
        textures = {
                {"mobs_creatures_chicken.png"},
        },
        visual_size = {x=2.2, y=2.2},

        makes_footstep_sound = true,
        walk_velocity = 1,
        drops = {
                {name = "mobs_creatures:chicken_raw", chance = 2, min = 1, max = 1},
                {name = "mobs_creatures:chicken_feather", chance = 2, min = 0, max = 1},
        },

        water_damage = 1,
        lava_damage = 4,
        light_damage = 0,
        fall_damage = 0,
        fall_speed = -2.25,
        sounds = {
                random = "mobs_creatures_chicken_random",
                death = "mobs_creatures_chicken_damage",
                damage = "mobs_creatures_chicken_damage",
                distance = 16,
        },
        animation = {
                stand_speed = 25, walk_speed = 25, run_speed = 50,
                stand_start = 0,                stand_end = 0,
                walk_start = 0,         walk_end = 40,
                run_start = 0,          run_end = 40,
        },

        follow = {"farming:seed_wheat", "farming:seed_cotton"},
        view_range = 16,
        fear_height = 2,

        on_rightclick = function(self, clicker)
                if mobs:feed_tame(self, clicker, 1, true, true) then return end
                if mobs:protect(self, clicker) then return end
                if mobs:capture_mob(self, clicker, 0, 60, 5, false, nil) then return end
        end,

        do_custom = function(self, dtime)

                self.egg_timer = (self.egg_timer or 0) + dtime
                if self.egg_timer < 10 then
                        return
                end
                self.egg_timer = 0

                if self.child
                or math.random(1, 100) > 1 then
                        return
                end

                local pos = self.object:get_pos()

                minetest.add_item(pos, "mobs_creatures:egg")

                minetest.sound_play("mobs_creatures_chicken_eggpop", {
                        pos = pos,
                        gain = 1.0,
                        max_hear_distance = 16,
                })
        end,

})

--spawn
mobs:spawn_specific("mobs_creatures:chicken", {"default:dirt_with_grass","ethereal:prairie_dirt"}, {"air"}, 9, 15, 120, 2500, 3, 2, 30, true)

-- spawn eggs
mobs:register_egg("mobs_creatures:chicken", "Chicken Spawn Egg", "wool_red.png", 1)
