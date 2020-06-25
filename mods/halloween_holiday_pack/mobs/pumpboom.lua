-- code based off of pumpboom in nssm. pumpkin texture from farming_redo or crops.

-- REGISTER MOB & ATTRIBUTES
-- todo: add costume drops
mobs:register_mob("halloween_holiday_pack:pumpboom", {
    type = "monster",
    hp_min = 10,
    hp_max = 10,
    collisionbox = {-0.45, -0.5, -0.45, 0.45, 0.45, 0.45},
    visual = "cube",
    textures = {{"farming_pumpkin_top.png",
                "farming_pumpkin_top.png",
                "farming_pumpkin_side.png",
                "farming_pumpkin_side.png",
                "farming_pumpkin_face_on.png",
                "farming_pumpkin_side.png"}},
    visual_size = {x=1, y=1},
    explosion_radius = 3,
    makes_footstep_sound = false,
    view_range = 12,
    fear_height = 4,
    walk_velocity = 1.5,
    run_velocity = 2.5,
    sounds = {
                random = "mobs_creatures_dirt_golem_random",
                attack = "tnt_ignite",
                death = "mobs_creatures_boomer_death",
                damage = "mobs_creatures_boomer_damage",
                fuse = "tnt_ignite",
                explode = "tnt_explode",
                distance = 16,
    },
    damage = 1.5,
    jump = true,
    drops = {
		{name = "farming:pumpkin_slice", chance = 1, min = 1, max = 2},
		{name = "candles:candle", chance = 1, min = 1, max = 1},
		{name = "halloween_holiday_pack:candycorn", chance = 4, min = 1, max = 2},
		{name = "halloween_holiday_pack:caramel_apple", chance = 4, min = 1, max = 2},
		{name = "halloween_holiday_pack:halloween_chocolate", chance = 4, min = 1, max = 2},
		{name = "halloween_holiday_pack:lolipop", chance = 4, min = 1, max = 2},
                {name = "tnt:gunpowder", chance = 25, min = 0, max = 2,},
                {name = "halloween_holiday_pack:mask_pumpkin", chance = 100, min = 1, max = 1},
                {name = "halloween_holiday_pack:shirt_halloween_hoodie", chance = 100, min = 1, max = 1},
                {name = "halloween_holiday_pack:suit_pumpkin", chance = 100, min = 1, max = 1},
	},
    armor = 200,
    drawtype = "front",
    water_damage = 2,
    lava_damage = 5,
    light_damage = 0,
    suffocation = false,
    group_attack=true,
    knock_back= 4,
    blood_amount = 8,
    blood_texture="farming_pumpkin_slice.png",
    stepheight=1.1,
    on_rightclick = nil,
    attack_type = "explode",
	    -- Only spawn around Halloween date/time (Oct 20th - Nov 3rd, 2 weeks).
	    do_custom = function(self)
		        local date = os.date("*t")
		        if not (date.month == 10 and date.day >= 20) or (date.month == 11 and date.day <= 3) then
		                       self.object:remove()
		        end
	    end,
})

-- Register spawn egg
mobs:register_egg("halloween_holiday_pack:pumpboom","Pumpboom Spawn Egg", "farming_pumpkin_side.png", 1)

-- World spawning parameters for the pumpboom.
mobs:spawn_specific("halloween_holiday_pack:pumpboom", {"group:cracky", "group:crumbly", "group:shovely", "group:pickaxey"}, {"air"}, 0, 5, 60, 4000, 8, -30912, 30192, false)