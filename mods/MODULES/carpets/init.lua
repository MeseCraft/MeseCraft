local modpath = minetest.get_modpath(minetest.get_current_modname())
dofile(modpath .. "/api.lua")

if minetest.get_modpath("wool") then
	local nodenames = {
		"wool:black",
		"wool:blue",
		"wool:brown",
		"wool:cyan",
		"wool:dark_green",
		"wool:dark_grey",
		"wool:green",
		"wool:grey",
		"wool:magenta",
		"wool:orange",
		"wool:pink",
		"wool:red",
		"wool:violet",
		"wool:white",
		"wool:yellow",
	}
	for _, nodename in ipairs(nodenames) do
		carpets.register(nodename)
	end
end
