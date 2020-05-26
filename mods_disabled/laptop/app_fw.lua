laptop.apps = {}

local app_class = {}
app_class.__index = app_class
laptop.class_lib.app = app_class

-- internally used: get current app formspec
function app_class:get_formspec()
	local app_result
	if  self.formspec_func then
		app_result = self.formspec_func(self, self.os)
	else
		app_result = ""
	end
	if self.fullscreen then
		return app_result
	end

	if app_result == false then
		return false
	end

	local launcher = self.os:get_app(self.os.hwdef.custom_launcher or "launcher")
	local window_formspec = ""
	if launcher.appwindow_formspec_func then
		window_formspec = launcher.appwindow_formspec_func(launcher, self, self.os)
	end
	return window_formspec..app_result
end

-- internally used: process input
function app_class:receive_data(method, reshow, sender, ...)
	local ret

	if self[method] then
		ret = self[method](self, self.os, sender, ...)
	end

	if method == "receive_fields_func" then
		local fields = ...
		if fields.os_back then
			self:back_app()
		elseif fields.os_exit then
			self:exit_app()
		end
	end
	return ret
end

-- Back to previous app in stack
function app_class:back_app(fields, sender)
	self.os:set_app('<pop>', sender, fields)
	if fields then
		self.os:pass_to_app('receive_fields_func', true, sender, fields)
	end
end

-- Exit current app and back to launcher
function app_class:exit_app()
	self.os:set_app() -- launcher
end

function app_class:get_timer()
	self.os.timer = self.os.timer or minetest.get_node_timer(self.os.pos)
	return self.os.timer
end

-- Register new app
function laptop.register_app(name, def)
	def.name = name
	laptop.apps[name] = def
end

-- Register new app
function laptop.register_view(name, def)
	def.view = true
	laptop.apps[name] = def
end

-- load all apps
local app_path = minetest.get_modpath('laptop')..'/apps/'
local app_list = minetest.get_dir_list(app_path, false)

for _, file in ipairs(app_list) do
	if file:sub(-8) == '_app.lua' then
		dofile(app_path..file)
	end
end

dofile(app_path..'browser_app.lua')
for _, file in ipairs(app_list) do
    if file:sub(-8) == '_app.lua' and file ~= 'browser_app.lua' 
then
        dofile(app_path..file)
    end
end
