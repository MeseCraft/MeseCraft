local S = minetest.get_translator(minetest.get_current_modname())

hunter_statue = {}

-- override this to allow achievements to be recorded without requiring a dependency
hunter_statue.player_punched = function(node_name, pos, player) end

local statue_box = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5, -0.5, 0.5, 95/64, 0.5},
	},
}

local fourtyfivedegrees = math.pi/4
local sixtydegrees = math.pi/3

local default_sounds
if minetest.get_modpath("default") then
	default_sounds = default.node_sound_stone_defaults()
end

local test_array = {
	{x=0,y=0,z=0},
	{x=0,y=-1,z=0},
	{x=0,y=1,z=0},
	{x=0,y=-2,z=0},
	{x=0,y=2,z=0},
}

--statue_def = {
--	description = name of statue type
--	tiles = {}
--	drop = ""
--	sounds =
--	groups = {}
--	interval = 1
--	chance = 1
--	damage = 8
--	knockback = 16
--	tnt_vulnerable = false
--	tnt_debris = 
--	hunters_allowed_here = -- function(pos)
--	other_overrides = 
--}

hunter_statue.register_hunter_statue = function(node_name, statue_def)
	
	local def = {
		description = statue_def.description or S("Hunter Statue"),
	--		_doc_items_longdesc = long_description,
	--		_doc_items_usagehelp = usage_help,
		drawtype = "mesh",
		mesh = "hunter_statue.obj",
		tiles = statue_def.tiles or {},
		paramtype2 = "facedir",
		drop = statue_def.drop or "",
		collision_box = statue_box,
		selection_box = statue_box,
		groups = statue_def.groups or {falling_node = 1},
		sounds = statue_def.sounds or default_sounds,
	}
	
	if statue_def.tnt_vulnerable then
		def.on_blast = function(pos, intensity)
			if intensity >= 1.0 then
				minetest.set_node(pos, {name= statue_def.tnt_debris or "air"})
				minetest.check_for_falling(pos)
			end
		end
	end
	
	if statue_def.other_overrides then
		for k, v in pairs(statue_def.other_overrides) do
			def[k] = v
		end
	end
	
	local knockback = statue_def.knockback or 16
	local damage = statue_def.damage or 8
	local hunters_allowed_here = statue_def.hunters_allowed_here
	
	minetest.register_node(node_name, def)
	
	minetest.register_abm({
		label = node_name .. " ABM",
		nodenames = {node_name},
		interval = statue_def.interval or 1.0,
		chance = statue_def.chance or 1,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local players = minetest.get_connected_players()
			local nearest_distance = 50
			local nearest_player = nil
			local nearest_pos = nil
			for _, player in pairs(players) do
				local player_pos = player:get_pos()
				local player_distance = vector.distance(pos, player_pos)
				-- ignore far-away players
				if player_distance < 50 then
					local look_dir = player:get_look_dir()
					local statue_dir = vector.direction(player_pos, pos)
					local angle = vector.angle(look_dir, statue_dir)
					if angle < sixtydegrees then
						-- raycast test?
						-- a player is looking, do nothing
						return
					elseif player_distance < nearest_distance then
						nearest_distance = player_distance
						nearest_player = player
						nearest_pos = player_pos
					end
				end				
			end
			
			if nearest_player then
				if nearest_distance < 2 then
					local armour_multiplier = 1
					local fleshy_armour = nearest_player:get_armor_groups().fleshy
					if fleshy_armour then
						armour_multiplier = fleshy_armour/100
					end
					nearest_player:add_velocity(vector.multiply(vector.direction(pos, nearest_pos), knockback))
					nearest_player:set_hp(math.max(nearest_player:get_hp() - damage*armour_multiplier, 0))
					minetest.sound_play({name="hunter_statue_thud"}, {pos = nearest_pos})
					hunter_statue.player_punched(node_name, pos, nearest_player)
					return
				end
				local player_dir = vector.direction(pos, nearest_pos)
				local new_facedir = minetest.dir_to_facedir(player_dir)
				local new_pos = vector.round(vector.add(pos, player_dir))
				for _, add_pos in ipairs(test_array) do
					local test_base = vector.add(new_pos, add_pos)
					if hunters_allowed_here == nil or hunters_allowed_here(test_base) then
						local test_base_node = minetest.get_node(test_base)
						local test_base_node_def = minetest.registered_nodes[test_base_node.name]
						if test_base_node_def and test_base_node_def.buildable_to then
							local test_above = vector.add(test_base, {x=0, y=1, z=0})
							local test_above_node = minetest.get_node(test_above)
							local test_above_node_def = minetest.registered_nodes[test_above_node.name]
							if test_above_node_def and test_above_node_def.buildable_to then
								local test_below = vector.add(test_base, {x=0, y=-1, z=0})
								local test_below_node = minetest.get_node(test_below)
								local test_below_node_def = minetest.registered_nodes[test_below_node.name]
								if test_below_node_def and test_below_node_def.walkable then
									minetest.set_node(pos, {name="air"}) -- old location
									minetest.set_node(test_above, {name="air"}) -- some kind of filler node?
									node.param2 = new_facedir
									minetest.set_node(test_base, node)
									minetest.check_for_falling({x=pos.x, y=pos.y+1, z=pos.z})
									minetest.sound_play({name="hunter_statue_brick_step"}, {pos = pos, gain = 0.5})
									return
								end
							end
						end
					end
				end
				if node.param2 ~= new_facedir then
					node.param2 = new_facedir
					minetest.set_node(pos, node)
					minetest.sound_play({name="hunter_statue_turn_grind"}, {pos = pos, gain = 0.5})
				end
			end
		end,
	})
end