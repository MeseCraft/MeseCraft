-----------------------------------------------------
-- Hard-Coded version attributes
-----------------------------------------------------
laptop.os_version_attr = {
	['1.10'] = {
		releaseyear = '1976',
		version_string = '1.10',
		tty_style = 'AMBER',
		custom_launcher = "cs-bos_launcher",
		custom_theme = "Amber Shell",
		blacklist_commands = { EXIT = true },
		tty_monochrome = true,
		min_scrollback_size = 20,
		max_scrollback_size = 34,
	},
	['3.31'] = {
		releaseyear = '1982',
		version_string = '3.31',
		tty_style = 'GREEN',
		custom_launcher = "cs-bos_launcher",
		custom_theme = "Green Shell",
		blacklist_commands = { EXIT = true },
		tty_monochrome = true,
		min_scrollback_size = 25,
		max_scrollback_size = 100,
	},
	['5.02'] = {
		releaseyear = '1989',
		version_string = '5.02',
		tty_style = 'WHITE',
		custom_theme = "Circuit",
		blacklist_commands = { },
		min_scrollback_size = 25,
		max_scrollback_size = 300,
	},
	['6.33'] = {
		releaseyear = '1995',
		version_string = '6.33',
		tty_style = 'WHITE',
		custom_theme = "Clouds",
		blacklist_commands = { },
		min_scrollback_size = 25,
		max_scrollback_size = 300,
	},
	['10.00'] = {
		releaseyear = '2010',
		version_string = '10.00',
		tty_style = 'WHITE',
		custom_theme = "Freedom",
		blacklist_commands = { },
		min_scrollback_size = 25,
		max_scrollback_size = 300,
	},
}
laptop.os_version_attr.default = laptop.os_version_attr['10.00']

-----------------------------------------------------
-- Hard-Coded supported monochrome colors
-----------------------------------------------------
laptop.supported_textcolors = {
	GREEN = "#00FF33",
	AMBER = "#FFB000",
	WHITE = "#FFFFFF",
}


-----------------------------------------------------
-- Operating System cache
-----------------------------------------------------
local mtos_cache = {
	list = {},
	is_running = false
}
laptop.mtos_cache = mtos_cache

function mtos_cache:get(pos)
	local hash = minetest.hash_node_position(pos)
	return self.list[hash]
end

function mtos_cache:set(pos, mtos)
	local hash = minetest.hash_node_position(pos)
	mtos.cache_first_access = mtos.cache_first_access or os.time()
	mtos.cache_last_access = os.time()
	self.list[hash] = mtos
	self:check_free_step()
end

function mtos_cache:free(pos)
	local hash = minetest.hash_node_position(pos)
	self.list[hash] = nil
end


function mtos_cache:sync_and_free(mtos)
	mtos.bdev:sync()
	self:free(mtos.pos)
end


function mtos_cache:check_free_step()
	-- do not start twice
	if self.is_running then
		return
	end

	local function check_free(mtos_cache)
		local current_time
		for hash, mtos in pairs(mtos_cache.list) do
			current_time = current_time or os.time()
			if mtos.cache_last_access + 5 <= current_time or -- 5 seconds unused
					mtos.cache_first_access + 15 <= current_time then -- or 15 seconds active
				self:sync_and_free(mtos)
			end
		end
		mtos_cache.is_running = false
		mtos_cache:check_free_step()
	end

	if next(self.list) then
		self.is_running = true
		minetest.after(1, check_free, self)
	end
end

-- Sync all on shutdown
minetest.register_on_shutdown(function()
	for hash, mtos in pairs(mtos_cache.list) do
		mtos_cache:sync_and_free(mtos)
	end
end)

-----------------------------------------------------
-- Operating System class
-----------------------------------------------------
local os_class = {}
os_class.__index = os_class
laptop.class_lib.os = os_class

-- Swap the node
function os_class:swap_node(new_node_name)
	local node = minetest.get_node(self.pos)
	if new_node_name then
		node.name = new_node_name
		self.hwdef = laptop.node_config[self.node.name]
	end
	if self.hwdef.paramtype2 == "colorfacedir" then
		local fdir = math.floor(node.param2 % 32)
		node.param2 = fdir + self.theme.node_color * 32
	end
	self:set_infotext(self.hwdef.infotext)
	minetest.swap_node(self.pos, node)
end

-- Power on the system and start the launcher
function os_class:power_on(new_node_name)
	self.bdev:free_ram_disk()
	mtos_cache:free(self.pos)
	-- update current instance with reinitialized data
	for k,v in pairs(laptop.os_get(self.pos)) do
		self[k] = v
	end
	self:swap_node(new_node_name)
	self:set_app() --launcher
end

-- Power on the system / and resume last running app
function os_class:resume(new_node_name)
	self:swap_node(new_node_name)
	self:set_app('<pop>')
end

-- Power off the system
function os_class:power_off(new_node_name)
	self:swap_node(new_node_name)
	self:set_app('os:power_off')
end

-- Set infotext for system
function os_class:set_infotext(infotext)
	self.meta:set_string('infotext', infotext)
end

-- Get given or current theme
function os_class:get_theme(theme)
	if not theme then
		if self.sysdata then
			theme = self.sysdata.theme
		end
		if not theme then
			theme = self.hwdef.custom_theme or self.os_attr.custom_theme
		end
	end
	return laptop.get_theme(theme)
end

-- Set current theme
function os_class:set_theme(theme)
	if laptop.themes[theme] then
		if self.sysdata then
			self.sysdata.theme = theme
		end
		self.theme = self:get_theme()
		self:swap_node()
		self:save()
	end
end

function os_class:get_os_attr()
	local os_attr = {}
	local os_version = self.hwdef.os_version or 'default'
	for k, v in pairs(laptop.os_version_attr[os_version]) do
		os_attr[k] = v
	end

	os_attr.tty_style = self.hwdef.tty_style or os_attr.tty_style
	if self.hwdef.tty_monochrome ~= nil then
		os_attr.tty_monochrome = self.hwdef.tty_monochrome
	end
	if os_attr.tty_monochrome then
		os_attr.blacklist_commands.TEXTCOLOR = true
	end
	return os_attr
end

-- Add app to stack (before starting new)
function os_class:appstack_add(appname)
	table.insert(self.sysram.stack, appname)
end

-- Get last app from stack
function os_class:appstack_pop()
	local ret
	if #self.sysram.stack > 0 then
		ret = self.sysram.stack[#self.sysram.stack]
		table.remove(self.sysram.stack, #self.sysram.stack)
	end
	return ret
end

-- Free stack
function os_class:appstack_free()
	self.sysram.stack = {}
end

-- Get new app instance
function os_class:is_app_compatible(name)
	local app_def = laptop.apps[name]
	if not app_def then
		return false
	end
	if app_def.os_min_version and (tonumber(app_def.os_min_version) > tonumber(self.os_attr.version_string)) then
		return false
	end
	if app_def.os_max_version and (tonumber(app_def.os_max_version) < tonumber(self.os_attr.version_string)) then
		return false
	end
	return true
end

-- Get new app instance
function os_class:is_theme_compatible(name)
	local theme_def = laptop.themes[name]
	if not theme_def then
		return false
	end
	if theme_def.os_min_version and (tonumber(theme_def.os_min_version) > tonumber(self.os_attr.version_string)) then
		return false
	end
	if theme_def.os_max_version and (tonumber(theme_def.os_max_version) < tonumber(self.os_attr.version_string)) then
		return false
	end
	return true
end

-- Get new app instance
function os_class:get_app(name)
	local template = laptop.apps[name]
	if not template then
		return
	end
	local app = setmetatable({}, laptop.class_lib.app)
	for k,v in pairs(template) do
		app[k] = v
	end
	app.name = name
	app.os = self
	return app
end

-- suspend timer from previous app before switching to new app
function os_class:save_timer()
	if not self.sysram.current_app then
		return
	end
	local appname = self.sysram.current_app
	if not appname then
		return
	end
	self.timer = minetest.get_node_timer(self.pos)
	if self.timer:is_started() then
		self.sysram.app_timer[appname] = {
				timeout = self.timer:get_timeout(),
				elapsed = self.timer:get_elapsed(),
			}
	else
		self.sysram.app_timer[self.sysram.current_app] = nil
	end
end

-- restore the timer of current app
function os_class:resume_timer(appname)
	if not appname then
		if not self.sysram.current_app then
			return
		end
		appname = self.sysram.current_app
	end
	self.timer = self.timer or minetest.get_node_timer(self.pos)
	if self.sysram.app_timer[appname] then
		local data = self.sysram.app_timer[appname]
		self.timer:set(data.timeout, data.elapsed)
	else
		self.timer:stop()
	end
end

-- Activate the app
function os_class:set_app(appname)
	local launcher = self.hwdef.custom_launcher or self.os_attr.custom_launcher or "launcher"
	local newapp = appname or launcher
	if newapp == launcher then
		self:appstack_free()
	elseif newapp == '<pop>' then
		newapp = self:appstack_pop() or launcher
	elseif self.sysram.current_app and
			self.sysram.current_app ~= launcher and
			self.sysram.current_app ~= newapp then
		self:appstack_add(self.sysram.current_app)
	end

	if self.sysram.current_app ~= newapp then
		self:save_timer()
		self:resume_timer(newapp)
	end

	self.sysram.current_app = newapp
	local app = self:get_app(newapp)
	local formspec = app:get_formspec()
	if formspec ~= false then
		self.meta:set_string('formspec', formspec)
	end
	self:save()
	mtos_cache:sync_and_free(self)
end

-- Handle input processing
function os_class:pass_to_app(method, reshow, sender, ...)
	local appname = self.sysram.current_app or self.hwdef.custom_launcher or self.os_attr.custom_launcher or "launcher"
	local app = self:get_app(appname)
	if not app then
		self:set_app()
		return
	end
	if sender then
		self.sysram.current_player = sender:get_player_name()
	else
		self.sysram.current_player = nil
	end
	local ret = app:receive_data(method, reshow, sender, ...)

	if self.sysram.current_app == appname and reshow then
		local formspec = app:get_formspec()
		if formspec ~= false then
			self.meta:set_string('formspec', formspec)
		end
	end
	if sender then
		self.sysram.last_player = sender:get_player_name()
	else
		self.sysram.last_player = nil
	end

	self:save()
	return ret
end

function os_class:save()
	self.bdev:sync_cloud()
	mtos_cache:set(self.pos, self)
end

-- Use parameter and launch the select_file dialog
-- Return values will be send as fields to the called app
function os_class:select_file_dialog(param)
	local store = self.bdev:get_app_storage('ram', 'os:select_file')
	store.param = param
	self:set_app('os:select_file')
end

-- Use parameter and launch the select_file dialog
-- Return values will be send as fields to the called app
function os_class:print_file_dialog(param)
	local store = self.bdev:get_app_storage('ram', 'printer:app')
	store.param = param
	self:set_app('printer:app')
end

-----------------------------------------------------
-- Get Operating system object
-----------------------------------------------------
function laptop.os_get(pos)
	-- get OS-object from cache
	local self = mtos_cache:get(pos)
	if self then
		return self
	end

	-- Create new if not in cache
	self = setmetatable({}, os_class)
	self.__index = os_class
	self.pos = pos
	self.node = minetest.get_node(pos)
	self.hwdef = laptop.node_config[self.node.name]
	if not self.hwdef then
		return nil -- not compatible node
	end
	self.meta = minetest.get_meta(pos)
	self.bdev = laptop.get_bdev_handler(self)
	self.sysram = self.bdev:get_app_storage('ram', 'os')
	self.sysram.stack = self.sysram.stack or {}
	self.sysram.app_timer = self.sysram.app_timer or {}
	self.sysdata = self.bdev:get_app_storage('system', 'os')
	self.os_attr = self:get_os_attr()
	self.theme = self:get_theme()
	return self
end
