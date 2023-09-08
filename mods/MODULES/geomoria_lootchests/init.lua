geomoria_lootchests = {}

local modname = "geomoria_lootchests"
local modpath = minetest.get_modpath(modname)

dofile(modpath .. "/item_table.lua")

local chest_def = table.copy( minetest.registered_nodes["default:chest"] )
chest_def.name = "geomoria_lootchests:chest"
chest_def.description = "Loot Chest"
chest_def.slot_spawn_chance = geomoria_lootchests.spawn_chance
chest_def.slots = geomoria_lootchests.slots
chest_def.spawn_in = {"default:diamondblock"}     --Prevent Lootchest mod from spawning these randomly.
chest_def.spawn_on = {"default:diamondblock"}     --We only want them where geomoria puts them.
chest_def.spawn_in_rarity = 1000000
chest_def.spawn_on_rarity = 1000000
chest_def.ymax = -130                                               --Max Y limit
chest_def.ymin = -180                                             --Min Y limit

lootchests.register_lootchest(chest_def)

-- Use the hook supplied by geomoria for this purpose
function geomoria_mod.treasure_chest_hook(pos, min_x, max_x, min_z, max_z, data, area, node)
	return minetest.get_content_id("geomoria_lootchests:chest_marker")
end


-- optional.  see setting: geomoria_lootchests_fix_buggy 
dofile(modpath .. "/fix_buggy.lua")


------------        EOF
------------		Debugging Code
--[[

local function roundPos(pos)
	-- Note that y is typically at 0.5, and may arbitrarily round up or down given a chance
	-- adding an extra 0.01 to y to goose it up instead of down
	local rval = {}
	rval.x = math.floor(pos.x+0.5)
	rval.y = math.floor(pos.y+0.51)
	rval.z = math.floor(pos.z+0.5)
	return rval
	end

local hash = minetest.hash_node_position
--local unhash = minetest.get_position_from_hash
local chestlog = {}
local hashlist = {}

minetest.register_abm({
    label = "Teleporting to Geomoria chests",
    nodenames = {"geomoria_lootchests:chest"},
    interval = 3,
    chance = 1,

    action = function(pos, node, active_object_count, active_object_count_wider)
    if "geomoria_lootchests:chest" ~= minetest.get_node(pos).name then return end

	local player = minetest.get_player_by_name("singleplayer")
	if not player then return end

	if #chestlog == 0 then
    	local ppos = vector.new(pos)
    	ppos.y = ppos.y+0.6
    	player:set_pos(ppos)
    end

    local h = hash(pos)
    if not hashlist[h] then
    	hashlist[h] = true
    	table.insert(chestlog, vector.new(pos))
    end

    if not "geomoria_lootchests:chest" == minetest.get_node(chestlog[1]).name
    then
    	table.remove(chestlog,1)
    	if #chestlog == 0 then return end
    	local ppos = vector.new(chestlog[1])
    	ppos.y = ppos.y+0.6
    	player:set_pos(ppos)
    end


	local direct = player:get_look_dir()
	direct = roundPos({x=direct.x*10, y=direct.y*10, z=direct.z*10})
	local playerpos = player:get_pos()
	if not playerpos then return end
	local spos = vector.subtract(pos,roundPos(playerpos))
	end
})


-- dump a table of registered items
-- dump is incomplete, only includes mods loaded before this one
-- bash$ sort < regitems.txt > regitems.sorted.txt

local regitems = {}
for k,_ in pairs(minetest.registered_items) do
	table.insert(regitems, k)
end
minetest.safe_file_write(modpath..'/regitems.txt', table.concat(regitems,'\n') )


--]]
