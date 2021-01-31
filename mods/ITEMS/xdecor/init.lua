--local t = os.clock()

local mver_major, mver_minor, mver_patch = 0, 4, 16 -- Minetest 0.4.16 minimum.

local client_version = minetest.get_version().string
local major, minor, patch = client_version:match("(%d+).(%d+).(%d+)")

if (major and minor and patch)     and
   ((tonumber(major) < mver_major) or
    (mver_major == tonumber(major) and tonumber(minor) < mver_minor)  or
    (mver_minor == tonumber(minor) and tonumber(patch) < mver_patch)) then
	minetest.log("error", "[xdecor] Your Minetest client is too old to run this mod. Disabling.")
	return
end

xdecor = {}
local modpath = minetest.get_modpath("xdecor")

dofile(modpath.."/handlers/animations.lua")
dofile(modpath.."/handlers/helpers.lua")
dofile(modpath.."/handlers/nodeboxes.lua")
dofile(modpath.."/handlers/registration.lua")
dofile(modpath.."/src/nodes.lua")
dofile(modpath.."/src/recipes.lua")

local subpart = {
	"mailbox",
}

for _, name in pairs(subpart) do
	local enable = minetest.settings:get_bool("enable_xdecor_"..name)
	if enable or enable == nil then
		dofile(modpath.."/src/"..name..".lua")
	end
end

--print(string.format("[xdecor] loaded in %.2f ms", (os.clock()-t)*1000))
