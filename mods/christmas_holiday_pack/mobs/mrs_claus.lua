mobs:register_mob("christmas_holiday_pack:mrs_claus", {
		type = "npc",
		passive = false,
		damage = 5,
		reach = 2,
		attack_type = "dogfight",
		pathfinding = false,
                attacks_monsters = true,
                attack_animals = false,
                attack_npcs = false,
		nametag = "Mrs Claus", 
		hp_min = 25,
		hp_max = 25,
		armor = 25,
		collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
		visual = "mesh",
		mesh = "mobs_character.b3d",
		textures = {
			{"christmas_holiday_pack_mrs_claus.png"},
		},
		makes_footstep_sound = true,
		sounds = {
--			random = "santa_random",
			attack = "christmas_holiday_pack_sleighbell",
			damage = "christmas_holiday_pack_sleighbell",
			jump = "christmas_holiday_pack_sleighbell",
--			death = "santa_random",
		},
		blood_amount = 0,
		walk_velocity = 0,
		run_velocity = 0,
		jump = false,
		suffocation = false,
		knock_back = false,
		water_damage = 0,
		lava_damage = 0,
		light_damage = 0,
		view_range = 15,
		owner = "",
		fear_height = 3,
	        animation = {
	                speed_normal = 30,
	                speed_run = 30,
	                stand_start = 0,
	                stand_end = 79,
--	                walk_start = 168,
--	                walk_end = 187,
--	                run_start = 168,
--	                run_end = 187,
	                punch_start = 200,
	                punch_end = 219,
	        },
		        on_rightclick = function(self, clicker)
            		   mobs_trader(self, clicker, entity, christmas_holiday_pack.mrs_claus)
		end,
	        on_spawn = function(self)
	                self.nametag = "Mrs Claus"
	                self.object:set_properties({
	                        nametag = self.nametag,
	                        nametag_color = "#BB2528"
	                })
	                return true -- return true so on_spawn is run once only
	        end,
		    on_die = function(self, pos) -- on die, spawn particles.
			        minetest.add_particlespawner({
			            amount = 100,
			            time = 0.1,
			            minpos = {x=pos.x-1, y=pos.y-1, z=pos.z-1},
			            maxpos = {x=pos.x+1, y=pos.y+1, z=pos.z+1},
			            minvel = {x=-0, y=-0, z=-0},
			            maxvel = {x=1, y=1, z=1},
			            minacc = {x=-0.5,y=5,z=-0.5},
			            maxacc = {x=0.5,y=5,z=0.5},
			            minexptime = 0.1,
			            maxexptime = 1,
			            minsize = 1,
			            maxsize = 3,
			            collisiondetection = false,
			            texture="christmas_holiday_pack_present_07.png"
			        })
			        self.object:remove()
	    	end,
})

-- Register Mrs Claus' Trading Table
christmas_holiday_pack.mrs_claus = {

	names = { "Mrs Claus" },
	items = {
                --{item for sale, price, chance of appearing in trader's inventory}
		{"mobs_creatures:milk_glass 1", "default:coal_lump 1", 1},
		{"mobs_creatures:milk_glass 1", "default:coal_lump 1", 1},
		{"christmas_holiday_pack:sugar_cookie 1", "default:coal_lump 1", 1},
		{"christmas_holiday_pack:sugar_cookie_bell 1", "default:coal_lump 1", 1},
		{"christmas_holiday_pack:sugar_cookie_star 1", "default:coal_lump 1", 1},
		{"christmas_holiday_pack:sugar_cookie_tree 1", "default:coal_lump 1", 1},
		{"christmas_holiday_pack:shirt_ugly_sweater 1", "default:coalblock 1", 1},
		}
	}
-- Register Spawn Eggs
mobs:register_egg("christmas_holiday_pack:mrs_claus", "Mrs Claus Spawn Egg", "wool_red.png", 1)

-- Register Holiday Season Check.
local date = os.date("*t")
if (date.month == 12 and date.day >= 1) or (date.month == 12 and date.day <= 31) then
	-- Spawns on Solid blocks -- Santa's spawning parameters.
	mobs:spawn_specific("christmas_holiday_pack:mrs_claus", {"default:snow", "default:snowblock", "default:dirt_with_snow"}, {"air"}, 7, 16, 600, 500, 1, 2, 200)
else
        return
end
