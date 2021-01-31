-- mydoors mod by don
-- DO WHAT YOU WANT TO PUBLIC LICENSE
-- or abbreviated DWYWPL

-- December 2nd 2015
-- License Copyright (C) 2015 Michael Tomaino (PlatinumArts@gmail.com)
-- www.sandboxgamemaker.com/DWYWPL/

-- DO WHAT YOU WANT TO PUBLIC LICENSE
-- TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

-- 1. You are allowed to do whatever you want to with what content is using this license.
-- 2. This content is provided 'as-is', without any express or implied warranty. In no event 
-- will the authors be held liable for any damages arising from the use of this content.


local doors = {
	-- Black door
	{"scifi_nodes:door2a","scifi_nodes:door2b","scifi_nodes:door2c","scifi_nodes:door2d","2","black", "doors:door_steel", "scifi_nodes_door_mechanic"},
	-- White door
	{"scifi_nodes:door3a","scifi_nodes:door3b","scifi_nodes:door3c","scifi_nodes:door3d","3","white", "doors:door_glass", "scifi_nodes_door_normal"},
	-- Green door
	{"scifi_nodes:door4a","scifi_nodes:door4b","scifi_nodes:door4c","scifi_nodes:door4d","4","green", "doors:door_wood", "scifi_nodes_door_mechanic"},
	-- DOOM door
	{"scifi_nodes:door1a","scifi_nodes:door1b","scifi_nodes:door1c","scifi_nodes:door1d","1","Doom", "doors:door_obsidian_glass", "scifi_nodes_door_mechanic"}
}


for i in ipairs (doors) do

-- TODO: make a map with entries: {a="", b="", desc="", etc}
local doora = doors[i][1]
local doorb = doors[i][2]
local doorc = doors[i][3]
local doord = doors[i][4]
local num = doors[i][5]
local des = doors[i][6]
local base_ingredient = doors[i][7]
local sound = doors[i][8]

minetest.register_craft({
    output = doora .. " 2",
    recipe = {
        {"default:steel_ingot", base_ingredient, "default:steel_ingot"},
        {"default:steel_ingot", base_ingredient, "default:steel_ingot"}
    }
})


function onplace(itemstack, placer, pointed_thing)
	local pos1 = pointed_thing.above
	local pos2 = {x=pos1.x, y=pos1.y, z=pos1.z}
	      pos2.y = pos2.y+1
	if

	not minetest.registered_nodes[minetest.get_node(pos1).name].buildable_to or
	not minetest.registered_nodes[minetest.get_node(pos2).name].buildable_to or
	not placer or
	not placer:is_player() or
	minetest.is_protected(pos1, placer:get_player_name()) or
	minetest.is_protected(pos2, placer:get_player_name()) then
		return
	end
			local pt = pointed_thing.above
			local pt2 = {x=pt.x, y=pt.y, z=pt.z}
			pt2.y = pt2.y+1
			local p2 = minetest.dir_to_facedir(placer:get_look_dir())
			local pt3 = {x=pt.x, y=pt.y, z=pt.z}
			local p4 = 0
			if p2 == 0 then
				pt3.x = pt3.x-1
				p4 = 2
			elseif p2 == 1 then
				pt3.z = pt3.z+1
				p4 = 3
			elseif p2 == 2 then
				pt3.x = pt3.x+1
				p4 = 0
			elseif p2 == 3 then
				pt3.z = pt3.z-1
				p4 = 1
			end
			if minetest.get_node(pt3).name == doora then
				minetest.set_node(pt, {name=doora, param2=p4})
				minetest.set_node(pt2, {name=doorb, param2=p4})
			else
				minetest.set_node(pt, {name=doora, param2=p2})
				minetest.set_node(pt2, {name=doorb, param2=p2})
			end
	itemstack:take_item(1)

	return itemstack;
end

function afterdestruct(pos, oldnode)
	   minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="air"})
end

function rightclick(pos, node, player, itemstack, pointed_thing)
	-- play sound
	minetest.sound_play(sound,{
		max_hear_distance = 16,
		pos = pos,
		gain = 1.0
	})

	local timer = minetest.get_node_timer(pos)
	local a = minetest.get_node({x=pos.x, y=pos.y, z=pos.z-1})
	local b = minetest.get_node({x=pos.x, y=pos.y, z=pos.z+1})
	local c = minetest.get_node({x=pos.x+1, y=pos.y, z=pos.z})
	local d = minetest.get_node({x=pos.x-1, y=pos.y, z=pos.z})
	local e = minetest.get_node({x=pos.x+1, y=pos.y, z=pos.z-1})
	local f = minetest.get_node({x=pos.x-1, y=pos.y, z=pos.z-1})
	local g = minetest.get_node({x=pos.x+1, y=pos.y, z=pos.z+1})
	local h = minetest.get_node({x=pos.x-1, y=pos.y, z=pos.z+1})
	
	
		minetest.set_node(pos, {name=doorc, param2=node.param2})
		minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z}, {name=doord, param2=node.param2})

	     if a.name == doora then
		minetest.set_node({x=pos.x, y=pos.y, z=pos.z-1}, {name=doorc, param2=a.param2})
		minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z-1}, {name=doord, param2=a.param2})
		end
	     if b.name == doora then
		minetest.set_node({x=pos.x, y=pos.y, z=pos.z+1}, {name=doorc, param2=b.param2})
		minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z+1}, {name=doord, param2=b.param2})
		end
	     if c.name == doora then
		minetest.set_node({x=pos.x+1, y=pos.y, z=pos.z}, {name=doorc, param2=c.param2})
		minetest.set_node({x=pos.x+1,y=pos.y+1,z=pos.z}, {name=doord, param2=c.param2})
		end
	     if d.name == doora then
		minetest.set_node({x=pos.x-1, y=pos.y, z=pos.z}, {name=doorc, param2=d.param2})
		minetest.set_node({x=pos.x-1,y=pos.y+1,z=pos.z}, {name=doord, param2=d.param2})
		end
	     if e.name == doora then
		minetest.set_node({x=pos.x+1, y=pos.y, z=pos.z-1}, {name=doorc, param2=e.param2})
		minetest.set_node({x=pos.x+1, y=pos.y+1, z=pos.z-1}, {name=doord, param2=e.param2})
		end
	     if f.name == doora then
		minetest.set_node({x=pos.x-1, y=pos.y, z=pos.z-1}, {name=doorc, param2=f.param2})
		minetest.set_node({x=pos.x-1, y=pos.y+1, z=pos.z-1}, {name=doord, param2=f.param2})
		end
	     if g.name == doora then
		minetest.set_node({x=pos.x+1, y=pos.y, z=pos.z+1}, {name=doorc, param2=g.param2})
		minetest.set_node({x=pos.x+1, y=pos.y+1, z=pos.z+1}, {name=doord, param2=g.param2})
		end
	     if h.name == doora then
		minetest.set_node({x=pos.x-1, y=pos.y, z=pos.z+1}, {name=doorc, param2=h.param2})
		minetest.set_node({x=pos.x-1, y=pos.y+1, z=pos.z+1}, {name=doord, param2=h.param2})
		end

	   timer:start(3)

end

function afterplace(pos, placer, itemstack, pointed_thing)
	   minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name=doord,param2=nodeu.param2})
end

function ontimer(pos, elapsed)
	-- play sound
	minetest.sound_play(sound,{
		max_hear_distance = 16,
		pos = pos,
		gain = 1.0
	})

	local node = minetest.get_node(pos)
	local a = minetest.get_node({x=pos.x, y=pos.y, z=pos.z-1})
	local b = minetest.get_node({x=pos.x, y=pos.y, z=pos.z+1})
	local c = minetest.get_node({x=pos.x+1, y=pos.y, z=pos.z})
	local d = minetest.get_node({x=pos.x-1, y=pos.y, z=pos.z})
	local e = minetest.get_node({x=pos.x+1, y=pos.y, z=pos.z-1})
	local f = minetest.get_node({x=pos.x-1, y=pos.y, z=pos.z-1})
	local g = minetest.get_node({x=pos.x+1, y=pos.y, z=pos.z+1})
	local h = minetest.get_node({x=pos.x-1, y=pos.y, z=pos.z+1})
	
	
		minetest.set_node(pos, {name=doora, param2=node.param2})
		minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z}, {name=doorb, param2=node.param2})

	     if a.name == doorc then
		minetest.set_node({x=pos.x, y=pos.y, z=pos.z-1}, {name=doora, param2=a.param2})
		minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z-1}, {name=doorb, param2=a.param2})
		end
	     if b.name == doorc then
		minetest.set_node({x=pos.x, y=pos.y, z=pos.z+1}, {name=doora, param2=b.param2})
		minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z+1}, {name=doorb, param2=b.param2})
		end
	     if c.name == doorc then
		minetest.set_node({x=pos.x+1, y=pos.y, z=pos.z}, {name=doora, param2=c.param2})
		minetest.set_node({x=pos.x+1,y=pos.y+1,z=pos.z}, {name=doorb, param2=c.param2})
		end
	     if d.name == doorc then
		minetest.set_node({x=pos.x-1, y=pos.y, z=pos.z}, {name=doora, param2=d.param2})
		minetest.set_node({x=pos.x-1,y=pos.y+1,z=pos.z}, {name=doorb, param2=d.param2})
		end
	     if e.name == doorc then
		minetest.set_node({x=pos.x+1, y=pos.y, z=pos.z-1}, {name=doora, param2=e.param2})
		minetest.set_node({x=pos.x+1, y=pos.y+1, z=pos.z-1}, {name=doorb, param2=e.param2})
		end
	     if f.name == doorc then
		minetest.set_node({x=pos.x-1, y=pos.y, z=pos.z-1}, {name=doora, param2=f.param2})
		minetest.set_node({x=pos.x-1, y=pos.y+1, z=pos.z-1}, {name=doorb, param2=f.param2})
		end
	     if g.name == doorc then
		minetest.set_node({x=pos.x+1, y=pos.y, z=pos.z+1}, {name=doora, param2=g.param2})
		minetest.set_node({x=pos.x+1, y=pos.y+1, z=pos.z+1}, {name=doorb, param2=g.param2})
		end
	     if h.name == doorc then
		minetest.set_node({x=pos.x-1, y=pos.y, z=pos.z+1}, {name=doora, param2=h.param2})
		minetest.set_node({x=pos.x-1, y=pos.y+1, z=pos.z+1}, {name=doorb, param2=h.param2})
		end

end

minetest.register_node(doora, {
	description = des.." Sliding Door",
	inventory_image = "scifi_nodes_door"..num.."a_inv.png",
	wield_image = "scifi_nodes_door"..num.."a_inv.png",
	tiles = {
		"scifi_nodes_door"..num.."a_edge.png",
		"scifi_nodes_door"..num.."a_edge.png",
		"scifi_nodes_door"..num.."a_edge.png",
		"scifi_nodes_door"..num.."a_edge.png",
		"scifi_nodes_door"..num.."a_rbottom.png",
		"scifi_nodes_door"..num.."a_bottom.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 3},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, 0.5, 0.5, 0.0625}
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, 0.5, 1.5, 0.0625}
		}
	},

on_place = onplace,

after_destruct = afterdestruct,

on_rightclick = rightclick,
})
minetest.register_node(doorb, {
	tiles = {
		"scifi_nodes_door"..num.."a_edge.png",
		"scifi_nodes_door"..num.."a_edge.png",
		"scifi_nodes_door"..num.."a_edge.png",
		"scifi_nodes_door"..num.."a_edge.png",
		"scifi_nodes_door"..num.."a_rtop.png",
		"scifi_nodes_door"..num.."a_top.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, 0.5, 0.5, 0.0625}
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{0, 0, 0, 0, 0, 0},
		}
	},
})
minetest.register_node(doorc, {
	tiles = {
		"scifi_nodes_door"..num.."a_edge.png",
		"scifi_nodes_door"..num.."a_edge.png",
		"scifi_nodes_door"..num.."a_edge.png",
		"scifi_nodes_door"..num.."a_edge.png",
		"scifi_nodes_door"..num.."a_rbottom0.png",
		"scifi_nodes_door"..num.."a_bottom0.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	drop = doora,
	groups = {cracky = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, -0.25, 0.5, 0.0625},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, -0.25, 1.5, 0.0625},
		}
	},
after_place_node = afterplace,
after_destruct = afterdestruct,
on_timer = ontimer,
})
minetest.register_node(doord, {
	tiles = {
		"scifi_nodes_door"..num.."a_edge.png",
		"scifi_nodes_door"..num.."a_edge.png",
		"scifi_nodes_door"..num.."a_edge.png",
		"scifi_nodes_door"..num.."a_edge.png",
		"scifi_nodes_door"..num.."a_rtopo.png",
		"scifi_nodes_door"..num.."a_topo.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, -0.25, 0.5, 0.0625},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{0, 0, 0, 0, 0, 0}, 
		}
	},
})
end
