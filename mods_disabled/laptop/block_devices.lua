local mod_storage = minetest.get_mod_storage()

local bdev = {}

-- Check hardware capabilities { "hdd", "floppy", "usb", "net", "liveboot" }
function bdev:is_hw_capability(hw_cap)
	for i, cap in ipairs(self.os.hwdef.hw_capabilities) do
		if cap == hw_cap or cap == hw_cap:sub(18, -1) then  --"laptop_removable_*"then
			return cap
		end
	end
	return false
end

-- Get RAM
function bdev:get_ram_disk()
	if not self.ram_disk then
		self.ram_disk = minetest.deserialize(self.os.meta:get_string('laptop_ram')) or {}
	end
	return self.ram_disk
end

function bdev:free_ram_disk()
	self.ram_disk = {}
	self:sync()
end


-- Get HDD if exists
function bdev:get_hard_disk()
	if self.hard_disk == nil then
		if self:is_hw_capability('hdd') then
			self.hard_disk = minetest.deserialize(self.os.meta:get_string('laptop_appdata')) or {}
		else
			self.hard_disk = false
		end
	end
	return self.hard_disk
end

-- Get Removable disk if exists
function bdev:get_removable_disk(removable_type)
	if self.removable_disk == nil then
		local data = { bdev = self }
		data.inv = self.os.meta:get_inventory()
		data.inv:set_size("main", 1) -- 1 disk supported
		function data:reload(stack)
			-- self.inv unchanged
			-- self.rtype unchanged (assumption
			stack = stack or self.inv:get_stack("main", 1)
			if stack then
				local def = stack:get_definition()
				if def and def.name ~= "" then
					self.stack = stack
					self.def = def
					self.meta = stack:get_meta()
					self.os_format = self.meta:get_string("os_format")
					if self.os_format == "" then
						self.os_format = "none"
					end
					self.label = self.meta:get_string("description")
					if self.label == "" then
						self.label = self.def.description
					end
					for group, _ in pairs(self.def.groups) do
						local rtype_chk = self.bdev:is_hw_capability(group)
						if not removable_type or removable_type == rtype_chk then
							self.rtype = rtype_chk
							break
						end
					end
					self.storage = minetest.deserialize(self.meta:get_string("os_storage")) or {}
				end
			end
		end
		function data:eject()
			if not self.stack then
				return false
			end
			local p = self.bdev.os.pos
			local drop_pos = { x=p.x+math.random()*2-1, y=p.y,z=p.z+math.random()*2-1 }
			minetest.item_drop(self.stack, nil, drop_pos)
			self.stack = nil
			return true
		end
		function data:format_disk(ftype, label)
			self.stack = ItemStack(self.def.name)
			self.meta = self.stack:get_meta()
			self.meta:set_string("os_format", ftype or "")
			self.os_format = ftype
			self.label = label or ""
		end

		data:reload()
		self.removable_disk = data
	end
	return self.removable_disk
end

-- Connect to cloud
function bdev:get_cloud_disk(store_name)
	if self.cloud_disk == nil or (self.cloud_disk ~= false and not self.cloud_disk[store_name]) then
		if self:is_hw_capability('net') then
			self.cloud_disk = self.cloud_disk or {}
			self.cloud_disk[store_name] = minetest.deserialize(mod_storage:get_string(store_name)) or {}
		else
			self.cloud_disk = false
			return false
		end
	end
	return self.cloud_disk[store_name]
end

-- Get device to boot
function bdev:get_boot_disk()
	if self:is_hw_capability('liveboot') then
		local drive = self:get_removable_disk()
		if drive.stack and drive.os_format == 'boot' then
			return 'removable'
		end
	end
	return 'hdd'
end

-- Get app related object from storage "disk_type"
function bdev:get_app_storage(disk_type, store_name)
	if disk_type == 'ram' then
		local store = self:get_ram_disk()
		store[store_name] = store[store_name] or {}
		return store[store_name]
	elseif disk_type == 'hdd' then
		local store = self:get_hard_disk()
		if store then
			store[store_name] = store[store_name] or {}
			return store[store_name]
		else
			return nil
		end
	elseif disk_type == 'removable' then
		local store = self:get_removable_disk()
		if store.stack and (store.os_format == 'data' or store.os_format == 'boot') then
			store.storage[store_name] = store.storage[store_name] or {}
			return store.storage[store_name]
		else
			return nil
		end
	elseif disk_type == 'system' then
		local runtime = self:get_app_storage("ram", "os")
		runtime.booted_from = runtime.booted_from or self:get_boot_disk()
		return self:get_app_storage(runtime.booted_from, store_name)
	elseif disk_type == 'cloud' then
		return self:get_cloud_disk(store_name) or nil
	end
end


-- Save all data if used
function bdev:sync()
	-- save RAM
	self.os.meta:set_string('laptop_ram', minetest.serialize(self.ram_disk))
	self.os.meta:mark_as_private('laptop_ram')

	-- save HDD
	if self.hard_disk then
		self.os.meta:set_string('laptop_appdata', minetest.serialize(self.hard_disk))
		self.os.meta:mark_as_private('laptop_appdata')
	end

	-- save removable
	if self.removable_disk then
		if self.removable_disk.stack then
			if self.removable_disk.def and self.removable_disk.label ~= self.removable_disk.def.description then
				self.removable_disk.meta:set_string("description", self.removable_disk.label)
			end
			if self.removable_disk.storage then
				self.removable_disk.meta:set_string("os_storage", minetest.serialize(self.removable_disk.storage))
			end
		end
		self.removable_disk.inv:set_stack("main", 1, self.removable_disk.stack)
	end
end

-- Save all data if used
function bdev:sync_cloud()
	-- Modmeta (Cloud)
	if self.cloud_disk then
		for store, value in pairs(self.cloud_disk) do
			mod_storage:set_string(store, minetest.serialize(value))
		end
	end
end

-- Get handler
function laptop.get_bdev_handler(mtos)
	local bdevobj = {}
	for k,v in pairs(bdev) do
		bdevobj[k] = v
	end
	bdevobj.os = mtos
	return bdevobj
end



