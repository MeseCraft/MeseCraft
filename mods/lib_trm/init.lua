-- declare our table
lib_trm = {}
lib_trm.path_mod = minetest.get_modpath(minetest.get_current_modname())
lib_trm.path_world = minetest.get_worldpath()

	-- execute the tool random modifiers.
	dofile(lib_trm.path_mod.."/lib_trm_toolcap_modifier.lua")
	-- execute the tool ranks portion.
	dofile(lib_trm.path_mod.."/lib_trm_tool_ranks.lua")
	
	minetest.register_on_mods_loaded(function()
		for node_name, node_def in pairs(minetest.registered_tools) do
			if node_name and node_name ~= "" then
				if node_def then
					if not node_def.original_description then
						local node_desc = node_def.description
						minetest.override_item(node_name, {
							original_description = node_desc,
							description = toolranks.create_description(node_desc, 0, 1),
							--description = node_desc,
							after_use = toolranks.new_afteruse,
						})
					end
				end
			end
		end
	end)