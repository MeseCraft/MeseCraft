ropes.doc = {}

if not minetest.get_modpath("doc") then
	return
end

-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

ropes.doc.ropesegment_longdesc = S("Rope segments are bundles of fibre twisted into robust cables.")
ropes.doc.ropesegment_usage = S("This craft item is useful for creating rope ladders, or for spooling on wooden spindles to hang and climb upon.")

ropes.doc.ropeladder_longdesc = S("A hanging rope ladder that automatically extends downward.")
ropes.doc.ropeladder_usage = S("After a rope ladder is placed on a vertical wall it will begin extending downward until it reaches its maximum length (@1 meters). If the rope ladder is removed all of the ladder below the point of removal will disappear. A rope ladder can be severed partway down using an axe or similar tool, and the ladder below the point where it is cut will collapse. No rope is actually lost in the process, though, and if the uppermost section of the ladder is removed and replaced the ladder will re-extend to the same maximum length as before.", ropes.ropeLadderLength)

local rope_length_doc = S("Rope boxes have a certain amount of rope contained within them specified in the name of the node, and have a limit to how much rope they can support that depends on the material they're made of. The different lengths can be crafted by combining and splitting up rope boxes in the crafting grid. For example, you can craft a @1m rope box by putting a @2m rope box and a rope segment in the crafting grid, or a @3m rope box and two rope segments in the crafting grid. Two rope segments can be recovered by putting the @1m rope box in the crafting grid by itself.", ropes.ropeLength*3, ropes.ropeLength*2, ropes.ropeLength) .. "\n"

if ropes.woodRopeBoxMaxMultiple == 1 then
	rope_length_doc = rope_length_doc .. "\n" .. S("Wood") .. " " .. S("rope boxes can hold @1m of rope.", ropes.ropeLength)
elseif ropes.woodRopeBoxMaxMultiple > 1 then
	rope_length_doc = rope_length_doc .. "\n" .. S("Wood") .. " " .. S("rope boxes can hold rope lengths from @1m to @2m.", ropes.ropeLength, ropes.ropeLength*ropes.woodRopeBoxMaxMultiple)
end

if ropes.copperRopeBoxMaxMultiple == 1 then
	rope_length_doc = rope_length_doc .. "\n" .. S("Copper") .. " " .. S("rope boxes can hold @1m of rope.", ropes.ropeLength)
elseif ropes.copperRopeBoxMaxMultiple > 1 then
	rope_length_doc = rope_length_doc .. "\n" .. S("Copper") .. " " .. S("rope boxes can hold rope lengths from @1m to @2m.", ropes.ropeLength, ropes.ropeLength*ropes.copperRopeBoxMaxMultiple)
end

if ropes.steelRopeBoxMaxMultiple == 1 then
	rope_length_doc = rope_length_doc .. "\n" .. S("Steel") .. " " .. S("rope boxes can hold @1m of rope.", ropes.ropeLength)
elseif ropes.steelRopeBoxMaxMultiple > 1 then
	rope_length_doc = rope_length_doc .. "\n" .. S("Steel") .. " " .. S("rope boxes can hold rope lengths from @1m to @2m.", ropes.ropeLength, ropes.ropeLength*ropes.steelRopeBoxMaxMultiple)
end

ropes.doc.ropebox_longdesc = S("Ropes are hung by placing rope boxes, which automatically lower a rope of fixed length below them. They can be climbed and cut.")
ropes.doc.ropebox_usage = rope_length_doc .. "\n\n" ..
	S("When a rope box is placed the rope will immediately begin lowering from it at one meter per second. The rope will only descend when its end is in the vicinity of an active player, suspending its journey when no players are nearby, so a long descent may require a player to climb down the rope as it goes. If you are near the bottom end of a rope that's extending you'll be automatically carried down with it. The rope will stop when it encounters and obstruction, but will resume lowering if the obstruction is removed.") .. "\n\n" ..
	S("A rope can be severed midway using an axe or other similar tool. The section of rope below the cut will collapse and disappear, potentially causing players who were hanging on to it to fall. The remaining rope will not resume descent on its own, but the rope box at the top of the rope \"remembers\" how long the rope was and if it is deconstructed and replaced it will still have the same maximum length of rope as before - no rope is permanently lost when a rope is severed like this.")

if ropes.extending_ladder_enabled then
	ropes.doc.ladder_longdesc = S("A ladder for climbing. It can reach greater heights when placed against a supporting block.")
	ropes.doc.ladder_usagehelp = S("Right-clicking on a ladder with a stack of identical ladder items will automatically add new ladder segments to the top, provided it hasn't extended too far up beyond the last block behind it providing support.")
end

ropes.doc.wooden_bridge_longdesc = S("A wooden platform with support struts useful for bridging gaps.")
ropes.doc.wooden_bridge_usagehelp = S("This behaves like most structural blocks except in one circumstance: when placed on top of a block with buildable space on the side facing away from you, this block will not be built on top but instead will extend out from that far side of the target block. This allows a platform to be easily built that juts out away from the location you're standing on.")

doc.add_entry_alias("nodes", "ropes:ropeladder_top", "nodes", "ropes:ropeladder")
doc.add_entry_alias("nodes", "ropes:ropeladder_top", "nodes", "ropes:ropeladder_bottom")
doc.add_entry_alias("nodes", "ropes:ropeladder_top", "nodes", "ropes:ropeladder_falling")

doc.add_entry_alias("nodes", "ropes:rope", "nodes", "ropes:rope_bottom")
doc.add_entry_alias("nodes", "ropes:rope", "nodes", "ropes:rope_top")