if lua_ext == nil then
    lua_ext = {}
    lua_ext.doc = {}
end

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

dofile(modpath.."/llist.lua")
