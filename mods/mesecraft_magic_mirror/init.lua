-- MAGIC MIRROR
-- by Komodo
-- Based off of "Mirror of Returning" by Wuzzy and "Recall Mirror" by davidthecreator. Thank you!

local magicmirror = {}

-- Sets the fallback position for users with no bed spawn.
-- Pull static spawn point from minetest.conf or settings.
magicmirror.placeholder_pos  = minetest.setting_get_pos("static_spawnpoint") or {x=0,y=0,z=0}

-- Set the mana cost for teleporting
magicmirror.cost_teleport = 200

-- Check settings for mana cost overrides.
if tonumber(minetest.settings:get("magicmirror_cost_teleport")) ~= nil then
	magicmirror.cost_teleport = tonumber(minetest.settings:get("magicmirror_cost_teleport"))
end

-- Set the magic mirror crafting recipes (Disabled here since its a drop-only item in Sara's Survival Server).
--minetest.register_craft({
--      output = "magic_mirror:magic_mirror",
--      recipe = {
--              {"default:gold_ingot", "default:diamond", "default:gold_ingot"},
--              {"default:mese", "default:glass", "default:mese"},
--              {"default:gold_ingot", "default:diamond", "default:gold_ingot"},
--      }
--})

-- Check to see if the user has mana or not
magicmirror.mana_check = function(player, cost)
	local allowed
	         -- Mana subtract function.
                 if mana.subtract(player:get_player_name(), cost) then
                        allowed = true
                 else
        	        allowed = false
                 end
		 return allowed
                 end -- end function

-- REGISTER THE MIRROR TOOL
minetest.register_tool("mesecraft_magic_mirror:magic_mirror", {
	description = "" ..core.colorize("#35cdff","Magic Mirror\n") ..core.colorize("#FFFFFF", "Gaze deeply into the mirror to return home."),
	light_source = 7,
	range = 0,
	stack_max = 1,
	inventory_image = "mesecraft_magic_mirror.png",
	on_use = function(itemstack,user)

		-- If user has the mana cost he/she can teleport.
		if magicmirror.mana_check(user, magicmirror.cost_teleport) then --allowed == true then

			-- Get the player name, current position, and bed position.
			local name = user:get_player_name()
			local firstpos = user:get_pos()
                        local rec_pos = beds.spawn[name]

			-- Teleporting departure effect.
                        minetest.sound_play("mesecraft_magic_mirror_teleport", {pos = firstpos, gain = 0.8})
                        for i=1,50 do
	                        minetest.add_particle({
	                                pos = firstpos,
	                                acceleration = 0,
	                                velocity = {x=math.random(-20, 20)/10, y=math.random(-20, 20)/10, z=math.random(-20, 20)/10},
	                                size = math.random(2,6),
	                                expirationtime = 3.0,
	                                collisiondetection = false,
	                                vertical = false,
	                                texture = "mesecraft_magic_mirror_particle.png",
	                                animation = {type="vertical_frames", aspect_w=8, aspect_h=8, length = 0.50,},
	                                glow = 30,
	                        })
                        end

                        -- Move the player to their bed position, else fallback to the spawn point.
                        if rec_pos then
                                user:set_pos(rec_pos)
                        else
                                user:set_pos(magicmirror.placeholder_pos)
                        end

                        -- Teleportation effects on arrival location.
                        local nextpos = user:get_pos()
                        minetest.sound_play("mesecraft_magic_mirror_teleport", {pos = nextpos, gain = 1.0})
                        for i=1,50 do
                                minetest.add_particle({
                                        pos = nextpos,
                                        acceleration = 0,
                                        velocity = {x=math.random(-20, 20)/10, y=math.random(-20, 20)/10, z=math.random(-20, 20)/10},
                                        size = math.random(2,6),
                                        expirationtime = 3.0,
                                        collisiondetection = false,
                                        vertical = false,
                                        texture = "mesecraft_magic_mirror_particle.png",
                                        animation = {type="vertical_frames", aspect_w=8, aspect_h=8, length = 0.2,},
                                        glow = 30,
                                })
                        end
	
		-- User does not have enough mana, play sound effect
		else
			local firstpos = user:get_pos()
			minetest.sound_play("bweapons_magic_pack_reload", {pos = firstpos, gain = 0.25})
		end -- end of "mana_check false" section.
end}) -- end register tool function
