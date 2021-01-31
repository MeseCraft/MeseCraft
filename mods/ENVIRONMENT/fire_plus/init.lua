fire_plus = {
	tnt_explode_radius = 1.5,
}

fire_plus.ignition_nodes = {
	"default:lava",
	"fire:",
}

fire_plus.put_outs = { -- Couldn't thnk of a better name
	"default:water",
	"default:river_water",
	"default:snow"
}

local firehud = {}
local firesound = {}
local callbacks = {}

local function make_registration()
	local registerfunc = function(func)
		callbacks[#callbacks + 1] = func
	end

	return(registerfunc)
end

minetest.register_on_player_hpchange(function(player, hp_change)
	local pos = player:get_pos()
	local node = minetest.get_node(pos)

	for id, string in ipairs(fire_plus.ignition_nodes) do
		if node.name:find(string) then
			fire_plus.burnplayer(player)
			break
		end
	end
end)

minetest.register_on_respawnplayer(function(player)
	local name = player:get_player_name()

	if firehud[name] then
		player:hud_remove(firehud[name])
		firehud[name] = nil
	end

	if firesound[name] then
		minetest.sound_stop(firesound[name])
		firesound[name] = nil
	end
end)

fire_plus.on_burn = make_registration()

function fire_plus.get_burn_dmg(player)
	local dmg = 1

	for id, func in ipairs(callbacks) do
		local rval = callbacks[k](player)

		if type(rval) == "number" then
			dmg = rval
			break
		end
	end

	return(dmg)
end

function fire_plus.burnplayer(player)
	if not player then return end

	local name = player:get_player_name()

	if firehud[name] then
		return
	end

	firehud[name] = player:hud_add({
		hud_elem_type = "image",
		position  = {x = 0.5, y = 0.95},
		offset    = {x = 0, y = 0},
		text      = "fire_basic_flame.png",
		alignment = -1,
		scale     = {x = 100, y = 32},
		number    = 0xFFFFFF,
	})

	firesound[name] = minetest.sound_play("fire_fire", {
        to_player = name,
        gain = 1.0,
        loop = true,
    })

	for i=1, 4, 1 do
		minetest.after(i, function()
			if not player or firehud[player:get_player_name()] == nil then
				return
			end

			local pos = player:get_pos()
			local pname = player:get_player_name()
			local name = minetest.get_node(pos).name
			local remove_burn = false

			for id, string in ipairs(fire_plus.put_outs) do
				if name:find(string) then
					remove_burn = true
					break
				end
			end

			if remove_burn == true then
				player:hud_remove(firehud[pname])
				minetest.sound_stop(firesound[pname])
				firehud[pname] = nil
				firesound[pname] = nil

				minetest.sound_play("fire_extinguish_flame", {
	    			to_player = pname,
	    			gain = 1.0,
				})

				return
			end

			-- Detonate any nearby TNT if player is on fire

			local tntpos = minetest.find_node_near(player:get_pos(), fire_plus.tnt_explode_radius, {"tnt:tnt"}, true)

			if player:get_hp() > 0 then
				player:set_hp(player:get_hp()-fire_plus.get_burn_dmg(player))
			end

			if tntpos then
				tnt.boom(tntpos, {radius = tnt_radius, damage_radius = tnt_radius})
			end

			minetest.add_particlespawner({
				amount = 20,
				time = 0.1,
				minpos = vector.subtract(pos, 0.5),
				maxpos = vector.add(pos, 0.5),
				minvel = {x = -1, y = 0, z = -1},
				maxvel = {x = 1, y = 1,  z = 1},
				minacc = {x = 0, y = 2, z = 0},
				maxacc = {x = 0, y = 3, z = 0},
				minexptime = 0.5,
				maxexptime = 1,
				minsize = 5 * 0.66,
				maxsize = 5 * 0.66,
				texture = "fire_basic_flame.png",
				collisiondetection = true,
			})
		end)
	end

	minetest.after(4.5, function()
		if not player then
			return
		end

		local name = player:get_player_name()

		if firehud[name] then
			player:hud_remove(firehud[name])
			firehud[name] = nil
		end

		if firesound[name] then
			minetest.sound_stop(firesound[name])
			firesound[name] = nil
		end
	end)
end

minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_ca, dir, dmg)
	if hitter:is_player() and tool_ca.damage_groups.burns == 1 and 
	(player:get_hp()-dmg) > 0 then
		fire_plus.burnplayer(player)
	end

	return(false)
end)