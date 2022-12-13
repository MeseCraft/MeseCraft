local special_leaves = {}

if minetest.get_modpath("sakuragi") then
special_leaves["sakuragi:sleaves"] = {
	texture = function() return "single_cherry_blossom"..math.random(1,4)..".png^[transform"..math.random(0,7) end, 
	velocity = function() 
		return {
			x=math.sin((os.clock()%2000)/40)*0.04,
			y = -0.05, -- If you know this, you're a weeb.
			z=math.cos((os.clock()%2000)/80)*0.04,
		} 
	end,
	size=0.75,
	expirationtime = 56,
	leaf_spawn_chance = 15,
	collision_removal = false,
	spawn_radius = 28,
}
end

if minetest.get_modpath("dfcaverns") then --Don't drop leaves from mushrooms, they don't have any!
	special_leaves["dfcaverns:fungiwood_shelf"] = {texture = "default_wood.png^[colorize:#0000:255",size=0,expirationtime = 0}
	special_leaves["dfcaverns:goblin_cap_gills"] = {texture = "default_wood.png^[colorize:#0000:255",size=0,expirationtime = 0}
	special_leaves["dfcaverns:nether_cap_gills"] = {texture = "default_wood.png^[colorize:#0000:255",size=0,expirationtime = 0}
	special_leaves["dfcaverns:tower_cap_gills"] = {texture = "default_wood.png^[colorize:#0000:255",size=0,expirationtime = 0}
	special_leaves["dfcaverns:spore_tree_hyphae"] = {texture = "default_wood.png^[colorize:#0000:255",size=0,expirationtime = 0}
	special_leaves["dfcaverns:spore_tree_fruiting_body"] = {texture = "default_wood.png^[colorize:#0000:255",size=0,expirationtime = 0}
end

if minetest.get_modpath("glowtest") then -- Glowing leaves shine in darkness
	special_leaves["glowtest:redleaf"] = {glow=10}
	special_leaves["glowtest:yellowleaf"] = {glow=10}
	special_leaves["glowtest:blueleaf"] = {glow=10}
	special_leaves["glowtest:greenleaf"] = {glow=10}
	special_leaves["glowtest:pinkleaf"] = {glow=10}
	special_leaves["glowtest:blackleaf"] = {glow=10}
	special_leaves["glowtest:whiteleaf"] = {glow=10}
	
end

minetest.after(0, function()
	for name,def in pairs(minetest.registered_nodes) do
		if def.groups and def.groups["leaves"] and def.groups["mushroom"] then
			special_leaves[name] {texture = "default_wood.png^[colorize:#0000:255",size=0}
		end
	end
	
end)

return special_leaves