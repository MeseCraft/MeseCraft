-- taken from https://gitlab.com/VanessaE/pipeworks

local filename=minetest.get_worldpath() .. "/teleport_tubes"

local tp_tube_db = nil -- nil forces a read
local tp_tube_db_version = 2.0

local function hash(pos)
	return string.format("%.30g", minetest.hash_node_position(pos))
end

local last_save_time
local function save_tube_db()
	local now = minetest.get_us_time()
	if last_save_time and (now - last_save_time) < 500000 then
		-- rate limit
		return
	end

	last_save_time = now

	local file, err = io.open(filename, "w")
	if file then
		if not tp_tube_db then return end
		tp_tube_db.version = tp_tube_db_version
		file:write(minetest.serialize(tp_tube_db))
		tp_tube_db.version = nil
		io.close(file)
	else
		error(err)
	end
end

local function migrate_tube_db()
		local tmp_db = {}
		tp_tube_db.version = nil
		for key, val in pairs(tp_tube_db) do
			if(val.channel ~= "") then -- skip unconfigured tubes
				tmp_db[hash(val)] = val
			end
		end
		tp_tube_db = tmp_db
		save_tube_db()
end

local function read_tube_db()
	local file = io.open(filename, "r")
	if file ~= nil then
		local file_content = file:read("*all")
		io.close(file)

		if file_content and file_content ~= "" then
			tp_tube_db = minetest.deserialize(file_content)
			if(not tp_tube_db.version or tonumber(tp_tube_db.version) < tp_tube_db_version) then
				migrate_tube_db()
			end
			tp_tube_db.version = nil -- we add it back when saving
			return tp_tube_db -- we read sucessfully
		end
	end
	tp_tube_db = {}
	return tp_tube_db
end


-- expose for external batch use (jumpdrive)
pipeworks.tptube = {
	hash = hash,
	save_tube_db = save_tube_db,
	get_db = function() return tp_tube_db or read_tube_db() end,
	tp_tube_db_version = tp_tube_db_version
}


-- debug formatter for coordinates used below
local fmt = function(pos)
	return pos.x..", "..pos.y..", "..pos.z
end

-- updates or adds a tube
local function set_tube(pos, channel, can_receive)
	local tubes = tp_tube_db or read_tube_db()
	local hashpos = hash(pos)
	local tube = tubes[hashpos]
	if tube then
		tube.channel = channel
		tube.cr = can_receive
		save_tube_db()
		return
	end

	-- we haven't found any tp tube to update, so lets add it
	-- but sanity check that the hash has not already been inserted.
	-- if so, complain very loudly and refuse the update so the player knows something is amiss.
	-- to catch regressions of https://github.com/minetest-mods/pipeworks/issues/166
	local existing = tp_tube_db[hash]
	if  existing ~= nil then
		local e = "error"
		minetest.log(e, "pipeworks teleport tube update refused due to position hash collision")
		minetest.log(e, "collided hash: "..hashpos)
		minetest.log(e, "tried-to-place tube: "..fmt(pos))
		minetest.log(e, "existing tube: "..fmt(existing))
		return
	end

	tp_tube_db[hashpos] = {x=pos.x,y=pos.y,z=pos.z,channel=channel,cr=can_receive}
	save_tube_db()
end

local function remove_tube(pos)
	local tubes = tp_tube_db or read_tube_db()
	tubes[hash(pos)] = nil
	save_tube_db()
end

local function read_node_with_vm(pos)
	local vm = VoxelManip()
	local MinEdge, MaxEdge = vm:read_from_map(pos, pos)
	local data = vm:get_data()
	local area = VoxelArea:new({MinEdge = MinEdge, MaxEdge = MaxEdge})
	return minetest.get_name_from_content_id(data[area:index(pos.x, pos.y, pos.z)])
end

local function get_receivers(pos, channel)
	local tubes = tp_tube_db or read_tube_db()
	local receivers = {}
	local dirty = false
	for key, val in pairs(tubes) do
		-- skip all non-receivers and the tube that it came from as early as possible, as this is called often
		if (val.cr == 1 and val.channel == channel and (val.x ~= pos.x or val.y ~= pos.y or val.z ~= pos.z)) then
			local is_loaded = (minetest.get_node_or_nil(val) ~= nil)
			local node_name = is_loaded and minetest.get_node(pos).name or read_node_with_vm(val)

			if minetest.registered_nodes[node_name] and minetest.registered_nodes[node_name].is_teleport_tube then
				table.insert(receivers, val)
			else
				tp_tube_db[key] = nil
				dirty = true
			end
		end
	end
	if dirty then
		save_tube_db()
	end
	return receivers
end

local function update_meta(meta, can_receive)
	meta:set_int("can_receive", can_receive and 1 or 0)
	local cr_state = can_receive and "on" or "off"
	meta:set_string("formspec","size[8.6,2.2]"..
			"field[0.6,0.6;7,1;channel;Channel:;${channel}]"..
			"label[7.3,0;Receive]"..
			"image_button[7.3,0.3;1,0.6;pipeworks_button_" .. cr_state ..
				".png;cr" .. (can_receive and 0 or 1) .. ";;;false;pipeworks_button_interm.png]"..
			"image[0.3,1.3;1,1;pipeworks_teleport_tube_inv.png]"..
			"label[1.6,1.2;channels are public by default]" ..
			"label[1.6,1.5;use <player>:<channel> for fully private channels]" ..
			"label[1.6,1.8;use <player>\\;<channel> for private receivers]" ..
			default.gui_bg..
			default.gui_bg_img)
end


-- override tp tubes
for i=1,10 do
	local nodename = "pipeworks:teleport_tube_" .. i
	assert(minetest.registered_nodes[nodename])

	local tube_def = minetest.registered_nodes[nodename].tube
	assert(type(tube_def) == "table")

	local node_def = {
		is_teleport_tube = true,
		tube = {
			-- copy previous definitions
			connect_sides = tube_def.connect_sides,
			priority = tube_def.priority,

			-- intercept can_go function for jumpdrive-compat tp-tube impl
			can_go = function(pos,node,velocity,stack)
				velocity.x = 0
				velocity.y = 0
				velocity.z = 0

				local channel = minetest.get_meta(pos):get_string("channel")
				if channel == "" then return {} end

				local target = get_receivers(pos, channel)
				if target[1] == nil then return {} end

				local d = math.random(1,#target)
				pos.x = target[d].x
				pos.y = target[d].y
				pos.z = target[d].z
				return pipeworks.meseadjlist
			end
		},
		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			update_meta(meta, true)
			meta:set_string("infotext", "unconfigured Teleportation Tube")
		end,
		on_receive_fields = function(pos,formname,fields,sender)
			if not fields.channel -- ignore escaping or clientside manipulation of the form
			or not pipeworks.may_configure(pos, sender) then
				return
			end
			local new_channel = tostring(fields.channel):trim()

			local meta = minetest.get_meta(pos)
			local can_receive = meta:get_int("can_receive")

			-- check for private channels each time before actually changing anything
			-- to not even allow switching between can_receive states of private channels
			if new_channel ~= "" then
				local sender_name = sender:get_player_name()
				local name, mode = new_channel:match("^([^:;]+)([:;])")
				if name and mode and name ~= sender_name then
					--channels starting with '[name]:' can only be used by the named player
					if mode == ":" then
						minetest.chat_send_player(sender_name, "Sorry, channel '"..
							new_channel.."' is reserved for exclusive use by "..name)
						return

					--channels starting with '[name];' can be used by other players, but cannot be received from
					elseif mode == ";" and (fields.cr1 or (can_receive ~= 0 and not fields.cr0)) then
						minetest.chat_send_player(sender_name, "Sorry, receiving from channel '"..new_channel.."' is reserved for "..name)
						return
					end
				end
			end

			local dirty = false

			-- was the channel changed?
			local channel = meta:get_string("channel")
			if new_channel ~= channel then
				channel = new_channel
				meta:set_string("channel", channel)
				dirty = true
			end

			-- test if a can_receive button was pressed
			if fields.cr0 and can_receive ~= 0 then
				can_receive = 0
				update_meta(meta, false)
				dirty = true
			elseif fields.cr1 and can_receive ~= 1 then
				can_receive = 1
				update_meta(meta, true)
				dirty = true
			end

			-- save if we changed something, handle the empty channel while we're at it
			if dirty then
				if channel ~= "" then
					set_tube(pos, channel, can_receive)
					local cr_description = (can_receive == 1) and "sending and receiving" or "sending"
					meta:set_string("infotext", string.format("Teleportation Tube %s on '%s'", cr_description, channel))
				else
					-- remove empty channel tubes, to not have to search through them
					remove_tube(pos)
					meta:set_string("infotext", "unconfigured Teleportation Tube")
				end
			end
		end,
		on_destruct = function(pos)
			remove_tube(pos)
		end
	}

	minetest.override_item(nodename, node_def)

end
