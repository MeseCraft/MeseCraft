--[[
Without another mod (like this one) filling chests with loot, 
Geomoria spawns default:chest without calling their constructor.
This leaves buggy, useless chests instead of chests with loot.
They can be detected as default:chest in a node lacking an associated
inventory meta.
]]


if not minetest.settings:get_bool('geomoria_lootchests_fix_buggy' , false)
	then return
end

-- find the lootchests lbm
local lootchest_lbm
for _, v in pairs(minetest.registered_lbms) do
	if v.name == "geomoria_lootchests:chest".."_marker_replace"
		then lootchest_lbm = v
	end	
end
if not lootchest_lbm then
	minetest.log("warning", 'geomoria_lootchests - Not fixing.  Cannot find Lootchest LBM ')
	return
end


minetest.register_lbm({
    name = "geomoria_lootchests:fix_buggy_chests",
    label = "Fixing buggy chests",
    nodenames = {"default:chest"},
    action = function(pos, node)
    	if not "default:chest" == minetest.get_node(pos).name then 
    		return end
    	if not minetest.get_inventory({type="node", pos=pos}) then
    		-- Found one.  Nuke it.
    		minetest.set_node(pos, {name="geomoria_lootchests:chest_marker"})
    		lootchest_lbm.action(pos, "geomoria_lootchests:chest".."_marker")
    		minetest.log("action", 'geomoria_lootchests - fixed '..tostring(pos))
    	end
	end
})
