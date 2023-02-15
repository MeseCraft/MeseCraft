-- Gramophone and music player API
-- By Zorman2000
-- Some mechanics inspired by mcl_jukebox mod by Wuzzy and itemframe mod by TenPlus1

gramophone = {}

gramophone.temp = {}

gramophone.registered_tracks = {}

-- Use this function register new discs
gramophone.register_disc = function(record_title, artist, color, record_filename)

	-- Enter track into array
	table.insert(gramophone.registered_tracks, {title=record_title, file=record_filename})
	local record_num = #gramophone.registered_tracks

	minetest.register_craftitem("gramophone:vinyl_disc"..record_num, {
		description = "Vinyl Record\n"
			.."Title: "..minetest.colorize(color, record_title).."\n"
			.."Artist: "..artist,
		inventory_image = "vinyl_disc.png^(vinyl_disc_center.png^[colorize:"..color..")",
		groups = {track = record_num, music_disc = 1},
		wield_image = "vinyl_disc.png^(vinyl_disc_center.png^[colorize:"..color..")"
	})
end

gramophone.disc_shelf_formspec = 
		"size[8,7]"..
		default.gui_bg..
		default.gui_bg_img..
		default.gui_slots..
		"list[context;main;1.5,0.25;5,2;]"..
		"list[current_player;main;0,2.75;8,1;]"..
		"list[current_player;main;0,4;8,3;8]"..
		"listring[context;main]"..
		"listring[current_player;main]"


gramophone.stop_playback = function(meta, pos)
	local handlers = minetest.deserialize(meta:get_string("gramophone:sound_handler"))
	if handlers then
		for i = 1, #handlers do
			minetest.sound_stop(handlers[i])
		end
		local meta = minetest.get_meta(pos)
		meta:set_string("gramophone:sound_handler", "")
		meta:set_string("gramophone:is_playing", "false")
	end
end

gramophone.on_punch = function(pos, node, clicker, pointed_thing)
	local name = clicker and clicker:get_player_name()
	if minetest.is_protected(pos, name) then
		minetest.record_protection_violation(pos, name)
		return
	end
	local itemstack = clicker:get_wielded_item()
	-- Check if there is a disc
	local objs = minetest.get_objects_inside_radius(pos, 0.5)
	local disc_obj = nil
	-- Take disc
	if #objs > 0 then
		for _, obj in pairs(objs) do
			if obj and obj:get_luaentity()
			and string.find(obj:get_luaentity().name, "^gramophone:vinyl_disc") then
				disc_obj = obj
				break
			end
		end

		if disc_obj then
			-- Get meta
			local meta = minetest.get_meta(pos)
			--minetest.log("Node: "..dump(node))
			-- Remove disc from gramophone inventory
			local gramophone_inv = meta:get_inventory()
			local disc = gramophone_inv:get_stack("main", 1)
			gramophone_inv:remove_item("main", disc)
			-- Add item to player inventory
			local player_inv = clicker:get_inventory()
			if player_inv:room_for_item("main", disc) then
				if itemstack:get_name() == disc:get_name() then
					itemstack:add_item(disc)
				elseif itemstack:is_empty() then
					--minetest.log("Is empty")
					itemstack:replace(disc)
					--itemstack:set_count(disc:get_count())
				else
					player_inv:add_item("main", disc)
				end
			else
				minetest.add_item(clicker:get_pos(), disc:get_name())
			end
			-- Clear values
			disc_obj:remove()
			gramophone.stop_playback(meta, pos)
			meta:set_int("gramophone:current_track", 0)
		end

	else 
		-- Check wielded item
		if string.find(itemstack:get_name(), "^gramophone:vinyl_disc") then
			-- Get meta
			local meta = minetest.get_meta(pos)
			-- Add texture data to temporary variable
			gramophone.temp.disc_texture = minetest.registered_items[itemstack:get_name()].inventory_image
			-- Add disc on top of gramophone
			local disc_ent = minetest.add_entity({x=pos.x, y=pos.y - 0.40, z=pos.z}, "gramophone:vinyl_disc")
			-- Remove disk from hand
			local item = itemstack:take_item()
			-- Add item name to meta
			local inv = meta:get_inventory()
			inv:add_item("main", item)
			-- Set track
			minetest.log("Disc track: "..dump(minetest.get_item_group(item:get_name(), "track")))
			meta:set_int("gramophone:current_track", minetest.get_item_group(item:get_name(), "track"))
		end
	end
	--return itemstack
	clicker:set_wielded_item(itemstack)
end

gramophone.on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
	--minetest.log("rightclick")
	local meta = minetest.get_meta(pos)
	local is_playing = meta:get_string("gramophone:is_playing")
	-- Find disc on top of gramophone
	local objs = minetest.get_objects_inside_radius(pos, 0.5)
	if #objs == 0 then
		-- No disc
		--minetest.log("Returning...")
		return itemstack
	end
	if objs then
		for _, obj in pairs(objs) do
			if obj and obj:get_luaentity()
			and obj:get_luaentity().name == "gramophone:vinyl_disc" then
				if is_playing == "true" then
					--minetest.log("This Stopping man...")
					obj:set_properties({automatic_rotate = 0})
				else 
					--minetest.log("Playing...")
					obj:set_properties({automatic_rotate = 1})
				end
			end
		end
	end
	-- Start or stop playing
	if is_playing == "true" then
		-- Stop sound
		--minetest.log("Stopping...")
		gramophone.stop_playback(meta, pos)
	else
		-- Start playing sound
		--minetest.log("Playing...")
		local pos1 = vector.subtract(pos, 1)
		local pos2 = vector.add(pos, 1)
		local speakers = minetest.find_nodes_in_area(pos1, pos2, {"gramophone:speaker"})
		minetest.log("Found speakers: "..dump(#speakers))
		-- If speakers found, start playing music on each of them
		if #speakers > 0 then
			local meta = minetest.get_meta(pos)
			meta:set_string("gramophone:is_playing", "true")

			local handlers = {}
			for i = 1, #speakers do
				-- Get track info
				local track_no = meta:get_int("gramophone:current_track") or 0
				minetest.log("Current track no.: "..dump(track_no))
				if track_no > 0 then
					local track_name = gramophone.registered_tracks[track_no].file
					local handler = minetest.sound_play(track_name, {pos = speakers[i], gain = 1.0, max_hear_distance = 32})
					table.insert(handlers, handler)
					meta:set_string("gramophone:sound_handler", minetest.serialize(handlers))
				end
			end
		end
	end
end

gramophone.register_player = function(name, def)
	minetest.register_node("gramophone:"..name, {
	description = def.description,
	tiles = def.tiles,
	drawtype = def.drawtype,
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = def.node_box,
	groups = def.groups,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_int("gramophone:current_track", 0)
		meta:set_string("gramophone:is_playing", "false")
		meta:set_string("gramophone:sound_handler", "")
		local inv = meta:get_inventory()
		inv:set_size("main", 1)
	end,
	on_punch = gramophone.on_punch,
	on_rightclick = gramophone.on_rightclick,
})
end
