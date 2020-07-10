
lib_trm = {}
lib_trm.name = "lib_trm"
lib_trm.ver_max = 0
lib_trm.ver_min = 1
lib_trm.ver_rev = 0
lib_trm.ver_str = lib_trm.ver_max .. "." .. lib_trm.ver_min .. "." .. lib_trm.ver_rev
lib_trm.authorship = "lisacvuk, davidthecreator, shadmordre"
lib_trm.license = "LGLv2.1"
lib_trm.copyright = "2019"
lib_trm.path_mod = minetest.get_modpath(minetest.get_current_modname())
lib_trm.path_world = minetest.get_worldpath()


	dofile(lib_trm.path_mod.."/lib_trm_toolcap_modifier.lua")
	
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



























