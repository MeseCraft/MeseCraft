if minetest.settings:get_bool("clothing_enable_craft") == false or
		not minetest.get_modpath("wool") then
	return
end
local modpath = minetest.get_modpath(minetest.get_current_modname())

dofile(modpath.."/loom.lua")

local colors = {
	white = "FFFFFF",
	grey = "C0C0C0",
	black = "232323",
	red = "FF0000",
	yellow = "FFEE00",
	green = "32CD32",
	cyan = "00959D",
	blue = "003376",
	magenta = "D80481",
	orange = "E0601A",
	violet = "480080",
	brown = "391A00",
	pink = "FFA5A5",
	dark_grey = "696969",
	dark_green = "154F00",
}

for color, hex in pairs(colors) do
	local desc = color:gsub("%a", string.upper, 1)
	desc = desc:gsub("_", " ")
	minetest.register_craftitem("clothing:hat_"..color, {
		description = desc.." Cotton Hat",
		inventory_image = "clothing_inv_hat.png^[multiply:#"..hex,
		uv_image = "(clothing_uv_hat.png^[multiply:#"..hex..")",
		groups = {clothing=1},
	})
	minetest.register_craftitem("clothing:shirt_"..color, {
		description = desc.." Cotton Shirt",
		inventory_image = "clothing_inv_shirt.png^[multiply:#"..hex,
		uv_image = "(clothing_uv_shirt.png^[multiply:#"..hex..")",
		groups = {clothing=1},
	})
	minetest.register_craftitem("clothing:pants_"..color, {
		description = desc.." Cotton Pants",
		inventory_image = "clothing_inv_pants.png^[multiply:#"..hex,
		uv_image = "(clothing_uv_pants.png^[multiply:#"..hex..")",
		groups = {clothing=1},
	})
	minetest.register_craftitem("clothing:cape_"..color, {
		description = desc.." Cotton Cape",
		inventory_image = "clothing_inv_cape.png^[multiply:#"..hex,
		uv_image = "(clothing_uv_cape.png^[multiply:#"..hex..")",
		groups = {cape=1},
	})
end
