df_dependencies = {}
local modpath = minetest.get_modpath(minetest.get_current_modname())

df_dependencies.mods_required = {}

df_dependencies.select_required = function(def)
	local ret
	for _, dependency in ipairs(def) do
		local mod = dependency[1]
		local item = dependency[2]
		df_dependencies.mods_required[mod] = true
		if minetest.get_modpath(mod) then
			ret = item
		end
	end
	assert(ret, "Unable to find item for dependency set " .. dump(def))
	return ret
end

df_dependencies.select_optional = function(def)
	local ret
	for _, dependency in ipairs(def) do
		local mod = dependency[1]
		local item = dependency[2]
		df_dependencies.mods_required[mod] = true
		if minetest.get_modpath(mod) then
			ret = item
		end
	end
	return ret
end

dofile(modpath.."/config.lua")
dofile(modpath.."/sounds.lua")
dofile(modpath.."/helper_functions.lua")
dofile(modpath.."/nodes.lua")
dofile(modpath.."/misc.lua")
dofile(modpath.."/mapgen.lua")

local list_mods_required = function()
	local mods_required = ""
	local mods_sorted = {}
	for mod, _ in pairs(df_dependencies.mods_required) do
		table.insert(mods_sorted, mod)
	end
	table.sort(mods_sorted)
	for _, mod in ipairs(mods_sorted) do
		mods_required = mods_required .. ", " .. mod
	end
	minetest.debug(mods_required)
end
--list_mods_required()

-- This mod is meant to only exist at initialization time. Other mods should make copies of anything it points to for their own use.
minetest.after(1, function() df_dependencies = nil end)
