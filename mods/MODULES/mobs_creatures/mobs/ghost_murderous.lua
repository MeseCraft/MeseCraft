-- GHOST BY FREEGAMERS.ORG, MURDEROUS, ATTACKS PLAYERS
-- DESCRIPTION: A spirit that wanders due to an unproper burial. Is not physical. Will haunt players until they are properly memoralized.
-- TODO: FIGURE OUT HOW TO WORK WITH LADDERS AND SHAFTS
mobs:register_mob("mobs_creatures:murderous_ghost", {
	type = "monster",
	passive = false,
	group_attack = true,
	attack_type = "dogfight",
	reach = 2,
	damage = 8,
	hp_min = 10,
	hp_max = 10,
	armor = 100,
	knock_back = false,
        collisionbox = {0.0,-1.0,0.0, 0.0,0.0,0.0},
        visual = "mesh",
        mesh = "mobs_character.b3d",
        textures = {
                {"mobs_creatures_ghost_murderous.png"},
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
	run_velocity = 3.75,
	jump = true,
	fly = true,
	floats = true,
	suffocation = false,
	view_range = 12,
	drops = {
	},
	stay_near = {nodes = "mesecraft_bones:bones", chance = 4}, -- Will search for its bones and attempt to bury itself. (restless ghost just follows players)
	follow = "mesecraft_bones:bones",	-- Will follow players holding bones.
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
		local checkpos = self.object:get_pos()
		local gravecheck = minetest.find_node_near(checkpos, 8, {"group:gravestone"})
		local bonecheck = minetest.find_node_near(checkpos, 8 ,{"mesecraft_bones:bones"})
		if gravecheck == nil then				-- ghost stays to haunt
			return
		elseif bonecheck == nil and gravecheck ~= nil then	-- ghost can pass on
			minetest.sound_play({name = "mobs_creatures_ghost_death", gain = 1.0}, {pos=checkpos, max_hear_distance = 12})
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
                minetest.add_particlespawner({
                        1, --amount
                        0.3, --time
                        {x=checkpos.x-0.3, y=checkpos.y+0.0, z=checkpos.z-0.3}, --minpos
                        {x=checkpos.x+0.3, y=checkpos.y+0.0, z=checkpos.z+0.3}, --maxpos
                        {x=-0, y=-0, z=-0}, --minvel
                        {x=0, y=0, z=0}, --maxvel
                        {x=0,y=1,z=0}, --minacc
                        {x=0.5,y=1.2,z=0.5}, --maxacc
                        3, --minexptime
                        5, --maxexptime
                        2, --minsize
                        3, --maxsize
                        true, --collisiondetection
                        "mobs_creatures_common_shadow.png" --texture
	                })
	end,
})

--Spawn Eggs
mobs:register_egg("mobs_creatures:murderous_ghost", "Murderous Ghost Spawn Egg", "wool_black.png", 1)

--Spawn Functions
mobs:spawn_specific("mobs_creatures:murderous_ghost", {"mesecraft_bones:bones"}, {"air"}, 0, 7, 240, 300, 2, -30912, -500)


