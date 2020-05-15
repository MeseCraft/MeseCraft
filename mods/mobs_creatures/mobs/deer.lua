-- Register the Deer into the API.
mobs:register_mob("mobs_creatures:deer", {
        type = "animal",
        hp_min = 4,
        hp_max = 8,
        collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
        textures = {
                {"mobs_creatures_deer.png"},
        },
        visual = "mesh",
        mesh = "mobs_creatures_deer.x",
        makes_footstep_sound = true,
        walk_velocity = 1,
        armor = 200,
        drops = {
                {name = "mobs:meat_raw",
                chance = 1,
                min = 2,
                max = 3,},
        },
        drawtype = "front",
        water_damage = 1,
        lava_damage = 5,
        light_damage = 0,
        animation = {
                speed_normal = 15,
                stand_start = 25,               stand_end = 75,
                walk_start = 75,                walk_end = 100,
        },
        follow = "farming:wheat",
        view_range = 5,
})
-- Register the Spawning Parameters
mobs:spawn_specific("mobs_creatures:deer", {"default:dirt_with_coniferous_litter"}, {"default:fern_2"}, 6, 16, 60, 480, 2, 2, 150)

-- Register the Spawn Egg
mobs:register_egg("mobs_creatures:deer", "Deer Spawn Egg", "wool_brown.png", 1)

