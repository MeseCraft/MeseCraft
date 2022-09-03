local S = minetest.get_translator(minetest.get_current_modname())

local use_timeout = {}

local check_timeout = function(user)
	if not user:is_player() then return false end
	local player_name = user:get_player_name()
	local curr_time = minetest.get_gametime() -- minetest.get_us_time() for microsecond precision
	local last_used = use_timeout[player_name]
	if not last_used or curr_time > last_used then
		use_timeout[player_name] = curr_time
		return true
	end
end

local drill_particles = function(pos)
	minetest.add_particlespawner({
		amount = 25,
		time = 0.5,
		minpos = pos,
		maxpos = pos,
		minvel = {x=-5, y=0, z=-5},
		maxvel = {x=5, y=10, z=5},
		minacc = {x=0, y=-10, z=0},
		maxacc = {x=0, y=-10, z=0},
		minexptime = 2.5,
		maxexptime = 7.5,
		minsize = 1,
		maxsize = 5,
		texture = "dfcaverns_glowpit_particle.png",
		collisiondetection = true,
		collision_removal = true,
		glow = 15,
	})
end

local slade_drill_def = {
	_doc_items_longdesc = df_underworld_items.doc.slade_drill_desc,
	_doc_items_usagehelp = df_underworld_items.doc.slade_drill_usage,
	light_source = minetest.LIGHT_MAX,
	description = S("Slade Drill"),
	inventory_image = "dfcaverns_slade_drill.png",
	groups = {cracky=3, stone=1, slade=1, pit_plasma_resistant=1, mese_radiation_shield=1,creative_breakable=1, material_stone=1},
	sounds = df_dependencies.sound_stone({ footstep = { name = "bedrock2_step", gain = 1 } }),
	_mcl_blast_resistance = 8,
	_mcl_hardness = 5,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type == "node" then
			local pos = pointed_thing.under
			local node = minetest.get_node(pos)
			if node.name == "df_underworld_items:slade" and check_timeout(user) then
				if not minetest.is_creative_enabled(user:get_player_name()) then
					itemstack:set_wear(itemstack:get_wear()+1)
				end
				minetest.sound_play("dfcaverns_slade_drill", {pos = user:get_pos()})
				minetest.set_node(pos, {name="df_underworld_items:slade_sand"})
				drill_particles(pointed_thing.above)
				return itemstack
			end
		end	
	end,
}

local tnt_boom = df_dependencies.tnt_boom
if tnt_boom then
	slade_drill_def.on_use = function(itemstack, user, pointed_thing)
		if not check_timeout(user) then return end
		local pos
		if pointed_thing.type == "node" then pos = pointed_thing.under
		elseif pointed_thing.type == "object" then pos = pointed_thing.ref:get_pos() end
		if pos then
			tnt_boom(pos, {radius=1})
			minetest.sound_play("dfcaverns_slade_drill", {pos = user:get_pos()})
			if not minetest.is_creative_enabled(user:get_player_name()) then
				itemstack:set_wear(itemstack:get_wear()+1)
			end
			drill_particles(pos)
			minetest.check_for_falling({x=pos.x, y=pos.y+1, z=pos.z})
			return itemstack
		end
	end
end

minetest.register_tool("df_underworld_items:slade_drill", slade_drill_def)