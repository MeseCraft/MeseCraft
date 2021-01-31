xbg = default.gui_bg..default.gui_bg_img..default.gui_slots
local default_inventory_size = 32

local default_inventory_formspecs = {
	["8"] = [[ size[8,6]
		list[context;main;0,0;8,1;]
		list[current_player;main;0,2;8,4;]
		listring[current_player;main]
		listring[context;main] ]]
		..default.get_hotbar_bg(0,2),

	["16"] = [[ size[8,7]
		list[context;main;0,0;8,2;]
		list[current_player;main;0,3;8,4;]
		listring[current_player;main]
		listring[context;main] ]]
		..default.get_hotbar_bg(0,3),

	["24"] = [[ size[8,8]
		list[context;main;0,0;8,3;]
		list[current_player;main;0,4;8,4;]
		listring[current_player;main]
		listring[context;main]" ]]
		..default.get_hotbar_bg(0,4),

	["32"] = [[ size[8,9]
		list[context;main;0,0.3;8,4;]
		list[current_player;main;0,4.85;8,1;]
		list[current_player;main;0,6.08;8,3;8]
		listring[current_player;main]
		listring[context;main] ]]
		..default.get_hotbar_bg(0,4.85)
}

local function get_formspec_by_size(size)
	local formspec = default_inventory_formspecs[tostring(size)]
	return formspec or default_inventory_formspecs
end

local default_can_dig = function(pos)
	local inv = minetest.get_meta(pos):get_inventory()
	return inv:is_empty("main")
end

function xdecor.register(name, def)
	local function xdecor_stairs_alternative(nodename, def)
		local mod, name = nodename:match("(.*):(.*)")
		for groupname, value in pairs(def.groups) do
			if groupname ~= "cracky"    and groupname ~= "choppy"  and
			   groupname ~= "flammable" and groupname ~= "crumbly" and
			   groupname ~= "snappy"    then
				def.groups.groupname = nil
			end
		end

		if minetest.get_modpath("moreblocks") then
			stairsplus:register_all(
				mod,
				name,
				nodename,
				{
					description = def.description,
					tiles = def.tiles,
					groups = def.groups,
					sounds = def.sounds,
				}
			)
		elseif minetest.get_modpath("stairs") then	
			stairs.register_stair_and_slab(name,nodename,
				def.groups,
				def.tiles,
				("%s Stair"):format(def.description),
				("%s Slab"):format(def.description),
				def.sounds
			)	
		end	
	end

	def.drawtype = def.drawtype or (def.mesh and "mesh") or (def.node_box and "nodebox")
	def.sounds = def.sounds or default.node_sound_defaults()

	if not (def.drawtype == "normal" or def.drawtype == "signlike" or
			def.drawtype == "plantlike" or def.drawtype == "glasslike_framed" or
			def.drawtype == "glasslike_framed_optional") then
		def.paramtype2 = def.paramtype2 or "facedir"
	end

	if def.sunlight_propagates ~= false and
			(def.drawtype == "plantlike" or def.drawtype == "torchlike" or
			def.drawtype == "signlike" or def.drawtype == "fencelike") then
		def.sunlight_propagates = true
	end

	if not def.paramtype and
		(def.light_source or def.sunlight_propagates or
		def.drawtype == "nodebox" or def.drawtype == "mesh") then
		def.paramtype = "light"
	end

	local infotext = def.infotext
	local inventory = def.inventory
	def.inventory = nil

	if inventory then
		def.on_construct = def.on_construct or function(pos)
			local meta = minetest.get_meta(pos)
			if infotext then meta:set_string("infotext", infotext) end

			local size = inventory.size or default_inventory_size
			local inv = meta:get_inventory()
			inv:set_size("main", size)
			meta:set_string("formspec", (inventory.formspec or
					get_formspec_by_size(size))..xbg)
		end
		def.can_dig = def.can_dig or default_can_dig
	elseif infotext and not def.on_construct then
		def.on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_string("infotext", infotext)
		end
	end

	minetest.register_node("xdecor:"..name, def)

	local workbench = minetest.settings:get_bool("enable_xdecor_workbench")

	if workbench == false and
	   (minetest.get_modpath("moreblocks") or minetest.get_modpath("stairs")) then
		if xdecor.stairs_valid_def(def) then
			xdecor_stairs_alternative("xdecor:"..name, def)
		end
	end
end
