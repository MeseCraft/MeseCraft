-- MOOSHROOM
mobs:register_mob("mobs_creatures:mooshroom", {
        type = "animal",
        hp_min = 10,
        hp_max = 10,
        collisionbox = {-0.45, -0.01, -0.45, 0.45, 1.39, 0.45},
        visual = "mesh",
        mesh = "mobs_creatures_cow.b3d",
        textures = { {"mobs_creatures_mooshroom.png", "mobs_creatures_mooshroom_red_mushroom.png"}, },
        visual_size = {x=2.8, y=2.8},
        makes_footstep_sound = true,
        walk_velocity = 1,
        drops = {
                {name = "mobs:meat_raw", chance = 1, min = 1, max = 3,},
                {name = "mobs:leather",chance = 1,min = 0,max = 2,},
        },
        water_damage = 1,
        lava_damage = 5,
        light_damage = 0,
        runaway = true,
        sounds = {
                random = "mobs_creatures_cow_random",
                death = "mobs_creatures_cow_damage",
                damage = "mobs_creatures_cow_damage",
                jump = "mobs_creatures_cow_jump",
                distance = 16,
        },
        animation = {
                stand_speed = 25, walk_speed = 25, run_speed = 50,
                stand_start = 0,                stand_end = 0,
                walk_start = 0,         walk_end = 40,
                run_start = 0,          run_end = 40,
        },
        follow = "farming:wheat",
        replace_rate = 10,
        replace_what = {
                {"group:grass", "air", 0},
                {"default:dirt_with_grass", "default:dirt", -1}
        },
        on_rightclick = function(self, clicker)
                if mobs:feed_tame(self, clicker, 1, true, true) then return end
                if mobs:protect(self, clicker) then return end

                if self.child then
                        return
                end
                local item = clicker:get_wielded_item()
                -- Use shears to get mushrooms and turn mooshroom into cow
                if item:get_name() == "mobs:shears" then
                        local pos = self.object:get_pos()
                        minetest.sound_play("shears", {pos = pos})
                        minetest.add_item({x=pos.x, y=pos.y+1.4, z=pos.z}, "flowers:mushroom_red" .. " 5")

                        local oldyaw = self.object:getyaw()
                        self.object:remove()
                        local cow = minetest.add_entity(pos, "mobs_creatures:cow")
                        cow:setyaw(oldyaw)
                -- Use bucket to milk
                elseif item:get_name() == "mesecraft_bucket:bucket_empty" and clicker:get_inventory() then
                        local inv = clicker:get_inventory()
                        inv:remove_item("main", "mesecraft_bucket:bucket_empty")
                        -- If room, add milk to inventory, otherwise drop as item
                        if inv:room_for_item("main", {name= "mobs_creatures:milk_bucket"}) then
                                clicker:get_inventory():add_item("main", "mobs_creatures:milk_bucket")
                                local pos = self.object:get_pos()
                                minetest.sound_play("mobs_creatures_cow_milk", {
                                pos = pos,
                                gain = 1.0,
                                max_hear_distance = 8,
                                })

                        else
                                local pos = self.object:get_pos()
                                pos.y = pos.y + 0.5
                                minetest.add_item(pos, {name = "mobs_creatures:milk_bucket"})
                                minetest.sound_play("mobs_creatures_cow_milk", {
                                pos = pos,
                                gain = 1.0,
                                max_hear_distance = 8,
                                })

                        end
                -- Use bowl to get mushroom stew
                elseif item:get_name() == "ethereal:bowl" and clicker:get_inventory() then
                        local inv = clicker:get_inventory()
                        inv:remove_item("main", "ethereal:bowl")
                        -- If room, add mushroom stew to inventory, otherwise drop as item
                        if inv:room_for_item("main", {name="ethereal:hearty_stew"}) then
                                clicker:get_inventory():add_item("main", "ethereal:hearty_stew")
                        else
                                local pos = self.object:get_pos()
                                pos.y = pos.y + 0.5
                                minetest.add_item(pos, {name = "ethereal:hearty_stew"})
                        end
                end
                mobs:capture_mob(self, clicker, 0, 5, 60, false, nil)
        end,
})


-- Register Spawn Mooshroom
if minetest.get_modpath("ethereal") then
	mobs:spawn_specific("mobs_creatures:mooshroom", "ethereal:mushroom_dirt", {"air"}, 9, 15, 120, 8000, 5, 0, 200)
end

-- Register Mooshroom Spawn Egg
mobs:register_egg("mobs_creatures:mooshroom", "Mooshroom Spawn Egg", "wool_red.png", 1)
