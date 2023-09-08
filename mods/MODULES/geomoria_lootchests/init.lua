geomoria_lootchests = {}

local modname = "geomoria_lootchests"
local modpath = minetest.get_modpath(modname)

dofile(modpath .. "/item_table.lua")

local chest_def = table.copy( minetest.registered_nodes["default:chest"] )
chest_def.name = "geomoria_lootchests:chest"
chest_def.description = "Loot Chest"
chest_def.slot_spawn_chance = geomoria_lootchests.spawn_chance
chest_def.slots = geomoria_lootchests.slots
chest_def.spawn_in = {"default:diamondblock"}     --Spawn in which nodes, may be one itemstring or a list of them
chest_def.spawn_on = {"default:diamondblock"}   --Spawn on which nodes, may be one itemstring or a list of them
chest_def.spawn_in_rarity = 10000                                   --Spawn in rarity, approximate spacing between each node
chest_def.spawn_on_rarity = 10000                                 --Spawn on rarity, spawns one out of defined value (if default is 1000 then on 1 out of 1000)

    --Height limit
chest_def.ymax = -130                                               --Max Y limit
chest_def.ymin = -180                                             --Min Y limit

lootchests.register_lootchest(chest_def)

function geomoria_mod.treasure_chest_hook(pos, min_x, max_x, min_z, max_z, data, area, node)
--  return node[treasure_chest]
	return minetest.get_content_id("geomoria_lootchests:chest_marker")
end

--[[
{
    --Spawning
}
--]]



--[[ Geomoria, as designed, leaves behind a mess of buggy loot chests.
The chests are created, along with everything else, using voxelmanip
They never have their constructors run, and so they never initialize 
the node inventory.  They present as a broken formspec, a great big grey
rectangle where inventory slots should be.

On servers that have been up for a while, it's not enough to just
create new loot chests when new tunnels are generated.  The old, 
buggy, left behind default:chest should also be replaced with lootchests.
--]]

if minetest.settings:get("mesecraft_geomoria_loot_fix_buggy") then
	local no_op = nil -- todo: actually work on this feature
end





minetest.register_chatcommand("test", {
    params = "",
    -- Short parameter description.  See the below note.

    description = "",
    -- General description of the command's purpose.

    privs = {},
    -- Required privileges to run. See `minetest.check_player_privs()` for
    -- the format and see [Privileges] for an overview of privileges.

    func = function(name, param)
		minetest.chat_send_player("singleplayer", tostring(minetest.registered_nodes["geomoria_lootchests:chest_marker"]))
	end,
    -- Called when command is run.
    -- * `name` is the name of the player who issued the command.
    -- * `param` is a string with the full arguments to the command.
    -- Returns a boolean for success and a string value.
    -- The string is shown to the issuing player upon exit of `func` or,
    -- if `func` returns `false` and no string, the help message is shown.
})








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
