df_trees = {}

local modname = minetest.get_current_modname()
df_trees.S = minetest.get_translator(modname)
local modpath = minetest.get_modpath(modname)

--load companion lua files
dofile(modpath.."/config.lua")
dofile(modpath.."/dependencies.lua")
dofile(modpath.."/doc.lua")
dofile(modpath.."/aliases.lua")

local S = df_trees.S

df_trees.register_all_stairs = function(name, override_def)
	local mod = "df_trees"

	local node_def = minetest.registered_nodes[mod..":"..name]
	override_def = override_def or {}
	
	-- Note that a circular table reference will result in a crash, TODO: guard against that.
	-- Unlikely to be needed, though - it'd take a lot of work for users to get into this bit of trouble.
	local function deep_copy(table_in)
		local table_out = {}
	
		for index, value in pairs(table_in) do
			if type(value) == "table" then
				table_out[index] = deep_copy(value)
			else
				table_out[index] = value
			end
		end
		return table_out
	end
	
	local node_copy = deep_copy(node_def)
	for index, value in pairs(override_def) do
		node_copy[index] = value
	end
		
	if minetest.get_modpath("stairs") then
		stairs.register_stair_and_slab(
			name,
			mod ..":" .. name,
			node_copy.groups,
			node_copy.tiles,
			S("@1 Stair", node_copy.description),
			S("@1 Slab", node_copy.description),
			node_copy.sounds
		)
	end
	if minetest.get_modpath("moreblocks") then
		stairsplus:register_all(mod, name, mod..":"..name, node_copy)
	end
end

dofile(modpath.."/blood_thorn.lua")
dofile(modpath.."/fungiwood.lua")
dofile(modpath.."/tunnel_tube.lua")
dofile(modpath.."/spore_tree.lua")
dofile(modpath.."/black_cap.lua")
dofile(modpath.."/nether_cap.lua")
dofile(modpath.."/goblin_cap.lua")
dofile(modpath.."/tower_cap.lua")

dofile(modpath.."/torchspine.lua")
dofile(modpath.."/spindlestem.lua")

