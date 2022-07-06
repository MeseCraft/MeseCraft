-- GHOST BY FREEGAMERS.ORG, RESTLESS, FOLLOWS PLAYERS
-- DESCRIPTION: A spirit that wanders due to an unproper burial. Is not physical. Will haunt players until they are properly memoralized.
-- TODO: FIGURE OUT HOW TO WORK WITH LADDERS AND SHAFTS
mobs:register_mob('mobs_creatures:ghost', {
	type = "animal",
	passive = false,
	group_attack = true,
	attack_type = "dogfight",
	reach = 2,
	damage = 0,
	hp_min = 10,
	hp_max = 10,
	armor = 100,
	knock_back = false,
        collisionbox = {0.0,-1.0,0.0, 0.0,0.0,0.0},
        visual = "mesh",
        mesh = "mobs_character.b3d",
        textures = {
                {"mobs_creatures_ghost.png"},
        },
	blood_amount = 0,
	makes_footstep_sound = false,
	sounds = {
		random = "mobs_creatures_ghost_random",
		 death = "mobs_creatures_ghost_death",
		attack = "mobs_creatures_ghost_attack",
		damage = "mobs_creatures_ghost_damage",
		warcry = "mobs_creatures_ghost_warcry",
	},
	walk_velocity = 1,
	run_velocity = 4,
	jump = true,
	fly = true,
	floats = true,
	suffocation = false,
	view_range = 32,
	drops = {
	},
	stay_near = {nodes = "bones:bones", chance = 5}, -- Will search for its bones and attempt to bury itself.
	follow = "bones:bones",	-- Will follow players holding bones.
	lava_damage = 0,
	water_damage = 0,
	light_damage = 0,
	fall_damage = 0,
        animation = {
                speed_normal = 0,
                speed_run = 79,
                stand_start = 0,
                stand_end = 79,
                walk_start = 0,
                walk_end = 79,
                run_start = 0,
                run_end = 79,
                punch_start = 0,
                punch_end = 79,
        },
	do_custom = function(self, pos)	-- ghosts will stay to haunt if there is no proper burial (gravestone) or if bones are still present.
		local checkpos = self.object:getpos()
		local gravecheck = minetest.find_node_near(checkpos, 8, {"group:gravestone"})
		local bonecheck = minetest.find_node_near(checkpos, 8 ,{"bones:bones"})
		if gravecheck == nil then				-- ghost stays to haunt
			return
		elseif bonecheck == nil and gravecheck ~= nil then	-- ghost can pass on
			minetest.sound_play({name = "mobs_creatures_ghost_warcry", gain = 1.0}, {pos=checkpos, max_hear_distance = 12})
			minetest.add_particlespawner({
			            amount = 10,
			            time = 1.0,
			            minpos = checkpos,
			            maxpos = checkpos,
			            minvel = {x=-0, y=-0, z=-0},
			            maxvel = {x=1, y=1, z=1},
			            minacc = {x=-0.3,y=3,z=-0.3},
			            maxacc = {x=0.5,y=5,z=0.5},
			            minexptime = 1,
			            maxexptime = 5,
			            minsize = 1,
			            maxsize = 3,
			            collisiondetection = false,
			            texture="default_item_smoke.png"
			        })
		        self.object:remove()
		end
		-- If the ghost is not in air, then it can go through walls and fly (so he doesnt fall through the ground).
		if minetest.get_node(checkpos).name ~= "air" then
			self.collisionbox = {0,0,0,0,0,0}
		end
	end,
})

--Spawn Eggs
mobs:register_egg("mobs_creatures:ghost", "Ghost Spawn Egg", "wool_white.png", 1)

--Spawn Functions
mobs:spawn_specific("mobs_creatures:ghost", {"bones:bones"}, {"air"}, 0, 16, 300, 100, 2, -30912, 30912, false)


