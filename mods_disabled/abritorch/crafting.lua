
local recipe_list
local modname

-- recipes when caverealms is present
if minetest.get_modpath("caverealms") then
	recipe_list = {
		{"black", "spike",}, {"blue", "glow_crystal",},
		{"cyan", "glow_gem",}, {"green", "glow_emerald",}, 
		{"magenta", "salt_gem",}, {"orange", "fire_vine",}, 
		{"purple", "glow_amethyst",}, {"red", "glow_ruby",}, 
		{"yellow", "glow_mese",}, {"white", "glow_ore",},
	}
	modname = "caverealms"
-- recipes when caverealms not present
else
	recipe_list = {
		{"black", "black",}, {"blue", "blue",},
		{"cyan", "cyan",}, {"green", "green",}, 
		{"magenta", "magenta",}, {"orange", "orange",}, 
		{"purple", "violet",}, {"red", "red",}, 
		{"yellow", "yellow",}, {"white", "white",},
	}
	modname = "dye"
end

for i in ipairs(recipe_list) do
	local colour = recipe_list[i][1]
	local ingredient = recipe_list[i][2]

	minetest.register_craft({
		output = "abritorch:torch_"..colour.." 4", 
		recipe = {
			{"default:torch", "", "default:torch" },
			{"", modname..":"..ingredient, "" },
			{"default:torch", "", "default:torch" },
		}
	})
end
